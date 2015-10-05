package com.pagesociety.ux.composite
{
    import com.adobe.images.JPGEncoder;
    import com.adobe.images.PNGEncoder;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.Image;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.decorator.Decorator;
    import com.pagesociety.ux.draw.Drawing;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.event.ResourceEvent;
    
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.ProgressEvent;
    import flash.filters.ColorMatrixFilter;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLRequestMethod;
    import flash.utils.ByteArray;

    [Event(type="com.pagesociety.ux.composite.Compositor", name="ready")]
    [Event(type="com.pagesociety.ux.composite.Compositor", name="uploaded")]
    public class Compositor extends Container
    {
        public static const READY:String = "ready";
        public static const UPLOADED:String = "uploaded";
        
        
        public static const PNG:uint = 0;
        public static const JPG:uint = 1;
        public var type:uint = JPG;
        
        public var getParams:String;
        public var serverPath:String;
        
        
        private var _to_load:uint;
        private var _loaded:uint;
        private var upload_loader:URLLoader ;
        
        
        public function Compositor(parent:Container, index:int=-1)
        {
            super(parent, index);
        }
        
        public function set displayList(dl:Array):void
        {
            _to_load = 0;
            _loaded = 0;
            clear();
            for (var i:uint=0; i<dl.length; i++)
            {
                var o:Object = dl[i];
                
                if (o.src != null)
                {
                    add_image(o);
                }
                else if (o.text != null)
                {
                    var l:Label = new Label(this);
                    l.text = o.text;
                    if(o.multiline != null)
                        l.multiline = Boolean(o.multiline);
                    
                    if(o.x != null)
                        l.x = o.x;
                        
                    if(o.y != null)
                        l.y = o.y;
                        
                    if(o.width != null)
                        l.width = o.width;
                        
                    if (o.fontStyle != null)
                        l.fontStyle = o.fontStyle;
                        
                    if (o.align != null)
                        l.align = uint(o.align);
                }
            }
            if (_to_load==0)
                complete();
        }
        
        private function add_image(o:Object):void
        {
            _to_load++;

            var c:Container = new Container(this);
                    
            if(o.x != null)
                c.x = o.x;
                
            if(o.y != null)
                c.y = o.y;
                
            if(o.alpha != null)
                c.alpha = o.alpha;
                
            if (o.scale != null)
                c.decorator.scale = o.scale;
            
            var cc:Container = new Container(c);
            var img:Image = new Image(cc);
            img.addEventListener(ResourceEvent.LOAD_RESOURCE, 
                function(e:ComponentEvent):void
                {
                    var s:Number = o.imageScale==null?1:o.imageScale;
                    if (o.imageX != null)
                    {
                        if (o.imageX != null)
                        {
                            cc.x = img.imageWidth/2+o.imageX;
                            img.x = -img.imageWidth/2;
                        }   
                        if (o.imageY != null)
                        {
                            cc.y = img.imageHeight/2+o.imageY;
                            img.y = -img.imageHeight/2;
                        }
                        if (o.imageRotation != null)
                            cc.decorator.rotation = o.imageRotation;
                        if (o.imageScale != null)
                            img.decorator.scale = s;
                    }
                    else if (o.iccx != null)
                    {
                        cc.x = o.iccx;
                        cc.y = o.iccy;
                        img.x = o.imgx;
                        img.y = o.imgy;
                        cc.decorator.rotation = o.imageRotation;
                        cc.decorator.scale = s;
                    }
                    if (o.greyscale!=null && o.greyscale)
                    {
                        var cc:ColorMatrix = new ColorMatrix();
                        cc.adjustSaturation(-100);
                        cc.adjustBrightness(2);
                        cc.adjustContrast(25);
                        img.decorator.midground.filters = [ new ColorMatrixFilter(cc) ];
                    }
                    if (o.scalingType!=null)
                        img.imageScalingType = o.scalingType;
                    if (o.scalingCue!=null)
                        img.imageScalingCue = o.scalingCue;
                        
                    loaded_another();
                });
            img.src = o.src;
            img.smoothing = true;
            
            if (o.mask != null)
            {
                var d:Drawing = new Drawing(c);
                d.drawStyle = Drawing.DRAW_STYLE_POSITIVE;
                d.points = o.mask;
                c.decorator.mask = d.decorator;
            }
        }
        
        private function loaded_another():void
        {
            _loaded++;
            if (_loaded==_to_load)
                complete();
        }
        
        private function complete():void
        {
            visible  = true;
            render();
            dispatchComponentEvent(READY,this);
        }
        
        public function doit():void
        {
            visible = true;
            render();
            visible = false;
        }
        
        public function upload(dec:Decorator=null):void
        {
            var m:DisplayObject = dec==null? this.decorator : dec;
            execute_later("XXX", function():void
            {
                
                var bm_src:BitmapData = new BitmapData (m.width, m.height);
                bm_src.draw(m);
                
                var ba:ByteArray;

                if (type==PNG)
                {
                    ba = PNGEncoder.encode(bm_src)
                }
                else
                {
                    var jpg_encoder:JPGEncoder = new JPGEncoder(60);
                    ba = jpg_encoder.encode(bm_src);
                }
                var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
                            
                var url_req:URLRequest = new URLRequest(serverPath+(getParams==null?"":getParams));     
                url_req.requestHeaders.push(header);                
                url_req.method = URLRequestMethod.POST;             
                url_req.data = ba;
                
                upload_loader = new URLLoader();
//              upload_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, on_stats);
//              upload_loader.addEventListener(ProgressEvent.PROGRESS, on_stats);
                upload_loader.addEventListener(Event.COMPLETE, on_stats);
                upload_loader.load(url_req);
                //navigateToURL(jpgURLRequest, "_blank");
                
            }, 100);
        }
        private function on_stats(e:Event):void
        { 
            trace(">>>"+upload_loader.data);
            dispatchComponentEvent(UPLOADED,this);
        }
        
        private function get_greyscale_filter():ColorMatrixFilter
        {
            return new ColorMatrixFilter(
                [0.3, 0.59, 0.11, 0, 0,
                0.3, 0.59, 0.11, 0, 0,
                0.3, 0.59, 0.11, 0, 0,
                0, 0, 0, 1, 0]);
        }
        
        private function get_contrast_filter():ColorMatrixFilter
        {
            
              return new ColorMatrixFilter(
                [ -2, -2, -2, 0, 768*2, 
                 -2, -2, -2, 0, 768*2, 
                 -2, -2, -2, 0, 768*2, 
                  0,  0,  0, 1, 0]);
        }
        
    }
}
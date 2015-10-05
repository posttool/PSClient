package com.pagesociety.ux.system
{
    import com.pagesociety.persistence.Entity;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.geom.Matrix;
    import flash.net.URLRequest;
    
    public class LoadAndSize
    {
        private var _resource:Entity;
        private var _bitmap:Bitmap;
        private var _on_complete:Function;
        private var _w:Number;
        private var _h:Number;
        
        public function LoadAndSize(resource:Entity, w:Number, h:Number, on_complete:Function)
        {
            _resource = resource;
            _on_complete = on_complete;
            _w = w;
            _h = h;
            load();
        }
        
        private function load():void
        {
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.INIT, on_load);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, on_io_error);
            loader.visible = false;
            
            var req:URLRequest = new URLRequest(
                (_resource.$.url!=null) ? _resource.$.url : _resource.$.resource.$.url);
            loader.load(req);
        }
        
        private function on_load(e:Event):void
        {
            var d:DisplayObject = e.currentTarget.content;
            var wr:Number = _w/d.width;
            var hr:Number = _h/d.height;
            var r:Number = Math.min(wr, hr);
            if (r>1) r = 1;
            
            var m:Matrix = new Matrix();
            m.scale(r,r);
            
            var bmd:BitmapData = new BitmapData(Math.floor(d.width*r), Math.floor(d.height*r));
            bmd.draw(d, m);
            
            _bitmap = new Bitmap(bmd);
            _resource.$.source = _bitmap;
            _on_complete(_resource);
        }
        
        public function get bitmap():Bitmap
        {
            return _bitmap;
        }
        
        private function on_io_error(e:IOErrorEvent):void
        {
            Logger.error(e);
        }

    }
}
package com.pagesociety.ux.decorator
{
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BlurFilter;
    import flash.filters.DropShadowFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.ui.ContextMenu;
    import flash.utils.getDefinitionByName;
    
    public class Decorator extends Sprite 
    {
        private static var NOT_RASTERIZED:uint = 0;
        private static var RASTERIZED:uint = 1;
        private var _state:uint = NOT_RASTERIZED;
        
        protected var _component:Component;

        protected var _visible:Boolean = true;
        protected var _x:Number = 0;
        protected var _y:Number = 0;
        protected var _width:Number = 0;
        protected var _height:Number = 0;
        protected var _corner_radius:Number = 0;
        protected var _blur_amount:Number = 0;
        protected var _shadow_size:Number = 0;
        protected var _shadow_strength:Number = .2;
        protected var _shadow_color:Number = 0x000000;
        protected var _shadow_alpha:Number = 1;
        protected var _shadow_distance:Number = 0;
        protected var _shadow_angle:Number = 45;
        
        protected var _rasterize:Boolean = false;
        
        // sprite       
        protected var _bg:Box;
        protected var _mid:Sprite;
        protected var _drag_area:Sprite;
        
        protected var _color:ColorTransform;
        protected var _shadow:DropShadowFilter;     
        protected var _blur:BlurFilter;
        
        protected var _raster:Sprite;
        
        protected var _drag_and_drop_class_name:String;
        protected var _drag_and_drop:DragAndDrop;

        public function Decorator()
        {   
            dragAndDropClassName = "com.pagesociety.ux.decorator.DragAndDrop";
            initGraphics();
        }
        
        public function initGraphics():void
        {
            mouseEnabled = false;
            useHandCursor = false;
            
            _bg = new Box();
            _bg.visible = false;
            addChild(_bg);
            
            _mid = new Sprite();
            addChild(_mid);

        }
        
        public function destroy():void
        {
            try {
                parent.removeChild(this);
            }catch(e:Error){
                Logger.error(e);
            }
        }
        
        public function get component():Component
        {
            return _component;
        }
        
        public function set component(c:Component):void
        {
            _component = c;
            if (_component.parent != null)
                _component.parent.decorator.midground.addChild(this);
        }
        
        public function set dragAndDropClassName(s:String):void
        {
            _drag_and_drop_class_name = s;
            var DragAndDropClass:Class = getDefinitionByName(_drag_and_drop_class_name) as Class;
            _drag_and_drop = (new DragAndDropClass(this) as DragAndDrop);
        }
        
        public function get dragAndDropClassName():String
        {
            return _drag_and_drop_class_name;
        }
        
        public function bringToFront():void
        {
            parent.setChildIndex(this, parent.numChildren-1);
        }
        
        public function sendToBack():void
        {
            parent.setChildIndex(this, 0);
        }
        
        public function decorate():void
        {
            super.visible = _visible;
            if (!_visible)
                return;
                
            updatePosition(_x,_y);
            _bg.decorate();
            
            if (_color!=null)
            {
                midground.transform.colorTransform = _color;
                background.transform.colorTransform = _color;
            }
            
            var f:Array = new Array();
            if (_shadow_size!=0)
            {
                if (_shadow == null)
                    initDropShadow();
                _shadow.blurX = _shadow_size;
                _shadow.blurY = _shadow_size;
                _shadow.strength = _shadow_strength;
                _shadow.color = _shadow_color;
                _shadow.alpha = _shadow_alpha;
                _shadow.distance = _shadow_distance;
                _shadow.angle = _shadow_angle;
                f.push(_shadow);            
            }
            if (_blur_amount!=0)
            {
                if (_blur == null)
                    initBlur();
                _blur.blurX = _blur_amount;
                _blur.blurY = _blur_amount;
                f.push(_blur);  
            }
            filters = f;
            
            // 
            if (_rasterize && _state == NOT_RASTERIZED)
            {
                addChild(createBitmap());
                removeChild(_bg);
                removeChild(_mid);
                _state = RASTERIZED;
            }
            else if (!_rasterize && _state == RASTERIZED)
            {
                removeChildAt(0);
                addChild(_bg);
                addChild(_mid);
                _state = NOT_RASTERIZED;
            }
        }
        
        public function updatePosition(x0:Number,y0:Number):void
        {
            x = x0;
            y = y0;
//          super.x = Math.floor(x0);
//          super.y = Math.floor(y0);
            super.x = x0;
            super.y = y0;
        }
        
        public function updateX(x0:Number):void
        {
            x = x0;

            //          super.x = Math.floor(x0);
            //          super.y = Math.floor(y0);
            super.x = x0;

        }
        
        public function updateY(y0:Number):void
        {

            y = y0;
            //          super.x = Math.floor(x0);
            //          super.y = Math.floor(y0);
            super.y = y0;
        }
        
        public function updateVisibility(b:Boolean):void
        {
            _visible = b;
            super.visible = b;
        }

        // hooks to as3 display objects
        public function get displayObject():DisplayObject
        {
            return this;
        }
                
        public function get dragArea():Sprite
        {
            if (_drag_area!=null)
                return _drag_area;
            return this;
        }
        
        public function set dragArea(s:Sprite):void
        {
            _drag_area = s;
        }

        override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
        {   
//          if (hasEventListener(type))
//              throw new Error("DefaultDecorator.addEventListener Error: Event type ["+type+"] already handled.");

            if (type!=ComponentEvent.CHANGE_VALUE)
            {
                mouseEnabled = true;
                useHandCursor = true;
            }

            super.addEventListener(type,listener,useCapture,priority,useWeakReference);
        }
        
        public function get background():Box
        {
            return _bg;
        }
        
        public function get midground():Sprite
        {
            return _mid;
        }
        
        
        
        
        // drawing stuff
        public function lineH(line_style:LineStyle, x:Number, y:Number, width:Number, clear:Boolean=true):void
        {
            var g:Graphics = graphics;
            if (clear) g.clear();
            g.lineStyle(line_style.thickness, line_style.color, line_style.alpha);
            g.moveTo(x,y);
            g.lineTo(x+width,y);
        }
        
        public function lineRect(line_style:LineStyle, x:Number, y:Number, width:Number, height:Number, clear:Boolean=true):void
        {
            var g:Graphics = graphics;
            if (clear) g.clear();
            g.lineStyle(line_style.thickness, line_style.color, line_style.alpha);
            g.drawRect(x,y,width,height);
        }
        
        public function fillRect(color:uint, alpha:Number, x:Number, y:Number, width:Number, height:Number, clear:Boolean=true):void
        {
            var g:Graphics = graphics;
            if (clear) g.clear();
            g.beginFill(color, alpha);
            g.drawRect(x, y, width, height);
            g.endFill();
        }
        
        //
        override public function set visible(b:Boolean):void
        {
            _visible = b;
        }
        
        override public function get visible():Boolean
        {
            return _visible;
        }
        
        override public function set x(x:Number):void
        {
            _x = x;
        }
        
        override public function get x():Number
        {
            return _x;
        }
        
        override public function set y(y:Number):void
        {
            _y = y;
        }
        
        override public function get y():Number
        {
            return _y;
        }
        
        override public function set width(w:Number):void
        {
            if (isNaN(w))
                return;
            _width = w;
            _bg.width = w;
        }
        
        override public function get width():Number
        {
            return _width;
        }
        
        override public function set height(h:Number):void
        {
            if (isNaN(h))
                return;
            _height = h;
            _bg.height = h;
        }

        override public function get height():Number
        {
            return _height;
        }

        public function set cornerRadius(r:Number):void
        {
            _corner_radius = r;
            _bg.cornerRadius = r;
        }
        
        public function get cornerRadius():Number
        {
            return _corner_radius;
        }
        
        public function set blur(b:Number):void
        {
            _blur_amount = b;
        }
        
        public function get blur():Number
        {
            return _blur_amount;
        }
        
        public function set shadowSize(s:Number):void
        {
            _shadow_size = s;
        }
        
        public function get shadowSize():Number
        {
            return _shadow_size;
        }
        
        public function set shadowStrength(s:Number):void
        {
            _shadow_strength = s;
        }
        
        public function get shadowStrength():Number
        {
            return _shadow_strength;
        }
        
        public function set shadowColor(s:Number):void
        {
            _shadow_color = s;
        }
        
        public function get shadowColor():Number
        {
            return _shadow_color;
        }
        
        public function set shadowAlpha(a:Number):void
        {
            _shadow_alpha = a;
        }
        
        public function get shadowAlpha():Number
        {
            return _shadow_alpha;
        }
        
        public function set shadowDistance(a:Number):void
        {
            _shadow_distance = a;
        }
        
        public function get shadowDistance():Number
        {
            return _shadow_distance;
        }
        
        public function set shadowAngle(a:Number):void
        {
            _shadow_angle = a;
        }
        
        public function get shadowAngle():Number
        {
            return _shadow_angle;
        }
        
        public function set color(c:uint):void
        {
            if (_color==null)
                _color = new ColorTransform();          
            _color.color = c;
        }
        
        public function get color():uint
        {
            if (_color==null)
                return 0;
            return _color.color;
        }
        
        public function set scale(s:Number):void
        {
            scaleX = scaleY = s;
        }
        
        public function get scale():Number
        {
            return scaleX;
        }
        
        public function set rasterize(b:Boolean):void
        {
            _rasterize = b;
        }
        
        public function get rasterize():Boolean
        {
            return _rasterize ;
        }
                
        public function toStringAllProps():String
        {
            var s:String = "Decorator {\n";
            for (var p:String in this)
            {
                s += "\t"+p+"="+this[p]+"\n";   
            }
            s += "}";
            return s;
        }
        
        
        private function initBlur():void
        {
            _blur = new BlurFilter();
            _blur.quality = 2;
        }
        
        private function initDropShadow():void
        {
            _shadow = new DropShadowFilter();
            _shadow.quality = BitmapFilterQuality.HIGH;
            _shadow.strength = 1;
            _shadow.blurX = 7;
            _shadow.blurY = 7;
            _shadow.distance = 0;
            _shadow.alpha = .3;
            _shadow.color = 0;
        }
        
        
        public function createBitmap(s:Number=1): Bitmap
        {
            return create_bitmap(this,s,_width,_height,background.borderThickness,0,0, true, 0x00000000);
        }
        
        public function createCroppedBitmap(s:Number,w:Number,h:Number,xoff:Number,yoff:Number): Bitmap
        {
            return create_bitmap(this,1,w,h,0,xoff,yoff,true,0);
        }
        
        private function create_bitmap(d:Decorator,s:Number,w:Number,h:Number,b:Number,xoff:Number,yoff:Number,use_alpha:Boolean,matte_color:uint): Bitmap
        {
            var m:Matrix = new Matrix();
            m.translate(b/2+xoff,b/2+yoff);
            m.scale(s,s);
            var bmd:BitmapData = new BitmapData(w+b, h+b, use_alpha, matte_color);
            bmd.draw(d, m);
            return new Bitmap(bmd);
        }
    
        public function getRootPosition():Point
        {
            return _bg.localToGlobal(new Point(_bg.x,_bg.y))
        }
        // drag and drop
        public function set dragComponent(c:Component):void
        {
            _drag_and_drop.setDragComponent(c);
        }
        
        public function get dragComponent():Component
        {
            return _drag_and_drop.dragComponent;
        }
        
        public function setDragComponent(c:Component):void
        {
            _drag_and_drop.setDragComponent(c);
        }
        
        public function addDropComponent(drop_target_component:Component):void
        {
            _drag_and_drop.addDropComponent(drop_target_component);
        }
        
        public function removeDropComponent(drop_target_component:Component):void
        {
            _drag_and_drop.removeDropComponent(drop_target_component);
        }
        
        public function get dropTargets():Array
        {
            return _drag_and_drop.dropTargets;
        }
        
        public function set dropTargets(a:Array):void
        {
            for (var i:uint=0; i<a.length; i++)
                if (a[i]==null)
                    throw new Error("XXX");
             _drag_and_drop.dropTargets = a;
        }

    
    }
}
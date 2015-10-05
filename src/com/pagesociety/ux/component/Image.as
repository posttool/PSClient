package com.pagesociety.ux.component
{
    import com.pagesociety.ux.decorator.Decorator;
    import com.pagesociety.ux.decorator.ImageDecorator;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.event.ResourceEvent;
    
    [Event(type="com.pagesociety.ux.event.ResourceEvent",name="load_resource")]
    [Event(type="com.pagesociety.ux.event.ResourceEvent",name="load_error")]
    [Event(type="com.pagesociety.ux.event.ResourceEvent",name="load_progress")]
    public class Image extends Component
    {
        public static var ROOT_URL:String;
        
        protected var _image_decorator:ImageDecorator;
        protected var _src:String;
        private var _loaded:Boolean;
        
        public function Image(parent:Container, index:int=-1)
        {
            super(parent, index);
            decorator = new ImageDecorator();
            styleName = "Image";
        }
        
        override public function set decorator(d:Decorator):void 
        {
            super.decorator = d;
            _image_decorator = d as ImageDecorator;
            if (_image_decorator!=null)
            {
                _image_decorator.addEventListener(ResourceEvent.LOAD_RESOURCE, on_load_resource_event);
                _image_decorator.addEventListener(ResourceEvent.LOAD_ERROR, on_load_resource_error);
                _image_decorator.addEventListener(ResourceEvent.LOAD_PROGRESS, on_load_progress);
            }
        }
        
        
        public function get imageDecorator():ImageDecorator
        {
            return _image_decorator;
        }
        
        public function set src(s:String):void
        {
            if (s==_src)
                return;
            
            if (ROOT_URL!=null && s.indexOf("http://")==-1)
                    s = ROOT_URL + s;
            
            _src = s;
            _loaded = false;
            _image_decorator.imageSrc = s;
        }
        
        public function set smoothing(b:Boolean):void
        {
            imageDecorator.smoothing = b;
        }
        
        public function get smoothing():Boolean
        {
            return imageDecorator.smoothing;
        }
        
        
        public function get src():String
        {
            return _src;
        }
        
        override public function destroy():void
        {
            if (_image_decorator!=null)
            {
                _image_decorator.removeEventListener(ResourceEvent.LOAD_RESOURCE, on_load_resource_event);
                _image_decorator.removeEventListener(ResourceEvent.LOAD_ERROR, on_load_resource_error);
            }
            super.destroy();
            
        }

        protected function on_load_resource_event(e:ResourceEvent):void
        {
            _loaded = true;
            dispatchEvent(new ResourceEvent(ResourceEvent.LOAD_RESOURCE,this));
        }
        
        protected function on_load_resource_error(e:ResourceEvent=null):void
        {
            _loaded = true;
            if (_src!=null)
            {
                Logger.error("IMAGE: cant load "+_src);
                _src = null;
            }
            dispatchEvent(new ResourceEvent(ResourceEvent.LOAD_ERROR,this));
        }
        
        protected function on_load_progress(e:ComponentEvent):void
        {
            dispatchComponentEvent(ResourceEvent.LOAD_PROGRESS,this,e.data);
        }
        
        override public function get width():Number
        {
            if (_image_decorator == null || _image_decorator.is_centered_x())
                return super.width;
            
            switch (_image_decorator.imageScalingType)
            {
                case ImageDecorator.IMAGE_SCALING_VALUE_NONE:
                    return imageWidth;
                default:
                    return super.width;
            }
            
        }
        
        override public function get height():Number
        {
            if (_image_decorator == null || _image_decorator.is_centered_y())
                return super.height;
            
            switch (_image_decorator.imageScalingType)
            {
                case ImageDecorator.IMAGE_SCALING_VALUE_NONE:
                //case ImageDecorator.IMAGE_SCALING_VALUE_FIT_HEIGHT:
                    return imageHeight;
                default:
                    return super.height;
            }
        }
        
        public function get imageWidth():Number
        {
            return _image_decorator.imageWidth;
        }
        
        public function get imageHeight():Number
        {
            return _image_decorator.imageHeight;
        }
        
        public function get imageX():Number
        {
            if (!_loaded)
                return 0;
            else
                return _image_decorator.imageX;
        }
        
        public function get imageY():Number
        {
            if (!_loaded)
                return 0;
            else
                return _image_decorator.imageY;
        }
    
        public function get imageScalingType():uint
        {
            return imageDecorator.imageScalingType;
        }
        
        public function set imageScalingType(i:uint):void
        {
            imageDecorator.imageScalingType = i;
        }
        
        public function set imageScalingCue(o:Object):void
        {
            imageDecorator.imageScalingCue = o;
        }
        
        

    }
}
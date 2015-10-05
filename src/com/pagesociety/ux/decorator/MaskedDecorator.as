package com.pagesociety.ux.decorator
{
    import flash.geom.Rectangle;
    
    public class MaskedDecorator  extends Decorator
    {
        protected var _mask_x:Number = 0;
        protected var _mask_y:Number = 0;
        protected var _content_width:Number = 0;
        protected var _content_height:Number = 0;
        protected var _dirty_rect:Boolean = false;
        protected var _use_mask:Boolean = true;     
        
        protected var _content_size_provider:Function;
        

        protected var _scroll_rect:Rectangle;
        
        protected var _inset_x:int;//shrink the mask..positive numbers. 2 = shrink 2 px from left and right
        protected var _inset_y:int;

        public function MaskedDecorator(maskWidth:Number=0, maskHeight:Number=0, contentWidth:Number=0, contentHeight:Number=0)
        {
            super();
            _content_width = contentWidth;
            _content_height = contentHeight;
            _inset_x = 0;
            _inset_y = 0;
        }
        
        override public function initGraphics():void
        {
            super.initGraphics();
            //cache as bitmap creates redraw errors in masked items?...
            //midground.cacheAsBitmap = true;
            _scroll_rect = new Rectangle();
        }

        override public function decorate():void
        {
            super.decorate(); 
            if (_dirty_rect)
            {
                _scroll_rect.x = _mask_x;
                _scroll_rect.y = _mask_y;
                _scroll_rect.width  = _width + -(_inset_x * 2);             
                _scroll_rect.height = _height+ (-_inset_y * 2);
                if (_use_mask)
                {
                    midground.x = 0 + _inset_x;
                    midground.y = 0 + _inset_y;
                    midground.scrollRect = _scroll_rect;
                }
                else
                {
                    midground.x = -_mask_x;
                    midground.y = -_mask_y;
                    midground.scrollRect = null;
                }
                _dirty_rect = false;
            }
        }

        public function set insets(insets:Array):void
        {
            _inset_x = insets[0];
            _inset_y = insets[1];
            
        }
        override public function set width(w:Number):void
        {
            super.width = w;
            _dirty_rect = true;
        }
        
        override public function set height(h:Number):void
        {
            super.height = h;
            _dirty_rect = true;
        }
        
        public function set maskX(x:Number):void
        {
            _mask_x = x;
            _dirty_rect = true;
        }
        
        public function get maskX():Number
        {
            return _mask_x;
        }
        
        public function set maskY(y:Number):void
        {
            _mask_y = y;
            _dirty_rect = true;
        }
        
        public function get maskY():Number
        {
            return _mask_y;
        }
        
        public function set useMask(b:Boolean):void
        {
            _use_mask = b;
        }
        
        public function get useMask():Boolean
        {
            return _use_mask;
        }
        
        public function set contentWidth(w:Number):void
        {
            _content_width = w;
            _dirty_rect = true;
        }
        
        public function get contentWidth():Number
        {
            return _content_width;
        }
        
        public function set contentHeight(h:Number):void
        {
            _content_height = h;
            _dirty_rect = true;
        }
        
        public function get contentHeight():Number
        {
            return _content_height;
        }
        
        public function set contentSizeProvider(f:Function):void
        {
            _content_size_provider = f;
        }
        
        public function get contentSizeProvider():Function
        {
            return _content_size_provider;
        }
        
    }
}
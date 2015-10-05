package com.pagesociety.ux.decorator
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    public class ScrollingDecorator extends MaskedDecorator implements IScrollingDecorator
    {

        
        public static var SCROLL_TYPE_VALUE_VERTICAL:String     = "vertical"; 
        public static var SCROLL_TYPE_VALUE_HORIZONTAL:String   = "horizontal"; 
        public static var SCROLL_TYPE_VALUE_BOTH:String         = "both"; 
        
        private var _scroll_type:String;


        public function ScrollingDecorator(scroll_type:String=null)
        {
            super();
            _scroll_type = scroll_type == null ? SCROLL_TYPE_VALUE_VERTICAL : scroll_type;
        }

        
        public function scrollsHorizontally():Boolean
        {
            return _scroll_type==SCROLL_TYPE_VALUE_HORIZONTAL || _scroll_type==SCROLL_TYPE_VALUE_BOTH;
        }
        
        public function scrollsVertically():Boolean
        {
            return _scroll_type==SCROLL_TYPE_VALUE_VERTICAL || _scroll_type==SCROLL_TYPE_VALUE_BOTH;
        }
    
        public function setScrollOffset(h:Number,v:Number):void
        {
            scroll_vertical(v);
            scroll_horizontal(h);
        }
    
        ///////////////////////// mouse vertical
        
        protected function scroll_vertical(y:Number):void 
        {   
//          var max_scroll:Number = _content_height - _mask_height;
//          if (y > max_scroll) 
//              y = max_scroll;
//          if (y < 0) 
//              y=0;
            maskY = y;
        }
        
        public function setScrollVertical(y:Number):void 
        {
            scroll_vertical(y);
            decorate();
        }
        
        public function getScrollVertical():Number
        {
            return _mask_y;
        }
    
        public function isDisplayingVertical(y:Number):Boolean
        {
            if (y < getScrollVertical())
                return false;
            if (y > getScrollVertical() + _height)
                return false;
            return true;
        }
        
        // horizontal

        protected function scroll_horizontal(x:Number):void 
        {   
//          var max_scroll:Number = _content_width - _mask_width;
//          if (x > max_scroll) 
//              x = max_scroll;
//          if (x < 0) 
//              x=0;
            maskX = x;
            
        }
        
        public function setScrollHorizontal(x:Number):void 
        {
            scroll_horizontal(x);
            decorate();
        }
        
        public function getScrollHorizontal():Number
        {
            return _mask_x;
        }
    
        public function isDisplayingHorizontal(x:Number):Boolean
        {
            if (x < getScrollHorizontal())
                return false;
            if (x > getScrollHorizontal() + _width)
                return false;
            return true;
        }
    
    
    }
}
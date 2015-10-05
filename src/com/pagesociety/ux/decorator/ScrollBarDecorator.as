package com.pagesociety.ux.decorator
{
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    public class ScrollBarDecorator extends ScrollingDecorator
    {

        protected var _scroll_bar_height:Number = 12;
        protected var _scroll_bar_width:Number = 12;
        protected var _scroll_bar_background_color:uint = 0xAAAAAA;
        protected var _scroll_bar_background_alpha:Number = .3;
        protected var _scroll_bar_thumb_corner_radius:Number = 10;
        protected var _scroll_bar_thumb_color:uint = 0x999999;
        protected var _scroll_bar_thumb_alpha:Number = .8;
        
        protected var horizontal_scroll_bar:Sprite;
        protected var horizontal_thumb:Sprite;
        protected var vertical_scroll_bar:Sprite;
        protected var vertical_thumb:Sprite;
        
        // calculated on render
        private var width_ratio:Number;
        private var height_ratio:Number;
        private var thumb_width:Number;
        private var thumb_height:Number;

        private var click_x:Number;
        private var click_thumb_x:Number;
        private var click_y:Number;
        private var click_thumb_y:Number;

        public function ScrollBarDecorator(scroll_type:String)
        {
            super(scroll_type);
            
        }

        public function set scrollBarHeight(n:Number):void
        { 
            _scroll_bar_height = n; 
        }
        
        public function set scrollBarWidth(n:Number):void
        { 
            _scroll_bar_width = n; 
        }
        
        public function set scrollBarBackgroundColor(c:uint):void
        { 
            _scroll_bar_background_color = c; 
        }
        
        public function set scrollBarBackgroundAlpha(a:Number):void
        { 
            _scroll_bar_background_alpha = a; 
        }
        
        public function set scrollBarThumbCornerRadius(r:Number):void
        { 
            _scroll_bar_thumb_corner_radius= r; 
        }
         
        public function set scrollBarThumbColor(c:uint):void
        { 
            _scroll_bar_thumb_color = c; 
        }
        
        public function set scrollBarThumbAlpha(a:Number):void
        { 
            _scroll_bar_thumb_alpha = a; 
        }
        
        //
        public function get scrollBarHeight():Number
        { 
            return _scroll_bar_height; 
        }
        
        public function get scrollBarWidth():Number
        { 
            return _scroll_bar_width; 
        }
        
        public function get scrollBarBackgroundColor():uint
        { 
            return _scroll_bar_background_color; 
        }
        
        public function get scrollBarBackgroundAlpha():Number
        { 
            return _scroll_bar_background_alpha; 
        }
        
        public function get scrollBarThumbCornerRadius():Number
        { 
            return _scroll_bar_thumb_corner_radius; 
        }
         
        public function get scrollBarThumbColor():uint
        { 
            return _scroll_bar_thumb_color; 
        }
        
        public function get scrollBarThumbAlpha():Number
        { 
            return _scroll_bar_thumb_alpha; 
        }
    
        //////////////////////////////////////////////////////////////////////////
        
        override public function initGraphics():void 
        {   
            super.initGraphics();
            horizontal_scroll_bar = new Sprite();
            horizontal_scroll_bar.addEventListener(MouseEvent.MOUSE_DOWN, press_horizontal_bar);
            horizontal_scroll_bar.addEventListener(MouseEvent.ROLL_OVER, on_over_horizontal_bar );
            horizontal_scroll_bar.addEventListener(MouseEvent.ROLL_OUT, on_out_horizontal_bar );
            addChild(horizontal_scroll_bar);
            
            horizontal_thumb = new Sprite();
            horizontal_thumb.addEventListener(MouseEvent.MOUSE_DOWN, press_horizontal_thumb);
            horizontal_thumb.addEventListener(MouseEvent.ROLL_OVER, on_over_horizontal_bar );
            horizontal_thumb.addEventListener(MouseEvent.ROLL_OUT, on_out_horizontal_bar );
            addChild(horizontal_thumb);
            
            vertical_scroll_bar = new Sprite();
            vertical_scroll_bar.addEventListener(MouseEvent.MOUSE_DOWN, press_vertical_bar);
            vertical_scroll_bar.addEventListener(MouseEvent.ROLL_OVER, on_over_vertical_bar );
            vertical_scroll_bar.addEventListener(MouseEvent.ROLL_OUT, on_out_vertical_bar );
            addChild(vertical_scroll_bar);
            
            vertical_thumb = new Sprite();
            vertical_thumb.addEventListener(MouseEvent.MOUSE_DOWN, press_vertical_thumb);
            vertical_thumb.addEventListener(MouseEvent.ROLL_OVER, on_over_vertical_bar );
            vertical_thumb.addEventListener(MouseEvent.ROLL_OUT, on_out_vertical_bar );
            addChild(vertical_thumb);
        }
        
        protected function on_over_horizontal_bar(e:MouseEvent):void { horizontal_scroll_bar.alpha = .9;}
        protected function on_out_horizontal_bar(e:MouseEvent):void { horizontal_scroll_bar.alpha = 1;}
        protected function on_over_vertical_bar(e:MouseEvent):void { vertical_scroll_bar.alpha = .9;}
        protected function on_out_vertical_bar(e:MouseEvent):void { vertical_scroll_bar.alpha = 1;}
        
        override public function decorate():void 
        {
            
            super.decorate();

            width_ratio = _width/_content_width;
            height_ratio = _height/_content_height;
            
            thumb_width = _width*width_ratio;
            thumb_height = _height*height_ratio;
        
            if (scrollsHorizontally() && width_ratio<1.0) 
            {
                horizontal_scroll_bar.visible = true;
                horizontal_scroll_bar.y = _height - _scroll_bar_height;
                draw_horizontal_scroll_bar(horizontal_scroll_bar.graphics, _width, _scroll_bar_height);
                
                horizontal_thumb.visible = true;
                horizontal_thumb.y = _height - _scroll_bar_height;
                draw_horizontal_scroll_thumb(horizontal_thumb.graphics, thumb_width, _scroll_bar_height);
                
                scroll_horizontal(getScrollHorizontal());
            } 
            else 
            {
                horizontal_scroll_bar.visible = false;
                horizontal_thumb.visible = false;
                scroll_horizontal(0);
            }
            if (scrollsVertically() && height_ratio<1.0) 
            {
                vertical_scroll_bar.visible = true;
                vertical_scroll_bar.x = _width - _scroll_bar_width; 
                draw_vertical_scroll_bar(vertical_scroll_bar.graphics, _scroll_bar_width, _height);

                vertical_thumb.visible = true;
                vertical_thumb.x = _width - _scroll_bar_width;
                draw_vertical_scroll_thumb(vertical_thumb.graphics, _scroll_bar_width, thumb_height);
                
                scroll_vertical(getScrollVertical());
            } 
            else 
            {
                vertical_scroll_bar.visible = false;
                vertical_thumb.visible = false;
                scroll_vertical(0);
            }
            
        }
        
        protected function draw_horizontal_scroll_bar(g:Graphics, width:Number, height:Number):void
        {
            g.clear();
            g.beginFill(_scroll_bar_background_color,_scroll_bar_background_alpha);
            g.drawRect(0,0,width,height);
            g.endFill();
        }
        
        protected function draw_horizontal_scroll_thumb(g:Graphics, width:Number, height:Number):void
        {
            g.clear();
            g.beginFill(_scroll_bar_thumb_color,_scroll_bar_thumb_alpha);
            g.drawRoundRect(0, 1 , width, height-2, _scroll_bar_thumb_corner_radius, _scroll_bar_thumb_corner_radius);
            g.endFill();
        }
    

        protected function draw_vertical_scroll_bar(g:Graphics, width:Number, height:Number):void
        {
            g.clear();
            g.beginFill(_scroll_bar_background_color,_scroll_bar_background_alpha);
            g.drawRect(0,0,width,height);
            g.endFill();
        }
        
        protected function draw_vertical_scroll_thumb(g:Graphics, width:Number, height:Number):void
        {
            g.clear();
            g.beginFill(_scroll_bar_thumb_color,_scroll_bar_thumb_alpha);
            g.drawRoundRect(2, 0, width-4, height, _scroll_bar_thumb_corner_radius, _scroll_bar_thumb_corner_radius);
            g.endFill();
        }
    
        ///////////////////////// mouse vertical
        
        private function press_vertical_thumb(e:MouseEvent):void
        {
            click_thumb_y = vertical_thumb.y;
            click_y = e.stageY;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, drag_vertical);
            stage.addEventListener(MouseEvent.MOUSE_UP, release_vertical);
        }
        
        private function drag_vertical(e:MouseEvent):void
        {
            scroll_vertical_in_thumb_coords(click_thumb_y + (e.stageY - click_y));
            dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE));
        }
        
        private function release_vertical(e:MouseEvent):void
        {
            if (stage==null)
            {
                Logger.log("STAGE IS NULL! "+this);
                return;
            }
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, drag_vertical);
            stage.removeEventListener(MouseEvent.MOUSE_UP, release_vertical);
        }
        
        private function press_vertical_bar(e:MouseEvent):void
        {
            scroll_vertical_in_thumb_coords(e.localY - thumb_height/2);
            dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE));
        }
        
        private function scroll_vertical_in_thumb_coords(y_thumb:Number):void 
        {   
            var max_thumb:Number = _height - thumb_height;
            var max_scroll:Number = _content_height - _height;
            if (y_thumb > max_thumb) 
                y_thumb = max_thumb;
            if (y_thumb < 0) 
                y_thumb = 0;
            vertical_thumb.y = y_thumb;
            var y_fg:Number = max_scroll * (y_thumb / max_thumb);
            maskY = y_fg;
            super.decorate();
        }
        
        override protected function scroll_vertical(y:Number):void 
        {   
            var max_scroll:Number = _content_height - _height;
            if (y > max_scroll) 
                y = max_scroll;
            if (y < 0) 
                y=0;
            maskY = y;
            var max_thumb:Number = _height - thumb_height;
            vertical_thumb.y = (y / max_scroll) * max_thumb;
            super.decorate();
        }
        
        public function get percentVertical():Number
        {
            return vertical_thumb.y/(_content_height - _height);
        }
        
        
        
        // horizontal

        private function press_horizontal_thumb(e:MouseEvent):void
        {
            click_thumb_x = horizontal_thumb.x;
            click_x = e.stageX;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, drag_horizontal);
            stage.addEventListener(MouseEvent.MOUSE_UP, release_horizontal);
        }
        
        private function drag_horizontal(e:MouseEvent):void
        {
            scroll_horizontal_in_thumb_coords(click_thumb_x + (e.stageX - click_x));
            dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE));
        }
        
        private function release_horizontal(e:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, drag_horizontal);
            stage.removeEventListener(MouseEvent.MOUSE_UP, release_horizontal);
        }
        
        private function press_horizontal_bar(e:MouseEvent):void
        {
            scroll_horizontal_in_thumb_coords(e.localX - thumb_width/2);
            dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE));
        }
        
        private function scroll_horizontal_in_thumb_coords(x_thumb:Number):void 
        {   
            var max_thumb:Number = _width - thumb_width;
            var max_scroll:Number = _content_width - _width;
            if (x_thumb > max_thumb) 
                x_thumb = max_thumb;
            if (x_thumb < 0) 
                x_thumb = 0;
            horizontal_thumb.x = x_thumb;
            var x_fg:Number = max_scroll * (x_thumb / max_thumb);
            maskX = x_fg ;
            super.decorate();
        }
        
        override protected function scroll_horizontal(x:Number):void 
        {   
            var max_scroll:Number = _content_width - _width;
            if (x > max_scroll) 
                x = max_scroll;
            if (x < 0) 
                x=0;
            maskX = x;
            var max_thumb:Number = _width - thumb_width;
            horizontal_thumb.x = (x / max_scroll) * max_thumb;
            super.decorate();
        }
        
        
        
    
    
        // scroll wehelele
        public function do_mouse_wheel(e:MouseEvent):void
        {
            if (scrollsVertically())
            {
                if(e.delta<0)
                    scroll_vertical_in_thumb_coords(vertical_thumb.y + 10);
                else
                    scroll_vertical_in_thumb_coords(vertical_thumb.y - 10);
            }
            else if (scrollsHorizontally())
            {
                if(e.delta<0)
                    scroll_horizontal_in_thumb_coords(horizontal_thumb.x + 10);
                else
                    scroll_horizontal_in_thumb_coords(horizontal_thumb.x - 10);
            }
            decorate();
        }
    }
}
package com.pagesociety.ux.decorator
{
    import com.pagesociety.ux.component.Slider;
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class SliderDecorator extends Decorator
    {
        protected var _sbg:Sprite;
        protected var _smax:Sprite;
        protected var _nub:Sprite;
        
        protected var _r:Number; // between 0 and 1 
        protected var _max:Number;
        
        private var _nub_size           :Number = 6;
        private var _bg_color           :uint = 0x000000;
        private var _bg_alpha           :Number = 1;
        private var _max_color          :uint = 0x666666;
        private var _max_alpha          :Number = 1;
        private var _nub_color          :uint = 0xffffff;
        private var _nub_alpha          :Number = 1;
        private var _nub_height         :Number = -1;
        private var _nub_yoffset        :Number = 0;
        private var _change_val_on_drag :Boolean = true;
        
        public function SliderDecorator()
        {
            super();
        }
        
        override public function initGraphics():void
        {
            super.initGraphics();
            
            _sbg = new Sprite();
            addChild(_sbg);

            _smax = new Sprite();
            _smax.addEventListener(MouseEvent.MOUSE_DOWN, on_click_bg);
            _smax.addEventListener(MouseEvent.MOUSE_OVER, on_over_bg);
            _smax.addEventListener(MouseEvent.MOUSE_OUT, on_out_bg);
            addChild(_smax);

            _nub = new Sprite();
            _nub.addEventListener(MouseEvent.MOUSE_DOWN, on_mouse_down_nub);
            _nub.addEventListener(MouseEvent.MOUSE_OVER, on_over_bg);
            _nub.addEventListener(MouseEvent.MOUSE_OUT, on_out_bg);
            addChild(_nub);
            
            on_over_bg(null);
        }
        
        public function get nubR():Number
        {
            return _r;
        }
        
        public function set nubR(r:Number):void
        {
            _r = r;
        }
        
        public function set max(m:Number):void
        {
            _max = m;
        }

        public function get max():Number
        {
            return _max;
        }

        public function get nubSize():Number
        {
            return _nub_size;
        }
        
        public function set nubSize(x:Number):void
        {
            _nub_size = x;
        }
        
        public function get backgroundColor():uint
        {
            return _bg_color;
        }
        
        public function set backgroundColor(x:uint):void
        {
            _bg_color = x;
        }
        
        public function get backgroundAlpha():Number
        {
            return _bg_alpha;
        }
        
        public function set backgroundAlpha(x:Number):void
        {
            _bg_alpha = x;
        }
        
        public function get maxColor():uint
        {
            return _max_color;
        }
        
        public function set maxColor(x:uint):void
        {
            _max_color = x;
        }
        
        public function get maxAlpha():Number
        {
            return _max_alpha;
        }
        
        public function set maxAlpha(x:Number):void
        {
            _max_alpha = x;
        }
        
        public function get nubColor():uint
        {
            return _nub_color;
        }
        
        public function set nubColor(x:uint):void
        {
            _nub_color = x;
        }
        
        public function get nubAlpha():Number
        {
            return _nub_alpha;
        }
        
        public function set nubAlpha(x:Number):void
        {
            _nub_alpha = x;
        }
        
        
        public function get nubHeight():Number
        {
            return _nub_height;
        }
        
        public function set nubHeight(x:Number):void
        {
            _nub_height = x;
        }
        
        public function get nubYOffset():Number
        {
            return _nub_yoffset;
        }
        
        public function set nubYOffset(y:Number):void
        {
            _nub_yoffset = y;
        }
        
        
        override public function decorate():void
        {
            updatePosition(_x,_y);
            draw_bg();
            draw_smax();
            draw_nub();
            _sbg.alpha = .2;
            _nub.x = (width-_nub_size)*_r;
        }
        
        
        // click drag release nub
        private var _drag_point:Point;
        private function on_mouse_down_nub(e:MouseEvent):void
        {
            stage.addEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move_nub);
            stage.addEventListener(MouseEvent.MOUSE_UP, on_mouse_release_nub);
            _drag_point = new Point(e.stageX,e.stageY);
            on_over_bg(e);
        }
        
        private function on_mouse_move_nub(e:MouseEvent):void
        {
            var np:Point = new Point(e.stageX,e.stageY);
            _nub.x -= _drag_point.subtract(np).x;
            if (!constrain_nub_x())
                _drag_point = np;
            calc_rx();
            if (_change_val_on_drag)
                dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE));
        }
        
        private function on_mouse_release_nub(e:MouseEvent):void
        {
            _drag_point=null;
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move_nub);
            stage.removeEventListener(MouseEvent.MOUSE_UP, on_mouse_release_nub);
            if (!_change_val_on_drag)
                dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE));
            dispatchEvent(new ComponentEvent(ComponentEvent.MOUSE_RELEASE));
        }
        
        // over bg
        private function on_click_bg(e:MouseEvent):void
        {
            _nub.x = e.localX-_nub_size/2;
            constrain_nub_x();
            calc_rx()
            dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE));
            on_mouse_down_nub(e);
        }
        
        private function calc_rx():void
        {
            _r = _nub.x / (width- _nub_size);
        }
        
        private function on_over_bg(e:MouseEvent):void
        {
            _smax.alpha = .4;
        }
        
        private function on_out_bg(e:MouseEvent):void
        {
            if (_drag_point==null)
                _smax.alpha = .2;
        }
        
        protected function constrain_nub_x():Boolean
        {
            if (_nub.x<0)
            {
                _nub.x = 0;
                return true;
            }
            if (_nub.x > width - _nub_size)
            {
                _nub.x = width - _nub_size;
                return true;
            }
            if (_nub.x > width*_max - _nub_size)
            {
                _nub.x = width*_max - _nub_size;
                return true;
            }
            return false;
        }

        
        protected function draw_bg():void
        {
            var g:Graphics = _sbg.graphics;
            g.clear();
            g.beginFill(_bg_color,_bg_alpha);
            g.drawRect(0,0,width,height);
            g.endFill();
        }
        
        protected function draw_smax():void
        {
            var g:Graphics = _smax.graphics;
            g.clear();
            if (isNaN(_max))
                return;
            g.beginFill(_max_color,_max_alpha);
            g.drawRect(0,0,width*_max,height);
            g.endFill();
        }
        
        protected function draw_nub():void
        {
            var g:Graphics = _nub.graphics;
            g.clear();
            g.beginFill(_nub_color,_nub_alpha);
            g.drawRect(0,_nub_yoffset,_nub_size,_nub_height==-1?height:_nub_height);
            g.endFill();
        }
        
    }
}
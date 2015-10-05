package com.pagesociety.ux.component.media
{
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.display.Graphics;
    import flash.geom.Point;

    [Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
    public class Volume extends Container
    {
        private var _controller     :Container;
        private var _cb             :Component;
        private var _bars           :Component;
        private var _audio_level    :Number = 1;
        
        private var _bg_color:uint = 0xffffff;
        private var _bar_color:uint = 0xffffff;
        
        public function Volume(parent:Container, index:int=-1)
        {
            super(parent, index);
            _controller         = new Container(this);
            _controller.addEventListener(ComponentEvent.DRAG, on_drag);
            _controller.x       = 33;
            _controller.y       = -H1;
            _controller.alpha   = 0;
            _controller.height  = H1;
            _controller.backgroundVisible = true;
            _controller.backgroundColor = _bar_color;
            _controller.backgroundAlpha = .4;
            
            _cb                 = new Component(_controller);
            _cb.backgroundVisible = true;
            _cb.backgroundColor = _bar_color;
            
            _bars               = new Component(this);
            
            backgroundVisible   = true;
            backgroundColor     = _bg_color;
            backgroundAlpha     = .4;
            
            addEventListener(ComponentEvent.MOUSE_OVER, function(e:*):void
            {
                _controller.alphaTo(1);
            });
            addEventListener(ComponentEvent.MOUSE_OUT, function(e:*):void
            {
                _controller.alphaTo(0);
            });
            addEventListener(ComponentEvent.CLICK, on_click);
            
            width = 30;
        }
        
        public function get value():Number
        {
            return _audio_level;
        }
        
        public function set value(n:Number):void
        {
            _audio_level = n;
        }
        
        private static const XO:Number = 38;
        private static const YO:Number = 10;
        private static const W:Number = 8;
        private static const H:Number = 18;
        private static const H1:Number = 75;
        private static const H2:Number = 40;
        private static const GAP:Number = 3;
        private static const BARS:uint = 3;
        
        override public function render():void
        {
//          _headphones.x = 10;
//          _headphones.y = 10;

            _cb.height = _audio_level*_controller.height;
            _cb.y = _controller.height-_cb.height;
            
            var g:Graphics = _bars.decorator.graphics;
            g.clear();
            for (var i:uint=0; i<BARS; i++)
            {
                var h:Number = ((i+1)/BARS)*H;
                g.beginFill(_bar_color, (i/BARS)<_audio_level?1:.5);
                g.drawRect(XO+i*W, YO+H-h, W-GAP, h);   
                g.endFill();
            }
//          _controller.movieClip.top_with_shadow.y = 35-_audio_level*H2;
//          _controller.movieClip.bottom.y = 35-_audio_level*H2+30;
//          _controller.movieClip.bottom.height = 25+_audio_level*H2;
            super.render();
        }
        
        private function on_drag(e:ComponentEvent):void
        {
            var p:Point = _controller.getRootPosition();
            var y:Number = e.data.y-p.y;
            var a:Number = 1-y/H1;
            if (a<0) a=0;
            if (a>1) a= 1;
            _audio_level = a;
            render();
            dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, _audio_level);
        }
        
        private function on_click(e:ComponentEvent):void
        {
            if (_audio_level==0)
                _audio_level = .85;
            else
                _audio_level = 0;
            render();
            dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, _audio_level);
        }
    }
}
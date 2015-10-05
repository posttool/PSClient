package com.pagesociety.ux.component.media
{
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.SpriteComponent;
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.display.Graphics;

    [Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
    public class PlayPause extends Container
    {
        private var _play_pause:SpriteComponent;
        private var _state:uint=PAUSE;
        
        public static const PLAY:uint = 0;
        public static const PAUSE:uint = 1;
        
        public function PlayPause(parent:Container, index:int=-1)
        {
            super(parent, index);
            
//          _play_pause = new SpriteComponent(this, new PlayPause());
//          _play_pause.stop();
//          _play_pause.x = 10;
//          _play_pause.y = 10;
            
            backgroundVisible   = true;
            backgroundAlpha     = .4;
            
            addEventListener(ComponentEvent.CLICK, on_click);
            
        }
        
        private function on_click(e:ComponentEvent):void
        {
            if (_state==PLAY)
                _state = PAUSE;
            else
                _state = PLAY;
            render();
            dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, _state);
        }
        
        public function get state():uint
        {
            return _state;
        }
        
        public function set state(s:uint):void
        {
            _state = s
        }
        
        override public function render():void
        {
            var XO:Number = 9;
            var YO:Number = 7;
            var S:Number = 17;
            var g:Graphics = decorator.graphics;
            g.clear();
            if (_state==PAUSE)
            {
                g.beginFill(0xffffff,1);
                g.moveTo(XO+0,YO+0);
                g.lineTo(XO+S/2,YO+S/2);
                g.lineTo(XO+0,YO+S);
                g.lineTo(XO+0,YO+0);
                g.endFill();
            }
            else
            {
                g.beginFill(0xffffff,1);
                g.drawRect(XO+0,YO+0,4,S);
                g.drawRect(XO+8,YO+0,4,S);
                g.endFill();
            }
            super.render();
        }
    }
}
  package com.pagesociety.ux.component.media
{
    import com.pagesociety.ux.MovingValue;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.Slider;
    import com.pagesociety.ux.event.ComponentEvent;

    [Event(type="com.pagesociety.ux.component.media.VideoControl", name="seek")]
    [Event(type="com.pagesociety.ux.component.media.VideoControl", name="seek_complete")]
    [Event(type="com.pagesociety.ux.component.media.VideoControl", name="play")]
    [Event(type="com.pagesociety.ux.component.media.VideoControl", name="pause")]
    [Event(type="com.pagesociety.ux.component.media.VideoControl", name="volume")]
    public class VideoControl extends Container
    {
        
        public static const SEEK            :String = "seek";
        public static const SEEK_COMPLETE   :String = "seek_complete";
        public static const PLAY            :String = "play";
        public static const PAUSE           :String = "pause";
        public static const VOLUME          :String = "volume";
        
        
        private var _controls               :Container;
//      private var _info                   :Label;
        private var _bg                     :Component;
        private var _play_pause             :PlayPause;
        private var _loading_indicator      :Component;
        private var _seeker                 :Slider;
        private var _volume                 :Volume;
        
        private var _time                   :Number;
        private var _duration               :Number;
        private var _buffer_length          :Number;
        private var _buffering              :Boolean;
        private var _percent_complete       :Number;
        private var _seeking                :Boolean;
        
        public var MAX_H                    :Number = 33;
        private var _h                      :MovingValue = new MovingValue(MAX_H);
        private var _yo                     :MovingValue = new MovingValue(0);
        
        private var _is_hidable             :Boolean = true;
        
        
        public function VideoControl(parent:Container, index:int=-1)
        {
            super(parent, index);
            
            _controls                   = new Container(this);
//          _controls.decorator         = new MaskedDecorator();
            
//          _info                       = new Label(_controls);
            
            _bg                         = new Component(_controls);
            _bg.backgroundVisible       = true;
//          _bg.backgroundColor         = Constants.COLOR_PRIMARY;
            _bg.backgroundAlpha         = .4;
            
            _play_pause                 = new PlayPause(_controls);
            _play_pause.addEventListener(ComponentEvent.CHANGE_VALUE, on_play_pause);

            _loading_indicator                      = new Component(_controls);
            _loading_indicator.backgroundVisible    = true;
//          _loading_indicator.backgroundColor      = Constants.COLOR_PRIMARY;
            _loading_indicator.backgroundAlpha      = .4;
            _loading_indicator.width                = 1;
            
            _seeker                     = new Slider(_controls);
//          _seeker.nubColor            = Constants.COLOR_PRIMARY;
            _seeker.nubSize             = 10;
            _seeker.backgroundAlpha     = 0;
            _seeker.setRange(0, 1);
            _seeker.addEventListener(ComponentEvent.CHANGE_VALUE, on_seek);
            _seeker.addEventListener(ComponentEvent.MOUSE_RELEASE, on_seek_complete);

            _volume                     = new Volume(_controls);
            _volume.addEventListener(ComponentEvent.CHANGE_VALUE, on_volume);
            
            _duration                   = 0;
        }
        
        override public function render():void
        {
            var xo:Number = 65;
            var wo:Number = width-xo-xo;
            var is_vis:Boolean = _h.value==MAX_H;
            
            _controls.y = height - _h.value - _yo.value;
            _controls.height = _h.value;

            _play_pause.visible = is_vis;
            _volume.visible = is_vis;
            
            _play_pause.width = xo;
            _loading_indicator.x = xo;          
            _seeker.x = xo;
            if (_duration!=0)
            {
                var m:Number = Math.max((_time+_buffer_length)/_duration, _percent_complete);
                _loading_indicator.width = m*wo;
                _seeker.width = wo;
                _seeker.maxValue = m;
                if (!_seeking)
                    _seeker.value = _time/_duration;
            }
            
            _volume.width = xo;
            _volume.x = width - xo;
            super.render();
        }
        
        public function get paused():Boolean
        {
            return _play_pause.state == PlayPause.PAUSE;
        }
        
        public function set paused(b:Boolean):void
        {
            if (b)
                _play_pause.state = PlayPause.PAUSE;
            else
                _play_pause.state = PlayPause.PLAY;
        }
        
        public function set buffering(b:Boolean):void
        {
            _buffering = b;
            //TODO update_ui_related_to_buffering
        }
        
        public function set time(n:Number):void
        {
//          if (!_buffering)
//              _info.text = n + " of "+_duration;
            _time = n;
        }
        
        public function set hiding(b:Boolean):void
        {
            _is_hidable = b;
        }
        
        public function get hiding():Boolean
        {
            return _is_hidable;
        }
        
        public function set volume(n:Number):void
        {
            _volume.value = n;
        }
        
        public function get volume():Number
        {
            return _volume.value;
        }
        
        public function set bufferLength(n:Number):void
        {
            _buffer_length = n;
        }
        
        public function set percentComplete(n:Number):void
        {
            _percent_complete = n;
        }
        
        public function set duration(n:Number):void
        {
            _duration = n;
        }
        
        public function show():void
        {
            cancel_execute_late("hide_controller");
            _h.value = MAX_H;
            animate([_h], 200);
        }
        
        public function hide():void
        {
            if (_is_hidable)
                execute_later("hide_controller",do_hide,1700);
        }
        
        private function do_hide():void
        {
            _h.value = 0;
            animate([_h], 500);
        }
        
        private function on_seek(e:ComponentEvent):void
        {
            _seeking = true;
            dispatchComponentEvent(SEEK, this, e.data*_duration);
        }
        
        private function on_seek_complete(e:ComponentEvent):void
        {
            _seeking = false;
            dispatchComponentEvent(SEEK_COMPLETE, this, e.data*_duration);
        }
        
        private function on_play_pause(e:ComponentEvent):void
        {
            if (_play_pause.state==PlayPause.PAUSE)
                dispatchComponentEvent(PAUSE, this);
            else
                dispatchComponentEvent(PLAY, this);
        }
        
        private function on_volume(e:ComponentEvent):void
        {
            dispatchComponentEvent(VOLUME, this, _volume.value);
        }
        
    }
}
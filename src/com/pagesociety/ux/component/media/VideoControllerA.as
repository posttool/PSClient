package com.pagesociety.ux.component.media
{
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.composite.ColorMatrix;
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.filters.ColorMatrixFilter;
    
    public class VideoControllerA extends Container
    {
        
        public var stillRenderer:Function;
        public var bufferIndicatorRenderer:Function;
        public var playButtonRenderer:Function;
        public var pauseButtonRenderer:Function;
        public var replayButtonRenderer:Function;
        public var volumeControlRenderer:Function;
        public var seekerRenderer:Function;
        public var timeDisplayRenderer:Function;
        //
        private var _play_controls:Container;
        private var _video:VideoPlayerA;
        private var _still:Component;
        private var _buffer_indicator:Component;
        private var _play_button:Component;
        private var _pause_button:Component;
        private var _replay_button:Component;
        private var _volume_control:Component;
        private var _seek_control:Component;
        private var _time_display:Component;

        public function VideoControllerA(parent:Container, index:int=-1)
        {
            super(parent, index);
            
            _video = new VideoPlayerA(this);
            _video.addEventListener(VideoPlayerA.TICK, function(e:*):void { update_time(); });
            _video.addEventListener(VideoPlayerA.STOP, onBubbleEvent);
            _video.addEventListener(VideoPlayerA.ON_META_DATA, onBubbleEvent);
            _video.addEventListener(VideoPlayerA.PAUSE, onBubbleEvent);
            
            _play_controls = new Container(this);
        }
        
        public function get playControlContainer():Container
        {
            return _play_controls;
        }
        
//      public function setBrightnessContrast(b:Number,c:Number):void
//      {
//          var cc:ColorMatrix = new ColorMatrix();
//          cc.adjustBrightness(b);
//          cc.adjustContrast(c);
//          _video.decorator.filters = [ new ColorMatrixFilter(cc) ];
//      }
        
        public function get video():VideoPlayerA
        {
            return _video;
        }
        
        public function init():void
        {
            if (stillRenderer!=null)
            {
                _still                      = stillRenderer(this);
                _still.visible              = false;
            }

            if (seekerRenderer!=null)
            {
                _seek_control           = seekerRenderer(_play_controls);
                _seek_control.addEventListener(ComponentEvent.CHANGE_VALUE, on_seek);
                _seek_control.addEventListener(ComponentEvent.MOUSE_RELEASE, on_seek_end);
            }

            _buffer_indicator           = bufferIndicatorRenderer(_play_controls);
            _buffer_indicator.visible   = false;
            
            _play_button                = playButtonRenderer(_play_controls);
            _play_button.visible        = false;
            _play_button.addEventListener(ComponentEvent.CLICK, on_click_play);
            
            _pause_button               = pauseButtonRenderer(_play_controls);
            _pause_button.visible       = false;
            _pause_button.addEventListener(ComponentEvent.CLICK, on_click_pause);
            
            _replay_button              = replayButtonRenderer(_play_controls);
            _replay_button.visible      = false;
            _replay_button.addEventListener(ComponentEvent.CLICK, on_click_replay);
            
            if (timeDisplayRenderer!=null)
            {
                _time_display = timeDisplayRenderer(_play_controls);
            }
            
            if (volumeControlRenderer!=null)
            {
                _volume_control         = volumeControlRenderer(_play_controls);
                _volume_control.addEventListener(ComponentEvent.CHANGE_VALUE, on_change_volume);
            }
                        
            _video.init_buffer_graphics = function ():void
            {
                _buffer_indicator.visible   = true;
                if (_still!=null)
                    _still.visible              = false;
                _video.visible              = true;
                _replay_button.visible      = false;
                _play_button.visible        = false;
                _pause_button.visible       = false;
                render();
            }
            
            _video.update_buffer_graphics = function (p:Number):void
            {   
                //_buffer_indicator should be instance of IPercentValue or something....
                Object(_buffer_indicator).percent   = p;
                render();   
            }
            
            _video.clear_buffering_graphics = function ():void
            {
                _buffer_indicator.visible   = false;
                if (_still!=null)
                    _still.visible              = false;
                _video.visible              = true;
                _replay_button.visible      = false;
                _play_button.visible        = false;
                _pause_button.visible       = true;
                render();
            }
            
            _video.init_end_graphics = function ():void
            {
                _buffer_indicator.visible   = false;
                if (_still!=null)
                {
                    _still.visible              = true;
                    _video.visible              = false;
                }
                _replay_button.visible      = true;
                _play_button.visible        = false;
                _pause_button.visible       = false;
                render();
            }
            
            _video.update_play_pause_graphics = function (play:Boolean):void
            {
                if (_still==null || !_still.visible)
                {
                    _play_button.visible        = play;
                    _pause_button.visible       = !play;
                    render();
                }
            }
            
            _video.clear_end_graphics = function ():void
            {
                _buffer_indicator.visible   = false;
                if (_still!=null)
                    _still.visible              = false;
                _video.visible              = true;
                _replay_button.visible      = false;
                _play_button.visible        = false;
                _pause_button.visible       = false;
                Object(_buffer_indicator).percent   = 0;
                render();
            }
                
            _video.init_end_graphics();

        }
        
        private var _tick_count:uint=0;
        private function update_time():void
        {
            if (_tick_count%5==0)
            {
                if (_seek_control!=null)
                {
                    if (_video.duration!=0)
                    {
                        var m:Number = Math.max(_video.time/_video.duration, _video.bytesLoaded/_video.bytesTotal);
                        Object(_seek_control).max = m;
                        //if (!_seeking)
                            Object(_seek_control).value = _video.time/_video.duration;
                        _seek_control.render();
                    }           
                }
                if (_time_display!=null)
                {
                    var d:Number = Math.floor(_video.time);
                    var n:Number = 0;
                    if (d>59)
                    {
                        n = Math.floor(d/60);
                        d = d-n*60;
                    }
                    Object(_time_display).text = twodig(n)+":"+twodig(d);
                    _time_display.render();
                }
            }
            _tick_count++;
//          _play_controls.render();
        }
        
        private function twodig(n:Number):String
        {
            if (n>9)
                return n.toString();
            else
                return "0"+n;
        }
        
        private function on_click_play(e:ComponentEvent):void
        {
            _video.pause(false);
        }
        
        private function on_click_pause(e:ComponentEvent):void
        {
            _video.pause(true);
        }
        
        private function on_click_replay(e:ComponentEvent):void
        {
            replay();
        }
        
        public function replay():void
        {
            _video.play(_video.flv);
            dispatchComponentEvent(VideoPlayerA.REPLAY, this);
        }
        
        private function on_change_volume(e:ComponentEvent):void
        {
            volume = e.data;
        }
        
        public function set volume(v:Number):void
        {
            _video.volume = v;
        }
        
        private var _seeking:Boolean;
        private var _was_paused:Boolean;
        private function on_seek(e:ComponentEvent):void
        {
            _seeking = true;
//          _was_paused = _video.paused;
//          _video.pause(true);
            _video.time = e.data * _video.duration;
        }
        
        private function on_seek_end(e:ComponentEvent):void
        {
            _seeking = false;
//          _video.pause(_was_paused);
            _video.time = e.data * _video.duration;
        }
    }
}
package com.pagesociety.ux.component.media
{
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.util.Locker;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.web.ResourceUtil;
    
    import flash.utils.Timer;

    [Event(type="com.pagesociety.ux.component.Video",name="start")]
    [Event(type="com.pagesociety.ux.component.Video",name="stop")]
    [Event(type="com.pagesociety.ux.component.Video",name="duration")]
    [Event(type="com.pagesociety.ux.component.Video",name="seek")]
    [Event(type="com.pagesociety.ux.component.Video",name="tick")]
    public class Video extends Container
    {
        
        public static const START           :String = "start";
        public static const STOP            :String = "stop";
        public static const DURATION        :String = "duration";
        public static const SEEK            :String = "seek";
        public static const TICK            :String = "tick";

        private var _player:VideoPlayer;
        private var _control:VideoControl;
        private var _timer:Timer;
        private var _flv:String;
        private var _started:Boolean;
        private var _slideshow:SlideShow;
        
        private var _play_lock:Locker;
        
        public function Video(parent:Container, control:VideoControl=null)
        {
            super(parent);
            backgroundVisible = true;
            backgroundColor = 0;
            
            _player = new VideoPlayer(this);
            _player.addEventListener(VideoPlayer.BUFFERING, on_buffering);
            _player.addEventListener(VideoPlayer.START, on_start);
            _player.addEventListener(VideoPlayer.STOP, on_stop);
            _player.addEventListener(VideoPlayer.TICK, on_tick);
            _player.addEventListener(VideoPlayer.ON_DURATION, on_duration);
            _player.addEventListener(VideoPlayer.REQUEST_START, on_replay);
            
            _slideshow = new SlideShow(this);
            
            _control = (control==null) ? new VideoControl(this) : control;
            _control.addEventListener(VideoControl.SEEK, on_seek);
            _control.addEventListener(VideoControl.SEEK_COMPLETE, on_seek_complete);
            _control.addEventListener(VideoControl.PLAY, on_play);
            _control.addEventListener(VideoControl.PAUSE, on_pause);
            _control.addEventListener(VideoControl.VOLUME, on_volume);
            _control.visible = false;

            addEventListener(ComponentEvent.MOUSE_OVER, on_over);
            addEventListener(ComponentEvent.MOUSE_OUT, on_out);
            
            var o:* = application.getSharedObject(MP3SlideShow.SO_KEY_VOLUME);
            if (o!=null)
            {
                _player.volume = o;
                _control.volume = o;
            }
            
            _play_lock = new Locker();
            
        }
        
        override public function stop():void
        {
            _player.pause(true);
            _control.paused = true;
        }
        
        
        public function set flv(url:String):void
        {
            _flv = url;
        }
        
        public function set value(resource:Entity):void
        {
            userObject = resource;
            _play_lock.lock();
            ResourceUtil.getUrl(resource, 
                function(url:String):void
                {
                    _flv = url;
                    _play_lock.unlock();
                });
        }
        
        public function get flv():String
        {
            return _flv;
        }
        
        public function play():void
        {
            _play_lock.wait(function():void
            {
                _slideshow.visible = false;
                _control.paused = false;
                _control.buffering = true;
                _control.render();
                _player.play(_flv);
                _started = true;
            });
        }
        
        private function on_buffering(e:ComponentEvent):void
        {
            _control.buffering = true;
            _control.render();
        }

        private function on_start(e:ComponentEvent):void
        {
            _control.buffering = false;
            _control.render();
            dispatchComponentEvent(START,this);
        }
        
        private function on_stop(e:ComponentEvent):void
        {
            render();
            dispatchComponentEvent(STOP,this);
        }
        
        private function on_duration(e:ComponentEvent):void
        {
            _control.duration = e.data;
            _control.render();
            dispatchComponentEvent(DURATION,this,e.data);
        }
        
        private function on_tick(e:ComponentEvent):void
        {
            _control.time               = _player.time;
            _control.bufferLength       = _player.bufferLength;
            _control.percentComplete    = _player.bytesLoaded/_player.bytesTotal;
            _control.render();
            dispatchComponentEvent(TICK,this,_player.time);
        }
        
        private function on_seek(e:ComponentEvent):void
        {
            _player.pause(true);
            _player.time = e.data;
            dispatchComponentEvent(SEEK,this,_player.time);
        }
        
        private function on_seek_complete(e:ComponentEvent):void
        {
            _player.pause(_control.paused);
            _player.time = e.data;
        }
        
        private function on_play(e:ComponentEvent):void
        {
            if (!_started)
                play();
            _player.pause(false);
        }
        
        private function on_pause(e:ComponentEvent):void
        {
            _player.pause(true);
        }
        
        private function on_replay(e:ComponentEvent):void
        {
            if (!_started)
                play();
            else
            {
                _player.time = 0;
                _player.pause(false);
            }
        }
        
        private function on_volume(e:ComponentEvent):void
        {
            _player.volume = e.data;
            application.setSharedObject(MP3SlideShow.SO_KEY_VOLUME, e.data);
        }
        
        private function on_over(e:ComponentEvent):void
        {
            //trace("VIDEO OVER");
            _control.show();
        }
        
        private function on_out(e:ComponentEvent):void
        {
            //trace("VIDEO OUT");
            //if (!_player.paused)
                _control.hide();
            render();
        }
        
        public function hideController():void
        {
            _control.hide();
        }
        
    }
}


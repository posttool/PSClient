package com.pagesociety.ux.component.media
{
    import com.pagesociety.util.Locker;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.TimerEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.net.URLRequest;
    import flash.utils.Timer;

    public class MP3SlideShow extends Container
    {
        public static const SO_KEY_VOLUME:String = "ps_volume";

        private var req:URLRequest;
        private var _sound:Sound;
        private var _channel:SoundChannel;
        private var _control:VideoControl;
        private var _slideshow:SlideShow;
        private var _timer:Timer;
        private var _loaded:Number;
        private var _mp3:String;
        
        private var _lock:Locker;
        
        private var _pause_pos:uint;
        private var _is_playing:Boolean = false;
        
        public function MP3SlideShow(parent:Container)
        {
            super(parent);
            
            _slideshow = new SlideShow(this);

            _control = new VideoControl(this);
            _control.addEventListener(VideoControl.SEEK, on_seek);
            _control.addEventListener(VideoControl.SEEK_COMPLETE, on_seek_complete);
            _control.addEventListener(VideoControl.PLAY, on_play);
            _control.addEventListener(VideoControl.PAUSE, on_pause);
            _control.addEventListener(VideoControl.VOLUME, on_volume);
            
            var o:* = application.getSharedObject(SO_KEY_VOLUME);
            if (o!=null)
            {
                _control.volume = o;
            }
            
            _lock = new Locker();
            
            _timer = new Timer(100);
            _timer.addEventListener(TimerEvent.TIMER, on_tick);

        }
        
        override public function destroy():void
        {
            stop();
            super.destroy();
        }
        
        public function setValue(mp3_url:String, resources:Array):void
        {
            _mp3 = mp3_url;
            _slideshow.value = resources;
        }
        
        public function play():void
        {
            _lock.wait(function():void
            {
                _is_playing = true;
                _control.paused = false;
                _timer.start();
                
                if (_sound!=null)
                {
                    _channel = _sound.play(_pause_pos,0,new SoundTransform(_control.volume));
                    return;
                }
                
                req = new URLRequest(_mp3);
                
                try 
                {
                    _sound = new Sound();
                    _sound.load(req);
                    _channel = _sound.play(0,0,new SoundTransform(_control.volume));
                }
                catch (err:Error) 
                {
                    Logger.error(err);
                }
     
                _sound.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
                _sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
                
            });
        }
        
        private function pause(pos:int = 0):void
        {
            if (_is_playing)
            {
                _pause_pos = pos;
                _channel.stop();
                _timer.stop();
                _is_playing = false;
            }    
        }
        
        override public function stop():void
        {
            if (_channel!=null)
                _channel.stop();
            try
            {
                _sound.close();
            }
            catch (e:Error)
            {
                Logger.error(e);
            }
            _timer.stop();
            _control.percentComplete = 0;
            _control.bufferLength = 0;
            _control.duration = 1;
            _control.time = 0;
        }
        
        private function cueto(cue:Number):void 
        {
            _channel.stop();
            _channel = _sound.play(cue);   
        }
        
        private function progressHandler(event:ProgressEvent):void 
        {
            _loaded = event.bytesLoaded / event.bytesTotal;
        }
        
        private function on_tick(e:TimerEvent):void
        {
            if (_channel == null || _sound == null)
                return;
            
            _control.percentComplete = _loaded;
            _control.bufferLength = 0;
            if (_sound!=null)
                _control.duration = _sound.length / _loaded;
            if (_channel!=null)
                _control.time = _channel.position;
            _control.render();
        }
        
        public function get percentLoaded():Number
        {
            return _loaded;
        }
 
        private function errorHandler(errorEvent:IOErrorEvent):void 
        {
            Logger.error("The sound could not be loaded: " + errorEvent.text);
        }
        
        
        ///
        private function on_seek(e:ComponentEvent):void
        {
            cueto(e.data);
        }
        
        private function on_seek_complete(e:ComponentEvent):void
        {
            cueto(e.data);
        }
        
        private function on_play(e:ComponentEvent):void
        {
            play();
        }
        
        private function on_pause(e:ComponentEvent):void
        {
            pause(_channel.position);
        }
        
        private function on_volume(e:ComponentEvent):void
        {
            if (_channel!=null)
                _channel.soundTransform = new SoundTransform(e.data);
            application.setSharedObject(SO_KEY_VOLUME, e.data);
        }
        
    }
}
package com.pagesociety.ux.component.media
{
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.Image;
    import com.pagesociety.ux.component.button.CirclePlayButton;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.composite.ColorMatrix;
    import com.pagesociety.ux.decorator.ImageDecorator;
    import com.pagesociety.ux.decorator.VideoDecorator;
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.filters.ColorMatrixFilter;
    import flash.utils.Timer;
    
    [Event(type="VideoPlayer",name="request_start")]
    [Event(type="VideoPlayer",name="start")]
    [Event(type="VideoPlayer",name="stop")]
    [Event(type="VideoPlayer",name="pause")]
    [Event(type="VideoPlayer",name="buffering")]
    [Event(type="VideoPlayer",name="on_duration")]
    [Event(type="VideoPlayer",name="tick")]
    public class VideoPlayerA extends Container
    {
        public static const REQUEST_START   :String = "request_start";
        public static const START           :String = "start";
        public static const STOP            :String = "stop";
        public static const PAUSE           :String = "pause";
        public static const BUFFERING       :String = "buffering";
        public static const ON_DURATION     :String = "on_duration";
        public static const ON_META_DATA    :String = "on_meta_data";
        public static const TICK            :String = "tick";
        public static const REPLAY          :String = "replay";
        
        private var _vdec:VideoDecorator;
        private var _timer:Timer;
        
        public var init_buffer_graphics:Function;
        public var update_buffer_graphics:Function;
        public var clear_buffering_graphics:Function;
        public var init_end_graphics:Function;
        public var update_play_pause_graphics:Function;
        public var clear_end_graphics:Function;
            
        public function VideoPlayerA(parent:Container,index:int=-1)
        {
            super(parent, index);
            
            decorator = _vdec = new VideoDecorator();
            
            _vdec.addEventListener(VideoDecorator.BUFFERING, on_stream_start);
            _vdec.addEventListener(VideoDecorator.BUFFER_FULL, on_buffer_full);
            _vdec.addEventListener(VideoDecorator.BUFFER_EMPTY, on_buffer_empty);
            _vdec.addEventListener(VideoDecorator.PLAY_STOP, on_play_stop);
            _vdec.addEventListener(VideoDecorator.ON_META_DATA, on_meta_data);

            _timer = new Timer(100);
            _timer.addEventListener(TimerEvent.TIMER, on_tick);
        }
        
        public function set looped(b:Boolean):void
        {
            _vdec.looped = b;
        }
        
        private var _flv:String;
        public function play(s:String=null):void
        {
            if (clear_end_graphics!=null)
                clear_end_graphics();
            if (s!=null)
                _flv = s;
            _vdec.play(_flv);
            if (hasEventListener(TICK))
                _timer.start();
        }
        
        public function get flv():String
        {
            return _flv;
        }
        
        public function set flv(s:String):void
        {
            _flv = s;
        }
        
        public function pause(b:Boolean):void
        {
            update_play_pause_graphics(b);
            _vdec.pause(b);
            dispatchComponentEvent(PAUSE, this, b);
        }
        
        public function get paused():Boolean
        {
            return _vdec.paused;
        }
        
        override public function destroy():void
        {
            super.destroy();
        }
        
        public function get time():Number
        {
            return _vdec.time;
        }
        
        public function set time(x:Number):void
        {
            _timer.start();
            _vdec.time = x;
        }
        
        public function get duration():Number
        {
            return _vdec.duration;
        }
        
        public function get volume():Number
        {
            return _vdec.volume;
        }
        
        public function set volume(n:Number):void
        {
            _vdec.volume = n;
        }
        
        public function get bytesLoaded():Number
        {
            return _vdec.bytesLoaded;
        }
        
        public function get bytesTotal():Number
        {
            return _vdec.bytesTotal;
        }
        
        public function get bufferLength():Number
        {
            return _vdec.bufferLength;
        }
        
        
        
        public function set scaleType(t:uint):void
        {
            _vdec.scaleType = t;
        }
        
        public function get scaleType():uint
        {
            return _vdec.scaleType;
        }

        private function on_stream_start(e:Event):void
        {
            if (init_buffer_graphics!=null)
                init_buffer_graphics();
            dispatchComponentEvent(BUFFERING, this, _vdec.duration);
        }
        
        private function on_buffer_full(e:Event):void
        {
            if (clear_buffering_graphics!=null)
                clear_buffering_graphics();
            dispatchComponentEvent(START, this, _vdec.duration);
        }
        
        private function on_buffer_empty(e:Event):void
        {
            if (init_buffer_graphics!=null)
                init_buffer_graphics();
            dispatchComponentEvent(START, this, _vdec.duration);
        }

        private function on_play_stop(e:Event):void
        {
            if (init_buffer_graphics!=null)
                init_end_graphics();
            _timer.stop();
            dispatchComponentEvent(STOP, this, _vdec.duration);
        }
        
        private function on_meta_data(e:ComponentEvent):void
        {
            dispatchComponentEvent(ON_DURATION, this, _vdec.duration);
            dispatchComponentEvent(ON_META_DATA, this, e.data);
        }
        
        private function on_tick(e:Event):void
        {
            var p:Number = (_vdec.bufferLength/_vdec.bufferTime);
            if (p<1)
                update_buffer_graphics(p);
            dispatchComponentEvent(TICK, this, time);
        }
        
        private function on_click_play_btn(e:Event):void
        {
            pause(false);
            render();
        }
        
        private function on_click_pause_btn(e:Event):void
        {
            pause(true);
            render();
        }
        
        
    }
}
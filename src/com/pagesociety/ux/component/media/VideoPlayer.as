package com.pagesociety.ux.component.media
{
    import com.google.maps.Constants;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.Image;
    import com.pagesociety.ux.component.Progress;
    import com.pagesociety.ux.component.button.CirclePlayButton;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.decorator.ImageDecorator;
    import com.pagesociety.ux.decorator.VideoDecorator;
    import com.pagesociety.ux.event.ComponentEvent;

    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import mx.messaging.channels.NetConnectionChannel;

    [Event(type="com.pagesociety.ux.component.media.VideoPlayer",name="request_start")]
    [Event(type="com.pagesociety.ux.component.media.VideoPlayer",name="start")]
    [Event(type="com.pagesociety.ux.component.media.VideoPlayer",name="stop")]
    [Event(type="com.pagesociety.ux.component.media.VideoPlayer",name="buffering")]
    [Event(type="com.pagesociety.ux.component.media.VideoPlayer",name="on_duration")]
    [Event(type="com.pagesociety.ux.component.media.VideoPlayer",name="tick")]
    public class VideoPlayer extends Container
    {
        public static const REQUEST_START   :String = "request_start";
        public static const START           :String = "start";
        public static const STOP            :String = "stop";
        public static const BUFFERING       :String = "buffering";
        public static const ON_DURATION     :String = "on_duration";
        public static const ON_META_DATA    :String = "on_meta_data";
        public static const TICK            :String = "tick";

        private var _vdec:VideoDecorator;
        private var _imagec:Container;
        private var _image:Image;
        private var _buffering_msg:Label;
        private var _buffering_progress:Progress;
        private var _play_button:CirclePlayButton;
        private var _timer:Timer;

        public function VideoPlayer(parent:Container,index:int=-1)
        {
            super(parent, index);
            decorator = _vdec = new VideoDecorator();
            _vdec.addEventListener(VideoDecorator.BUFFERING, on_stream_start);
            _vdec.addEventListener(VideoDecorator.PLAY_STOP, on_play_stop);
            _vdec.addEventListener(VideoDecorator.BUFFER_FULL, on_buffer_full);
            _vdec.addEventListener(VideoDecorator.BUFFER_EMPTY, on_stream_start);
            _vdec.addEventListener(VideoDecorator.ON_META_DATA, on_meta_data);
            _imagec = new Container(this);

            _buffering_progress = new Progress(this);
            _buffering_progress.alpha = 0;

            _buffering_msg = new Label(this);
            _buffering_msg.backgroundVisible = true;
            _buffering_msg.backgroundColor = 0xcccccc;
            _buffering_msg.cornerRadius = 12;
            _buffering_msg.alpha = 0;

            _buffering_msg.text = "  buffering video...  ";

            _buffering_progress.width = _buffering_msg.width - 4;
            _buffering_progress.height = 5;
            _buffering_progress.color = 0xdddddd;
            _buffering_progress.cornerRadius = 12;

            _play_button = new CirclePlayButton(this);
            //_play_button.backgroundVisible = true;
            //_play_button.backgroundColor = 0xff0000;
            _play_button.width  = 180;
            _play_button.height = 180;

            _play_button.addEventListener(ComponentEvent.CLICK, on_replay);
            _play_button.overAlpha   = 0.9;
            _play_button.normalAlpha = 0.3;
            _play_button.arrowNormalAlpha = 0.3;
            _play_button.arrowOverAlpha   = 0.7;
            //_play_button.addEventListener(ComponentEvent.MOUSE_OVER, function(e:ComponentEvent):void{_play_button.alpha=1;render();});
            //_play_button.addEventListener(ComponentEvent.MOUSE_OUT, function(e:ComponentEvent):void{_play_button.alpha=0.5;render();});
            _timer = new Timer(100);
            _timer.addEventListener(TimerEvent.TIMER, on_tick);
        }

        public function set bufferingProgressColor(c:uint):void
        {
            _buffering_progress.color = c;
        }

        public function get playButton():CirclePlayButton
        {
            return _play_button;
        }

        public function get inBetweenContainer():Container
        {
            return _imagec;
        }

        public function get bufferingLabel():Label
        {
            return _buffering_msg;
        }

        public function addImage(src:String, scaling_type:int=-1):void
        {
            _imagec.clear();
            var i:Image = new Image(_imagec);
            i.src = src;
            i.imageScalingType = scaling_type!=-1?scaling_type:ImageDecorator.IMAGE_SCALING_VALUE_MASK_FULL_BLEED;
            i.render();
        }

        override public function render():void
        {
            _buffering_msg.x = (width-_buffering_msg.width)/2;
            _buffering_msg.y = (height-_buffering_msg.height)/2;
            _buffering_progress.x = _buffering_msg.x + 2;
            _buffering_progress.y = _buffering_msg.y+_buffering_msg.height + 5;
            _play_button.x = (width-_play_button.width)/2;
            _play_button.y = (height-_play_button.height)/2;
            super.render();
        }

        public function set looped(b:Boolean):void
        {
            _vdec.looped = b;
        }

        private var _flv:String;
        public function play(s:String):void
        {
            clear_end_graphics();
            _flv = s;
            _vdec.play(s);
            if (hasEventListener(TICK))
                _timer.start();
        }

        public function pause(b:Boolean):void
        {
            clear_end_graphics();
            _vdec.pause(b);
        }

        override public function stop():void
        {
            clear_end_graphics();
            _vdec.stop();
            _timer.stop();
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

        public function seek(time:Number):void
        {
            this.time = time;
        }

        public function set time(x:Number):void
        {
            _timer.start();
            _vdec.time = x;
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

        private var bt:Timer;
        protected function init_buffer_graphics():void
        {
            _buffering_msg.alpha      = 1;
            _buffering_progress.alpha = 1;
            trace('init buffer graphics');
            bt = new Timer(500);
            bt.addEventListener(TimerEvent.TIMER,update_buffering_status)
            bt.start();
        }

        private function update_buffering_status(e:Event):void
        {
            var vdec:VideoDecorator = VideoDecorator(decorator);
            var p:Number = (vdec.bufferLength/vdec.bufferTime);
            trace('buffering p is '+p);
            if (p<1 && p> 0)
            {
                _buffering_progress.progress = p;
                render();
            }
            else
            {
                clear_buffering_graphics();
                bt.stop();
            }
        }


        protected function clear_buffering_graphics():void
        {
            trace("CLEARING BUFFERING GRAPHICS");
            //_buffering_msg.alphaTo(0,0);
            //_buffering_progress.alphaTo(0,0);
            _buffering_msg.alpha = 0;
            _buffering_progress.alpha = 0;
            _buffering_progress.progress= 0;
            bt.stop();
            render();
        }

        protected function init_end_graphics():void
        {
            _imagec.visible = true;
            _play_button.visible =true;
        }

        protected function clear_end_graphics():void
        {
            _play_button.visible = false;
            _imagec.visible = false;
        }

        private function on_stream_start(e:Event):void
        {
            init_buffer_graphics();
            dispatchComponentEvent(BUFFERING, this, _vdec.duration);
            //var p:Number = (_vdec.bufferLength/_vdec.bufferTime);
        }

        private function on_buffer_full(e:Event):void
        {
            clear_buffering_graphics();
            dispatchComponentEvent(START, this, _vdec.duration);
        }

        private function on_play_stop(e:Event):void
        {
            init_end_graphics();
            _timer.stop();
            dispatchComponentEvent(STOP, this, _vdec.duration);
        }

        private function on_meta_data(e:ComponentEvent):void
        {
            //render();
            dispatchComponentEvent(ON_DURATION, this, _vdec.duration);
            dispatchComponentEvent(ON_META_DATA, this, e.data);
        }

        private function on_tick(e:Event):void
        {
            dispatchComponentEvent(TICK, this, time);
        }

        private function on_replay(e:Event):void
        {
//          time = 0;
//          pause(false);
            dispatchComponentEvent(REQUEST_START, this);
        }

    }
}
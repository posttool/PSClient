package com.pagesociety.ux.decorator
{
    import com.pagesociety.ux.event.ComponentEvent;

    import flash.events.AsyncErrorEvent;
    import flash.events.Event;
    import flash.events.NetStatusEvent;
    import flash.events.TimerEvent;
    import flash.media.SoundTransform;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.utils.Timer;

    [Event(type="com.pagesociety.ux.decorator.VideoDecorator",name="play_stop")]
    [Event(type="com.pagesociety.ux.decorator.VideoDecorator",name="buffering")]
    [Event(type="com.pagesociety.ux.decorator.VideoDecorator",name="buffer_full")]
    [Event(type="com.pagesociety.ux.decorator.VideoDecorator",name="on_meta_data")]
    public class VideoDecorator extends Decorator
    {
        public static const PLAY_STOP       :String = "play_stop";
        public static const BUFFERING       :String = "buffering";
        public static const BUFFER_EMPTY    :String = "buffer_empty";
        public static const BUFFER_FULL     :String = "buffer_full";
        public static const ON_META_DATA    :String = "on_meta_data";

        private var _video                  :Video;
        private var _netstream              :NetStream;
        //
        private var _looped                 :Boolean;
        private var _seeking                :Boolean;
        private var _seek_time              :Number;
        private var _seek_timer             :Timer;
        private var _paused                 :Boolean;
        //meta data
        private var _video_width            :Number;
        private var _video_height           :Number;
        private var _video_duration         :Number;
        private var _video_codec_id         :Number;
        private var _video_can_seek_to_end  :Boolean
        private var _video_frame_rate       :Number;
        private var _video_data_rate        :Number;
        private var _video_audio_codec_id   :Number;
        private var _video_audio_data_rate  :Number;
        private var _video_audio_delay      :Number;

        private var _closed:Boolean = false;
        private var _current_vid:String;

        public function VideoDecorator()
        {
            super();
        }

        override public function initGraphics():void
        {
            super.initGraphics();

            _video = new Video();
            _video.smoothing = true;
            _video.deblocking = 1;
            _bg.addChild(_video);

            var nc:NetConnection = new NetConnection();
            nc.connect(null);
            _netstream = new NetStream(nc);
            _netstream.client = this;
            _netstream.bufferTime = 8;
            _netstream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            _netstream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            _video.attachNetStream(_netstream);
            _paused = true;
        }
        
        public function onPlayStatus(e:*):void
        {
            trace("onPlayStatus e="+e);
        }

        override public function destroy():void
        {
            try
            {
                _netstream.close();
                _closed = true;
            }
            catch (e:Error)
            {
                trace("VideoDecorator error "+e.message);
            }
            super.destroy();
        }

        public function set looped(b:Boolean):void
        {
            _looped = b;
        }

        public function get looped():Boolean
        {
            return _looped;
        }

        public function play(s:String):void
        {
            Logger.log("VideoDecorator.play("+s+")");

            _video_width            = -1;
            _video_height           = -1;
            _video_duration         = -1;
            _video_codec_id         = -1;
            _video_can_seek_to_end  = false;
            _video_frame_rate       = -1;
            _video_data_rate        = -1;
            _video_audio_codec_id   = -1;
            _video_audio_data_rate  = -1;
            _video_audio_delay      = -1;

            _current_vid            = s;



            _netstream.play(s);
            _paused = false;
            _closed = false;
        }

        public function get time():Number
        {
            if (_seeking)
            {
                return _seek_time;
            }
            return _netstream.time;
        }

        public function set time(t:Number):void
        {
            _seeking = true;
            _seek_time = t;
            _netstream.seek(t);
            if (_seek_timer==null)
            {
                _seek_timer = new Timer(5);
                _seek_timer.addEventListener(TimerEvent.TIMER, on_seek_check);
                _seek_timer.start();
            }
        }

        private function on_seek_check(e:TimerEvent):void
        {
            var m:Number = Math.abs(_netstream.time - _seek_time);
            if (m<1.5)  // relationship between time & keyframes, because we can only seek to a keyframe
            {
                _seek_timer.stop();
                _seek_timer = null;
                _seeking = false;
            }
            //Logger.log("SEEK CHECK "+_seeking+" "+m);
        }

        public function pause(b:Boolean):void
        {
            _paused = b;
            if (b)
                _netstream.pause();
            else
            {
                if(_closed)
                {   /* this is whole stop / closed business is so we can actually stop the thing from
                    beffering if we want to by calling stop. if we call play after we call stop. it starts
                    from the beginning but it will have cached up until as far as you were before you
                    stopped.*/
                    _closed = false;
                    var nc:NetConnection = new NetConnection();
                    nc.connect(null);
                    var vol:Number = _netstream.soundTransform.volume;
                    _netstream = new NetStream(nc);
                    _netstream.client = this;
                    _netstream.bufferTime = 8;
                    _netstream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
                    _netstream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
                    _video.attachNetStream(_netstream);
                    this.volume = vol;
                    play(_current_vid);

                }
                else
                    _netstream.resume();

            }
        }

        public function stop():void
        {
            try
            {
                _netstream.close();
                _closed = true;

            }
            catch (e:Error)
            {
                trace("VideoDecorator error "+e.message);
            }
        }

        public function get paused():Boolean
        {
            return _paused;
        }

        public function get volume():Number
        {
            return _netstream.soundTransform.volume;
        }

        public function set volume(n:Number):void
        {
            _netstream.soundTransform = new SoundTransform(n);
        }

        public function get bytesLoaded():Number
        {
            return _netstream.bytesLoaded;
        }

        public function get bytesTotal():Number
        {
            return _netstream.bytesTotal;
        }

        public function get bufferLength():Number
        {
            return _netstream.bufferLength;
        }

        public function get bufferTime():Number
        {
            return _netstream.bufferTime;
        }

        public function set bufferTime(bt:Number):void
        {
            _netstream.bufferTime = bt;
        }

        private static const VCODEC:Array = [null,null, "Sorenson H.263", "Screen Video", "On2 VP6", "On2 VP6", "Screen Video V2" ];
        private static const ACODEC:Array = [ "Uncompressed","ADPCM", "MP3", null,null, "NellyMoser", "NellyMoser"];

        public function onMetaData(info:Object):void
        {
            if (info==null)
                return;
            _video_width            = info.width;
            _video_height           = info.height;
            _video_duration         = info.duration;
            _video_codec_id         = info.videocodecid;
            _video_can_seek_to_end  = info.canSeekToEnd;
            _video_frame_rate       = info.framerate;
            _video_data_rate        = info.videodatarate;
            _video_audio_codec_id   = info.audiocodecid;
            _video_audio_data_rate  = info.audiodatarate;
            _video_audio_delay      = info.audiodelay;

            info.videocodec         = VCODEC[_video_codec_id];
            info.audiocodec         = ACODEC[_video_audio_codec_id];

            decorate();

            dispatchEvent(new ComponentEvent(ON_META_DATA,component,info));
        }

        public function get duration():Number
        {
            return _video_duration;
        }

        public function onXMPData(infoObject:Object):void
        {
            //trace("onXMPData");
            //trace("raw XMP =\n");
            //trace(infoObject.data);
            var cuePoints:Array = new Array();
            var cuePoint:Object;
            var strFrameRate:String;
            var nTracksFrameRate:Number;
            var strTracks:String = "";
            var onXMPXML:XML = new XML(infoObject.data);
            // Set up namespaces to make referencing easier
            var xmpDM:Namespace = new Namespace("http://ns.adobe.com/xmp/1.0/DynamicMedia/");
            var rdf:Namespace = new Namespace("http://www.w3.org/1999/02/22-rdf-syntax-ns#");
            for each (var it:XML in onXMPXML..xmpDM::Tracks)
            {
                 var strTrackName:String = it.rdf::Bag.rdf::li.rdf::Description.@xmpDM::trackName;
                 var strFrameRateXML:String = it.rdf::Bag.rdf::li.rdf::Description.@xmpDM::frameRate;
                 strFrameRate = strFrameRateXML.substr(1,strFrameRateXML.length);

                 nTracksFrameRate = Number(strFrameRate);

                 strTracks += it;
            }
            var onXMPTracksXML:XML = new XML(strTracks);
            var strCuepoints:String = "";
            for each (var item:XML in onXMPTracksXML..xmpDM::markers)
            {
                strCuepoints += item;
            }
            trace(strCuepoints);
        }

        private function asyncErrorHandler(event:AsyncErrorEvent):void
        {
            trace("ansync error "+event.text);
        }

        private function netStatusHandler(event:NetStatusEvent):void
        {
            switch (event.info.code)
            {

                case "NetStream.Play.Start":
                    dispatchEvent(new Event(BUFFERING));
                    break;
                case "NetStream.Buffer.Empty":
                    //Logger.log(">NetStream.Buffer.EmptyNetStream.Buffer.EmptyNetStream.Buffer.Empty ");
                    if (time<duration-1)
                        dispatchEvent(new Event(BUFFER_EMPTY));
                    break;
                case "NetStream.Buffer.Full":
                    dispatchEvent(new Event(BUFFER_FULL));
                    break;
                case "NetStream.Play.Stop":
                    if (_looped)
                        _netstream.seek(0);
                    else
                        dispatchEvent(new Event(PLAY_STOP));
                    break;
                case "NetStream.Seek.Notify":
//                  _seeking = false;
//                  trace("SEEK TIME "+_seek_time+" TIME "+time);
                    break;
                case "NetStream.Buffer.Flush":
                    //done w/ download
                    //Logger.log(">NetStream.Buffer.Flush ");
                case "NetStream.Connect.Closed":
                    //trace('netstream is closed');
                    break;
                default:
                    trace("NETSTATUS ");
                    for (var p:String in event.info)
                        Logger.log(">NETSTATUS "+p+"="+event.info[p]);

            }
        }

        public static const VIDEO_SCALE_VALUE_NONE:uint = 0;
        public static const VIDEO_SCALE_VALUE_FIT:uint = 1;
        public static const VIDEO_SCALE_VALUE_FULL_BLEED:uint = 2;

        private var _scale_type:uint = VIDEO_SCALE_VALUE_FIT;
        public function set scaleType(t:uint):void
        {
            _scale_type = t;
        }

        public function get scaleType():uint
        {
            return _scale_type;
        }

        override public function decorate():void
        {
            updateVisibility(visible);
            if (!visible)
                return;

            updatePosition(_x,_y);

            if (_video_width!=-1 && _video_height!=-1)
            {
                var sx:Number = width/_video_width;
                var sy:Number = height/_video_height;
                switch (_scale_type)
                {
                    case VIDEO_SCALE_VALUE_NONE:
                        _video.width = _video_width;
                        _video.height = _video_height;
                        break;
                    case VIDEO_SCALE_VALUE_FIT:
                        if ( sx < sy )
                        {
                            _video.width = _video_width*sx;
                            _video.height = _video_height*sx;
                        }
                        else
                        {
                            _video.width = _video_width*sy;
                            _video.height = _video_height*sy;
                        }
                        break;
                    case VIDEO_SCALE_VALUE_FULL_BLEED:
                        if ( sx > sy )
                        {
                            _video.width = _video_width*sx;
                            _video.height = _video_height*sx;
                        }
                        else
                        {
                            _video.width = _video_width*sy;
                            _video.height = _video_height*sy;
                        }
                        break;
                }
            }
            else
            {
                _video.width = width;
                _video.height = height;
            }

            _video.x = Math.max(0, Math.floor((_width-_video.width)/2));
            _video.y = Math.max(0, Math.floor((_height-_video.height)/2));
        }



    }
}
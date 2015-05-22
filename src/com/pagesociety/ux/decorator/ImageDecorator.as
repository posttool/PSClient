package com.pagesociety.ux.decorator
{
	import com.pagesociety.util.StringUtil;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.event.ResourceEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	
	[Event(type="com.pagesociety.ux.event.ResourceEvent", name="load_resource")]
	[Event(type="com.pagesociety.ux.event.ResourceEvent", name="load_error")]
	[Event(type="com.pagesociety.ux.event.ResourceEvent", name="load_progress")]
	public class ImageDecorator extends Decorator
	{
		public static var DEBUG:Boolean = false;
		public static var CHECK_POLICY_FILE:Boolean = true;
		
		// no mask
		public static const IMAGE_SCALING_VALUE_NONE:uint 								= 0;
		public static const IMAGE_SCALING_VALUE_FIT:uint 								= 1;
//		public static const IMAGE_SCALING_VALUE_FIT_STRETCH:uint 						= 2;
//		public static const IMAGE_SCALING_VALUE_FIT_OR_SHRINK:uint 						= 3;
//		public static const IMAGE_SCALING_VALUE_FIT_OR_SHRINK_ALIGN_CENTER:uint 		= 4;
//		public static const IMAGE_SCALING_VALUE_FIT_OR_SHRINK_ALIGN_LEFT_CENTER:uint 	= 5;
		public static const IMAGE_SCALING_VALUE_FIT_HEIGHT:uint 						= 6;
		
		//
		public static const IMAGE_SCALING_VALUE_MASK:uint 								= 802;
		public static const IMAGE_SCALING_VALUE_MASK_ALIGN_CENTER:uint 					= 803;
		public static const IMAGE_SCALING_VALUE_MASK_ALIGN_TOP_LEFT:uint 				= 804;
//		public static const IMAGE_SCALING_VALUE_MASK_FIT_WIDTH_ALIGN_TOP:uint 			= 805;
//		public static const IMAGE_SCALING_VALUE_MASK_FIT_WIDTH_ALIGN_CENTER:uint 		= 806;
//		public static const IMAGE_SCALING_VALUE_MASK_FIT_WIDTH_ALIGN_BOTTOM:uint 		= 807;
//		public static const IMAGE_SCALING_VALUE_MASK_FIT_HEIGHT_ALIGN_LEFT:uint 		= 808;
//		public static const IMAGE_SCALING_VALUE_MASK_FIT_HEIGHT_ALIGN_CENTER:uint 		= 809;
//		public static const IMAGE_SCALING_VALUE_MASK_FIT_HEIGHT_ALIGN_RIGHT:uint 		= 810;
		public static const IMAGE_SCALING_VALUE_MASK_FULL_BLEED:uint 					= 811;
		
		public static const IMAGE_REPEAT_VALUE_XY:uint									= 910;
		public static const IMAGE_REPEAT_VALUE_X:uint									= 911;
		public static const IMAGE_REPEAT_VALUE_Y:uint									= 912;

		//settable
		private var _image_src:String;
		private var _image_scaling_type:uint = IMAGE_SCALING_VALUE_NONE;
		private var _image_scaling_cue:Object = null;
		private var _auto_load:Boolean = true;

		//private state
		private var _loaded:Boolean;
		private var _last_loaded_src:String;
		private var _loaded_img_width:Number = -1;
		private var _loaded_img_height:Number = -1;
		private	var _scale:Number = 1;
		private var _smoothing:Boolean;
		//flash
		private var _img_loader:Loader;
		private var _loaded_img:DisplayObject;
		private var _loaded_img_bm:Bitmap; // for bg tiling
		private var _mask_rect:Shape;
		private var _progress_sprite:Sprite;
		private var _outline:Sprite;
		//private var _sim_bitmap:Bitmap; // for simulation
		private var _bitmap:Bitmap; // when content is loaded
		
		public function ImageDecorator()
		{
			super();
		}
		
		override public function initGraphics():void
		{
			super.initGraphics();
			
			_mask_rect = new Shape();
			_mask_rect.graphics.beginFill(0xFFFFFF);
			_mask_rect.graphics.drawRect(0, 0, 100, 100);
			_mask_rect.visible = false;
			addChild(_mask_rect);
			
			_progress_sprite = new Sprite();
			addChild(_progress_sprite);

			_outline = new Sprite();
			addChild(_outline);
			
			_loaded = false;
		}
		
		override public function get displayObject():DisplayObject
		{
			return _loaded_img;
		}
		
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		
		override public function decorate():void
		{
			super.decorate();

			if (_auto_load)
				load();

			update_scale();
			switch (_image_scaling_type)
			{
				case IMAGE_SCALING_VALUE_MASK_FULL_BLEED:
					process_full_bleed_cue();
					break;
				case IMAGE_REPEAT_VALUE_XY:
				case IMAGE_REPEAT_VALUE_Y:
				case IMAGE_REPEAT_VALUE_X:
					update_repeat();
					break;
			}
			update_mask_size();
			update_outline();
			
		}
		
		public function load():void
		{
			if (_image_src!=null && _image_src!=_last_loaded_src)
			{
				create_image_loader();
				
	            _img_loader.visible = false;
	            _progress_sprite.visible = _visible;
	            
				update_mask_size();
				
				_last_loaded_src = _image_src;
				
				var urlReq:URLRequest = new URLRequest(_last_loaded_src);
				QUEUE_LOAD(_img_loader,urlReq,this);
				on_progress(null);
			}
			else if (_image_src==null)
			{
	            generatingPreview = true;
			}
			
		}
		
		private function create_image_loader():void
		{
			if (_img_loader!=null)
				return;

			_img_loader = new Loader();
			_img_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, on_complete);
	        _img_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, on_progress);
	        _img_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, on_io_error);
	        _img_loader.contentLoaderInfo.addEventListener(Event.UNLOAD, on_unload);
//	        _img_loader.contentLoaderInfo.addEventListener(Event.OPEN, on_open);
//	        _img_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, on_http_status);

			midground.addChild(_img_loader);
		}
		
		public function update_scale():void
		{
			_scale = 1;
			
			var w:Number = this.width;
			var h:Number = this.height;
			var iw:Number = _loaded_img_width;
			var ih:Number = _loaded_img_height;
			
			if (iw<1 || ih<1)
				return;
			
			var sx:Number =  w/iw;
			var sy:Number =  h/ih;
			
			var sw:Number, sh:Number, xo:Number, yo:Number;
			
			switch (_image_scaling_type)
			{
				case IMAGE_SCALING_VALUE_NONE:
					sw = iw;
					sh = ih;
					break;
				case IMAGE_SCALING_VALUE_FIT:
					if ( sx < sy )
					{
						sw = iw*sx;
						sh = ih*sx;
						_scale = sx;
					}
					else
					{
						sw = iw*sy;
						sh = ih*sy;
						_scale = sy;
					}
					break;
				case IMAGE_SCALING_VALUE_FIT_HEIGHT:
					sw = iw*sy;
					sh = ih*sy;
					_scale = sy;
					break;
				case IMAGE_SCALING_VALUE_MASK:
					break;
				case IMAGE_SCALING_VALUE_MASK_ALIGN_CENTER:
					_scale = 1;
					sw = iw;
					sh = ih;
					break;
				case IMAGE_SCALING_VALUE_MASK_FULL_BLEED:
					if ( sx > sy )
					{
						sw = iw*sx;
						sh = ih*sx;
						_scale = sx;
					}
					else
					{
						sw = iw*sy;
						sh = ih*sy;
						_scale = sy;
					}
					break;
			}

			if (_loaded_img==null)
				return;
			
			_loaded_img.x = 0;
			_loaded_img.y = 0;
			if (is_centered_x())
				_loaded_img.x = Math.floor((w-sw)/2);
			if (is_centered_y())
				_loaded_img.y = Math.floor((h-sh)/2);
			
			if (!StringUtil.endsWith(_image_src, ".swf"))
			{
				_loaded_img.width = sw;
				_loaded_img.height = sh;
			}
		}
		
		private function is_autocentered():Boolean
		{
			return (_image_scaling_type >= IMAGE_SCALING_VALUE_MASK && _image_scaling_type <= IMAGE_SCALING_VALUE_MASK_FULL_BLEED);
			// || (_image_scaling_type >= IMAGE_SCALING_VALUE_MASK && _image_scaling_type < IMAGE_REPEAT_VALUE_XY)???
		}
		
		public function is_centered_y():Boolean
		{
			if (is_autocentered()) return true;
			if (_image_scaling_cue == null) return false;
			if (!_image_scaling_cue.hasOwnProperty('center') && !_image_scaling_cue.hasOwnProperty('centerY')) return false;
			return _image_scaling_cue.center || _image_scaling_cue.centerY;
		}
		
		public function is_centered_x():Boolean
		{
			if (is_autocentered()) return true;
			if (_image_scaling_cue == null) return false;
			if (!_image_scaling_cue.hasOwnProperty('center') && !_image_scaling_cue.hasOwnProperty('centerX')) return false;
			return _image_scaling_cue.center || _image_scaling_cue.centerX;
		}

		private function process_full_bleed_cue():void
		{

			if (_loaded_img==null)
				return;

			if (_image_scaling_cue==null || !(_image_scaling_cue is String))
			{
				_loaded_img.y = (height - _loaded_img.height)/2;
			}
			else if (_image_scaling_cue.indexOf("crop bottom")!=-1 || _image_scaling_cue.indexOf("show top")!=-1)
			{
				_loaded_img.y = 0;
			}
			else if (_image_scaling_cue.indexOf("crop top")!=-1 || _image_scaling_cue.indexOf("show bottom")!=-1)
			{
				_loaded_img.y = height - _loaded_img.height;
			}
			else if (_image_scaling_cue.indexOf("crop left")!=-1 || _image_scaling_cue.indexOf("show right")!=-1)
			{
				_loaded_img.x = width - _loaded_img.width;
			}
			else if (_image_scaling_cue.indexOf("crop right")!=-1 || _image_scaling_cue.indexOf("show left")!=-1)
			{
				_loaded_img.x = 0;
			}
			else
			{
				_loaded_img.y = (height - _loaded_img.height)/2;
			}
		}
		
		private function update_repeat():void
		{
			_scale = 1;
			switch (_image_scaling_type)
			{
				case IMAGE_REPEAT_VALUE_XY:
					setup_repeat();
					midground.graphics.beginBitmapFill(_loaded_img_bm.bitmapData);
					midground.graphics.drawRect(0, 0, width, height);
					midground.graphics.endFill();
					break;
				case IMAGE_REPEAT_VALUE_X:
					setup_repeat();
					midground.graphics.beginBitmapFill(_loaded_img_bm.bitmapData);
					midground.graphics.drawRect(0, 0, width, imageHeight);
					midground.graphics.endFill();
					break;
				case IMAGE_REPEAT_VALUE_Y:
					setup_repeat();
					midground.graphics.beginBitmapFill(_loaded_img_bm.bitmapData);
					midground.graphics.drawRect(0, 0, imageWidth, height);
					midground.graphics.endFill();
					break;
			}
		}
		
	
		
		private function update_mask_size():void
		{
			if (_image_scaling_type >= IMAGE_SCALING_VALUE_MASK) {
				_mask_rect.width = width;
				_mask_rect.height = height;
				if (_loaded_img!=null)
					_loaded_img.mask = _mask_rect;
			}
			else if (_loaded_img!=null)
			{
				_loaded_img.mask = null;
			}
		}
		
		private function update_outline():void
		{
			var g:Graphics = _outline.graphics;
			g.clear();
			if (_bg.borderVisible)
			{
				g.lineStyle(_bg.borderThickness,_bg.borderColor,_bg.borderAlpha,false,LineScaleMode.NORMAL,CapsStyle.SQUARE,JointStyle.MITER,3);
				g.drawRect(imageX,imageY,imageWidth,imageHeight);
			}
		}
		
		private function setup_repeat():void
		{
			if (has_repeat || _loaded_img == null)
				return;
				
			var bmd:BitmapData = new BitmapData(_loaded_img.width,_loaded_img.height);
			bmd.draw(_loaded_img);
			_loaded_img_bm = new Bitmap(bmd);
			midground.removeChild(_loaded_img);
			midground.graphics.clear();
		}
		
		private function destroy_repeat():void
		{
			if (!has_repeat)
				return;
			
			midground.graphics.clear();
			_loaded_img_bm.bitmapData.dispose();
			_loaded_img_bm = null;
			midground.addChild(_loaded_img);

		}
		
		private function get has_repeat():Boolean
		{
			return _loaded_img_bm!=null;
		}
		
		public function set imageSrc(s:String):void
		{
			if (_img_loader!=null)
	            _img_loader.visible = false;
			if (_progress_sprite!=null)
	            _progress_sprite.visible = false;
			_image_src = s;
			progress = 0;
			_loaded_img = null;
			destroy_repeat();
		}
		
		public function get imageSrc():String
		{
			return _image_src;
		}
		
		public function set imageScalingType(t:uint):void
		{
			destroy_repeat();
			_image_scaling_type = t;
		}
		
		public function get imageScalingType():uint
		{
			return _image_scaling_type;
		}
		
		public function set imageScalingCue(o:Object):void
		{
			_image_scaling_cue = o;
		}
		
		public function get imageX():Number
		{
			if (_loaded_img!=null)
				return _loaded_img.x;
			else
				return 0;
		}
		
		public function get imageY():Number
		{
			if (_loaded_img!=null)
				return _loaded_img.y;
			else
				return 0;
		}
		
		public function get imageWidth():Number
		{
			update_scale();
			if (_loaded_img_width!=-1)
				return _loaded_img_width * _scale;
			else
				return width;
		}
		
		public function set imageWidth(w:Number):void
		{
			_loaded_img_width = w;
		}
		
		public function get imageHeight():Number
		{
			update_scale();
			if (_loaded_img_height!=-1)
				return _loaded_img_height * _scale;
			else
				return height;
		}
		
		public function set imageHeight(h:Number):void
		{
			_loaded_img_height = h;
		}
		
		
		public function set smoothing(b:Boolean):void
		{
			_smoothing = b;
		}
		
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		
		public function set autoLoad(b:Boolean):void
		{
			_auto_load = b;
		}
		
		public function get autoLoad():Boolean
		{
			return _auto_load;
		}

		override public function destroy():void
		{
			if (DEBUG)
				trace("DESTROY "+this);

			QUEUE_REMOVE(this);
			
			if (has_repeat)
			{
				destroy_repeat();
			}
			else if (_img_loader!=null)
			{
				kill_image_loader();
			}
			
			_last_loaded_src = null;
			super.destroy();
		}
		
	
		
		
		private function on_complete(event:Event):void 
		{
			if (_img_loader==null)
				return;
			
			try {
				if (_img_loader.content is Bitmap)
				{	
					_bitmap = Bitmap(_img_loader.content);
					if (_smoothing && _bitmap != null)
						_bitmap.smoothing = true;
				}
			} catch(e:Error)
			{
				Logger.error(e);
			}
            //Logger.log("Image.loader.complete: " + event);
            QUEUE_COMPLETE(this);
        
			if (_loaded_img_width == -1)
				_loaded_img_width = _img_loader.width;
			else if (_loaded_img_width != _img_loader.width)
				Logger.debug("assertion failed: _loaded_img_width="+_loaded_img_width+" != _img_loader.width="+_img_loader.width);
			if (_loaded_img_height == -1)
				_loaded_img_height = _img_loader.height;
			else if (_loaded_img_height != _img_loader.height)
				Logger.debug("assertion failed: _loaded_img_height="+_loaded_img_height+" != _img_loader.height="+_img_loader.height);
           	_img_loader.visible = true;
           	_loaded_img = _img_loader;
			_progress_sprite.visible = false;
            _loaded = true;
 			decorate();
            dispatchEvent(new ResourceEvent(ResourceEvent.LOAD_RESOURCE,null));
        }

        private function on_http_status(event:HTTPStatusEvent):void 
        {
            //trace("Image.loader.httpStatus: " + event.status);
            // if code             QUEUE_COMPLETE(loader);
        }

        private function on_init(event:Event):void {
            //trace("Image.loader.init: " + event);
        }

        private function on_io_error(event:IOErrorEvent):void 
        {
        	_last_loaded_src = null;
        	_image_src = null;
            dispatchEvent(new ResourceEvent(ResourceEvent.LOAD_ERROR,null));
            QUEUE_COMPLETE(this);
       }

        private function on_open(event:Event):void {
            //trace("Image.loader.open: " + event);
        }

        private function on_progress(event:ProgressEvent):void 
        {
            var p:Number = (event == null || event.bytesTotal ==0) ? 0 : (event.bytesLoaded / event.bytesTotal);
            progress = p;
			dispatchEvent(new ComponentEvent(ResourceEvent.LOAD_PROGRESS,null,p));
        }
        
        private function set progress(p:Number):void
        {
        	var g:Graphics = _progress_sprite.graphics;
            g.clear();
//            g.beginFill(0x777777,.1);
//            g.drawRect(0,0,width,height);
//            g.endFill();
			g.beginFill(0xffffff,.333);
            g.drawRect(0,0,imageWidth*p,imageHeight);
            g.endFill();
			
			//trace(">progress for "+component.parent.indexOf(component)+" is at "+p+" "+component.visible+" "+_visible);
        }
        
        public function set generatingPreview(b:Boolean):void
        {
        	if (imageWidth==0||imageHeight==0)
        		return;
        	_progress_sprite.visible = true;
        	var g:Graphics = _progress_sprite.graphics;
            g.clear();
            g.beginFill(0x777777,.15);
            g.drawRect(0,0,imageWidth,imageHeight);
            g.endFill();
            g.lineStyle(4,0x444444,.35,true,LineScaleMode.NORMAL,CapsStyle.ROUND);
            var x:uint;
           	for (x=0; x<imageWidth/2 && x<imageHeight/2; x+=10)
           	{
            	g.drawRect(x,x,imageWidth-x*2,imageHeight-x*2);
           	}
        }

        private function on_unload(event:Event):void 
        {
        	kill_image_loader();
            QUEUE_REMOVE(this);
        }
        
        private var _killing:Boolean = false;
        private function kill_image_loader():void
        {
        	if (_killing)
        		return;
        	_killing = true;

			_img_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, on_complete);
            _img_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, on_progress);
            _img_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, on_io_error);
//	        _img_loader.contentLoaderInfo.removeEventListener(Event.OPEN, on_open);
            _img_loader.contentLoaderInfo.removeEventListener(Event.UNLOAD, on_unload);
//	        _img_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, on_http_status);

        	try{
        	_img_loader.close();
        	} catch(e:Error) {
//        		Logger.error("ImageDecorator Error:"+e.message);
        	}
        	try{
        	_img_loader.unload();
        	} catch(e:Error) {
//        		Logger.error("ImageDecorator Error:"+e.message);
        	}

			var b:Bitmap = Bitmap(_img_loader.content)
			if (b!=null)
	        	b.bitmapData.dispose();
			while(_mid.numChildren!=0)
				_mid.removeChildAt(0);
			
			_img_loader = null;

        }

		///////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////
		
		private static var _QUEUE:Array = [];
		private static var _QUEUE_LOAD_COUNT:uint = 0;
		//state of image loading (last col in each row of queue)
		private static var _QINIT:uint 		= 0;
		private static var _QLOADING:uint 	= 1;
//		private static var _QLOADED:uint 	= 2;
		//
		public static var _QUEUE_MAX_SIMULATANEOUS_LOAD:uint = 8;
		public static var _QUEUE_TIMER:Timer;
		
		private static function QUEUE_LOAD(loader:Loader, url_req:URLRequest, image_decorator:ImageDecorator):void
		{
			_QUEUE.push({
				loader:		loader,
				url:		url_req,
				decorator:	image_decorator,
				state:		_QINIT});
			
			START_QUEUE();
		}
		
		private static function START_QUEUE():void
		{
			if (_QUEUE_TIMER==null)
			{
				_QUEUE_TIMER = new Timer(10);
				_QUEUE_TIMER.addEventListener(TimerEvent.TIMER, ON_QUEUE_TIMER);
			}
			_QUEUE_TIMER.start();
		}
		private static function STOP_QUEUE():void
		{
			_QUEUE_TIMER.stop();
		}
		
		private static function ON_QUEUE_TIMER(e:TimerEvent):void
		{
			QUEUE_DO_LOAD();
//			trace("Q="+_QUEUE);
		}
		
		private static function QUEUE_DO_LOAD():void
		{
			var i:uint;
			var n:Object;
			// trace
			if (DEBUG)
			{
				trace("QUEUE LENGTH= "+_QUEUE.length);
				for (i=0; i<_QUEUE.length; i++)
				{
					n = _QUEUE[i];
					var ss:String = (n.state==0)?"init":"load";
					trace(i+". "+ss+" "+n.url.url);
				}
			}
			//
			var s:uint = _QUEUE_MAX_SIMULATANEOUS_LOAD - _QUEUE_LOAD_COUNT;
			if (s==0)
			{
				STOP_QUEUE();
				return;
			}
			for (i = 0; i < s && i < _QUEUE.length; i++)
			{
				n = _QUEUE[i];
				if (n.state != _QINIT)
					continue;
				n.state = _QLOADING;
				var lc:LoaderContext = new LoaderContext();
				lc.checkPolicyFile = CHECK_POLICY_FILE;
				n.loader.load(n.url as URLRequest, lc);
				_QUEUE_LOAD_COUNT++;
				s--;
				if (DEBUG)
					Logger.log("ImageDecorator.QUEUE DO LOAD "+n.url.url );
			}
			
		}
		
		private static function QUEUE_COMPLETE(dec:ImageDecorator):void
		{
			QUEUE_REMOVE(dec);
			START_QUEUE();
		}
		
		//synchronize with load
		private static function QUEUE_REMOVE(dec:ImageDecorator):void
		{
			for (var i:uint = 0; i < _QUEUE.length; i++)
			{
				if (_QUEUE[i].decorator == dec)
				{
					_QUEUE.splice(i,1);
					_QUEUE_LOAD_COUNT--;
					if (DEBUG)
						trace("QUEUE REMOVED 1");
					return;
				}
			}
			if (DEBUG)
				trace("NOT IN QUEUE ");
		}
	}
}
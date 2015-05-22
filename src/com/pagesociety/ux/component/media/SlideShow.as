package com.pagesociety.ux.component.media
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.util.Random;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.Image;
	import com.pagesociety.ux.component.ImageResource;
	import com.pagesociety.ux.component.container.PageContainer;
	import com.pagesociety.ux.decorator.ImageDecorator;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.event.ResourceEvent;
	import com.pagesociety.ux.event.SelectionEvent;
	import com.pagesociety.web.module.Resource;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	[Event(type="com.pagesociety.ux.event.SelectionEvent", name="select")]
	[Event(type="com.pagesociety.ux.event.ResourceEvent", name="load_resource")]
	[Event(type="com.pagesociety.ux.event.ResourceEvent", name="load_resources")]
	[Event(type="com.pagesociety.ux.component.media.SlideShow", name="next")]
	public class SlideShow extends Container
	{
		public static const NEXT:String = "next";
		protected var _slides:PageContainer;
		protected var _timer:Timer;
		protected var _slide_data:Array;
		protected var _image_scaling_type:int;
		protected var _image_scaling_cue:Object;
		protected var _image_width:Number;
		protected var _image_height:Number;
		protected var _image_jpeg_quality:int;
		protected var _play:Boolean;
		protected var _speed:uint;
		protected var _controller:VideoControl;
		
		protected var _load_index:uint;
		protected var _loaded:Array;
		protected var _linear_load:Boolean;
		protected var _show_next_loaded:Boolean;
		
		public function SlideShow(parent:Container)
		{
			super(parent);
			
			_slides = new PageContainer(this);
			_slides.type = PageContainer.TYPE_SIMPLE_FADE;
			_image_scaling_type = ImageDecorator.IMAGE_SCALING_VALUE_FIT_HEIGHT;
			_image_width = 1500;
			_image_height = 1000;
			_speed = 3000;
			_image_jpeg_quality = ImageResource.DEFAULT_JPEG_QUALITY;
			_linear_load = true;
		}
		
		public function get pageContainer():PageContainer
		{
			return _slides;
		}
		
		public function get slides():Array
		{
			return _slides.children;
		}
		
		public function get currentImage():Image
		{
			if (_slides.children[_slides.page] is Image)
				return _slides.children[_slides.page];
			else
				return null;
		}
		
		public function get currentComponent():Component
		{
			return _slides.children[_slides.page];
		}
		
		public function get currentIndex():uint
		{
			return _slides.page;
		}
		
//		public function get imagesWidth():Number
//		{
//			return _slides.layoutWidth;
//		}
		
		private static const CONSTRUCTED:uint = 0;
		private static const LOAD_STARTED:uint = 1;
		private static const LOAD_COMPLETE:uint = 2;
		public function set value(images:Array):void
		{
			_slide_data = images;

			_slides.clear();
			_loaded = new Array();
			if (_slide_data!=null)
				for (var i:uint=0; i<_slide_data.length; i++)
				{
					cell_renderer(_slides, _slide_data[i]);
					_loaded.push(CONSTRUCTED);
				}
			page = 0;
			load_image();
		}
		
		public function get value():Array
		{
			return _slide_data;
		}
		
		protected function cell_renderer(p:Container, data:Object):Component
		{
			if (is_image_or_swf(data as Entity))	
			{
				var ir:ImageResource 		= new ImageResource(p);
				ir.userObject 				= data;
				ir.smoothing 				= true;
				ir.previewHeight 			= _image_height;
				ir.previewWidth 			= _image_width;
				ir.jpegQuality	 			= _image_jpeg_quality;
				ir.visible 					= false;
				ir.setResource(data as Entity, false);
				ir.addEventListener(ResourceEvent.LOAD_RESOURCE, on_load_slide);
				if (hasEventListener(SelectionEvent.SELECT))
					ir.addEventListener(ComponentEvent.CLICK, on_click_component);
				return ir;
			}
			else
			{
				var m:Video 				= new Video(p, _controller);
				m.userObject 				= data;
				//	if (hasEventListener(SelectionEvent.SELECT))
				//		m.addEventListener(ComponentEvent.CLICK, on_click_component);
				return m;
			}
		}
		
		protected function load_cell_handler(cell:Component, data:Object):void
		{
			var r:Entity = data as Entity;
			if (is_image_or_swf(r))	
			{
				var ir:ImageResource 		= cell as ImageResource;;
				ir.load();
			}
			else
			{
				var m:Video 				= cell as Video;
				m.value						= r;
				load_image_complete(_load_index);
			}
		}
		
		override public function render():void
		{
			for (var i:uint=0; i<_slides.children.length; i++)
			{
				if (_slides.children[i] is Image)
				{
					var img:Image = _slides.children[i];
					img.imageScalingType = _image_scaling_type;
					img.imageScalingCue = _image_scaling_cue;
				}
			}
			super.render();
		}
		
		public function set pageContainerType(t:uint):void
		{
			_slides.type = t;
			_slides.showPage(0);
		}
		
		public function set pageContainerGap(u:Number):void
		{
			_slides.gap = u;
		}
		
		public function set imageScalingType(t:int):void
		{
			_image_scaling_type = t;
		}
		
		public function get imageScalingType():int
		{
			return _image_scaling_type;
		}
		
		public function set imageScalingCue(t:Object):void
		{
			_image_scaling_cue = t;
		}
		
		public function get imageScalingCue():Object
		{
			return _image_scaling_cue;
		}
		
		public function set imageWidth(w:Number):void
		{
			_image_width = w;
		}
		
		public function get imageWidth():Number
		{
			return _image_width;
		}
		
		public function set imageJpegQuality(w:int):void
		{
			_image_jpeg_quality = w;
		}
		
		public function get imageJpegQuality():int
		{
			return _image_jpeg_quality;
		}
		
		public function set imageHeight(h:Number):void
		{
			_image_height = h;
		}
		
		public function get imageHeight():Number
		{
			return _image_height;
		}
		
		public function set speed(s:uint):void
		{
			if (isNaN(s))
				return;
			_speed = s;
			if (_timer!=null)
			{
				_timer.stop();
				_timer=null;
			}
			playing = _play;
		}
		
		public function get speed():uint
		{
			return _speed;
		}
		
		public function set looping(b:Boolean):void
		{
			_slides.looping = b;
		}
		
		public function get looping():Boolean
		{
			return _slides.looping;
		}
		
		public function set playing(b:Boolean):void
		{
			_play = b;
			if (b)
				start_slide_show_timer();
			else if (_timer!=null)
				_timer.stop();
		}
		
		public function get playing():Boolean
		{
			return _play && _load_index>0;
		}
		
		public function set page(i:uint):void
		{
			if (_slides==null)
				return;
				
			_slides.page = i;
			if (_loaded!=null && _loaded[i]==LOAD_COMPLETE)
				return

			// get it loading!
			_load_index = i;
			load_image();
			
		}
		
		public function get page():uint
		{
			return _slides.page;
		}
		
		public function get pageComponent():Component
		{
			return _slides.children[_slides.page];
		}
		
		public function set controller(h:VideoControl):void
		{
			_controller = h;
		}
		
		public function get controller():VideoControl
		{
			return _controller;
		}
		
		public function set linearLoad(b:Boolean):void
		{
			_linear_load = b;
		}
		public function get linearLoad():Boolean
		{
			return _linear_load;
		}
		
		public static function is_image_or_swf(r:Entity):Boolean
		{
			return is_image(r) || is_swf(r);
		}
		
		public static function is_image(r:Entity):Boolean
		{
			return r.$[Resource.RESOURCE_FIELD_SIMPLE_TYPE]==Resource.SIMPLE_TYPE_IMAGE_STRING;
		}
		
		public static function is_swf(r:Entity):Boolean
		{
			return  r.$[Resource.RESOURCE_FIELD_SIMPLE_TYPE]==Resource.SIMPLE_TYPE_SWF_STRING;
		}
		
		private function load_image():void
		{
			if (_slide_data == null || _slide_data.length == 0 || _load_index >= _slides.children.length)
				return;
			
			_loaded[_load_index] 			= LOAD_STARTED;
			load_cell_handler(_slides.children[_load_index], _slide_data[_load_index]);
			
		}
		
		protected function on_load_slide(e:ComponentEvent):void
		{
			load_image_complete(_slides.indexOf(e.component));
		}
		
		protected function load_image_complete(index:int):void
		{
			_loaded[index] = LOAD_COMPLETE;
			
			if (_show_next_loaded)
			{
				on_tick(null);
				_show_next_loaded = false;
			}
			
			if (_play)
				start_slide_show_timer();
			
			render();
			
			dispatchComponentEvent(ResourceEvent.LOAD_RESOURCE, this, _load_index);
			if (all_loaded())
			{
				dispatchComponentEvent(ResourceEvent.LOAD_RESOURCES, this, _slide_data.length);
				return;
			}

			if (_play || _linear_load)
				_load_index = get_next();
			else
				_load_index = get_random();
			load_image();
					
		}
		
		private function get_next():int
		{
			for (var i:uint=0; i<_loaded.length; i++)
			{
				if (_loaded[i]==CONSTRUCTED)
					return i;
			}
			return -1;
		}
		
		private function get_random():int
		{
			var l:Array = new Array();
			for (var i:uint=0; i<_loaded.length; i++)
			{
				if (_loaded[i]==CONSTRUCTED)
					l.push(i);
			}
			if (l.length==0)
				return -1;
			return l[Random.R(l.length)];
		}
		
		private function all_loaded():Boolean
		{
			for (var i:uint=0; i<_loaded.length; i++)
			{
				if (_loaded[i]==CONSTRUCTED)
					return false;
			}
			return true;
		}
		
		
		private function is_next_loaded():Boolean
		{
			var i:uint = _slides.page+1;
			if (i>=_loaded.length)
				i = 0;
			return _loaded[i]==LOAD_COMPLETE;
		}
		
		protected function on_click_component(e:ComponentEvent):void
		{
			var t:Entity = e.component.userObject;
			var i:int = _slides.indexOf(e.component);
			dispatchComponentEvent(SelectionEvent.SELECT, e.component, i);
		}
		
		private function start_slide_show_timer():void
		{
			if (_timer==null)
			{
				_timer = new Timer(_speed);
				_timer.addEventListener(TimerEvent.TIMER, on_tick);
			}
			_timer.start();
		}
		
		private function on_tick(e:TimerEvent):void
		{
			if (is_next_loaded())
			{
				_slides.next();
				_slides.render();
				dispatchComponentEvent(NEXT, this);
			}
			else
				_show_next_loaded = true;
		}
		
		
		override public function set visible(b:Boolean):void
		{
			if (!b && _timer!=null)
				_timer.stop();
			else if (b && _timer!=null)
				_timer.start();
			super.visible = b;
		}
		
	}
}
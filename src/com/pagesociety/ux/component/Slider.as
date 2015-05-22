package com.pagesociety.ux.component
{
	import com.pagesociety.ux.decorator.SliderDecorator;
	import com.pagesociety.ux.event.ComponentEvent;

	[Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
	[Event(type="com.pagesociety.ux.event.ComponentEvent", name="mouse_release")]
	public class Slider extends Component
	{
		
		private var _bottom		:Number;
		private var _top		:Number;
		private var _slide_dec	:SliderDecorator;
		
		public function Slider(parent:Container)
		{
			super(parent);
			decorator = _slide_dec = new SliderDecorator();
			decorator.addEventListener(ComponentEvent.CHANGE_VALUE, on_change_value);
			decorator.addEventListener(ComponentEvent.MOUSE_RELEASE, on_release_mouse);
		}
		
		public function setRange(b:Number,t:Number):void
		{
			_bottom = b;
			_top = t;
		}
		
		public function set maxValue(v:Number):void
		{
			_slide_dec.max = v;
		}
		
		public function get value():Number
		{
			var r:Number = _slide_dec.nubR ;
			if (r<0) r=0;
			if (r>1) r=1;
			return (_top-_bottom)*r+_bottom;
		}
		
		public function set value(n:Number):void
		{
			var r:Number = (n-_bottom)/(_top-_bottom);
			if (r<0) r=0;
			if (r>1) r=1;
			_slide_dec.nubR =  r;
		}
		
		private function on_change_value(e:ComponentEvent):void
		{
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, value);
		}
		
		private function on_release_mouse(e:ComponentEvent):void
		{
			dispatchComponentEvent(ComponentEvent.MOUSE_RELEASE, this, value);
		}
		
		//
		public function get nubSize():Number
		{
			return _slide_dec.nubSize;
		}
		
		public function set nubSize(x:Number):void
		{
			_slide_dec.nubSize = x;
		}
		
		override public function get backgroundColor():uint
		{
			return _slide_dec.backgroundColor;
		}
		
		override public function set backgroundColor(x:uint):void
		{
			_slide_dec.backgroundColor = x;
		}
		
		override public function get backgroundAlpha():Number
		{
			return _slide_dec.backgroundAlpha;
		}
		
		override public function set backgroundAlpha(x:Number):void
		{
			_slide_dec.backgroundAlpha = x;
		}
		
		public function get nubColor():uint
		{
			return _slide_dec.nubColor;
		}
		
		public function set nubColor(x:uint):void
		{
			_slide_dec.nubColor = x;
		}
		
		public function get nubAlpha():Number
		{
			return _slide_dec.nubAlpha;
		}
		
		public function set nubAlpha(x:Number):void
		{
			_slide_dec.nubAlpha = x;
		}
		
		public function get nubHeight():Number
		{
			return _slide_dec.nubHeight;
		}
		
		public function set nubHeight(x:Number):void
		{
			_slide_dec.nubHeight = x;
		}
		
		public function get nubYOffset():Number
		{
			return _slide_dec.nubYOffset;
		}
		
		public function set nubYOffset(y:Number):void
		{
			_slide_dec.nubYOffset = y;
		}
		
	}
}
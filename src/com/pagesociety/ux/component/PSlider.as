package com.pagesociety.ux.component
{
	import com.pagesociety.ux.Margin;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.dim.Guide;
	import com.pagesociety.ux.event.ComponentEvent;
	
	import flash.geom.Point;
	
	[Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
	public class PSlider extends Container
	{
		public static const HORIZONTAL:uint = 0;
		public static const VERTICAL:uint = 1;
		
		private var _type:uint;
		
		private var _value:Number;
		private var _max:Number;
		
		private var _bg:Component;
		private var _thumb:Component;
		private var _fwd:Component;
		
		private var _margin:Margin;
		
		public function PSlider(parent:Container, type:uint)
		{
			super(parent);
			
			_type = type;
			
			_value = 0;
			_max = 1;
			
			_bg = init_bg(this);
			_bg.decorator.mouseChildren = false;
			_thumb = init_thumb(this);
			_thumb.decorator.mouseChildren = false;
			_fwd = init_fwd(this);
			_fwd.decorator.mouseChildren = false;
			
			_margin = new Margin(0,0,0,0);
			
			backgroundVisible = true;
			addEventListener(ComponentEvent.DRAG, on_drag);
		}
		
		public function get max():Number
		{
			return _max;
		}
		
		public function set max(m:Number):void
		{
			_max = m;
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(v:Number):void
		{
			_value = v;
		}
		
		public function getValue(a:Number,b:Number=-1):Number
		{
			if (b<a)
				return a*_value;
			else
				return (b-a)*_value + a;
		}
		
		public function get margin():Margin
		{
			return _margin;
		}
		
		protected function init_bg(p:Container):Component
		{
			var c:Component = new Component(p);
			c.backgroundVisible = true;
			c.backgroundColor = 0x777777;
			c.backgroundAlpha = .4;
			return c;
		}
		
		protected function init_thumb(p:Container):Component
		{
			var c:Component = new Component(p);
			c.backgroundVisible = true;
			c.backgroundColor = 0x333333;
			c.backgroundAlpha = 1;
			switch(_type)
			{
				case HORIZONTAL:
					c.width = 3;
					break;
				case VERTICAL:
					c.height = 3;
					break;
			}
			return c;
		}
		
		protected function init_fwd(p:Container):Component
		{
			var c:Component = new Component(p);
			c.backgroundVisible = true;
			c.backgroundColor = 0x777777;
			c.backgroundAlpha = .5;
			switch(_type)
			{
				case HORIZONTAL:
					c.height = 1;
					c.alignY(Guide.CENTER);
					break;
				case VERTICAL:
					c.width = 1;
					c.alignX(Guide.CENTER);
					break;
			}
			return c;
		}
		
		private function on_drag(e:ComponentEvent):void
		{
			var p:Point = getRootPosition();
			switch(_type)
			{
				case HORIZONTAL:
					_value = (e.data.x-p.x-margin.left)/(width-margin.left-margin.right);
					break;
				case VERTICAL:
					_value = 1-(e.data.y-p.y-margin.top)/(height-margin.top-margin.bottom);
					break;
			}
			if (_value<0) _value=0;
			if (_value>_max) _value= _max;
			render();
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, _value);
		}
		
		override public function render():void
		{
			switch(_type)
			{
				case HORIZONTAL:
					var w:Number 	= width - margin.left - margin.right - _thumb.width;
					_bg.x 			= 0;
					_bg.width 		= margin.left + w*_value;
					_thumb.x 		= margin.left + w*_value;
					_fwd.width 		= w*(_max-_value);
					_fwd.x 			= _thumb.x+_thumb.width;
					_fwd.visible	= _fwd.width>0;
					break;
				case VERTICAL:
					var fa:Number	= 1-_value;
					var h:Number 	= height - margin.top - margin.bottom - _thumb.height;
					_thumb.y 		= margin.top + h*fa ;
					_bg.y			= _thumb.y+_thumb.height;
					_bg.heightDelta = -_bg.y;
					_fwd.height 	= h*(_max-_value);
					_fwd.y 			= _thumb.y-_fwd.height;
					_fwd.visible	= _fwd.height>0;
					break;
			}
			super.render();
		}
	}
}
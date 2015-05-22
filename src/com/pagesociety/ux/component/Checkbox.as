package com.pagesociety.ux.component
{
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.event.ComponentEvent;
	
	import flash.display.Graphics;

	public class Checkbox extends Component implements IEditor
	{
		private var _dirty:Boolean;
		private var _value:Boolean;
		private var _check_color:uint = 0;
		
		public function Checkbox(parent:Container, index:int=-1)
		{
			super(parent, index);
			backgroundVisible = true;
			backgroundColor = 0xffffff;
			backgroundShadowSize = 3;
			backgroundShadowStrength = .3;
			width = 14;
			height = 14;
			addEventListener(ComponentEvent.CLICK, on_click);
		}
		
		public function set value(o:Object):void
		{
			_dirty = false;
			_value = o as Boolean;
		}
		
		public function get value():Object
		{
			return _value;
		}
		
		public function get dirty():Boolean
		{
			return _dirty;
		}
		
		public function set dirty(b:Boolean):void
		{
			_dirty = b;
		}
		
		public function set checkColor(c:uint):void
		{
			_check_color = c;
		}
		
		public function get checkColor():uint
		{
			return _check_color;
		}
		
		private function on_click(e:*):void
		{
			_dirty = true;
			_value = !_value;
			render();
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, _value);
		}
		
		override public function render():void
		{
			var g:Graphics = decorator.midground.graphics;
			g.clear();
			if (_value)
			{
				g.beginFill(_check_color, 1);
				g.drawRect(2,2,width-4,height-4);
				g.endFill()
			}
			super.render();
		}
	}
}
package com.pagesociety.ux.layout
{
	import com.pagesociety.ux.Margin;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;

	public class TextFlowLayout implements Layout
	{
		private var _row_height:Number = 22;
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _margin:Margin;
		private var _container:Container;
		
		public function TextFlowLayout()
		{
			_margin = new Margin(0,0,0,0);
		}
		
		public function set rowHeight(n:uint):void
		{
			_row_height = n;
		}
		
		public function get rowHeight():uint
		{
			return _row_height;
		}
		

		public function get container():Container
		{
			return _container;
		}
		
		public function set container(c:Container):void
		{
			_container = c;
		}
		
		public function get margin():Margin
		{
			return _margin;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function layout():void
		{
			var line:uint=0;
			var c:uint=0;
			var s:uint=_container.children.length;
			_y = 0;
			while (c<s)
			{
				var p:Component = _container.children[c];
				_x = 0;
				while (c<s && _x < _container.width - p.width)
				{
					p = _container.children[c];
					p.updatePosition(_x,_y);
					_x += _margin.left + p.width + _margin.right;
					c++;
				}
				_y += _row_height;
				line++;
			}
		}
		
		public function calculateHeight():Number
		{
			return _y+_row_height;
		}
		
		public function calculateWidth():Number
		{
			return _container.width;
		}
		
		public function calculateIndex(x:Number, y:Number):uint
		{
			return 0;
		}
		
		public function calculateWidthForUnset():Number
		{
			return 20;
		}
		
		public function calculateHeightForUnset():Number
		{
			return _row_height;
		}
		
	}
}
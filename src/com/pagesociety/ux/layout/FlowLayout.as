package com.pagesociety.ux.layout
{
	import com.pagesociety.ux.Margin;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	
	public class FlowLayout implements Layout
	{
		public static var LEFT_TO_RIGHT:uint = 1;
		public static var RIGHT_TO_LEFT:uint = 2;
		public static var TOP_TO_BOTTOM:uint = 3;
		public static var BOTTOM_TO_TOP:uint = 4;
		public static var LEFT_TO_RIGHT_FREE_Y:uint = 5;
		public static var TOP_TO_BOTTOM_FREE_X:uint = 6;
		
		private var _type:uint;
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _cell_width:Number = 0;
		private var _cell_height:Number = 0;
		private var _margin:Margin;
		private var _current_container:Container;
		private var _invisible_components_in_flow:Boolean = false;
		
		public function FlowLayout(type:uint, params:Object=null)
		{
			_type = type;
			_margin = new Margin(0,0,0,0);
			if (params!=null)
			{
				if (params.cellWidth!=null)
					cellWidth = params.cellWidth;
				if (params.cellHeight!=null)
					cellHeight = params.cellHeight;
				if (params.margin!=null)
					_margin = params.margin;
				if(params.invisibleComponentsInFlow != null)
					_invisible_components_in_flow = params.invisibleComponentsInFlow;
			}
		}
		
		public function get container():Container
		{
			return _current_container;
		}
		
		public function set container(c:Container):void
		{
			_current_container = c;
		}
		
		public function get type():uint
		{
			return _type;
		}
		
		public function set type(t:uint):void
		{
			_type = t;
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
			if (_current_container.children.length==0)
				return;
				
			switch(_type)
			{
				case LEFT_TO_RIGHT:
				case TOP_TO_BOTTOM:
					_x = _margin.left;
					_y = _margin.top;
					break;
				case RIGHT_TO_LEFT:
					if (_cell_width!=0)
						_x = _current_container.width - _cell_width - margin.right;
					else
						_x = _current_container.width;
					_y = _margin.top;
					break;					
				case BOTTOM_TO_TOP:
					_x = _margin.left;
					if (_cell_height!=0)
						_y = _current_container.height - _cell_height - margin.bottom;
					else
						_y = _current_container.height - _current_container.firstChild.height - margin.bottom;
					break;
				case LEFT_TO_RIGHT_FREE_Y:
					_x = _margin.left;
					break;
				case TOP_TO_BOTTOM_FREE_X:
					if (_cell_height!=0)
						_y = _current_container.height - _cell_height - margin.bottom;
					else
						_y = _current_container.height - _current_container.firstChild.height - margin.bottom;
					break;
				default:
					throw new Error("Unimplemented "+_type);
			}
			
			for (var i:uint=0; i<_current_container.children.length; i++)
			{
				var c:Component = _current_container.children[i];
				if (!c.visible && !_invisible_components_in_flow)
					continue;
				position(c);
			}
		}
		
		public function get margin():Margin
		{
			return _margin;
		}
		
		public function set cellWidth(w:Number):void
		{
			_cell_width = w;
		}
		
		public function get cellWidth():Number
		{
			return _cell_width;
		}
		
		public function set cellHeight(h:Number):void
		{
			_cell_height = h;
		}
		
		public function get cellHeight():Number
		{
			return _cell_height;
		}
		
		public function position(c:Component):void
		{
			
			switch(_type)
			{
				case LEFT_TO_RIGHT:
					c.updatePosition(_x,_y);			
					if (_cell_width!=0)
						_x += _cell_width + margin.right + margin.left;
					else
						_x += c.width + margin.right + margin.left;
					break;
				case TOP_TO_BOTTOM:
					c.updatePosition(_x,_y);			
					if (_cell_height!=0)
						_y += _cell_height + margin.top + margin.bottom;
					else
						_y += c.height + margin.top + margin.bottom;
					break;
				case RIGHT_TO_LEFT: 		
					if (_cell_width!=0)
						_x -= _cell_width + margin.right + margin.left;
					else
						_x -= c.width + margin.right + margin.left;
					
					c.updatePosition(_x,_y);
					break;
				case LEFT_TO_RIGHT_FREE_Y:
					c.updateX(_x);			
					if (_cell_width!=0)
						_x += _cell_width + margin.right + margin.left;
					else
						_x += c.width + margin.right + margin.left;
					break;

				case TOP_TO_BOTTOM_FREE_X:
					c.updateY(_y);			
					if (_cell_height!=0)
						_y += _cell_height + margin.top + margin.bottom;
					else
						_y += c.height + margin.top + margin.bottom;
					break;
				default:
					throw new Error("Unimplemented "+_type);
			}
		}
	

		public function calculateHeight():Number
		{
			var components:Array = _current_container.children;
			if (_type==LEFT_TO_RIGHT||_type==RIGHT_TO_LEFT)
				return _current_container.height;
				
			if (_cell_height != 0)
				return components.length*(_cell_height + margin.top + margin.bottom);
			var h:uint = 0;
			for (var i:uint=0; i<components.length; i++)
			{
				if (!components[i].visible && !_invisible_components_in_flow)
					continue;
				h += components[i].height + margin.top + margin.bottom;
			}
			return h;
		}
		
		public function calculateWidth():Number
		{
			var components:Array = _current_container.children;
			if (_type==TOP_TO_BOTTOM||_type==BOTTOM_TO_TOP)
				return _current_container.width;
				
			if (_cell_width != 0)
				return components.length*(_cell_width + margin.right + margin.left);
			var w:uint = 0;
			for (var i:uint=0; i<components.length; i++)
			{
				if (!components[i].visible && !_invisible_components_in_flow)
					continue;
				w += components[i].width  + margin.right + margin.left;
			}
			return w;
		}
		
		public function calculateIndex(x:Number, y:Number):uint
		{
			var components:Array = _current_container.children;
			var i:uint=0;
			switch (_type)
			{
				case TOP_TO_BOTTOM:
					if (_cell_height!=0)
						return Math.floor( y/(_cell_height + margin.top + margin.bottom) ) ;
					else
					{
						var h:uint = 0;
						for (i=0; i<components.length; i++)
						{	
							h += components[i].height  + margin.top + margin.bottom;
							if (h>y)
								return i;
						}
						return components.length;
					}
				case LEFT_TO_RIGHT:
					if (_cell_width!=0)
						return Math.floor( x/(_cell_width + margin.right + margin.left) ) ;
					else
					{
						var w:uint = 0;
						for (i=0; i<components.length; i++)
						{	
							w += components[i].width  + margin.right + margin.left;
							if (w>x)
								return i;
						}
						return components.length;
					}
			}
			return 0;
		}
		
		public function calculateHeightForUnset():Number
		{
			if (type == FlowLayout.LEFT_TO_RIGHT || type == FlowLayout.RIGHT_TO_LEFT)
			{
				return _current_container.height - margin.top - margin.bottom;
			}
			
			var k:Number=0;
			var c:Number=0;
			var uc:int;
			var i:uint;
			var children:Array = _current_container.children;
			for (i=0; i<children.length; i++)
			{
				if (!children[i].isHeightUnset)
				{
					k += children[i].height;
					c++;
				}
			}
			uc = children.length - c;
			if (uc < 1)
				return 0;
			else
				return Math.floor((_current_container.height - k)/uc) - margin.top - margin.bottom;
		}
		
		public function calculateWidthForUnset():Number
		{
			if (type == FlowLayout.TOP_TO_BOTTOM || type == FlowLayout.BOTTOM_TO_TOP)
			{
				return _current_container.width - margin.left - margin.right;
			}
			else if (cellWidth != 0)
			{
				return cellWidth - margin.left - margin.right;
			}
			else
			{
				var k:Number=0;
				var c:Number=0;
				var uc:int;
				var i:uint;
				var children:Array = _current_container.children;
				for (i=0; i<children.length; i++)
				{
					if (!children[i].isWidthUnset)
					{
						k += children[i].width;
						c++;
					}
				}
				uc = children.length - c;
				if (uc < 1)
					return 0;
				else
					return Math.floor((_current_container.width - k)/uc) - margin.right - margin.left;
			}
		}
	}
}
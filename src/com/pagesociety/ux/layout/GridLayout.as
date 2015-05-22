package com.pagesociety.ux.layout
{
	import com.pagesociety.ux.Margin;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	
	public class GridLayout implements Layout
	{
		public static var GROW_VERTICALLY:uint = 0;
		public static var GROW_HORIZONTALLY:uint = 1;
		
		private var _type:uint;
		private var _current_container:Container;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _cell_width:Number = 100;
		private var _cell_height:Number = 100;
		private var _columns:uint = 4;
		private var _column_count:uint = 0;
		private var _rows:uint = 0;
		private var _row_count:uint = 0;
		private var _margin:Margin;
		
		public function GridLayout(type:uint,params:Object=null)
		{
			_type = type;
			_margin = new Margin(0,0,0,0);
			if (params!=null)
			{
				if (params.cellWidth==null)
					throw new Error("Missing required parameter 'cellWidth' for Browser grid layout");
				else
					cellWidth = params.cellWidth;
				if (params.cellHeight==null)
					throw new Error("Missing required parameter 'cellHeight' for Browser grid layout");
				else
					cellHeight = params.cellHeight;
				if (params.margin!=null)
					_margin = params.margin;
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
			width = _current_container.width;
			height = _current_container.height;
			_x = _margin.left;
			_y = _margin.top;
			_column_count = 0;
			_row_count = 0;
			for (var i:uint=0; i<_current_container.children.length; i++)
				position(_current_container.children[i]);
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
				
		public function set columns(c:Number):void
		{
			_columns = c-1;
		}
		
		public function get height():Number
		{
			return _y;
		}
		
		public function get width():Number
		{
			return _columns * cellWidth;
		}
		
		public function set width(w:Number):void
		{
			_columns = Math.floor(w/(_cell_width + margin.right + margin.left))-1;
		}
		
		public function get columns():Number
		{
			return _columns;
		}
		
		public function set height(h:Number):void
		{
//			_rows = Math.floor(h/_cell_height);
		}
		
		private function position(c:Component):void
		{
			c.updatePosition(_x,_y);
			switch(_type)
			{
				case GROW_VERTICALLY:
					_x += _cell_width + margin.right + margin.left;
					_column_count++;
					if ( _column_count > _columns)
					{
						_y += _cell_height + margin.top + margin.bottom;
						_x = margin.left;
						_column_count = 0;
					}
					break;
				case GROW_HORIZONTALLY:
					_y += _cell_height + margin.top + margin.bottom;
					_row_count++;
					if (_rows > 0 && _row_count>_rows)
					{
						_x += _cell_width + margin.right + margin.left;
						_y = _margin.top;
						_row_count = 0;
					}
					break;
			}
		}
		
		public function calculateHeight():Number
		{
			var components:Array = _current_container.children;
			if (_type==GROW_VERTICALLY)
			{
				var numChildren:uint = components.length;
				var a:Number = 1+Math.floor((numChildren-1)/(_columns+1));
				return a*(_cell_height + margin.top + margin.bottom);
			}
			else
				return _current_container.height;
		}
		
		public function calculateWidth():Number
		{
//			var numChildren:uint = components.length;
//			return numChildren*(_cell_width + margin.right + margin.left);
			return _current_container.width;
		}
		
		public function calculateIndex(x:Number, y:Number):uint
		{
			switch (_type)
			{
				case GROW_VERTICALLY:
					return Math.floor( x/(_cell_width + margin.right + margin.left) ) +
							Math.floor( y/(_cell_height + margin.top + margin.bottom) )*(_columns+1);
				case GROW_HORIZONTALLY:
					return Math.floor( x/(_cell_width + margin.right + margin.left) ) * (_rows+1) +
							Math.floor( y/(_cell_height + margin.top + margin.bottom) );
					break;
			}
			return 0;
		}

	}
}
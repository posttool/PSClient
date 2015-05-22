package com.pagesociety.ux.component.text
{
	import com.pagesociety.ux.ISelectable;
	import com.pagesociety.ux.Margin;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	

	public class Pager extends Container
	{
		protected var _label:Label;
		protected var _pages:Container;
		
		protected var _count_suffix:String = "total";
		protected var _offset:int = 0;
		protected var _page_size:uint = 20; 
		protected var _total_count:uint = 0;
		protected var _font_style:String;
		protected var _link_style:String;
		protected var _show_max:uint = 10;
		
		protected var _cell_renderer:Function;
		protected var _needs_redraw:Boolean;
		
		public function Pager(parent:Container)
		{
			super(parent);
			_label = new Label(this);
			_pages = new Container(this);
			_pages.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT, {margin: new Margin(0,6,0,0)});
			_cell_renderer = default_cell_renderer;
		}
		
		public function set cellRenderer(f:Function):void
		{
			_cell_renderer = f;
		}
		
		public function get label():Label
		{
			return _label;
		}
		
		public function set countSuffix(s:String):void
		{
			if (_count_suffix == s)
				return;
			_count_suffix = s;
			_needs_redraw = true;
		}
		
		public function get pagesContainer():Container
		{
			return _pages;
		}
		
		public function get offset():uint
		{
			return _offset;
		}
		
		public function set offset(i:uint):void
		{
			if (_offset == i)
				return;
			_offset = i;
			_needs_redraw = true;
		}
		
		public function get page():int
		{
			return _offset/_page_size;
		}
		
		public function set page(p:int):void
		{
			_offset = p*_page_size;
			if (_offset<0) _offset = 0;
			if (_offset>(pages-1)*pageSize) _offset = (pages-1)*pageSize;
			_needs_redraw = true;
		}
		
		public function get pages():uint
		{
			return (totalCount-1)/pageSize +1;
		}
		
		public function get max():uint
		{
			return _show_max;
		}
		
		public function set max(i:uint):void
		{
			_show_max = i;
			_needs_redraw = true;
		}
		
		public function get pageSize():uint
		{
			return _page_size;
		}
		
		public function set pageSize(p:uint):void
		{
			_page_size = p;
			_needs_redraw = true;
		}
		
		
		public function get totalCount():uint
		{
			return _total_count;
		}
		
		public function set totalCount(c:uint):void
		{
			_total_count = c;
			_needs_redraw = true;
		}
		
		public function set fontStyle(s:String):void
		{
			_font_style = s;
			_needs_redraw = true;
		}
		
		public function get fontStyle():String
		{
			return _font_style;
		}
		
		public function set linkStyle(s:String):void
		{
			_link_style = s;
			_needs_redraw = true;
		}
		
		public function get linkStyle():String
		{
			return _link_style;
		}
		
		override public function get width():Number
		{
			return _pages.x + _pages.layout.calculateWidth();
		}
		
		override public function get height():Number
		{
			return _label.height;
		}
		
		override public function render():void
		{
			if (_needs_redraw)
				redraw();
			super.render();
		}
		
		protected function redraw():void
		{
			_label.text = _total_count+" "+_count_suffix;
			if (_font_style!=null)
				_label.fontStyle = _font_style;
			
			_pages.clear();
			_pages.x = _label.width+12;
			
			
			if (pages > 1)
			{
				if (pages>_show_max)
					add_cell("&lt;",0)
				
				var at_page:int = _offset/pageSize;
				var min_page:int = 0;
				var max_page:int = _show_max;
				if (pages<=_show_max)
				{
					max_page = pages;
				}
				else if (at_page>pages-_show_max)
				{
					min_page = pages-_show_max;
					max_page = pages;
				}
				else if (at_page>_show_max/2)
				{
					min_page = at_page-_show_max/2;
					max_page = at_page+_show_max/2;
				}

				for (var i:uint=min_page; i<max_page; i++)
				{
					var offset:uint = i*pageSize;
					var max:uint = Math.min(totalCount, offset+pageSize);
					var label:String = (i+1).toString();//(offset+1)+"-"+max;
					var c:Component = add_cell(label,offset,offset==_offset);
					if (offset==_offset)
						_last_p = ISelectable(c);
				}
				
				if (pages>_show_max)
					add_cell("&gt;",(pages-1)*pageSize)
			}
			
			_needs_redraw = false;
		}
		
		private function add_cell(label:String, value:Object, selected:Boolean=false):Component
		{
			var page:Component = _cell_renderer(_pages, label);
			page.userObject = value;
			page.addEventListener(ComponentEvent.CLICK, handle_click);
			if (selected && page is ISelectable)
				ISelectable(page).selected = true;
			return page;
		}
		
		protected function default_cell_renderer(p:Container, label:String):Component
		{
			var page:Link = new Link(p);
			page.text = label;
			if (_link_style!=null)
				page.styleName = _link_style;
			else if (_font_style!=null)
				page.fontStyle = _font_style;
			return page;
		}
 
		private var _last_p:ISelectable;
		private function handle_click(e:ComponentEvent):void
		{
			_offset = e.component.userObject;
			redraw();
			render();
			dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE, this));
			//update_page();
		}
		
//		private function update_page():void
//		{
//			if (_last_p!=null)
//			{
//				_last_p.selected = false;
//				Component(_last_p).render();
//			}
//			_last_p = _pages.children[page];
//			if (_last_p!=null)
//			{
//				_last_p.selected = true;
//				Component(_last_p).render();
//			}
//			
//			dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE, this));
//		}
		
	}
}
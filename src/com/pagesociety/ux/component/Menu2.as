package com.pagesociety.ux.component
{
	import com.pagesociety.ux.ISelectable;
	import com.pagesociety.ux.Margin;
	import com.pagesociety.ux.component.text.Link;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	import com.pagesociety.ux.layout.Layout;
	
	[Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
	public class Menu2 extends Container
	{
		//
		protected var _c:Container;
		protected var _margin:Margin;
		
		private var _selected_index:int;
		private var _selected_component:Component;
		
		private var _options:Array;
		private var _option_renderer:Function;
		private var _use_margin:Boolean;
		
		public function Menu2(parent:Container,use_margin:Boolean=true)
		{
			super(parent);
			_c = new Container(this);
			_c.layout = new FlowLayout(FlowLayout.TOP_TO_BOTTOM);
			_selected_index = -1;
			_use_margin = use_margin;
			if (use_margin)
				_margin = new Margin(5,5,8,5);
			_option_renderer = default_option_renderer;
			styleName = "Menu";
		}
		
		protected function default_option_renderer(p:Container, label:String, value:Object):Component
		{
			var link:Link = new Link(p);
			link.text = label;
			return link
		}
		
		public function get margin():Margin
		{
			return _margin;
		}
		
		override public function get layout():Layout
		{
			return _c.layout;
		}
		
		public function get flowLayout():FlowLayout
		{
			return _c.layout as FlowLayout;
		}

		public function get selectedIndex():int
		{
			return _selected_index;
		}
		
		public function set selectedIndex(i:int):void
		{
			selectComponent(i<0?null:_c.children[i]);
		}
		
		public function get selectedComponent():Component
		{
			return _selected_component;
		}
		
		public function set optionRenderer(f:Function):void
		{
			_option_renderer = f;
		}
		
		private function add_option(label:String,value:Object):void
		{
			var c:Component = _option_renderer(_c,label,value);
			c.userObject = value;
			c.addEventListener(ComponentEvent.CLICK, do_select_component);
		}
		
		public function get options():Array
		{
			return _options;
		}
		
		public function set options(values:Array):void
		{
			_options = values;
			_c.clear();
			if (_options==null)
				return;
			for (var i:uint=0; i<_options.length; i++)
			{
				var v:Object = _options[i];
				if (v is String)
					add_option(v as String,v as String);
				else if (v is Array)
					add_option(v[0],v[1]);
			}
		}
	
		private function do_select_component(c:ComponentEvent):void
		{
			selectComponent(c.component);
			dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE, _selected_component));
		}
		
		public function selectComponent(c:Component):void
		{
			if (_selected_component!=null && _selected_component is ISelectable)
			{
				ISelectable(_selected_component).selected = false;
				_selected_component.render();
			}
			
			_selected_component = c;
			_selected_index = c==null?-1:_c.indexOf(c);
			
			if (_selected_component is ISelectable)
			{
				ISelectable(_selected_component).selected = true;
				_selected_component.render();
			}
			
		}
		
		override public function get height():Number
		{
			switch (flowLayout.type)
			{
				case FlowLayout.BOTTOM_TO_TOP:
				case FlowLayout.TOP_TO_BOTTOM:
					return flowLayout.calculateHeight() + (_use_margin ? _margin.top+_margin.bottom : 0);
				case FlowLayout.LEFT_TO_RIGHT:
				case FlowLayout.RIGHT_TO_LEFT:
					return super.height;//for my children, get max height
			}
			return super.height;
		}
		
		override public function get width():Number
		{
			switch (flowLayout.type)
			{
				case FlowLayout.BOTTOM_TO_TOP:
				case FlowLayout.TOP_TO_BOTTOM:
					return super.width;//for my children, get max width;
				case FlowLayout.LEFT_TO_RIGHT:
				case FlowLayout.RIGHT_TO_LEFT:
					return flowLayout.calculateWidth() + (_use_margin ? _margin.left+_margin.right : 0);
			}
			return super.width;
		}
		
		override public function render():void
		{
			if (_use_margin)
			{
				_c.x = _margin.left;
				_c.y = _margin.top;
				_c.width = width - _margin.left - _margin.right;
				_c.height = height - _margin.top - _margin.bottom;
			}
			super.render();
		}
	}
}
package com.pagesociety.ux.component
{
	import com.pagesociety.ux.ISelectable;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	
	[Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
	public class Menu extends Container
	{
		//
		private var _selected_index:int;
		
		public function Menu(parent:Container)
		{
			super(parent);
			layout = new FlowLayout(FlowLayout.TOP_TO_BOTTOM);
			layout.margin.top = 0;
			layout.margin.left = 0;
			_selected_index = -1;
			styleName = "Menu";
		}
		
		public function get flowLayout():FlowLayout
		{
			return layout as FlowLayout;
		}

		public function get selectedIndex():int
		{
			return _selected_index;
		}
		
		public function set selectedIndex(i:int):void
		{
			selectComponent(i<0?null:children[i]);
		}
		
		public function get selectedComponent():Component
		{
			return children[_selected_index];
		}
		
		override public function addComponent(c:Component,i:int=-1):void
		{
			super.addComponent(c,i);
			if (!c.hasEventListener(ComponentEvent.CLICK))
				c.addEventListener(ComponentEvent.CLICK, do_select_component);
		}
		
		
		
		private function do_select_component(c:ComponentEvent):void
		{
			selectComponent(c.component);
			dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE, selectedComponent));
		}
		
		public function selectComponent(c:Component):void
		{
			if (selectedComponent!=null && selectedComponent is ISelectable)
			{
				ISelectable(selectedComponent).selected = false;
				selectedComponent.render();
			}
			
			_selected_index = c==null?-1:indexOf(c);
			
			if (selectedComponent is ISelectable)
			{
				ISelectable(selectedComponent).selected = true;
				selectedComponent.render();
			}
			
		}
		
		
		
		
	}
}
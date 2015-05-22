package com.pagesociety.ux.component.container
{
	import com.pagesociety.ux.ISelectable;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.event.ComponentEvent;

	[Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
	public class SingleSelectionContainer extends Container
	{
		public var _selected:Component;
		public function SingleSelectionContainer(parent:Container, index:int=-1)
		{
			super(parent, index);
		}
		
		override public function addComponent(child:Component,i:int=-1):void
		{
			super.addComponent(child,i);
			child.addEventListener(ComponentEvent.CLICK, on_click);
		}
		
		protected function on_click(e:ComponentEvent):void
		{
			select(e.component);
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, e.component);
		}
		
		public function select(c:Component):void
		{
			var s:ISelectable;
			if (_selected!=null)
			{
				s = _selected as ISelectable;
				if (s!=null)
					s.selected = false;
				_selected.render();
			}
			_selected = c;
			s = c as ISelectable;
			if (s!=null)
			{
				s.selected = true;
				_selected.render();
			}
		}
		
		public function get selected():Component
		{
			return _selected;
		}
		
		public function get selectionIndex():int
		{
			return children.indexOf(_selected);
		}
		
		public function set selectionIndex(i:int):void
		{
			select( children[i] );
		}
	
	}
}
package com.pagesociety.ux.component.form
{
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;

	[Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]

	public class RadioGroup extends Container implements IEditor
	{
		private var _selected:LabeledCheckbox;
		private var _dirty:Boolean;
		
		public function RadioGroup(parent:Container, index:Number=-1)
		{
			super(parent, index);
			layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
			layout.margin.right = 10;
			width = 0;//provided by layout
		}
		
		override public function get width():Number
		{
			if (FlowLayout(layout).type==FlowLayout.LEFT_TO_RIGHT)
				return layout.calculateWidth();
			else
				return super.width;
		}
		
		override public function get height():Number
		{
			if (FlowLayout(layout).type==FlowLayout.TOP_TO_BOTTOM)
				return layout.calculateHeight();
			else
				return super.height;
		}
		
		public function addOption(s:String, user_object:*=null):void
		{
			var r:LabeledCheckbox = new LabeledCheckbox(this);
			r.userObject = user_object;
			r.text = s;
			r.addEventListener(ComponentEvent.CHANGE_VALUE, on_select_item);
		}
		
		private function on_select_item(e:ComponentEvent):void
		{
			_dirty = true;
			select(e.component as LabeledCheckbox);
			render();
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, value);
		}
		
		private function select(r:LabeledCheckbox):void
		{
			if (_selected != null)
				_selected.selected = false;
			_selected = r;
			if (_selected != null)
				_selected.selected = true;
		}
		
		public function get value():Object
		{
			if (_selected==null)
				return null;
			if (_selected.userObject==null) 
				return _selected.text;
			return _selected.userObject;
		}
		
		public function set value(o:Object):void
		{
			_dirty = false;
			if (o!=null)
				for (var i:uint=0; i<children.length; i++)
				{
					if (children[i].userObject == o)
					{
						select(children[i]);
						return;
					}
				}
			select(null);
		}
		
		public function set dirty(b:Boolean):void
		{
			_dirty = b;
		}
		
		public function get dirty():Boolean
		{
			return _dirty;
		}
		
	}
}
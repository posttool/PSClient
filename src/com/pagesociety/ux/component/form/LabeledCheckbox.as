package com.pagesociety.ux.component.form
{
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.component.Checkbox;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.event.ComponentEvent;
	
	

	public class LabeledCheckbox extends Container implements IEditor
	{
		
		private var _checkbox:Checkbox;
		private var _label:Label;
		
		public function LabeledCheckbox(parent:Container, index:int=-1)
		{
			super(parent, index);
			_checkbox = new Checkbox(this);
			_checkbox.y = 3;
			_checkbox.removeAllEventListeners();
			
			_label = new Label(this);
			_label.x = 16;
			addEventListener(ComponentEvent.CLICK, on_click);
		}
		
		public function on_click(e:ComponentEvent):void
		{
			_checkbox.dirty = true;
			_checkbox.value = !_checkbox.value;
			_checkbox.render();
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, value);
		}
		
		public function get value():Object
		{
			return _checkbox.value;
		}
		
		public function set value(b:Object):void
		{
			_checkbox.value = b as Boolean;
		}
		
		public function get dirty():Boolean
		{
			return _checkbox.dirty;
		}
		
		public function set dirty(b:Boolean):void
		{
			_checkbox.dirty = b;
		}
		
		public function get label():Label
		{
			return _label;
		}
		
		public function set text(s:String):void
		{
			_label.text = s;
		}
		
		public function get text():String
		{
			return _label.text;
		}
		
		public function set selected(b:Boolean):void
		{
			value = b;
		}
		
		public function get selected():Boolean
		{
			return value;
		}
		
		override public function get width():Number
		{
			return _label.x+_label.width;
		}
		
		override public function get height():Number
		{
			return _label.height;
		}
	}
}
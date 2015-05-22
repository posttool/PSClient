package com.pagesociety.ux.component.form
{
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Input;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.event.InputEvent;

	public class LabeledInput extends LabeledEditor implements IEditor
	{
		private var _input:Input;
		
		public function LabeledInput(parent:Container, fieldname:String, label:String, fs_label:String=null, fs_input:String=null)
		{
			super(parent,fieldname,label,fs_label);
			
			_input = new Input(this);
			if (fs_input!=null)
				_input.styleName = fs_input;
			_input.y = 15;
			_input.addEventListener(ComponentEvent.CHANGE_VALUE, onBubbleEvent);
			_input.addEventListener(InputEvent.LOSE_FOCUS_WHILE_DIRTY, onBubbleEvent);
			_input.addEventListener(InputEvent.SUBMIT, onBubbleEvent);
			multiline = false;
		}
		
		public function get input():Input
		{
			return _input;
		}
		
		public function get value():Object
		{
			return _input.value;
		}
		
		public function set value(o:Object):void
		{
			_input.value = o;
		}
		
		public function get dirty():Boolean
		{
			return _input.dirty;
		}
		
		public function set dirty(b:Boolean):void
		{
			_input.dirty = b;
		}
		
		override public function get height():Number
		{
			return _input.height + 20;
		}
		
		public function set multiline(b:Boolean):void
		{
			_input.multiline = b;
			
		}
		
		
		
	}
}
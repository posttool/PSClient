package com.pagesociety.ux.component.form
{
	import com.pagesociety.persistence.FieldDefinition;
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Label;
	
	public class FieldEditor extends Container implements IEditor
	{
		protected var _field:FieldDefinition;
		protected var _label:Label;
		protected var _editor:Component;
		protected var _ieditor:IEditor;
		
		public function FieldEditor(parent:Container, f:FieldDefinition)
		{
			super(parent);
			
			_field = f;
			id = _field.name;
			
			_label = new Label(this);
			_label.text = _field.name.toUpperCase();
			_label.fontStyle = "black_small";
			
			_editor = createEditorComponent();
			if (_editor==null)
				throw new Error("FieldEditorComponent.getEditorComponent returned null");
			if (!(_editor is IEditor))
				throw new Error("FieldEditorComponent ERROR: getEditorComponent must return a Component that implements the Editor interface");
			_ieditor = _editor as IEditor;
			_editor.y = 15;
			
			height = _editor.height + 20;
			widthDelta = -20;
		}
		
		public function get field():FieldDefinition
		{
			return _field;
		}
		
		public function get label():Label
		{
			return _label;
		}
		
		public function get editor():IEditor
		{
			return _editor as IEditor;
		}
		
		public function get value():Object
		{ 
			return _ieditor.value; 
		}
		
		public function set value(o:Object):void
		{ 
			_ieditor.value = o; 
		}
		
		public function get dirty():Boolean
		{ 
			return _ieditor.dirty; 
		}
		
		public function set dirty(b:Boolean):void
		{ 
			_ieditor.dirty = b; 
		}
		
		public function createEditorComponent():Component
		{
			return null; // causes an error, extending classes must override this method
		}//TODO WHY? just bring the default implementation back here... programmer can overload if necessary
		
		

	}
}
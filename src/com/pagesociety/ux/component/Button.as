package com.pagesociety.ux.component
{
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.decorator.ButtonDecorator;
	import com.pagesociety.ux.event.ComponentEvent;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	public class Button extends Container
	{
		private var _label:Label;
		private var _enabled:Boolean;
		
		public function Button(parent:Container, index:int=-1)
		{
			super(parent, index);
			decorator = new ButtonDecorator();
			_label = new Label(this);
			enabled = true;
			styleName = "Button";
			add_mouse_over_default_behavior();
		}
		
		public function get labelComponent():Label 
		{
			return _label;
		}
		
		
		public function set label(v:String):void 
		{
			_label.text = v;
		}
		
		public function get label():String 
		{
			return _label.text;
		}
		
		public function set textFormat(tf:TextFormat):void
		{
			_label.textFormat = tf;
		}
		
		public function set fontStyle(s:String):void 
		{
			_label.fontStyle = s;
		}
		
		public function get fontStyle():String 
		{
			return _label.fontStyle;
		}
		
		
		override public function get width():Number
		{
			if (!isWidthUnset)
				return super.width;
			return _label.width;
		}
		
		override public function get height():Number
		{
			if (!isHeightUnset)
				return super.height;
			return _label.height+4;
		}
		
		public function set enabled(b:Boolean):void
		{
			_enabled = b;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		override public function render():void
		{
			alpha = _enabled ? _over ? .8 : 1 : .1;
			super.render();
		}
		
		private function on_click(e:*):void
		{
			if (!_enabled)
				return;
			dispatchEvent(new ComponentEvent(ComponentEvent.CLICK, this));
		}
		
		private function on_dbl_click(e:*):void
		{
			if (!_enabled)
				return;
			dispatchEvent(new ComponentEvent(ComponentEvent.DOUBLE_CLICK, this));
		}
		
		
	}
}
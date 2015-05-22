package com.pagesociety.ux.component
{
	import com.pagesociety.util.ColorUtil;
	import com.pagesociety.ux.component.form.IntEditor;
	import com.pagesociety.ux.component.text.Input;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.decorator.ColorChooserDecorator;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.event.InputEvent;
	import com.pagesociety.ux.layout.FlowLayout;


	[Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
	public class ColorChooser extends Container
	{
		private var _cdec:ColorChooserDecorator;
		private var _text_inputs:Container;
		private var _r:IntEditor;
		private var _g:IntEditor;
		private var _b:IntEditor;
		private var _hex:Input;
		
		private var _color:uint;
		
		public var fontStyle:String;
		
		public function ColorChooser(parent:Container, index:int=-1)
		{
			super(parent, index);
			decorator = _cdec = new ColorChooserDecorator();
			decorator.addEventListener(ColorChooserDecorator.CHANGE_COLOR_VALUE, on_change_decorator_value);

			width = 250;
			height = 300;
			backgroundVisible = true;
			backgroundColor = 0x333333;
			backgroundShadowStrength = 1.5;
			backgroundShadowSize = 23;
			
			_text_inputs = get_row(this,4);
			_text_inputs.x = 20;
			_text_inputs.y = height - 50;
			
			var c:Container;
			c = get_column(_text_inputs,0,{width:70});
				get_label(c, "HEX");
				_hex = new Input(c);
//				_hex.fontStyle = fontStyle;
				_hex.height = 20;
				_hex.addEventListener(InputEvent.SUBMIT, on_change_hex);
				
			get_gap(_text_inputs,10);
			
			c = get_column(_text_inputs,0,{width:30});
				get_label(c, "R");
				_r = new IntEditor(c);
//				_r.fontStyle = fontStyle;
				_r.height = 20;
				_r.addEventListener(InputEvent.SUBMIT, on_change_rgb);
				
			c = get_column(_text_inputs,0,{width:30});
				get_label(c, "G");
				_g = new IntEditor(c);
//				_g.fontStyle = fontStyle;
				_g.height = 20;
				_g.addEventListener(InputEvent.SUBMIT, on_change_rgb);
				
			c = get_column(_text_inputs,0,{width:30});
				get_label(c, "B");
				_b = new IntEditor(c);
//				_b.fontStyle = fontStyle;
				_b.height = 20;
				_b.addEventListener(InputEvent.SUBMIT, on_change_rgb);
				
			value = 0xffffff;
			
		}
		
		
		public function get_label(p:Container,s:String, style_props:Object=null):Label
		{
			var c:Label = new Label(p);
			c.text = s;
			c.widthDelta = -22;
			c.height = 15;
			if (style_props!=null)
				application.style.apply(c, style_props);
			return c;
		}
		
		public function get_gap(p:Container,h:Number=6):Component
		{
			var c:Component = new Component(p);
			c.height = h;
			c.width = h;
			return c;
		}
		
		public function get_column(p:Container,space_between_elements:uint=0,style_props:Object=null):Container
		{
			var c:Container = new Container(p);
			c.layout = new FlowLayout(FlowLayout.TOP_TO_BOTTOM);
			c.layout.margin.bottom = space_between_elements;
//			c.layout.margin.right = right_margin;
			if (style_props!=null)
				application.style.apply(c, style_props);
			return c;
		}
		
		public function get_row(p:Container,space_between_elements:uint=0,style_props:Object=null):Container
		{
			var c:Container = new Container(p);
			c.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
			c.layout.margin.right = space_between_elements;
			if (style_props!=null)
				application.style.apply(c, style_props);
			return c;
		}
		
	
		
		public function set value(o:Object):void
		{
			_color = Number(o);
			update_ui();
		}
		
		public function get value():Object
		{
			return _color;
		}
		
		private function update_ui():void
		{
			var o:Object = ColorUtil.toRgb(_color);
			_r.value =o.r; 
			_g.value =o.g; 
			_b.value =o.b; 
			_hex.value = ColorUtil.toHexString(_color).toUpperCase();
			_cdec.color = _color;
		}
		
		private function on_change_decorator_value(e:ComponentEvent):void
		{
			_color = decorator.color;
			update_ui();
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, _color);
			render();
		}
		
		private function on_change_rgb(e:ComponentEvent):void
		{
			_color = ColorUtil.toInt({r:_r.value, g: _g.value, b: _b.value});
			update_ui();
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, _color);
			render();
		}
		
		private function on_change_hex(e:ComponentEvent):void
		{
			_color = Number("0x"+_hex.value);
			update_ui();
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, _color);
			render();
		}
		
	}
}
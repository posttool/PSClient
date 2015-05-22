package com.pagesociety.ux.decorator
{
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.style.Style;
	
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;

	public class LinkDecorator extends LabelDecorator
	{
		
		private var _link_color_normal:uint = 0x666666;
		private var _link_color_over:uint = 0x999999;
		private var _link_thickness_normal:int = 0;
		private var _link_thickness_over:int = 0;
		private var _link_color_selected:uint = 0x111111;
		private var _is_selected:Boolean = false;
		
		private var _over:Boolean;
		
		public function LinkDecorator(style:Style)
		{
			super(style);
			
			addEventListener(MouseEvent.MOUSE_OVER, on_mouse_over);
			addEventListener(MouseEvent.MOUSE_OUT, on_mouse_out);
			
			color = _link_color_normal;

			alpha = 1;
		
		}
		
		public function set selected(b:Boolean):void
		{
			_is_selected = b;
		}
		
		public function set normalColor(c:uint):void
		{
			_link_color_normal = c;
		}
		
		public function set overColor(c:uint):void
		{
			_link_color_over = c;
		}
		
		public function set normalThickness(c:int):void
		{
			_link_thickness_normal = c;
		}
		
		public function set overThickness(c:int):void
		{
			_link_thickness_over = c;
		}
		
		
		public function set selectedColor(c:uint):void
		{
			_link_color_selected = c;
		}
		
		override public function decorate():void
		{
			update_color();
			super.decorate(); 
		}
		
		private function update_color():void
		{
			if (_is_selected)
				color = _link_color_selected;
			else if (_over)
				color = _link_color_over;
			else
				color = _link_color_normal;
			
			if (_is_selected || _over)
				_label.thickness = _link_thickness_over;
			else
				_label.thickness = _link_thickness_normal;
		}
		
		protected function on_mouse_over(e:MouseEvent):void
		{
			_over = true;
			update_color();
			super.decorate(); 
		}
		
		protected function on_mouse_out(e:MouseEvent):void
		{
			_over = false;
			update_color();
			super.decorate(); 
		}
		
	}
}
package com.pagesociety.ux.component.container
{
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.decorator.Decorator;
	import com.pagesociety.ux.decorator.MaskedDecorator;
	import com.pagesociety.ux.decorator.ScrollBarDecorator;
	import com.pagesociety.ux.decorator.ScrollingDecorator;
	
	import flash.events.MouseEvent;
	
	public class ScrollingContainer extends Container
	{
		public static var HORIZONTAL:uint = 0;
		public static var VERTICAL:uint = 1;
		public static var BOTH:uint = 2;
		
		private var _type:uint;
		private var _content_width:Number;
		private var _content_height:Number;
		private var _use_mask:Boolean = true;
		
		public function ScrollingContainer(parent:Container,d:Decorator=null,index:int=-1)
		{
			super(parent, index);
			if (d == null)
			{
				var sbd:ScrollBarDecorator = new ScrollBarDecorator(ScrollingDecorator.SCROLL_TYPE_VALUE_BOTH);
				sbd.addEventListener(MouseEvent.MOUSE_WHEEL, sbd.do_mouse_wheel);
				decorator = sbd;
			}
			else
				decorator = d;
			styleName = "ScrollingContainer";
		}
		
		public function get scrollingDecorator():ScrollingDecorator
		{
			return ScrollingDecorator(decorator);
		}
		
		public function updateContentHeight():void
		{
			if (layout!=null)
			{
				contentHeight = layout.calculateHeight();
			}
		}
		
		public function setScrollOffset(v:Number,h:Number=-1):void
		{
			if (h==-1)
				h=v;
			scrollingDecorator.setScrollOffset(h,v);
		}
		
		public function setScrollVertical(v:Number):void
		{
			scrollingDecorator.setScrollVertical(v);
		}
		
		public function getScrollVertical():Number
		{
			return scrollingDecorator.getScrollVertical();
		}
		
		public function setScrollHorizontal(h:Number):void
		{
			scrollingDecorator.setScrollHorizontal(h);
		}
		
		public function getScrollHorizontal():Number
		{
			
			return scrollingDecorator.getScrollHorizontal();
		}


		public function set contentWidth(w:Number):void
		{
			_content_width = w;
			scrollingDecorator.contentWidth = w;
		}
		
		public function set contentHeight(h:Number):void
		{
			_content_height = h;
			scrollingDecorator.contentHeight = h;
		}
		
		public function get contentWidth():Number
		{
			return _content_width;
		}

		public function get contentHeight():Number
		{
			return _content_height;
		}
		
		public function set useMask(b:Boolean):void
		{
			_use_mask = b;
		}
		
		public function get useMask():Boolean
		{
			return _use_mask;
		}
		
		override public function render():void
		{
			if (decorator is MaskedDecorator)
				MaskedDecorator(decorator).useMask = _use_mask;
			if (decorator is ScrollingDecorator)
				updateContentHeight();
			super.render();
		}
		
	}
}
package com.pagesociety.ux.component.container
{
	import com.pagesociety.ux.Margin;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.decorator.ScrollBarDecorator;
	import com.pagesociety.ux.decorator.ScrollingDecorator;
	import com.pagesociety.ux.layout.FlowLayout;
	
	public class TwoColumnContainer extends Container
	{
		protected var _left_col:ScrollingContainer;
		protected var _right_col:ScrollingContainer;
		
		public function TwoColumnContainer(parent:Container, index:Number=-1)
		{
			super(parent, index);
			
			layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT, { margin: new Margin(0,10,0,0) } ); 
			
			_left_col = new ScrollingContainer(this);
			_left_col.layout = new FlowLayout(FlowLayout.TOP_TO_BOTTOM, { margin: new Margin(0,0,10,10) } ); 
			_left_col.decorator = new ScrollBarDecorator(ScrollingDecorator.SCROLL_TYPE_VALUE_VERTICAL);
			
			_right_col = new ScrollingContainer(this); 
			_right_col.layout = new FlowLayout(FlowLayout.TOP_TO_BOTTOM, { margin: new Margin(0,0,10,10) } ); 
			_right_col.decorator = new ScrollBarDecorator(ScrollingDecorator.SCROLL_TYPE_VALUE_VERTICAL);
		}
		
		public function get leftColumn():ScrollingContainer
		{
			return _left_col;
		}
		
		public function get rightColumn():ScrollingContainer
		{
			return _right_col;
		}
		
	}
}
package com.pagesociety.ux.decorator
{
	public interface IScrollingDecorator
	{
	
		function setScrollOffset(h:Number,v:Number):void;

		function scrollsVertically():Boolean;
		function setScrollVertical(y:Number):void;
		function getScrollVertical():Number;
		function isDisplayingVertical(y:Number):Boolean;
		
		function scrollsHorizontally():Boolean;
		function setScrollHorizontal(x:Number):void;
		function getScrollHorizontal():Number;
		function isDisplayingHorizontal(y:Number):Boolean;
	}
}
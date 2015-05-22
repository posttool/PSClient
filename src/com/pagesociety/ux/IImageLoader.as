package com.pagesociety.ux
{
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Image;
	
	public interface IImageLoader
	{
		function set value(a:Array):void;
		function loadImage(img:Image):void
		function get selectionIndex():uint;
		function set selectionIndex(i:uint):void;
		function get selectedComponent():Component;
	}
}
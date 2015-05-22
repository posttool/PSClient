package com.pagesociety.ux.layout
{
	import com.pagesociety.ux.Margin;
	import com.pagesociety.ux.component.Container;
	
	public interface Layout
	{
		function set container(c:Container):void;
		function get container():Container;
		function layout():void;
		function calculateHeight():Number;
		function calculateWidth():Number;
		function calculateIndex(x:Number,y:Number):uint;
		function get margin():Margin;
		function get x():Number;
		function get y():Number;
	}
}
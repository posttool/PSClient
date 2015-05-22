package com.pagesociety.ux
{
	import flash.events.KeyboardEvent;
	
	public interface IKeyListener
	{
		function onKeyPress(e:KeyboardEvent):void;
		function onKeyRelease(e:KeyboardEvent):void;
	}
}
package com.pagesociety.ux.event
{
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.container.Browser;
	
	import flash.events.Event;

	public class BrowserEvent extends ComponentEvent
	{
		public static var SINGLE_CLICK:String = "browser_item_single_click";
		public static var DOUBLE_CLICK:String = "browser_item_double_click";
		public static var DRAGGING:String = "browser_dragging";
		
		public static var REMOVE:String = "browser_item_remove";
		public static var ADD:String = "browser_item_add";
		public static var REORDER:String = "browser_item_reorder";
		
		public static var SELECT:String = "select";
		
		private var _target:Component;
		private var _new_index:int;
		
		public function BrowserEvent(type:String, browser:Component, target:Component, new_index:int=-1)
		{
			super(type, browser);
			_target = target;
			_new_index = new_index;
		}
		
		public function get browser():Browser
		{
			return component as Browser;
		}
		
		public function get changeType():String
		{
			return type;
		}
		
		public function get changeTarget():Component
		{
			return _target;
		}
		
		public function get changeIndex():uint
		{
			return _new_index;
		}
		
		override public function clone():Event
		{
			return new BrowserEvent(type,component as Browser,_target,_new_index);
		}
		
	}
}
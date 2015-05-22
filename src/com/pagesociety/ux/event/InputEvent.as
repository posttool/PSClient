package com.pagesociety.ux.event
{
	import com.pagesociety.ux.IComponent;
	import com.pagesociety.ux.component.Component;
	
	import flash.events.Event;

	public class InputEvent extends ComponentEvent
	{
		public static var SUBMIT:String 					= "input_submit";
		public static var PRESS_ENTER_KEY:String 			= "press_enter_key";
		public static var LOSE_FOCUS_WHILE_DIRTY:String 	= "lose_focus_while_dirty";
		public static var FOCUS:String 						= "focus";
		public static var LOSE_FOCUS:String 				= "lose_focus";
		
		public function InputEvent(type:String, component:Component=null, data:*=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, component, data, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new InputEvent(type,component,data,bubbles,cancelable);
		}
		
	}
}
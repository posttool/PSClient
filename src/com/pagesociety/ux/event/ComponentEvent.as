package com.pagesociety.ux.event
{
    import com.pagesociety.ux.component.Component;
    
    import flash.events.Event;


    public class ComponentEvent extends Event
    {
        public static var CHANGE_VALUE  :String = "change_value";
        public static var CHANGE_SIZE   :String = "change_size";
        //
        public static var OK            :String = "ok";
        public static var READY         :String = "ready";
        public static var CANCEL        :String = "cancel";
        public static var BACK          :String = "back";
        public static var PREVIOUS      :String = "previous";
        public static var NEXT          :String = "next";
        public static var LINK          :String = "link";
        //
        public static var CLICK         :String = "click";
        public static var DOUBLE_CLICK  :String = "double_click";
        public static var MOUSE_OVER    :String = "mouse_over";
        public static var MOUSE_OUT     :String = "mouse_out";
        public static var MOUSE_MOVE    :String = "mouse_move";
        public static var ROLL_OVER     :String = "roll_over";
        public static var ROLL_OUT      :String = "roll_out";
        public static var MOUSE_DOWN    :String = "mouse_down";
        public static var MOUSE_RELEASE :String = "mouse_release";
        public static var DRAG          :String = "drag";
        public static var DRAG_START    :String = "drag_start";
        public static var DRAG_STOP     :String = "drag_stop";

        

        public var component:Component;
        public var data:*;
        
        public function ComponentEvent(type:String, component:Component=null, data:*=null, bubbles:Boolean=true, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            this.component = component;
            this.data = data;
        }
        
        override public function clone():Event
        {
            return new ComponentEvent(type,component,data,bubbles,cancelable);
        }
        
    }
}
package com.pagesociety.ux.event
{
    import com.pagesociety.ux.component.Component;
    
    import flash.events.Event;
    
    public class FocusEvent extends Event
    {
        public static var FOCUS:String          = "focus";
        public static var UNFOCUS:String        = "unfocus";
        public static var FOCUS_CHILD:String    = "focus_child";
        public static var UNFOCUS_CHILD:String  = "unfocus_child";
        
        private var _component:Component;
        public function FocusEvent(type:String, component:Component=null,bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            _component = component;
        }
        public function get component():Component
        {
            return _component;
        }
    }
}
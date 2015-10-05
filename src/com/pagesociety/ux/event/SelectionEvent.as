package com.pagesociety.ux.event
{
    import com.pagesociety.ux.component.Component;
    
    public class SelectionEvent extends ComponentEvent
    {
        public static var SELECT:String = "select";
        
        private var _data:Object;
        public function SelectionEvent(type:String, component:Component, data:Object, bubbles:Boolean=true, cancelable:Boolean=false)
        {
            super(type, component, data, bubbles, cancelable);
        }
        
    }
}
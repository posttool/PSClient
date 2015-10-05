package com.pagesociety.ux.event
{
    import com.pagesociety.ux.component.Component;

    public class ResourceEvent extends ComponentEvent
    {
        public static var LOAD_RESOURCES:String = "load_resources";
        public static var LOAD_RESOURCE:String = "load_resource";
        public static var LOAD_ERROR:String = "load_error";
        public static var LOAD_PROGRESS:String = "load_progress";
        
        public function ResourceEvent(type:String, component:Component, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, component, bubbles, cancelable);
        }
        
    }
}
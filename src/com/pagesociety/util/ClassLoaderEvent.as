package com.pagesociety.util
{
    import flash.events.Event;

    public class ClassLoaderEvent extends Event
    {
        public static var CLASS_LOADED:String = "class_loaded";
        public static var LOAD_ERROR:String = "load_error";
        public static var PROGRESS:String = "progress";
        private var _loader:LibraryLoader;
        public function ClassLoaderEvent(type:String, c:LibraryLoader)
        {
            super(type);
            _loader = c;
        }
        public function get loader():LibraryLoader
        {
            return _loader;
        }
        
    }
}
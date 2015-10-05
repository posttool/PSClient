package com.pagesociety.util
{
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.errors.IllegalOperationError;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.system.SecurityDomain;
    
    public class LibraryLoader extends EventDispatcher 
    {
        public static const LOAD_STATE_INIT:uint = 0;
        public static const LOAD_STATE_LOADING:uint = 1;
        public static const LOAD_STATE_LOADED:uint = 2;
        public static const LOAD_STATE_UNLOADED:uint = 3;
        public static const LOAD_STATE_ERROR:uint = 4;
        
        private var _load_state:uint;
        private var _loader:Loader;
        private var _url:String;
        private var _request:URLRequest;
//      private var _on_complete:Function;
        private var _load_progress:Number;
    
        public function LibraryLoader(url:String) 
        {
            _url = url;
//          _on_complete = on_complete;
            _load_state = LOAD_STATE_INIT;
            _load_progress = 0;
            _loader = new Loader();
            _loader.contentLoaderInfo.addEventListener(Event.INIT,completeHandler); 
            _loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressHandler); 
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
            _loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
        }
        
        public function get url():String
        {
            return _url;
        }
        
        public function get loaded():Boolean
        {
            return _load_state == LOAD_STATE_LOADED;
        }
        
        // returns 0-1 (1=loaded)
        public function get loadProgress():Number
        {
            return _load_progress;
        }
    
        public function load(use_same_security_domain:Boolean,dont_cache:Boolean):void 
        {
            if (_load_state!=LOAD_STATE_INIT)
                throw new Error("ClassLoader.unload Error - can't load with [load_state="+_load_state+"]");
            _load_state = LOAD_STATE_LOADING;
            var url:String = dont_cache ? add_junk_to_url_so_flash_doesnt_cache_incorrectly(_url) : _url;
            _request = new URLRequest(url);
            var context:LoaderContext = new LoaderContext();
            context.applicationDomain = ApplicationDomain.currentDomain; 
            if (use_same_security_domain)
                context.securityDomain = SecurityDomain.currentDomain;
            _loader.load(_request,context);
        }
        
        private function add_junk_to_url_so_flash_doesnt_cache_incorrectly(s:String):String
        {
            var t:Number = new Date().time;
            if (s.indexOf("?")==-1)
                s += "?";
            else 
                s+= "&";
            s += "___dhs87="+t;
            return s;
        }
        
        public function unload():void
        {
            if (_load_state!=LOAD_STATE_LOADED)
                throw new Error("ClassLoader.unload Error - can't unload with [load_state="+_load_state+"]");
            _url = null;
            try {
                content.parent.removeChild(content);
                _loader = null;
            } 
            catch (e:Error)
            {
                Logger.error("Bootstrap.unload error: "+e.message);
            }
            _load_state = LOAD_STATE_UNLOADED;
        }
    
        public function getClass(className:String):Class 
        {
            if (_load_state!=LOAD_STATE_LOADED)
                throw new Error("ClassLoader.getClass Error - resource not loaded [load_state="+_load_state+"]");
            try {
                return _loader.contentLoaderInfo.applicationDomain.getDefinition(className)  as  Class;
            } catch (e:Error) {
                throw new IllegalOperationError(className + " definition not found in " + _url);
            }
           
            return null;
        }
        
        public function get content():DisplayObject
        {
            return _loader.content;
        }

        private function completeHandler(e:Event):void 
        {
            _load_state = LOAD_STATE_LOADED;
//          if (_on_complete != null)
//              _on_complete(this);
            dispatchEvent(new ClassLoaderEvent(ClassLoaderEvent.CLASS_LOADED, this));
        }
    
        private function ioErrorHandler(e:Event):void 
        {
            _load_state = LOAD_STATE_ERROR;
            dispatchEvent(new ClassLoaderEvent(ClassLoaderEvent.LOAD_ERROR, this));
        }
    
        private function securityErrorHandler(e:Event):void 
        {
            _load_state = LOAD_STATE_ERROR;
            dispatchEvent(new ClassLoaderEvent(ClassLoaderEvent.LOAD_ERROR, this));
        }
        
        private function progressHandler(e:ProgressEvent):void 
        {
            _load_progress = e.bytesLoaded/e.bytesTotal;
            dispatchEvent(new ClassLoaderEvent(ClassLoaderEvent.PROGRESS, this));
        }
    }
}
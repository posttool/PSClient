package com.pagesociety.ux.system
{
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.util.ObjectUtil;
    import com.pagesociety.ux.Application;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.web.ModuleRequest;
    import com.pagesociety.web.ResourceUtil;
    import com.pagesociety.web.amf.AmfLong;
    import com.pixelbreaker.ui.osx.MacMouseWheel;
    
    import flash.events.Event;

    public class SystemApplication extends Application implements ISystemApplication
    {
        
        protected var _style_sheet_path:String;

        protected var _domain:String; 
        protected var _user_id:AmfLong;
        protected var _user_name:String;
        protected var _selected_entity_node_id:uint;
        protected var _selected_entity_resource_index:uint;

        protected var _data:Entity;
        protected var _system_properties:Object;

        protected var _system:ISystem;
        protected var _hosted:Boolean;
        protected var _debug:Boolean;
        
        public function SystemApplication(style:String, debug:Boolean)
        {
            super();
            _style_sheet_path = style;
            _debug = debug;
            ResourceUtil.DEBUG = _debug;
        }
        
        public function getSelectedEntityNodeId():uint { return _system.selectedNode.id.longValue; }
        
        public function getSelectedImageIndex():uint { return _system.selectedIndex; }
        
        /*abstract*/ 
        public function getPresets():Array { return [{}] }
        
        /*abstract*/ 
        public function getSystemPropertyDescriptors():SystemStyleProps { throw new Error("SystemApplication.getSystemPropertyDescriptors is abstract. override!"); }
        
        /*abstract*/ 
        public function getRequiredFontLibraries():Array { return [] }

        /*abstract*/ 
        public function getSuggestedFontLibraries():Array { return [] }
        
        /*abstract*/ 
        public function createSystem(p:Container):ISystem { return null; }
        
        // init sequence 1
        //   store params passed by the web browser
        public function initBootstrap(params:Object=null):void
        {
            init(params);
            if (_style_sheet_path==null)
                on_init_bootstrap_2();
            else
                loadStyle(_style_sheet_path, on_init_bootstrap_2);
        }
        
        private function on_init_bootstrap_2():void
        {
            getPublicData();
        }
        
        public function initHosted(params:Object, on_complete:Function):void
        {
            init(params);
            loadStyle(_style_sheet_path, on_complete);
        }
       
       override public function init(params:Object=null):void
       {
           ObjectUtil.registerDefaultEntities();
           MacMouseWheel.setup( stage );
            //trace("SystemApplication.init");
            ModuleRequest.SERVICE_URL   = params.moduleRootUrl;
            if (params.p!=null)
                _user_id = new AmfLong( Number(params.p) ); // NOTE: param name "p" is obfuscated because it will appear in the html...
            if (params.d!=null)
                _domain = params.d; 
            if (params.n!=null)
                _selected_entity_node_id = Number(params.n) ;
            if (params.un!=null)
                _user_name = params.un ;
            // NOTE: the system application does not call super.init
            // it expects the host to call initComplete
       }
     
        // init sequence 2
        //    provide the complete tree and selected entity id
        public function initData(data:Entity=null, selected_entity_node_id:uint=0, index:uint=0, hosted:Boolean=false):void
        {
            trace("SystemApplication.initData");
            _hosted = hosted;
                
            _selected_entity_node_id = selected_entity_node_id;
            _selected_entity_resource_index = index;

            if (!hosted && !_debug)
            {
                getPublicData();
                return;
            }
            
            if (_debug)
                data = create_debug_tree();
                
            _data = data;
            if (_system==null)
            {
                initRootContainer();
            }
            else
            {
                do_init_system_with_data();
            }
        }
        
        // init sequence 3
        // initComplete must be called by client
        // the application is still not ready... until initRootContainer is called
        
        // init sequence end (triggered by initComplete)
        override public function initRootContainer():void 
        {
            trace("SystemApplication.initRootContainer");
            super.initRootContainer();
            if (stage!=null && _hosted)
            {
                stage.removeEventListener(Event.RESIZE, do_resize);
            }
            _system = createSystem(container);
            init_system_with_data();
        }
        
        // try to 
        protected function init_system_with_data():void
        {
            if (_hosted)
            {
                do_init_system_with_data();
                return;
            }
            if (_system == null || _data==null)
                return;
            _bootstrap.loadFonts(getRequiredFontLibraries(),do_init_system_with_data);
        }
        
        
        private function do_init_system_with_data(c:*=null):void
        {
            if (_system == null || _data==null)
                return;
                
            if (_system_properties == null)
                _system_properties = getPresets()[0];

            _system.init(_data, _selected_entity_node_id, 0);
            apply_properties();
            _system.initEnd();
            _system.render();
        }
        
        private function apply_properties():void
        {
            try 
            {
                _system.systemProperties = _system_properties;
            }
            catch (e:Error)
            {
                Logger.error("ERROR Setting system properties: "+e.message);
                _system_properties = getPresets()[0];
                if (_system_properties==null)
                    _system_properties = [];
                _system.systemProperties = _system_properties;
            }
        }
        
        // responsible for getting site props & tree, then loading required fonts, then calling initRootContainer & init_system_with_data
        public function getPublicData():void
        {
            throw new Error("OVERLOAD ME!");
        }
        

        
        public function setSystemPropertyValues(props:Object):void
        {
            _system_properties = props;
            if (_system != null)
            {
                _system.systemProperties = props;
                _system.render();
            }
        }
        
        public function getSystemPropertyValues():Object
        {
            return _system_properties;
        }
        
//      public function getSystemPropertyValue(name:String):Object
//      {
//          var a:Array = getSystemPropertyDescriptors();
//          if (a==null)
//              return null;
//          for (var i:uint=0; i<a.length; i++)
//          {
//              if (a[i].name ==name)
//                  return a[i];
//          }
//          return null;
//      }
        
        
        
        protected function create_debug_tree():Entity
        {
            throw new Error("SystemApplication error - override abstract function create_debug_tree");
        }
        
        
        // graphic...
        override public function get height():Number
        {
            if (_hosted && !_container.isHeightUnset)
                return _container.height;
            return stage.stageHeight;
        }
        
        override public function get width():Number
        {
            if (_hosted && !_container.isWidthUnset)
                return _container.width;            
            return stage.stageWidth;
        }
        //TODO ALL SIZE SETTERS ARE BROKEN EXCEPT FOR THE FOLLOWING 2 
        // special consideration must be made for the application
        override public function set height(h:Number):void
        {
            if (_container!=null)
                _container.height = h;
        }
        
        override public function set width(w:Number):void
        {
            if (_container!=null)
                _container.width = w;
        }
        
    }
}
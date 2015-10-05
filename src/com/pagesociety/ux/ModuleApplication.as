package com.pagesociety.ux
{
    import com.pagesociety.util.BootstrapImpl;
    import com.pagesociety.util.ClassLoaderEvent;
    import com.pagesociety.web.ResourceUtil;
    import com.pagesociety.web.ModuleRequest;
    import com.pagesociety.web.module.ApplicationModule;
    
    public class ModuleApplication extends Application
    {
        protected var _page_params:Object;
        protected var _app_params:Object;
        protected var _style_sheet_url:String;
        protected var _fonts:Array;

        public function ModuleApplication()
        {
            super();
        }
        
        public function initModuleApplication(params:Object,style_sheet:String,fonts:Array):void
        {
            _page_params = params;
            _style_sheet_url = style_sheet;
            _fonts = fonts;
            
            if (_page_params.moduleRootUrl==null)
                throw new Error("MISSING PARAM moduleRootUrl");
            ModuleRequest.SERVICE_URL = _page_params.moduleRootUrl;
            
            ApplicationModule.GetApplicationInitParams(on_got_init_params);
        }
        
        private function on_got_init_params(params:Object):void
        {
            _app_params = params;
            ApplicationModule.GetAppResourceInfo(on_got_resource_info);
        }
        
        
        public function get appInitParams():Object
        {
            return _app_params;
        }
        
        private function on_got_resource_info(resource_info:Array):void
        {
            ResourceUtil.init(resource_info);
            loadStyle(_style_sheet_url, on_init1);
        }
        
        private function on_init1():void
        {
//          loadRemoteFonts(_fonts, on_init2);
            loadFonts(_fonts, on_init2);
        }
        
        private function on_init2(e:*):void
        {   
            super.init(_page_params);
        }
    }
}
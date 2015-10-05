package com.pagesociety.ux.system
{
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.ux.IApplication;

    public interface ISystemApplication extends IApplication
    {
        function getSystemPropertyDescriptors():SystemStyleProps; 
        function setSystemPropertyValues(properties:Object):void;
        function getPresets():Array;
        function initBootstrap(params:Object=null):void;
        function initHosted(params:Object,on_complete:Function):void;
        function initData(site_map:Entity=null, selected_id:uint=0, index:uint=0, hosted:Boolean=false):void;
        function initRootContainer():void;
        function getSelectedEntityNodeId():uint;
        function getSelectedImageIndex():uint;
        function getRequiredFontLibraries():Array;
        function getSuggestedFontLibraries():Array;
    }
}
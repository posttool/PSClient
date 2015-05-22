package com.pagesociety.web.module
{
	import com.pagesociety.web.ModuleConnection;
	
	public class ApplicationModule extends ModuleConnection
	{
	
		public static const MODULE_NAME:String = "ApplicationInfoModule";
	
	
		// GetAppResourceInfo returns List<Map<String,Object>> 
		// throws WebApplicationException
		public static var METHOD_GETAPPRESOURCEINFO:String = MODULE_NAME + "/GetAppResourceInfo";
		public static function GetAppResourceInfo(on_complete:Function, on_error:Function=null):void
		{
			doModule(METHOD_GETAPPRESOURCEINFO, [], on_complete, on_error);		
		}
		
		// GetApplicationInitParams returns Map<String,Object> 
		// throws WebApplicationException
		public static var METHOD_GETAPPLICATIONINITPARAMS:String = MODULE_NAME + "/GetApplicationInitParams";
		public static function GetApplicationInitParams(on_complete:Function, on_error:Function=null):void
		{
			doModule(METHOD_GETAPPLICATIONINITPARAMS, [], on_complete, on_error);		
		}
		
	}

}
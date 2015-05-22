package com.pagesociety.ux
{
	import com.pagesociety.web.ModuleRequest; 

	public interface INetworkEventHandler
	{
		function timeout():void;
		function beginModuleRequest(r:ModuleRequest):void;
		function endModuleRequest(r:ModuleRequest,status:uint,arg:Object):void; /*arg is the object returned from the ok module request or the exception object */
	}
}
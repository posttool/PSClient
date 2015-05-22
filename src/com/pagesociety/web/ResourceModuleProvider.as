package com.pagesociety.web
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.web.amf.AmfLong;
	import com.pagesociety.web.module.User;
	
	public class ResourceModuleProvider
	{
		private var _module_name:String;
		private var _type:String;
		private var _path_provider:PathProvider;
		
		public function ResourceModuleProvider(module_name:String, type:String, root_url:String)
		{
			_module_name = module_name;
			_type = type;
			if (root_url!=null)
				_path_provider = new PathProvider(root_url);
		}
		
		public function CreateResource():String 		{ return _module_name+"/CreateResource"; }
		public function DeleteResource():String 		{ return _module_name+"/DeleteResource"; }
		public function UpdateResource():String 		{ return _module_name+"/UpdateResource"; }
		public function CancelUpload():String 			{ return _module_name+"/CancelUpload"; }
		public function GetResourceUrl():String 		{ return _module_name+"/GetResourceURL"; }
		public function GetResourcePreviewUrl():String 		{ return _module_name+"/GetResourcePreviewURL"; }
		public function GetResourceUrlWithDim():String 	{ return _module_name+"/GetResourcePreviewURLWithDim"; }
		public function GetUploadProgress():String 		{ return _module_name+"/GetUploadProgress"; }
		public function GetSessionId():String 			{ return User.METHOD_GETSESSIONID; }
		
		public function getResourceUrl(id:AmfLong, on_complete:Function, on_error:Function):void
		{
			ModuleConnection.doModule(GetResourceUrl(), [id], on_complete, on_error, true);
		}
		
		public function getResourcePreviewUrl(id:AmfLong, options:Object, on_complete:Function, on_error:Function):void
		{
			ModuleConnection.doModule(GetResourcePreviewUrl(), [id,string_only(options)], on_complete, on_error, true);
		}
		
		private function string_only(o:Object):Object
		{
			var r:Object = {};
			for (var p:String in o)
				r[p] = o[p].toString();
			return r;
		}
		
		public function getPath(resource:Entity, options:Object):String
		{
			if (_path_provider==null)
				throw new Error("NO PATH PROVIDER DEFINED FOR "+resource);
			return _path_provider.getPath(resource,options);
		}
	}
}
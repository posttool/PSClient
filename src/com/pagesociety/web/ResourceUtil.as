package com.pagesociety.web
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.persistence.FieldDefinition;
	
	public class ResourceUtil
	{
		public static var DEBUG:Boolean = false;
		private static var RESOURCE_MAP:Object;
		
		/**
		 * requires a list of these {resource_module_name: '', resource_entity_name: '', resource_base_url: ''}
		 */
		public static function init(data:Array):void
		{
			if (RESOURCE_MAP!=null)
			{
				Logger.log("Resource Map has already been initialized...");
				return;
			}
			RESOURCE_MAP = {};
			for (var i:uint=0; i<data.length; i++)
			{
				var info:Object 			= data[i];
				var module_name:String 		= info.resource_module_name;
				var entity_type:String 		= info.resource_entity_name;
				var base_url:String 		= info.resource_base_url;
				if (RESOURCE_MAP[entity_type]!=null)
					throw new Error("ResourceUtil.init ERROR: Registering entity "+entity_type+" again.");
				RESOURCE_MAP[entity_type] 	= new ResourceModuleProvider(module_name, entity_type, base_url);
				Logger.log("Registered ResourceModule "+entity_type+" "+base_url);
			}
		}

		public static function isResource(field:FieldDefinition):Boolean
		{
			return RESOURCE_MAP[field.referenceType]!=null;
		}
		
		public static function getModuleProvider(o:Object):ResourceModuleProvider
		{
			var type:String;
			if (o is String)
				type = o as String;
			else if (o is FieldDefinition)
				type = (o as FieldDefinition).referenceType;
			else
				throw new Error("CANT getModuleProvider for "+o);
			return RESOURCE_MAP[type];
		}
		
		public static function getPath(resource:Entity, options:Object=null):String
		{
			if (RESOURCE_MAP==null)
				throw new Error("ResourceUtil.RESOURCE_MAP is not configured");
			var resource_module:ResourceModuleProvider = RESOURCE_MAP[resource.type];
			if (resource_module==null)
				throw new Error("ResourceUtil.RESOURCE_MAP does not contain "+resource.type);
			return resource_module.getPath(resource, options);
		}
		
		public static function getUrl(resource:Entity, on_complete:Function):void
		{
			if (resource==null)
			{
				on_complete(null);
			}
			else if (DEBUG)
			{
				on_complete(resource);
			}
			else
			{
				if (RESOURCE_MAP==null)
					throw new Error("ResourceUtil.RESOURCE_MAP is not configured");
				var resource_module:ResourceModuleProvider = RESOURCE_MAP[resource.type];
				if (resource_module==null)
					throw new Error("ResourceUtil.RESOURCE_MAP does not contain "+resource.type);
				resource_module.getResourceUrl(resource.id, on_complete, function(e:Object):void{ trace("ERROR"); });
			}
		}
		
		public static function getPreviewUrl(resource:Entity, options:Object, on_complete:Function):void
		{
			if (resource==null)
			{
				on_complete(null);
			}
//			else if (DEBUG)
//			{
//				new LoadAndSize(resource.$.resource, w, h, on_complete);
//			}
			else
			{
				if (RESOURCE_MAP==null)
					throw new Error("ResourceUtil.RESOURCE_MAP is not configured");
				var resource_module:ResourceModuleProvider = RESOURCE_MAP[resource.type];
				if (resource_module==null)
					throw new Error("ResourceUtil.RESOURCE_MAP does not contain "+resource.type);
				resource_module.getResourcePreviewUrl(resource.id, options, on_complete, function(e:Object):void{ trace("ERROR"); });
			}
		}
		
		public static function hasResourceModuleProvider(type:String):Boolean
		{
			return RESOURCE_MAP[type] != null;
		}
		
	}
}
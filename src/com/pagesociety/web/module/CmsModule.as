package com.pagesociety.web.module
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.web.ModuleConnection;
	import com.pagesociety.web.amf.AmfLong;
	
	public class CmsModule extends ModuleConnection
	{

		// GetEntityDefinitions returns List 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETENTITYDEFINITIONS:String = "CMS/GetEntityDefinitions";
		public static function GetEntityDefinitions(on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETENTITYDEFINITIONS, [], on_complete, on_error);		
		}

		// GetEntityById returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETENTITYBYID:String = "CMS/GetEntityById";
		public static function GetEntityById(entity_type:String, entity_id:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETENTITYBYID, [entity_type, entity_id], on_complete, on_error);		
		}

		// GetEntityIndices returns List 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETENTITYINDICES:String = "CMS/GetEntityIndices";
		public static function GetEntityIndices1(a1:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETENTITYINDICES, [a1], on_complete, on_error);		
		}
		
		// GetEntityIndices returns List 
		// throws WebApplicationException, PersistenceException
		public static function GetEntityIndices0(on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETENTITYINDICES, [], on_complete, on_error);		
		}

		// CreateEntity returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_CREATEENTITY:String = "CMS/CreateEntity";
		public static function CreateEntity(entity:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CREATEENTITY, [entity], on_complete, on_error);		
		}

		// UpdateEntity returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_UPDATEENTITY:String = "CMS/UpdateEntity";
		public static function UpdateEntity(type:String, id:AmfLong, name_values:Object, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_UPDATEENTITY, [type,id,name_values], on_complete, on_error);		
		}

		// UpdateEntity returns Entity 
		// throws WebApplicationException, PersistenceException
		public static function UpdateEntity0(e:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_UPDATEENTITY, [e], on_complete, on_error);		
		}
		
		// DeleteEntity returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_DELETEENTITY:String = "CMS/DeleteEntity";
		public static function DeleteEntity(entity:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_DELETEENTITY, [entity], on_complete, on_error);		
		}

		// BrowseEntities returns PagingQueryResult 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_BROWSEENTITIES:String = "CMS/BrowseEntities";
		public static function BrowseEntities0(entity_type:String, index_info:Object, order_by_attribute:String, asc:Boolean, offset:int, page_size:int, fill:Boolean, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_BROWSEENTITIES, [entity_type, index_info, order_by_attribute, asc, offset, page_size, fill], on_complete, on_error);		
		}

		// BrowseEntities returns PagingQueryResult 
		// throws WebApplicationException, PersistenceException
		public static function BrowseEntities1(entity_type:String, order_by_attribute:String, asc:Boolean, offset:int, page_size:int, fill:Boolean, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_BROWSEENTITIES, [entity_type, order_by_attribute, asc, offset, page_size, fill], on_complete, on_error);		
		}

	}
}
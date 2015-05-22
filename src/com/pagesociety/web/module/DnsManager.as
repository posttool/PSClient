package com.pagesociety.web.module
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.web.ModuleConnection;
	import com.pagesociety.web.amf.AmfLong;
	
	public class DnsManager extends ModuleConnection
	{
		public static var DOMAIN_ENTITY:String = "Domain";
		public static var DOMAIN_FIELD_ID:String = "id"; 
		public static var DOMAIN_FIELD_CREATOR:String = "creator"; 
		public static var DOMAIN_FIELD_DATE_CREATED:String = "date_created"; 
		public static var DOMAIN_FIELD_LAST_MODIFIED:String = "last_modified"; 
		public static var DOMAIN_FIELD_USER_OBJ:String = "user_obj"; 
		public static var DOMAIN_FIELD_NAME:String = "name"; 
		public static var DOMAIN_FIELD_ALIASES:String = "aliases"; 
		public static var DOMAIN_FIELD_RECORDS:String = "records"; 
		
		public static var DOMAINRECORD_ENTITY:String = "DomainRecord";
		public static var DOMAINRECORD_FIELD_ID:String = "id"; 
		public static var DOMAINRECORD_FIELD_CREATOR:String = "creator"; 
		public static var DOMAINRECORD_FIELD_DATE_CREATED:String = "date_created"; 
		public static var DOMAINRECORD_FIELD_LAST_MODIFIED:String = "last_modified"; 
		public static var DOMAINRECORD_FIELD_DOMAIN:String = "domain"; 
		public static var DOMAINRECORD_FIELD_TYPE:String = "type"; 
		public static var DOMAINRECORD_FIELD_NAME:String = "name"; 
		public static var DOMAINRECORD_FIELD_TARGET:String = "target"; 
		public static var DOMAINRECORD_FIELD_PRIORITY:String = "priority"; 
		public static var DOMAINRECORD_FIELD_WEIGHT:String = "weight"; 
		public static var DOMAINRECORD_FIELD_PORT:String = "port"; 
		public static var DOMAINRECORD_FIELD_PROTOCOL:String = "protocol"; 
		public static var DOMAINRECORD_FIELD_TTL_SEC:String = "ttl_sec"; 

		public static var MODULE_NAME:String = "DnsManager/";

		
		// RemoveCNameRecord returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_REMOVECNAMERECORD:String = MODULE_NAME + "RemoveCNameRecord";
		public static function RemoveCNameRecord(a1:AmfLong, a2:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_REMOVECNAMERECORD, [a1, a2], on_complete, on_error);		
		}
		
		// RemoveCNameRecord returns Entity 
		// throws PersistenceException, WebApplicationException
		public static function RemoveCNameRecord1(a1:Entity, a2:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_REMOVECNAMERECORD, [a1, a2], on_complete, on_error);		
		}
		
		// AddCNameRecord returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_ADDCNAMERECORD:String = MODULE_NAME + "AddCNameRecord";
		public static function AddCNameRecord(a1:Entity, a2:String, a3:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ADDCNAMERECORD, [a1, a2, a3], on_complete, on_error);		
		}
		
		// AddCNameRecord returns Entity 
		// throws PersistenceException, WebApplicationException
		public static function AddCNameRecord1(a1:AmfLong, a2:String, a3:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ADDCNAMERECORD, [a1, a2, a3], on_complete, on_error);		
		}
		
		// AddGoogleMail returns Entity 
		public static var METHOD_ADDGOOGLEMAIL:String = MODULE_NAME + "AddGoogleMail";
		public static function AddGoogleMail(on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ADDGOOGLEMAIL, [], on_complete, on_error);		
		}
		
		// RemoveMXRecord returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_REMOVEMXRECORD:String = MODULE_NAME + "RemoveMXRecord";
		public static function RemoveMXRecord(a1:Entity, a2:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_REMOVEMXRECORD, [a1, a2], on_complete, on_error);		
		}
		
		// RemoveMXRecord returns Entity 
		// throws PersistenceException, WebApplicationException
		public static function RemoveMXRecord1(a1:AmfLong, a2:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_REMOVEMXRECORD, [a1, a2], on_complete, on_error);		
		}
		
		// RemoveARecord returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_REMOVEARECORD:String = MODULE_NAME + "RemoveARecord";
		public static function RemoveARecord(a1:AmfLong, a2:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_REMOVEARECORD, [a1, a2], on_complete, on_error);		
		}
		
		// RemoveARecord returns Entity 
		// throws PersistenceException, WebApplicationException
		public static function RemoveARecord1(a1:Entity, a2:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_REMOVEARECORD, [a1, a2], on_complete, on_error);		
		}
		
		// GetDomains returns List 
		// throws PersistenceException
		public static var METHOD_GETDOMAINS:String = MODULE_NAME + "GetDomains";
		public static function GetDomains(a1:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETDOMAINS, [a1], on_complete, on_error);		
		}
		
		// AddStandardARecords returns Entity 
		public static var METHOD_ADDSTANDARDARECORDS:String = MODULE_NAME + "AddStandardARecords";
		public static function AddStandardARecords(on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ADDSTANDARDARECORDS, [], on_complete, on_error);		
		}
		
		// AddMxRecord returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_ADDMXRECORD:String = MODULE_NAME + "AddMxRecord";
		public static function AddMxRecord(a1:AmfLong, a2:String, a3:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ADDMXRECORD, [a1, a2, a3], on_complete, on_error);		
		}
		
		// AddMxRecord returns Entity 
		// throws PersistenceException, WebApplicationException
		public static function AddMxRecord1(a1:Entity, a2:String, a3:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ADDMXRECORD, [a1, a2, a3], on_complete, on_error);		
		}
		
		// AddAlias returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_ADDALIAS:String = MODULE_NAME + "AddAlias";
		public static function AddAlias(a1:AmfLong, a2:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ADDALIAS, [a1, a2], on_complete, on_error);		
		}
		
		// AddAlias returns Entity 
		// throws WebApplicationException, PersistenceException
		public static function AddAlias1(a1:Entity, a2:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ADDALIAS, [a1, a2], on_complete, on_error);		
		}
		
		// AddDomain returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_ADDDOMAIN:String = MODULE_NAME + "AddDomain";
		public static function AddDomain(a1:Entity, a2:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ADDDOMAIN, [a1, a2], on_complete, on_error);		
		}
		
		// AddDomain returns Entity 
		// throws PersistenceException, WebApplicationException
		public static function AddDomain1(a1:String, a2:AmfLong, a3:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ADDDOMAIN, [a1, a2, a3], on_complete, on_error);		
		}
		
		// DeleteDomain returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_DELETEDOMAIN:String = MODULE_NAME + "DeleteDomain";
		public static function DeleteDomain(a1:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_DELETEDOMAIN, [a1], on_complete, on_error);		
		}
		
		// DeleteDomain returns Entity 
		// throws PersistenceException, WebApplicationException
		public static function DeleteDomain1(a1:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_DELETEDOMAIN, [a1], on_complete, on_error);		
		}
		
		// AddARecord returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_ADDARECORD:String = MODULE_NAME + "AddARecord";
		public static function AddARecord(a1:Entity, a2:String, a3:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ADDARECORD, [a1, a2, a3], on_complete, on_error);		
		}
		
		// AddARecord returns Entity 
		// throws PersistenceException, WebApplicationException
		public static function AddARecord1(a1:AmfLong, a2:String, a3:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ADDARECORD, [a1, a2, a3], on_complete, on_error);		
		}
		
		
		
	}
}
package com.pagesociety.web.module
{
	import com.pagesociety.web.amf.AmfLong;
	import com.pagesociety.web.ModuleConnection;
	
	public class Resource extends ModuleConnection
	{
		public static const MODULE_NAME:String = "Resource";
		
		public static var RESOURCE_ENTITY:String = "Resource";
		public static var RESOURCE_FIELD_ID:String = "id";
		public static var RESOURCE_FIELD_CREATOR:String = "creator";
		public static var RESOURCE_FIELD_DATE_CREATED:String = "date_created";
		public static var RESOURCE_FIELD_LAST_MODIFIED:String = "last_modified";
		public static var RESOURCE_FIELD_CONTENT_TYPE:String = "content-type";
		public static var RESOURCE_FIELD_SIMPLE_TYPE:String = "simple-type";
		public static var RESOURCE_FIELD_FILENAME:String = "filename";
		public static var RESOURCE_FIELD_EXTENSION:String = "extension";
		public static var RESOURCE_FIELD_FILESIZE:String = "filesize";
		public static var RESOURCE_FIELD_PATH_TOKEN:String = "path-token";
		
		
//			public static final int JPG = 0;
//	public static final int GIF = 1;
//	public static final int PNG = 2;
//	public static final int TIFF = 3;
//	public static final int MP3 = 4;
//	public static final int WAV = 5;
//	public static final int AIF = 6;
//	public static final int VOG = 7;
//	public static final int AVI = 8;
//	public static final int MOV = 9;
//	public static final int DIVX = 10;
//	public static final int MPG = 11;
//	public static final int PDF = 12;
//	public static final int DOC = 13;
//	public static final int SWF = 14;
	
	// "simple" types
	public static const SIMPLE_TYPE_IMAGE    :int    = 100;
	public static const SIMPLE_TYPE_AUDIO    :int    = 101;
	public static const SIMPLE_TYPE_VIDEO    :int    = 102;
	public static const SIMPLE_TYPE_DOCUMENT :int    = 103;
	public static const SIMPLE_TYPE_SWF 	 :int    = 104;
	
	public static const SIMPLE_TYPE_IMAGE_STRING     :String    = "IMAGE";
	public static const SIMPLE_TYPE_AUDIO_STRING     :String    = "AUDIO";
	public static const SIMPLE_TYPE_VIDEO_STRING     :String    = "VIDEO";
	public static const SIMPLE_TYPE_DOCUMENT_STRING  :String    = "DOCUMENT";
	public static const SIMPLE_TYPE_SWF_STRING 	 	:String    = "SWF";
		

		// GetResourcePreviewURLWithDim returns String 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETRESOURCEPREVIEWURLWITHDIM:String = MODULE_NAME + "/GetResourcePreviewURLWithDim";
		public static function GetResourcePreviewURLWithDim(resource_id:AmfLong, w:int, h:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETRESOURCEPREVIEWURLWITHDIM, [resource_id, w, h], on_complete, on_error, true);		
		}

		// UpdateResource returns boolean 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_UPDATERESOURCE:String = MODULE_NAME + "/UpdateResource";
//		public static function UpdateResource(upload:MultipartForm, on_complete:Function, on_error:Function):void
//		{
//			doModule(METHOD_UPDATERESOURCE, [upload], on_complete, on_error);		
//		}

		// GetResourceURLs returns List 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETRESOURCEURLS:String = MODULE_NAME + "/GetResourceURLs";
		public static function GetResourceURLs(resource_ids:Array, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETRESOURCEURLS, [resource_ids], on_complete, on_error, true);		
		}

		// GetResourceURL returns String 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETRESOURCEURL:String = MODULE_NAME + "/GetResourceURL";
		public static function GetResourceURL(resource_id:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETRESOURCEURL, [resource_id], on_complete, on_error, true);		
		}

		// GetResource returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETRESOURCE:String = MODULE_NAME + "/GetResource";
		public static function GetResource(resource_id:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETRESOURCE, [resource_id], on_complete, on_error, true);		
		}

		// GetResourcePreviewURLsWithDim returns List 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETRESOURCEPREVIEWURLSWITHDIM:String = MODULE_NAME + "/GetResourcePreviewURLsWithDim";
		public static function GetResourcePreviewURLsWithDim(resource_ids:Array, w:int, h:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETRESOURCEPREVIEWURLSWITHDIM, [resource_ids, w, h], on_complete, on_error, true);		
		}

		// CreateResource returns boolean 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_CREATERESOURCE:String = MODULE_NAME + "/CreateResource";
//		public static function CreateResource(upload:MultipartForm, on_complete:Function, on_error:Function):void
//		{
//			doModule(METHOD_CREATERESOURCE, [upload], on_complete, on_error);		
//		}

		// CancelUpload returns List 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_CANCELUPLOAD:String = MODULE_NAME + "/CancelUpload";
		public static function CancelUpload(channel_name:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CANCELUPLOAD, [channel_name], on_complete, on_error);		
		}

		// GetUploadProgress returns List 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_GETUPLOADPROGRESS:String = MODULE_NAME + "/GetUploadProgress";
		public static function GetUploadProgress(channel_name:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETUPLOADPROGRESS, [channel_name], on_complete, on_error, true);		
		}

		// DeleteResource returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_DELETERESOURCE:String = MODULE_NAME + "/DeleteResource";
		public static function DeleteResource(resource_id:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_DELETERESOURCE, [resource_id], on_complete, on_error);		
		}
		


	}
}
package com.pagesociety.web.upload
{
	import com.pagesociety.web.ResourceModuleProvider;
	import com.pagesociety.web.ModuleRequest;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	public class MultipartUpload1 extends EventDispatcher
	{
		public static const CHANNEL_NAME:String = "A";
		public static const UPLOAD_DATA_FIELD_NAME:String = "picture";
		
 		private var _module_provider:ResourceModuleProvider;		

       	private var _upload_url:String;
       	private var _upload_variables:URLVariables;
       	
        private var _file_ref_list:FileReferenceList;
        private var _file_refs:Array;
        private var _file_list_index:int;

		private var _progress:Timer;
		private var _waiting_for_upload_progress_info:Boolean;
		
		public static const INIT:uint=0;
		public static const UPLOADING:uint = 1;
		public static const IN_BETWEEN_UPLOADS:uint = 2;
		public static const CANCELING:uint = 3;
		public static const COMPLETE:uint = 4;
		private static const U:Array = ["init","uploading","in btwn", "canceling", "complete"];
		private var _uploading:uint;
		private var _browsable_file_types:Array = MultipartUpload.DEFAULT_TYPES;


		public function MultipartUpload1(module_provider:ResourceModuleProvider, test_exception_in_resource:Boolean=false, test_exception_in_upload:Boolean=false)
		{
			_module_provider = module_provider;
			
			//service url
			var url:String = _module_provider.CreateResource();
			if (url.indexOf("/.form")==-1)
				url = url + "/.form";
			_upload_url = ModuleRequest.SERVICE_URL + url;
			
			//channel name, size, filename, ...
			_upload_variables = new URLVariables();
			_upload_variables.channel = CHANNEL_NAME;
			if (test_exception_in_resource)
				_upload_variables[MultipartUpload.PARAM_THROW_EXCEPTION_IN_ADD_RESOURCE] = "true";
			if (test_exception_in_upload)
				_upload_variables[MultipartUpload.PARAM_THROW_EXCEPTION_IN_PARSE_UPLOAD] = "true";

			//state of loading
            _uploading = INIT;
        	_file_list_index = -1;
        	_file_refs = new Array();
			
        	//
        	_progress = new Timer(1000);
			_progress.addEventListener(TimerEvent.TIMER, on_check_upload_progress);
 		}
 		
 		public function showFileSystemBrowser(browsable_file_types:Array=null):void
 		{
			if (browsable_file_types!=null)
				_browsable_file_types = browsable_file_types;
 			_file_ref_list = new FileReferenceList();
			_file_ref_list.addEventListener(Event.SELECT, on_select);
            _file_ref_list.addEventListener(Event.CANCEL, on_cancel);
            _file_ref_list.browse(_browsable_file_types);
 		}
 		
 		public function get fileReferences():Array
 		{
 			return _file_refs;
 		}
 		
 		public function get loadIndex():uint
 		{
 			return _file_list_index;
 		}
 		
 		public function get uploading():Boolean
 		{
 			return _uploading == UPLOADING || _uploading == IN_BETWEEN_UPLOADS || _uploading == CANCELING;
 		}
 		
		private function on_select(e:Event):void
		{
			for (var i:uint=0; i<_file_ref_list.fileList.length; i++)
				_file_refs.push(_file_ref_list.fileList[i]);
			dispatchEvent(new UploadEvent(UploadEvent.SELECT_FILE,null,null,_file_ref_list.fileList));
			if (!uploading)
			{
				_uploading = IN_BETWEEN_UPLOADS;
				ModuleRequest.doModule(_module_provider.GetSessionId(), [], get_session_id_ok, on_upload_err, true);
			}
		}
		
		private function on_cancel(e:Event):void
		{
			dispatchEvent(new UploadEvent(UploadEvent.DIALOG_CANCELED));
		}
		
		private function get_session_id_ok(id:String):void
		{
			begin_upload(id);
		}
		
        private function begin_upload(session_id:String):void
        {
			var kv:Array = session_id.split("=");
			_upload_variables[kv[0]] = kv[1];
           	_file_list_index = -1;
        	upload_next();
        }
        
        private function upload_next():void
        {
        	if (_uploading==UPLOADING)
        		throw new Error("Can't upload next while upload is in progress!");
        	
        	_uploading = UPLOADING;	
 			_file_list_index++;
	       	
			if (_file_list_index>=_file_refs.length)
			{
				_file_refs = new Array();
				_uploading = COMPLETE;
				return;
			}
			var _file:FileReference = _file_refs[_file_list_index];
			add_io_listeners(_file);
			
			_upload_variables.size = _file.size;
			
			_file.upload(get_upload_url(), UPLOAD_DATA_FIELD_NAME);
			dispatchEvent(new UploadEvent(UploadEvent.BEGIN_UPLOAD));
        	_progress.start();
        }
		
		private function get_upload_url():URLRequest
		{
			var u:URLRequest = new URLRequest(_upload_url);
			u.data = _upload_variables;
			return u;
		}
        
        
		private function on_check_upload_progress(e:TimerEvent):void
		{
			if (_waiting_for_upload_progress_info)
				return;
			_waiting_for_upload_progress_info = true;
			ModuleRequest.doModule(_module_provider.GetUploadProgress(), [CHANNEL_NAME], on_upload_progress_info_ok, on_upload_err, true);
		}
		
        private function on_upload_progress_info_ok(upload:UploadProgressInfo):void
		{
			_waiting_for_upload_progress_info = false;
			if (_uploading!=UPLOADING)
				return;
			if (upload==null)
				return;
			if (upload.completionObject != null)
			{
				_progress.stop();
				_uploading = IN_BETWEEN_UPLOADS;
			}
			dispatchEvent(new UploadEvent(UploadEvent.UPLOAD_PROGRESS,null,upload));
			if (upload.completionObject != null)
			{
				upload_next();
			}
		}
		
		public function cancelAll():void
		{
			_progress.stop();
			_file_refs = [];
			cancel_current_upload();
		}
        
        public function cancel(ref:Object):void
        {
        	//TODO  lock
        	var f:int = -1;
        	
        	for (var i:uint=0; i<_file_refs.length; i++)
        	{
        		if (ref==_file_refs[i])
        		{
        			f = i;
        			break;
        		}
        	}
        	if (f==-1)
        		return;
        	if (_file_list_index==f)
        	{
				cancel_current_upload();
        	}
        	else
        	{
        		_file_refs.splice(f,1);
        	}
	        
        }
        
        private function cancel_current_upload():void
        {
        	_uploading = CANCELING;
        	_progress.stop();
        	
        	ModuleRequest.doModule(_module_provider.CancelUpload(), [CHANNEL_NAME], on_cancel_complete, on_cancel_complete);
        }
        
        private function on_cancel_complete(e:*=null):void
        {
        	_uploading = IN_BETWEEN_UPLOADS;
        	upload_next();
        }
        
        // flash stuff
        private function add_io_listeners(dispatcher:IEventDispatcher):void 
        {
//            dispatcher.addEventListener(Event.OPEN, openHandler);
//            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
//            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
//            dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,uploadCompleteDataHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        }
        
        private function on_upload_err(e:*):void
        {
        	_progress.stop();
        	_waiting_for_upload_progress_info = false;
        	_uploading = COMPLETE;
        	Logger.error("UPLOAD ERR: "+e);
        	dispatchEvent(new UploadEvent(UploadEvent.UPLOAD_ERROR,null,null,e));
        }


        private function httpStatusHandler(event:HTTPStatusEvent):void 
        {
            Logger.log("UPLOAD httpStatusHandler: " + event);
        }
        
        private function ioErrorHandler(event:IOErrorEvent):void 
        {
        	_progress.stop();
        	_waiting_for_upload_progress_info = false;
        	_uploading = COMPLETE;
            Logger.log("UPLOAD ioErrorHandler: " + event);
        	dispatchEvent(new UploadEvent(UploadEvent.UPLOAD_ERROR,null,null,event));
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void 
        {
        	_progress.stop();
        	_waiting_for_upload_progress_info = false;
        	_uploading = COMPLETE;
            Logger.log("UPLOAD securityErrorHandler: " + event);
         	dispatchEvent(new UploadEvent(UploadEvent.UPLOAD_ERROR,null,null,event));
       }
	}
}
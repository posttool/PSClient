package com.pagesociety.web.upload
{
	import com.pagesociety.web.ResourceModuleProvider;
	import com.pagesociety.web.ModuleRequest;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	
	/*
TODO!!!!!!!!!!!!!!!!!!!!!
String throw_exception_in_parse_upload = upload.getParameter("throw_exception_in_parse_upload");
String throw_exception_in_add_resource = upload.getParameter("throw_exception_in_add_resource");
	
	*/
	
	/**
	 * MultipartUpload
	 * @see MultipartUpload1
	 */
	public class MultipartUpload extends EventDispatcher
	{
		
		internal static const PARAM_THROW_EXCEPTION_IN_PARSE_UPLOAD:String = "throw_exception_in_parse_upload"; 
		internal static const PARAM_THROW_EXCEPTION_IN_ADD_RESOURCE:String = "throw_exception_in_add_resource";
		
		
		public static const AllTypeFilter		:FileFilter = new FileFilter("All Resource Types", "*.*");
		public static const ImageTypeFilter		:FileFilter = new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
        public static const SwfTypeFilter		:FileFilter = new FileFilter("Flash (*.swf)", "*.swf");
        public static const FlvfTypeFilter		:FileFilter = new FileFilter("Flash Video (*.flv, *.f4v)", "*.flv;*.f4v");
		public static const TextTypeFilter		:FileFilter = new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
		public static const AudioTypeFilter		:FileFilter = new FileFilter("Audio Files (*.mp3, *.wav, *.aif, *.aiff)", "*.mp3;*.wav;*.aiff;*.aif");
		public static const ZipTypeFilter		:FileFilter = new FileFilter("Zip Files (*.zip)", "*.zip");
		
		public static const DEFAULT_TYPES		:Array		= [ImageTypeFilter, SwfTypeFilter, FlvfTypeFilter, AudioTypeFilter];
		
		public static const UPLOAD_DATA_FIELD_NAME:String = "picture";
		
 		private var _module_provider:ResourceModuleProvider;	        
       	private var _upload_req:URLRequest;
       	private var _upload_variables:URLVariables;
        private var _file:FileReference;
        
        private var _progress:Timer;
		private var _waiting_for_upload_progress_info:Boolean;
		
		public static const INIT:uint=0;
		public static const UPLOADING:uint = 1;
		public static const IN_BETWEEN_UPLOADS:uint = 2;
		public static const CANCELING:uint = 3;
		public static const COMPLETE:uint = 4;
		private static const U:Array = ["init","uploading","canceling", "complete"];
		private var _uploading:uint;
		private var _channel:int=0;
		private var _browsable_file_types:Array = DEFAULT_TYPES;


		public function MultipartUpload(module_provider:ResourceModuleProvider, test_exception_in_resource:Boolean=false, test_exception_in_upload:Boolean=false)
		{
			_module_provider = module_provider;
			_upload_req = new URLRequest();
			var url:String = _module_provider.CreateResource();
			if (url.indexOf("/.form")==-1)
				url = url + "/.form";
			_upload_req.url = ModuleRequest.SERVICE_URL + url;
			//channel name, size, filename, ...
			_upload_variables = new URLVariables();
			_upload_variables.channel = "C"+(_channel++);
			if (test_exception_in_resource)
				_upload_variables[MultipartUpload.PARAM_THROW_EXCEPTION_IN_ADD_RESOURCE] = "true";
			if (test_exception_in_upload)
				_upload_variables[MultipartUpload.PARAM_THROW_EXCEPTION_IN_PARSE_UPLOAD] = "true";
			_upload_req.data = _upload_variables;
			//
            _file = new FileReference();
			_file.addEventListener(Event.SELECT, ok_select_file);
            _file.addEventListener(Event.CANCEL, cancel_file_dialog);
//            _file.addEventListener(Event.OPEN, openHandler);
//            _file.addEventListener(Event.COMPLETE, completeHandler);
//            _file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
//            _file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,uploadCompleteDataHandler);
            _file.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            _file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
           
        	_progress = new Timer(1000);
			_progress.addEventListener(TimerEvent.TIMER, on_check_upload_progress);

 		}
 		
 		public function showFileSystemBrowser(browsable_file_types:Array=null):void
		{
			if (uploading)
				throw new Error("Can not show file system while upload in progress!");
			
			if (browsable_file_types!=null)
				_browsable_file_types = browsable_file_types;
				
           	_file.browse(_browsable_file_types);
 		}
 		
 		public function get file():FileReference
 		{
 			return _file;
 		}
 		
 		public function get data():URLVariables
 		{
 			return _upload_variables;
 		}
 		
 		public function get uploading():Boolean
 		{
 			return _uploading == UPLOADING || _uploading == IN_BETWEEN_UPLOADS || _uploading == CANCELING;
 		}

		private function ok_select_file(e:Event):void
		{
			if (uploading)
				throw new Error("File selected while upload in progress!");
				
			_uploading = IN_BETWEEN_UPLOADS;
			ModuleRequest.doModule(_module_provider.GetSessionId(), [], get_session_id_ok, on_upload_err);
		}
		
		private function get_session_id_ok(id:String):void
		{
			begin_upload(id);
		}
		
        private function begin_upload(session_id:String):void
        {
			var kv:Array = session_id.split("=");
			_upload_variables[kv[0]] = kv[1];
        	if (_uploading==UPLOADING)
        		throw new Error("Can't upload next while upload is in progress!");
        	
        	_uploading = UPLOADING;	
			_upload_variables.size = _file.size;
			_file.upload(_upload_req, UPLOAD_DATA_FIELD_NAME);
			dispatchEvent(new UploadEvent(UploadEvent.BEGIN_UPLOAD));
        	_progress.start();
        }
        
		
		private function cancel_file_dialog(e:Event):void
		{
			dispatchEvent(new UploadEvent(UploadEvent.UPLOAD_CANCELED, this));
		}

        private function on_check_upload_progress(e:TimerEvent):void
		{
			if (_waiting_for_upload_progress_info)
				return;
			_waiting_for_upload_progress_info = true;
			ModuleRequest.doModule(_module_provider.GetUploadProgress(), [_upload_variables.channel], on_upload_progress_info_ok, on_upload_err);
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
		}
        
        
        
        
        // cancel
        public function cancel():void
        {
        	_uploading = CANCELING;
        	_progress.stop();
        	
        	ModuleRequest.doModule(_module_provider.CancelUpload(), [_upload_variables.channel], on_cancel_complete, on_cancel_complete);
        }
        
        private function on_cancel_complete(e:*=null):void
        {
        	_uploading = INIT;
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
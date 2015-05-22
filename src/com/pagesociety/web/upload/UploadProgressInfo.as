package com.pagesociety.web.upload
{
	public class UploadProgressInfo
	{
		
		private var _fieldName:String;
		private var _fileName:String;
		private var _progress:Number;
		private var _fileSize:uint;
		private var _bytesRead:uint;
		private var _complete:Boolean;
		private var _completionObject:Object;
		private var _content_type:String;
		
		
		public function UploadProgressInfo()
		{
		}

		public function get fieldName():String
		{
			return _fieldName;
		}
	
		public function get fileName():String
		{
			return _fileName;
		}
	
		public function get progress():Number
		{
			return _progress;
		}
	
		public function get fileSize():uint
		{
			return _fileSize;
		}
	
		public function get bytesRead():uint
		{
			return _bytesRead;
		}
	
		public function get completionObject():Object
		{
			return _completionObject;
		}
	
		public function get isComplete():Boolean
		{
			return _complete;
		}





		public function set fieldName(fieldName:String):void
		{
			_fieldName = fieldName;
		}
	
		public function set fileName(fileName:String):void
		{
			_fileName = fileName;
		}
	
		public function set progress(progress:Number):void
		{
			_progress = progress;
		}
	
		public function set fileSize(fileSize:uint):void
		{
			_fileSize = fileSize;
		}
	
		public function set bytesRead(bytesRead:uint):void
		{
			 _bytesRead = bytesRead;
		}
	
		public function set completionObject(completionObject:Object):void
		{
			_completionObject = completionObject;
		}
	
		public function set isComplete(complete:Boolean):void
		{
			_complete = complete;
		}
		
		public function get contentType():String
		{
			return _content_type;
		}
	
		public function set contentType(s:String):void
		{
			_content_type = s;
		}

	}
}
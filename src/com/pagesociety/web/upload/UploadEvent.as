package com.pagesociety.web.upload
{
    import flash.events.Event;

    public class UploadEvent extends Event
    {
        public static const SELECT_FILE:String      = "select_file";
        public static const DIALOG_CANCELED:String      = "dialog_canceled";
        public static const BEGIN_UPLOAD:String     = "begin_upload";
        public static const UPLOAD_CANCELED:String  = "upload_canceled";
        public static const UPLOAD_PROGRESS:String  = "upload_progress";
        public static const UPLOAD_ERROR:String     = "upload_error";
        public static const UPLOAD_COMPLETE:String  = "upload_complete";
        public static const UPLOADS_COMPLETE:String  = "uploads_complete";
        
        private var _part:MultipartUpload;
        private var _info:UploadProgressInfo;
        private var _data:*;
        
        public function UploadEvent(type:String, part:MultipartUpload=null, info:UploadProgressInfo=null, o:*=null)
        {
            super(type);
            _part = part;
            _info = info;
            _data = o;
        }
        
        public function get part():MultipartUpload
        {
            return _part;
        }
        
        public function get info():UploadProgressInfo
        {
            return _info;
        }
        
        public function get data():*
        {
            return _data;
        }
        
    }
}
package com.pagesociety.web.module
{
    import com.pagesociety.web.amf.AmfLong;
    import com.pagesociety.web.ModuleConnection;
    
    public class Email extends ModuleConnection
    {

        // SendEmail returns void 
        // throws PersistenceException, WebApplicationException
        public static var METHOD_SENDEMAIL:String = "Email/SendEmail";
        public static function SendEmail(recipient:String, subject:String, message:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_SENDEMAIL, [recipient, subject, message], on_complete, on_error);       
        }

    }
}
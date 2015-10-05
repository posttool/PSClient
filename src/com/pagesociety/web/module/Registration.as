package com.pagesociety.web.module
{
    import com.pagesociety.web.amf.AmfLong;
    import com.pagesociety.web.ModuleConnection;
    
    public class Registration extends ModuleConnection
    {
        public static var OUTSTANDINGREGCONFIRMATION_ENTITY:String = "OutstandingRegConfirmation";
        public static var OUTSTANDINGREGCONFIRMATION_FIELD_ID:String = "id";
        public static var OUTSTANDINGREGCONFIRMATION_FIELD_CREATOR:String = "creator";
        public static var OUTSTANDINGREGCONFIRMATION_FIELD_DATE_CREATED:String = "date_created";
        public static var OUTSTANDINGREGCONFIRMATION_FIELD_LAST_MODIFIED:String = "last_modified";
        public static var OUTSTANDINGREGCONFIRMATION_FIELD_ACTIVATION_TOKEN:String = "activation_token";
        public static var OUTSTANDINGREGCONFIRMATION_FIELD_ACTIVATION_UID:String = "activation_uid";


        // Register returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_REGISTER:String = "TrialRegistrationModule/Register";
        public static function Register(email:String, username:String, password:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_REGISTER, [email, username, password], on_complete, on_error);      
        }

        // ActivateUserAccount returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_ACTIVATEUSERACCOUNT:String = "TrialRegistrationModule/ActivateUserAccount";
        public static function ActivateUserAccount(token:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_ACTIVATEUSERACCOUNT, [token], on_complete, on_error);       
        }

    }
}
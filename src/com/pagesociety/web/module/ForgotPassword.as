package com.pagesociety.web.module
{
    import com.pagesociety.web.amf.AmfLong;
    import com.pagesociety.web.ModuleConnection;
    
    public class ForgotPassword extends ModuleConnection
    {
        public static var OUTSTANDINGFORGOTPASSWORD_ENTITY:String = "OutstandingForgotPassword";
        public static var OUTSTANDINGFORGOTPASSWORD_FIELD_ID:String = "id";
        public static var OUTSTANDINGFORGOTPASSWORD_FIELD_CREATOR:String = "creator";
        public static var OUTSTANDINGFORGOTPASSWORD_FIELD_DATE_CREATED:String = "date_created";
        public static var OUTSTANDINGFORGOTPASSWORD_FIELD_LAST_MODIFIED:String = "last_modified";
        public static var OUTSTANDINGFORGOTPASSWORD_FIELD_ACTIVATION_TOKEN:String = "activation_token";
        public static var OUTSTANDINGFORGOTPASSWORD_FIELD_ACTIVATION_UID:String = "activation_uid";


        // ForgotPassword returns boolean 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_FORGOTPASSWORD:String = "ForgotPassword/ForgotPassword";
        public static function ForgotPassword1(email:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_FORGOTPASSWORD, [email], on_complete, on_error);        
        }

        // LoginWithForgotPasswordToken returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_LOGINWITHFORGOTPASSWORDTOKEN:String = "ForgotPassword/LoginWithForgotPasswordToken";
        public static function LoginWithForgotPasswordToken(a1:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_LOGINWITHFORGOTPASSWORDTOKEN, [a1], on_complete, on_error);     
        }

    }
}

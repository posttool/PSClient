package com.pagesociety.web.module
{
    import com.pagesociety.web.amf.AmfLong;
    import com.pagesociety.web.ModuleConnection;
    
    public class SystemNotificationModule extends ModuleConnection
    {
        public static var SYSTEMNOTIFICATION_ENTITY:String = "SystemNotification";
        public static var SYSTEMNOTIFICATION_FIELD_ID:String = "id";
        public static var SYSTEMNOTIFICATION_FIELD_CREATOR:String = "creator";
        public static var SYSTEMNOTIFICATION_FIELD_DATE_CREATED:String = "date_created";
        public static var SYSTEMNOTIFICATION_FIELD_LAST_MODIFIED:String = "last_modified";
        public static var SYSTEMNOTIFICATION_FIELD_NOTIFICATION_TYPE:String = "notification_type";
        public static var SYSTEMNOTIFICATION_FIELD_NOTIFICATION_USER:String = "notification_user";
        public static var SYSTEMNOTIFICATION_FIELD_NOTIFICATION_LEVEL:String = "notification_level";
        public static var SYSTEMNOTIFICATION_FIELD_NOTIFICATION_TEXT:String = "notification_text";

    public static const NOTIFICATION_LEVEL_ALERT:uint       = 0x01;
    public static const NOTIFICATION_LEVEL_INFO:uint        = 0x02;
    public static const NOTIFICATION_TYPE_UNDEFINED:uint    = 0x00;
    public static const NOTIFICATION_TYPE_USER:uint         = 0x01;
    public static const NOTIFICATION_TYPE_GLOBAL:uint       = 0x02;     
    // CreateGlobalInfoNotification returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_CREATEGLOBALINFONOTIFICATION:String = "SystemNotificationModule/CreateGlobalInfoNotification";
        public static function CreateGlobalInfoNotification(a1:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_CREATEGLOBALINFONOTIFICATION, [a1], on_complete, on_error);     
        }

        // CreateAlertNotificationForUser returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_CREATEALERTNOTIFICATIONFORUSER:String = "SystemNotificationModule/CreateAlertNotificationForUser";
        public static function CreateAlertNotificationForUser(a1:AmfLong, a2:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_CREATEALERTNOTIFICATIONFORUSER, [a1, a2], on_complete, on_error);       
        }

        // GetUserNotifications returns PagingQueryResult 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_GETUSERNOTIFICATIONS:String = "SystemNotificationModule/GetUserNotifications";
        public static function GetUserNotifications(a1:int, a2:int, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETUSERNOTIFICATIONS, [a1, a2], on_complete, on_error);     
        }

        // GetGlobalNotifications returns PagingQueryResult 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_GETGLOBALNOTIFICATIONS:String = "SystemNotificationModule/GetGlobalNotifications";
        public static function GetGlobalNotifications(a1:int, a2:int, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETGLOBALNOTIFICATIONS, [a1, a2], on_complete, on_error);       
        }

        // DeleteNotification returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_DELETENOTIFICATION:String = "SystemNotificationModule/DeleteNotification";
        public static function DeleteNotification(a1:AmfLong, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_DELETENOTIFICATION, [a1], on_complete, on_error);       
        }

        // CreateInfoNotificationForUser returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_CREATEINFONOTIFICATIONFORUSER:String = "SystemNotificationModule/CreateInfoNotificationForUser";
        public static function CreateInfoNotificationForUser(a1:AmfLong, a2:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_CREATEINFONOTIFICATIONFORUSER, [a1, a2], on_complete, on_error);        
        }

        // CreateGlobalAlertNotification returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_CREATEGLOBALALERTNOTIFICATION:String = "SystemNotificationModule/CreateGlobalAlertNotification";
        public static function CreateGlobalAlertNotification(a1:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_CREATEGLOBALALERTNOTIFICATION, [a1], on_complete, on_error);        
        }

    }
}
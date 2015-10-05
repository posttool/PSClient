package com.pagesociety.web.module
{
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.web.ModuleConnection;
    import com.pagesociety.web.amf.AmfLong;
    
    public class CommentModule extends ModuleConnection
    {
        public static const MODULE_NAME:String = "Comments";
        public static const COMMENT_ENTITY:String = "Comment";
        public static const COMMENT_FIELD_ID:String = "id"; 
        public static const COMMENT_FIELD_CREATOR:String = "creator"; 
        public static const COMMENT_FIELD_DATE_CREATED:String = "date_created"; 
        public static const COMMENT_FIELD_LAST_MODIFIED:String = "last_modified"; 
        public static const COMMENT_FIELD_TITLE:String = "title"; 
        public static const COMMENT_FIELD_COMMENT:String = "comment"; 
        public static const COMMENT_FIELD_TARGET:String = "target"; 
        public static const COMMENT_FIELD_FLAGGED_STATUS:String = "flagged_status"; 
        public static const COMMENT_FIELD_FLAGGING_USERS:String = "flagging_users"; 
        
        
        // UnflagComment returns Entity 
        // throws PersistenceException, WebApplicationException
        public static var METHOD_UNFLAGCOMMENT:String = MODULE_NAME+"/UnflagComment";
        public static function UnflagComment(comment_id:AmfLong, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_UNFLAGCOMMENT, [comment_id], on_complete, on_error);        
        }
        
        // GetFlaggedComments returns PagingQueryResult 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_GETFLAGGEDCOMMENTS:String = MODULE_NAME+"/GetFlaggedComments";
        public static function GetFlaggedComments(offset:int, page_size:int, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETFLAGGEDCOMMENTS, [offset, page_size], on_complete, on_error);        
        }
        
        // CreateComment returns Entity 
        // throws WebApplicationException, PersistenceException, BillingGatewayException
        public static var METHOD_CREATECOMMENT:String = MODULE_NAME+"/CreateComment";
        public static function CreateComment(comment:Entity, rating_data:Object, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_CREATECOMMENT, [comment, rating_data], on_complete, on_error);      
        }
        
        // CreateComment returns Entity 
        // throws WebApplicationException, PersistenceException, BillingGatewayException
//      public static var METHOD_CREATECOMMENT:String = MODULE_NAME+"/CreateComment";
        public static function CreateComment2(title:String, comment:String, target_type:String, target_id:AmfLong, rating_data:Object, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_CREATECOMMENT, [title, comment, target_type, target_id, rating_data], on_complete, on_error);       
        }
        
        // GetAllComments returns PagingQueryResult 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_GETALLCOMMENTS:String = MODULE_NAME+"/GetAllComments";
        public static function GetAllComments(entity_type:String, entity_id:AmfLong, offset:int, page_size:int, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETALLCOMMENTS, [entity_type, entity_id, offset, page_size], on_complete, on_error);        
        }
        
        // UpdateComment returns Entity 
        // throws WebApplicationException, PersistenceException, BillingGatewayException
        public static var METHOD_UPDATECOMMENT:String = MODULE_NAME+"/UpdateComment";
        public static function UpdateComment(comment_id:AmfLong, title:String, comment:String, rating_data:Object, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_UPDATECOMMENT, [comment_id, title, comment, rating_data], on_complete, on_error);       
        }
        
        // UpdateComment returns Entity 
        // throws WebApplicationException, PersistenceException, BillingGatewayException
//      public static var METHOD_UPDATECOMMENT:String = MODULE_NAME+"/UpdateComment";
        public static function UpdateComment2(comment:Entity, rating_data:Object, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_UPDATECOMMENT, [comment, rating_data], on_complete, on_error);      
        }
        
        // DeleteComment returns Entity 
        // throws PersistenceException, WebApplicationException
        public static var METHOD_DELETECOMMENT:String = MODULE_NAME+"/DeleteComment";
        public static function DeleteComment(comment:Entity, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_DELETECOMMENT, [comment], on_complete, on_error);       
        }
        
    }
}

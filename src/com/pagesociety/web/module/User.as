package com.pagesociety.web.module
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.web.ModuleConnection;
	import com.pagesociety.web.amf.AmfLong;
	
	public class User extends ModuleConnection
	{
		public static var USER_ENTITY:String = "User";
		public static var USER_FIELD_ID:String = "id";
		public static var USER_FIELD_CREATOR:String = "creator";
		public static var USER_FIELD_DATE_CREATED:String = "date_created";
		public static var USER_FIELD_LAST_MODIFIED:String = "last_modified";
		public static var USER_FIELD_EMAIL:String = "email";
		public static var USER_FIELD_PASSWORD:String = "password";
		public static var USER_FIELD_USERNAME:String = "username";
		public static var USER_FIELD_ROLES:String = "roles";
		public static var USER_FIELD_LAST_LOGIN:String = "last_login";
		public static var USER_FIELD_LAST_LOGOUT:String = "last_logout";
		public static var USER_FIELD_LOCK:String = "lock";
		public static var USER_FIELD_LOCK_CODE:String = "lock_code";
		public static var USER_FIELD_LOCK_NOTES:String = "lock_notes";

		public static var USER_LOCK_UNLOCKED:int	 			  	= 0x10;
		public static var USER_LOCK_LOCKED:int				  		= 0x20;
		public static var USER_LOCK_CODE_UNLOCKED:int				= 0x00;
		public static var USER_LOCK_CODE_DEFAULT:int				= 0x01;		

		public static var USER_ROLE_WHEEL:int 						= 0x1000;
		public static var USER_ROLE_USER:int	 				 	= 0x0001;

		public static var USER_EVENT_CREATED:int	 	 			= 0x1001;
		public static var USER_EVENT_LOGGED_IN:int  	 			= 0x1002;
		public static var USER_EVENT_LOGGED_OUT:int 	 			= 0x1004;
		public static var USER_EVENT_DELETED:int 	 	 			= 0x1008;


	public static const USER_KEY_USER_IS_DELINQUENT:String 				 	 = "is_delinquent_user";
	public static const USER_KEY_DELINQUENT_USER_IN_GRACE_PERIOD:String 		 = "in_grace_period";
	public static const USER_KEY_DELINQUENT_BALANCE:String 		 			 = "delinquent_balance";
	public static const USER_KEY_DELINQUENT_BILLING_FAILED_GENESIS:String 		 = "billing_failed_genesis";


		// Login returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_LOGIN:String = "User/Login";
		public static function Login(email:String, password:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_LOGIN, [email, password], on_complete, on_error);		
		}

		// GetUser returns Entity 
		public static var METHOD_GETUSER:String = "User/GetUser";
		public static function GetUser(on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETUSER, [], on_complete, on_error);		
		}

		// UpdatePassword returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_UPDATEPASSWORD:String = "User/UpdatePassword";
		public static function UpdatePassword(user_entity_id:AmfLong, old_password:String, new_password:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_UPDATEPASSWORD, [user_entity_id, old_password, new_password], on_complete, on_error);		
		}

		// Logout returns Entity 
		// throws PersistenceException
		public static var METHOD_LOGOUT:String = "User/Logout";
		public static function Logout(on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_LOGOUT, [], on_complete, on_error);		
		}

		// LockUser returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_LOCKUSER:String = "User/LockUser";
		public static function LockUser(user_entity_id:AmfLong, lock_code:int, notes:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_LOCKUSER, [user_entity_id, lock_code, notes], on_complete, on_error);		
		}

		// StartRegistration returns int 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_STARTREGISTRATION:String = "User/StartRegistration";
		public static function StartRegistration(domain:String, username:String, email:String, md5_password1:String, md5_password2:String, promo_code:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_STARTREGISTRATION, [domain, username, email, md5_password1, md5_password2, promo_code], on_complete, on_error);		
		}

		// CreatePublicUser returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_CREATEPUBLICUSER:String = "User/CreatePublicUser";
		public static function CreatePublicUser(email:String, password:String, username:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CREATEPUBLICUSER, [email, password, username], on_complete, on_error);		
		}

		// RemoveRole returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_REMOVEROLE:String = "User/RemoveRole";
		public static function RemoveRole(user_entity_id:AmfLong, role:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_REMOVEROLE, [user_entity_id, role], on_complete, on_error);		
		}

		
		// ActivateExpiredTrial returns Entity 
		// throws WebApplicationException, PersistenceException, BillingGatewayException
		public static var METHOD_ACTIVATEEXPIREDTRIAL:String = "User/ActivateExpiredTrial";
		public static function ActivateExpiredTrial(trial_activation_billing_record:Entity, promo_code:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ACTIVATEEXPIREDTRIAL, [trial_activation_billing_record, promo_code], on_complete, on_error);		
		}
		
		// CloseAccount returns void 
		public static var METHOD_CLOSEACCOUNT:String = "User/CloseAccount";
		public static function CloseAccount(on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CLOSEACCOUNT, [], on_complete, on_error);		
		}

		// AddRole returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_ADDROLE:String = "User/AddRole";
		public static function AddRole(user_entity_id:AmfLong, role:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ADDROLE, [user_entity_id, role], on_complete, on_error);		
		}

		// GetSessionId returns String 
		public static var METHOD_GETSESSIONID:String = "User/GetSessionId";
		public static function GetSessionId(on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETSESSIONID, [], on_complete, on_error);		
		}

		// StartTrial returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_STARTTRIAL:String = "User/StartTrial";
		public static function StartTrial(domain:String, username:String, email:String, md5_password1:String, md5_password2:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_STARTTRIAL, [domain, username, email, md5_password1, md5_password2], on_complete, on_error);		
		}

		// GetUsersByRole returns PagingQueryResult 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_GETUSERSBYROLE:String = "User/GetUsersByRole";
		public static function GetUsersByRole(role:int, offset:int, page_size:int, order_by:String, direction:uint, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETUSERSBYROLE, [role, offset, page_size, order_by, direction], on_complete, on_error);		
		}

		// CreatePrivilegedUser returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_CREATEPRIVILEGEDUSER:String = "User/CreatePrivilegedUser";
		public static function CreatePrivilegedUser(email:String, password:String, username:String, role:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CREATEPRIVILEGEDUSER, [email, password, username, role], on_complete, on_error);		
		}

		// GetLockedUsersByLockCode returns PagingQueryResult 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_GETLOCKEDUSERSBYLOCKCODE:String = "User/GetLockedUsersByLockCode";
		public static function GetLockedUsersByLockCode(lock_code:int, offset:int, page_size:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETLOCKEDUSERSBYLOCKCODE, [lock_code, offset, page_size], on_complete, on_error);		
		}

		// DeleteUser returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_DELETEUSER:String = "User/DeleteUser";
		public static function DeleteUser(user_id:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_DELETEUSER, [user_id], on_complete, on_error);		
		}

		// GetLockedUsers returns PagingQueryResult 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_GETLOCKEDUSERS:String = "User/GetLockedUsers";
		public static function GetLockedUsers(offset:int, page_size:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETLOCKEDUSERS, [offset, page_size], on_complete, on_error);		
		}

		// UpdateEmail returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_UPDATEEMAIL:String = "User/UpdateEmail";
		public static function UpdateEmail(user_entity_id:AmfLong, email:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_UPDATEEMAIL, [user_entity_id, email], on_complete, on_error);		
		}

		// UnlockUser returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_UNLOCKUSER:String = "User/UnlockUser";
		public static function UnlockUser(user_entity_id:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_UNLOCKUSER, [user_entity_id], on_complete, on_error);		
		}

		// EndRegistration returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_ENDREGISTRATION:String = "User/EndRegistration";
		public static function EndRegistration(billing_record:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ENDREGISTRATION, [billing_record], on_complete, on_error);		
		}

		// EndRegistration returns Entity 
		// throws PersistenceException, WebApplicationException
		public static function EndRegistration0(on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ENDREGISTRATION, [], on_complete, on_error);		
		}

		// UpdateUserName returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_UPDATEUSERNAME:String = "User/UpdateUserName";
		public static function UpdateUserName(user_entity_id:AmfLong, username:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_UPDATEUSERNAME, [user_entity_id, username], on_complete, on_error);		
		}
		
		// returns Boolean
		// throws PersistenceException, WebApplicationException
		public static var METHOD_EMAILEXISTS:String = "User/EmailExists";
		public static function EmailExists(email:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_EMAILEXISTS, [email], on_complete, on_error);
		}
		
		// FindByEmailOrUserName returns QueryResult 
		// throws PersistenceException, PermissionsException
		public static var METHOD_FINDBYEMAILORUSERNAME:String = "User/FindByEmailOrUserName";
		public static function FindByEmailOrUserName(a1:String, order:String, offset:uint, pagesize:uint, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_FINDBYEMAILORUSERNAME, [a1,order,offset,pagesize], on_complete, on_error);		
		}
		
		public static var METHOD_LOGINAS:String = "User/LogInAs";
		public static function LogInAs(user_id:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_LOGINAS, [user_id], on_complete, on_error);		
		}
		

	}
}

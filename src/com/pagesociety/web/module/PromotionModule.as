package com.pagesociety.web.module
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.web.ModuleConnection;
	import com.pagesociety.web.amf.AmfLong;
	
	public class PromotionModule extends ModuleConnection
	{
		public static var PROMOTION_ENTITY:String = "Promotion";
		public static var PROMOTION_FIELD_ID:String = "id";
		public static var PROMOTION_FIELD_CREATOR:String = "creator";
		public static var PROMOTION_FIELD_DATE_CREATED:String = "date_created";
		public static var PROMOTION_FIELD_LAST_MODIFIED:String = "last_modified";
		public static var PROMOTION_FIELD_TITLE:String = "title";
		public static var PROMOTION_FIELD_DESCRIPTION:String = "description";
		public static var PROMOTION_FIELD_PROGRAM:String = "program";
		public static var PROMOTION_FIELD_GR1:String = "gr1";
		public static var PROMOTION_FIELD_GR2:String = "gr2";

		public static var GLOBALPROMOTION_ENTITY:String = "GlobalPromotion";
		public static var GLOBALPROMOTION_FIELD_ID:String = "id";
		public static var GLOBALPROMOTION_FIELD_CREATOR:String = "creator";
		public static var GLOBALPROMOTION_FIELD_DATE_CREATED:String = "date_created";
		public static var GLOBALPROMOTION_FIELD_LAST_MODIFIED:String = "last_modified";
		public static var GLOBALPROMOTION_FIELD_PROMOTION:String = "promotion";
		public static var GLOBALPROMOTION_FIELD_ACTIVE:String = "active";

		public static var COUPONPROMOTION_ENTITY:String = "CouponPromotion";
		public static var COUPONPROMOTION_FIELD_ID:String = "id";
		public static var COUPONPROMOTION_FIELD_CREATOR:String = "creator";
		public static var COUPONPROMOTION_FIELD_DATE_CREATED:String = "date_created";
		public static var COUPONPROMOTION_FIELD_LAST_MODIFIED:String = "last_modified";
		public static var COUPONPROMOTION_FIELD_PROMOTION:String = "promotion";
		public static var COUPONPROMOTION_FIELD_PROMO_CODE:String = "promo_code";
		public static var COUPONPROMOTION_FIELD_NO_TIMES_CODE_CAN_BE_USED:String = "no_times_code_can_be_used";
		public static var COUPONPROMOTION_FIELD_NO_TIMES_CODE_HAS_BEEN_USED:String = "no_times_code_has_been_used";
		public static var COUPONPROMOTION_FIELD_EXPIRATION_DATE:String = "expiration_date";

		public static var USERPROMOTION_ENTITY:String = "UserPromotion";
		public static var USERPROMOTION_FIELD_ID:String = "id";
		public static var USERPROMOTION_FIELD_CREATOR:String = "creator";
		public static var USERPROMOTION_FIELD_DATE_CREATED:String = "date_created";
		public static var USERPROMOTION_FIELD_LAST_MODIFIED:String = "last_modified";
		public static var USERPROMOTION_FIELD_ORIGIN:String = "origin";
		public static var USERPROMOTION_FIELD_PROMOTION:String = "promotion";
		public static var USERPROMOTION_FIELD_IR1:String = "ir1";
		public static var USERPROMOTION_FIELD_IR2:String = "ir2";
		public static var USERPROMOTION_FIELD_IR3:String = "ir3";
		public static var USERPROMOTION_FIELD_IR4:String = "ir4";
		public static var USERPROMOTION_FIELD_SR1:String = "sr1";
		public static var USERPROMOTION_FIELD_SR2:String = "sr2";
		public static var USERPROMOTION_FIELD_FPR1:String = "fpr1";
		public static var USERPROMOTION_FIELD_FPR2:String = "fpr2";


		// CreateGlobalPromotion returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_CREATEGLOBALPROMOTION:String = "PromotionModule/CreateGlobalPromotion";
		public static function CreateGlobalPromotion(a1:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CREATEGLOBALPROMOTION, [a1], on_complete, on_error);		
		}

		// CreateGlobalPromotion returns Entity 
		// throws WebApplicationException, PersistenceException
		public static function CreateGlobalPromotion1(a1:Entity, a2:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CREATEGLOBALPROMOTION, [a1, a2], on_complete, on_error);		
		}


		// GetCouponPromotions returns PagingQueryResult 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETPROMOTIONS:String = "PromotionModule/GetPromotions";
		public static function GetPromotions(a1:int, a2:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETPROMOTIONS, [a1, a2], on_complete, on_error);		
		}

		// GetCouponPromotions returns PagingQueryResult 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETCOUPONPROMOTIONS:String = "PromotionModule/GetCouponPromotions";
		public static function GetCouponPromotions(a1:int, a2:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETCOUPONPROMOTIONS, [a1, a2], on_complete, on_error);		
		}

		// GetGlobalPromotions returns PagingQueryResult 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETGLOBALPROMOTIONS:String = "PromotionModule/GetGlobalPromotions";
		public static function GetGlobalPromotions(a1:int, a2:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETGLOBALPROMOTIONS, [a1, a2], on_complete, on_error);		
		}

		// UpdatePromotion returns Entity 
		// throws WebApplicationException, PersistenceException, BillingGatewayException
		public static var METHOD_UPDATEPROMOTION:String = "PromotionModule/UpdatePromotion";
		public static function UpdatePromotion(a1:AmfLong, a2:String, a3:String, a4:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_UPDATEPROMOTION, [a1, a2, a3, a4], on_complete, on_error);		
		}

		// UpdatePromotion returns Entity 
		// throws WebApplicationException, PersistenceException, BillingGatewayException
		public static function UpdatePromotion1(a1:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_UPDATEPROMOTION, [a1], on_complete, on_error);		
		}

		// CreatePromotion returns Entity 
		// throws WebApplicationException, PersistenceException, BillingGatewayException
		public static var METHOD_CREATEPROMOTION:String = "PromotionModule/CreatePromotion";
		public static function CreatePromotion(a1:String, a2:String, a3:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CREATEPROMOTION, [a1, a2, a3], on_complete, on_error);		
		}

		// CreatePromotion returns Entity 
		// throws WebApplicationException, PersistenceException, BillingGatewayException
		public static function CreatePromotion1(a1:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CREATEPROMOTION, [a1], on_complete, on_error);		
		}

		// SetCouponPromotionExpirationDate returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_SETCOUPONPROMOTIONEXPIRATIONDATE:String = "PromotionModule/SetCouponPromotionExpirationDate";
		public static function SetCouponPromotionExpirationDate(a1:AmfLong, a2:Date, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_SETCOUPONPROMOTIONEXPIRATIONDATE, [a1, a2], on_complete, on_error);		
		}

		// CreateCouponPromotion returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_CREATECOUPONPROMOTION:String = "PromotionModule/CreateCouponPromotion";
		public static function CreateCouponPromotion(a1:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CREATECOUPONPROMOTION, [a1], on_complete, on_error);		
		}

		// CreateCouponPromotion returns Entity 
		// throws WebApplicationException, PersistenceException
		public static function CreateCouponPromotion1(a1:String, a2:Entity, a3:int, a4:Date, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CREATECOUPONPROMOTION, [a1, a2, a3, a4], on_complete, on_error);		
		}

		// SetPromotionProgramRegisters returns Entity 
		// throws WebApplicationException, PersistenceException, BillingGatewayException
		public static var METHOD_SETPROMOTIONPROGRAMREGISTERS:String = "PromotionModule/SetPromotionProgramRegisters";
		public static function SetPromotionProgramRegisters(a1:AmfLong, a2:AmfLong, a3:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_SETPROMOTIONPROGRAMREGISTERS, [a1, a2, a3], on_complete, on_error);		
		}

		// ActivateGlobalPromotion returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_ACTIVATEGLOBALPROMOTION:String = "PromotionModule/ActivateGlobalPromotion";
		public static function ActivateGlobalPromotion(a1:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ACTIVATEGLOBALPROMOTION, [a1], on_complete, on_error);		
		}

		// DeleteGlobalPromotion returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_DELETEGLOBALPROMOTION:String = "PromotionModule/DeleteGlobalPromotion";
		public static function DeleteGlobalPromotion(a1:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_DELETEGLOBALPROMOTION, [a1], on_complete, on_error);		
		}

		// DeleteCouponPromotion returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_DELETECOUPONPROMOTION:String = "PromotionModule/DeleteCouponPromotion";
		public static function DeleteCouponPromotion(a1:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_DELETECOUPONPROMOTION, [a1], on_complete, on_error);		
		}

		// DectivateGlobalPromotion returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_DECTIVATEGLOBALPROMOTION:String = "PromotionModule/DectivateGlobalPromotion";
		public static function DectivateGlobalPromotion(a1:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_DECTIVATEGLOBALPROMOTION, [a1], on_complete, on_error);		
		}

		// DeletePromotion returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_DELETEPROMOTION:String = "PromotionModule/DeletePromotion";
		public static function DeletePromotion(a1:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_DELETEPROMOTION, [a1], on_complete, on_error);		
		}

		// GetCouponPromotionByPromoCode returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETCOUPONPROMOTIONBYPROMOCODE:String = "PromotionModule/GetCouponPromotionByPromoCode";
		public static function GetCouponPromotionByPromoCode(a1:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETCOUPONPROMOTIONBYPROMOCODE, [a1], on_complete, on_error);		
		}

	}
}

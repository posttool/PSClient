package com.pagesociety.web.module
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.web.ModuleConnection;
	import com.pagesociety.web.amf.AmfLong;
	
	public class ISOCountryModule extends ModuleConnection
	{

		public static var METHOD_GETCOUNTRIES:String = "ISOCountryModule/GetCountries";
		public static function GetCountries(on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETCOUNTRIES,[], on_complete, on_error);		
		}


		public static var METHOD_GETCOUNTRYCODE:String = "ISOCountryModule/GetCountryCode";
		public static function GetCountryCode(country:String,on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETCOUNTRYCODE,[country], on_complete, on_error);		
		}


		public static var METHOD_GETCOUNTRY:String = "ISOCountryModule/GetCountry";
		public static function GetCountry(code:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETCOUNTRY,[code], on_complete, on_error);		
		}


	}
}
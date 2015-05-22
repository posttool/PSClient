package com.pagesociety.web.amf
{
	public class AmfLong
	{
		private var _v:String;
		
		public function AmfLong(v:Number=0)
		{
			_v = v.toString();
		}
		
		public function get longValue():Number
		{
			return Number(_v);
		}
		
		public function set stringValue(v:String):void
		{
			_v = v;
		}
		
		public function get stringValue():String
		{
			return _v;
		}
		
		public function toString():String
		{
			return longValue.toString();
		}
	
	}
}
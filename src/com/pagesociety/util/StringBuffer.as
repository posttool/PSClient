package com.pagesociety.util
{
	public class StringBuffer
	{
		private var s:String;
		public function StringBuffer(init_val:String="")
		{
			s = init_val;
		}
		
		public function append(a:Object):void
		{
			s += a;
		}
		
		public function toString():String
		{
			return s;
		}

	}
}
package com.pagesociety.util
{
	public class Random
	{
		public static function R(max:uint):uint
		{
			return Math.floor(Math.random()*max);
		}
		
		public static function RR(bottom:int,top:int):uint
		{
			var r:int = top - bottom;
			return R(r)+bottom;
		}
		
		public static function A(array:Array):*
		{
			return array[R(array.length)];
		}

	}
}
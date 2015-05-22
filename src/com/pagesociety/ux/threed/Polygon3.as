package com.pagesociety.ux.threed
{
	
	public class Polygon3 
	{
		private var points:Array;
	
		public function Polygon3() 
		{
			points = new Array();
		}
	
		public function size():uint
		{
			return points.length;
		}
	
		public function getPoint(i:uint):Point3 
		{
			return points[i];
		}
	
		public function addPoint(p:Point3):void
		{
			points.push(p);
		}
	}
}
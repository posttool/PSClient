package com.pagesociety.ux.component.dim
{
	import com.pagesociety.ux.component.Component;

	public class ComponentDimension
	{
		public static const WIDTH:String = "width";
		public static const HEIGHT:String = "height";
		
		public static const UNSET:uint = 0x01;
		public static const PERCENT:uint = 0x02;
		public static const DELTA:uint = 0x03;
		public static const ABSOLUTE:uint = 0x04;

		private var _component:Component;
		private var _prop:String;
		private var _pf:Number;
		private var _o:Number;
		private var _type:uint;

		public function ComponentDimension(c:Component, prop:String) 
		{
			_component 		= c;
			_prop			= prop;
			unset();
		}
		
		public function get isUnset():Boolean
		{
			return _type==UNSET;
		}
		
		public function unset():void
		{
			_o				= 0;
			_pf				= 0;
			_type 			= UNSET;
		}
		
		public function setAbsolute(offset:Number):void
		{
			_type 		= ABSOLUTE;
			_o			= offset;
		}
		
		public function setPercent(p:Number,d:Number=0):void
		{
			_type 		= PERCENT;
			_o			= d;
			_pf 		= p;
		}
		
		public function setDelta(d:Number):void
		{
			_type 		= DELTA;
			_o			= d;
		}
		
		public function getValue():Number
		{
			var p:Component = _component.parent;
			var c:Component = _component;
			
			switch(_type)
			{
				case UNSET:
					if(p==null)
						return _component.application[_prop];
					else
						return p[_prop+"ForUnsetChild"];
					
				case PERCENT:
					if(p==null)
						return Math.floor(_pf * _component.application[_prop] + _o);
					else
						return Math.floor(_pf * p[_prop] + _o);

				case DELTA:
					if(p==null)
						return Math.floor(_o + _component.application[_prop]);
					else
						return Math.floor(_o + p[_prop]);

				case ABSOLUTE:
					return _o;
					
				default:
					throw new Error("NO SUCH TYPE!");
					

			}
		}
	}
}
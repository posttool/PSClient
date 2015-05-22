package com.pagesociety.ux.component.dim
{
	import com.pagesociety.ux.component.Component;

	public class ComponentPoint
	{
		public static const X:String = "x";
		public static const Y:String = "y";
		
		public static const UNSET:uint = 0x01;
		public static const RELATIVE_TO_PARENT:uint = 0x02;
		public static const RELATIVE_TO_SIBLING:uint = 0x03;
		public static const ABSOLUTE:uint = 0x04;
		public static const GUIDE:uint = 0x05;

		
		private var _component:Component;
		private var _prop:String;
		private var _nr1:Number;
		private var _nr2:Number;
		private var _nr3:Number;
		private var _cr1:Component;
		private var _cr2:Component;
		private var _or1:Object;
		private var _or2:Object;
		private var _type:uint;
		
		public function ComponentPoint(c:Component, prop:String)
		{
			_component 		= c;
			_prop			= prop;
			unset();
		}
		
		public function isUnset():Boolean
		{
			return _type==UNSET;
		}
		
		public function unset():void
		{
			_nr1				= 0;
			_nr2				= 0;
			_nr3				= 0;
			_cr1				= null;
			_cr2				= null;
			_type 			= UNSET;
		}
		
		public function setAlign(guide:int,offset:Number=0,dp:Number=Number.MAX_VALUE,guides:Array=null):void
		{
			switch (guide)
			{
				case Guide.TOP:
				case Guide.LEFT:
					setRelativeToParent( 0, offset, dp!=Number.MAX_VALUE?dp:Align.RIGHT);
					break;
				case Guide.CENTER:
					setRelativeToParent(.5, offset, dp!=Number.MAX_VALUE?dp:Align.CENTER);
					break;
				case Guide.BOTTOM:
				case Guide.RIGHT:
					setRelativeToParent( 1, offset, dp!=Number.MAX_VALUE?dp:Align.LEFT);
					break;
				default:/* if it isnt an implicit guide it is a user guide */
					setGuide(guides,guide,offset,dp!=Number.MAX_VALUE?dp:Align.LEFT);
					break;
			}
		}
		
		public function setRelativeToParent(percent:Number,offset:Number=0,dim_percent_offset:Number=0):void
		{
			_type 		= RELATIVE_TO_PARENT;
			_nr1			= percent;
			_nr2			= offset;
			_nr3			= dim_percent_offset;
			_cr2			= null;
			_cr1			= null;
		}
		
		public function setRelativeToSibling(sibling:Component,alignment:uint,offset:Number=0,dp:Number=Number.MAX_VALUE):void
		{
			switch (alignment)
			{
				case Align.TOP:
				case Align.LEFT:
					setRelativeToSiblingA(sibling, offset, dp!=Number.MAX_VALUE? dp:-1, _component);
					break;
				case Align.CENTER:
					setRelativeToSiblingA(sibling, offset, dp!=Number.MAX_VALUE? dp: 0, sibling);
					break;
				case Align.BOTTOM:
				case Align.RIGHT:
					setRelativeToSiblingA(sibling, offset, dp!=Number.MAX_VALUE? dp:+1, sibling);
					break;
			}
		}
		
		public function setRelativeToSiblingA(sibling:Component,offset:Number,dim_percent_offset:Number,dim_offset_target:Component):void
		{
			_type 		= RELATIVE_TO_SIBLING;
			_cr2 			= sibling;
			_nr2			= offset;
			_nr3			= dim_percent_offset;
			_cr1			= dim_offset_target;
			_nr1			= 0;
		}
		
		public function setAbsolute(val:Number,offset:Number=0,dim_percent_offset:Number=0):void
		{
			_type 		= ABSOLUTE;
			_nr2			= val;
			_nr1			= offset;
			_nr3			= dim_percent_offset;
			_cr2 			= null;
			_cr1 			= null;
		}
		
		public function setGuide(guides:Array,idx:uint,offset:Number=0,dim_percent_offset:Number=0):void
		{
			_type 			= GUIDE;
			_nr1			= idx;
			_nr2			= offset;
			_nr3			= dim_percent_offset;
			_or1 			= guides;
			_or2 			= null;
		}
	
		
		public function getValue():Number
		{
			
			var dim:String = _prop==X ? ComponentDimension.WIDTH : ComponentDimension.HEIGHT;
			var nr3xdim:Number = _nr3==0 ? 0  : _component[dim] * _nr3; //doesnt call component.x/y for nr3==0,,,,, sometimes getting the prop from the component results in a lot of recursion???
			switch(_type)
			{
				case UNSET:
					return 0;
				case RELATIVE_TO_PARENT:
					if (_component.parent==null)
						throw new Error("Cannot set application."+_prop+" relative to parent");
					
					return Math.floor(_nr1 * _component.parent[dim] + _nr2 + nr3xdim);					
				case RELATIVE_TO_SIBLING:
					return Math.floor(_cr2[_prop] + _nr2 + _nr3 * _cr1[dim]);
				case ABSOLUTE:
					return Math.floor(_nr1 + _nr2 + nr3xdim);
				case GUIDE:
					if(_or1[_nr1].type == Component.PERCENT)
						return Math.floor(_or1[_nr1].val * _component.parent[dim] + _nr2 +  nr3xdim);
					return Math.floor(_or1[_nr1].val + _nr2 + nr3xdim);

				default:
					throw new Error("Unhandled Component Point Type "+_type);
			}
		}
	}
}
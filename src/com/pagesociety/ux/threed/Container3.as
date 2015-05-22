package com.pagesociety.ux.threed
{
	import com.pagesociety.ux.component.Component;
	
	public class Container3 extends Object3
	{
		private var _children:Array;
		public function Container3(parent:Container3)
		{
			super(parent);
			_children = new Array();
		}
		
		internal function addChild(c:Object3):void
		{
			_children.push(c);
		}
		
		public function removeChild(c:Object3):void
		{
			_children.splice(_children.indexOf(c),1);
			c.destroy();
		}
		
		override public function render():void
		{
			
		}
		
	}
}
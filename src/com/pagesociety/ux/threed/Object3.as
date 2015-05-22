package com.pagesociety.ux.threed
{
	import com.pagesociety.ux.component.Component;
	
	public class Object3 extends Point3
	{
		private var _parent:Container3;
		private var _renderer:Renderer;
		private var _width:Number;
		private var _height:Number;
		private var _depth:Number;
		private var _component:Component;
		
		public function Object3(parent:Container3)
		{
			super(0,0,0);
			_parent = parent;
			_renderer = _parent.renderer;
			_parent.addChild(this);
		}
		
		public function get renderer():Renderer
		{
			return _renderer;
		}
		
		public function get parent():Container3
		{
			return _parent;
		}
		
		public function get component():Component
		{
			return _component;
		}
		
		public function set component(c:Component):void
		{
			_component = c;
		}
		
		internal function destroy():void
		{
			_parent = null;
			_renderer = null;
			_component = null;
		}
		
		public function render():void
		{
			
		}
		
	}
}
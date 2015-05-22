package com.pagesociety.ux.component.container
{
	import com.pagesociety.ux.MovingValue;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;

	public class ModalContainer extends Container
	{
		public var S:Number = 700;
		
		private var _fading:Component;
		private var _showing:Component;
		private var _destroy_0:Boolean;
		private var _destroy_1:Boolean;
		private var _alphaoff:MovingValue = new MovingValue(0);
		
		public function ModalContainer(parent:Container, index:int=-1)
		{
			super(parent, index);
		}
		
		override public function addComponent(child:Component,i:int=-1):void
		{
			super.addComponent(child,i);
			child.visible = false;
		}
		
		public function get showing():Component
		{
			return _showing;
		}
		
		public function show(c:Component, destroy_when_done:Boolean=false):void
		{		
			if (c==_showing)
				return;

			if(moving && _fading != null)
			{
				stop();
				if(_destroy_0)
				{
					removeComponent(_fading);
				}
				else
				{
					_fading.visible = false;
				}
			}			

			_fading 		= _showing;
			_destroy_0 		= _destroy_1;
			_showing 		= c;
			_destroy_1 		= destroy_when_done;
			_alphaoff.reset(0);
			_alphaoff.value = 1;
			animate([_alphaoff], S, on_complete);
		}
		
		override public function render():void
		{
			if (_showing != null)
			{
				_showing.alpha 		= _alphaoff.value;
				_showing.visible 	= true;
			}
			if (_fading != null)
			{
				_fading.alpha 		= Math.max(0, 1 - _alphaoff.value*3);
				_fading.visible 	= _fading.alpha > .05;
			}
			super.render();
		}
		
		private function on_complete():void
		{

			if (_fading!=null)
			{
				_fading.visible = false;
				if (_destroy_0)
				{
					removeComponent(_fading);
					_fading = null;
				}
				render();
			}
		}
		
		

	}
}
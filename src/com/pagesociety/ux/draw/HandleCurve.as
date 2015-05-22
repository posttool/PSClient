package com.pagesociety.ux.draw
{
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	
	import flash.display.Graphics;

	public class HandleCurve extends Component
	{
		private var _s:Number = 6;
		public function HandleCurve(parent:Container)
		{
			super(parent);
			add_mouse_over_default_behavior();
		}
		
		override public function render():void
		{
			var g:Graphics = decorator.midground.graphics;
			g.clear();
			g.beginFill(0,0);
			g.drawCircle(0,0,_s*2);
			g.beginFill(_over?0xff0000:0x00ff00,1);
			g.drawCircle(0,0,_s);
			super.render();
		}
		
	}
}
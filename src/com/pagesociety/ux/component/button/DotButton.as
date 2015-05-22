package com.pagesociety.ux.component.button
{
	import com.pagesociety.ux.component.Container;
	
	import flash.display.Graphics;
	
	public class DotButton extends SmallCircleButton
	{
		public function DotButton(parent:Container)
		{
			super(parent);
		}
		
		override public function render():void
		{
			var g:Graphics = decorator.midground.graphics;
			g.clear();
			draw_circle(g);
			g.beginFill(_over ? 0xffffff : 0, 1);
			g.drawCircle(7.5,7.5,2);
			super.render();
		}
		

	}
}
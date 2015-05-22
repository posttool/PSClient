package com.pagesociety.ux.component.button
{
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	
	import flash.display.Graphics;

	public class SmallCircleButton extends Component
	{
		public var overColor:uint = 0x555555;
		public var overAlpha:Number = 1;
		public var normalColor:uint = 0xaaaaaa;
		public var normalAlpha:Number = 1;
		public function SmallCircleButton(parent:Container)
		{
			super(parent);
			backgroundShadowSize 		= 3;
			backgroundShadowStrength 	= .1;
			height						= 15;
			width						= 15;
			add_mouse_over_default_behavior();
		}
		
	
		
		protected function draw_circle(g:Graphics):void
		{
			g.beginFill(0,0);
			g.drawCircle(width*.5,height*.5,width*.5);
			g.endFill();
			
			g.beginFill(_over?overColor:normalColor,_over?overAlpha:normalAlpha);
			g.drawCircle(width*.5,height*.5,width*.25);
			g.endFill();
		}
		
		
	}
}
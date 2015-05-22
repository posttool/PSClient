package com.pagesociety.ux.component.button
{
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.decorator.ShapeFactory;
	
	import flash.display.Graphics;
	
	public class CirclePlayButton extends SmallCircleButton
	{
		public var arrowNormalColor:uint = 0;
		public var arrowNormalAlpha:Number = 1;
		public var arrowOverColor:uint = 0x444444;
		public var arrowOverAlpha:Number = 1;

		public function CirclePlayButton(parent:Container)
		{
			super(parent);
			normalColor 				= 0xffffff;
			normalAlpha					= .7;
			overColor 					= 0xffffff;
			overAlpha					= 1;
			backgroundShadowSize 		= 18;
			backgroundShadowStrength 	= .4;
			backgroundShadowColor 		= 0xffffff;
		}
		
		override public function render():void
		{
			var g:Graphics = decorator.midground.graphics;
			g.clear();
			draw_circle(g);
			ShapeFactory.triangleLeft(g,width*.47,height*.43, width*.1, height*.15, _over ? arrowOverColor : arrowNormalColor, _over ? arrowOverAlpha : arrowNormalAlpha);
			super.render();
		}
		

	}
}
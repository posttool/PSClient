package com.pagesociety.ux.decorator
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	
	public class ShapeFactory
	{
		public static function chevron_left(g:Graphics, x:Number=0, y:Number=0, thickness:Number=2.5, width:Number=5, height:Number=8, color:uint=0, alpha:Number=1):void
		{
			g.beginFill(color,alpha);
			g.moveTo(x+width-thickness,y);
			g.lineTo(x+width,y);
			g.lineTo(x+thickness, y+height/2);
			g.lineTo(x+width,y+height);
			g.lineTo(x+width-thickness,y+height);
			g.lineTo(x, y+height/2);
			g.lineTo(x+width-thickness,y);
			g.endFill();
		}
		
		public static function chevron_right(g:Graphics, x:Number=0, y:Number=0, thickness:Number=2.5, width:Number=5, height:Number=8, color:uint=0, alpha:Number=1):void
		{
			g.beginFill(color,alpha);
			g.moveTo(x,y);
			g.lineTo(x+thickness,y);
			g.lineTo(x+width,y+height/2);
			g.lineTo(x+thickness,y+height);
			g.lineTo(x,y+height);
			g.lineTo(x+width-thickness,y+height/2);
			g.lineTo(x,y);
			g.endFill();
		}
		
		public static function chevron_down(g:Graphics, x:Number=0, y:Number=0, thickness:Number=2.5, width:Number=8, height:Number=5, color:uint=0, alpha:Number=1):void
		{
			g.beginFill(color,alpha);
			g.moveTo(x,y);
			g.lineTo(x,y+thickness);
			g.lineTo(x+width/2,y+height);
			g.lineTo(x+width,y+thickness);
			g.lineTo(x+width,y);
			g.lineTo(x+width/2,y+height-thickness);
			g.lineTo(x,y);
			g.endFill();
		}
		
		public static function chevron_up(g:Graphics, x:Number=0, y:Number=0, thickness:Number=2.5, width:Number=8, height:Number=5, color:uint=0, alpha:Number=1):void
		{
			g.beginFill(color,alpha);
			g.moveTo(x,				y+height-thickness);
			g.lineTo(x+width/2,		y);
			g.lineTo(x+width,		y+height-thickness);
			g.lineTo(x+width,		y+height);
			g.lineTo(x+width/2,		y+thickness);
			g.lineTo(x,				y+height);
			g.moveTo(x,				y+height-thickness);
			g.endFill();
		}
		
		public static function grid(g:Graphics,xo:Number,yo:Number,w:Number,h:Number):void
		{
			var p:Number;
			var a:Number;
			if (w<70) {
				p = 2; a = .3;
			} else if (w<130) {
				p = 3; a = .4;
			} else if (w<200) {
				p = 4; a = .5;
			} else {
				p = 5; a = .6;
			}
			for (var x:uint=0; x < 16; x++)
				for (var y:uint=0; y<16; y++)
					plus(g, x*w+xo, y*h+yo, p, a);
		}
		


		public static function plus(g:Graphics, x:Number, y:Number, plus_size:Number=4, color:Number=0xffffff, alpha:Number=.5, thickness:Number=1):void
		{
			g.clear();
			g.lineStyle(thickness,color,alpha,false,LineScaleMode.NORMAL,CapsStyle.SQUARE);
			g.moveTo(x,y-plus_size);
			g.lineTo(x,y+plus_size);
			g.moveTo(x-plus_size, y);
			g.lineTo(x+plus_size,y);
			g.lineStyle();
			g.beginFill(0xff0000,0);
			g.drawRect(x-plus_size-thickness,y-plus_size-thickness,(plus_size+thickness)*2,(plus_size+thickness)*2);
			g.endFill();
		}
		
		public static function minus(g:Graphics, x:Number, y:Number, minus_size:Number=4, color:Number=0xffffff, alpha:Number=.5, thickness:Number=1):void
		{
			g.clear();
			g.lineStyle(thickness,color,alpha,false,LineScaleMode.NORMAL,CapsStyle.SQUARE);
			g.moveTo(x-minus_size, y);
			g.lineTo(x+minus_size,y);
			g.lineStyle();
			g.beginFill(0xff0000,0);
			g.drawRect(x-minus_size-thickness,y-minus_size-thickness,(minus_size+thickness)*2,(minus_size+thickness)*2);
			g.endFill();
		}
		
		public static function x(g:Graphics, x:Number, y:Number, x_size:Number=4, color:Number=0xffffff, alpha:Number=.5, thickness:Number=1):void
		{
			g.lineStyle(thickness,color,alpha,false,LineScaleMode.NONE,CapsStyle.SQUARE);
			g.moveTo(x,y);
			g.lineTo(x+x_size,y+x_size);
			g.moveTo(x+x_size, y);
			g.lineTo(x,y+x_size);
			g.lineStyle();
			g.beginFill(0,0);
			g.drawRect(x,y,x_size,x_size);
			g.endFill();
		}
		
		
		//////////////
		public static function arrow(g:Graphics, x0:Number, y0:Number, r0:Number, r1:Number, t0:Number, t1:Number, color:uint=0, alpha:Number=1, line_weight:Number=1):void
		{
			g.lineStyle(line_weight,color,alpha,true);
			var x:Number;
			var y:Number;
			x = r0 * Math.cos( t0 );
			y = r0 * Math.sin( t0 );
			g.moveTo(x0+0,y0+0); 
			g.lineTo(x0+x,y0+y);
			x = r1 * Math.cos( t0-t1 );
			y = r1 * Math.sin( t0-t1 );
			g.moveTo(x0+x,y0+y); 
			g.lineTo(x0+0,y0+0);
			x = r1 * Math.cos( t0+t1 );
			y = r1 * Math.sin( t0+t1 );
			g.lineTo(x0+x,y0+y);
		}
		
		
		public static function arrowNorthEast(g:Graphics, x:Number, y:Number, size:Number, color:uint, alpha:Number=1,thickness:Number=1):void
		{
			arrow(g,x+size,y,size,size*.6,Math.PI*.75,Math.PI*.25,color,alpha,thickness);
		}
		
		public static function arrowNorthWest(g:Graphics, x:Number, y:Number, size:Number, color:uint, alpha:Number=1,thickness:Number=1):void
		{
			arrow(g,x,y,size,size*.6,Math.PI*.25,Math.PI*.25,color,alpha,thickness);
		}
		
		public static function arrowSouthEast(g:Graphics, x:Number, y:Number, size:Number, color:uint, alpha:Number=1,thickness:Number=1):void
		{
			arrow(g,x+size,y+size,size,size*.6,Math.PI*1.25,Math.PI*.25,color,alpha,thickness);
		}

		public static function arrowUp(g:Graphics, x:Number, y:Number, size:Number, color:uint, alpha:Number=1,thickness:Number=1):void
		{
			arrow(g,x,y,size,size*.6,Math.PI*.5,Math.PI*.25,color,alpha,thickness);
		}
		
		public static function arrowDown(g:Graphics, x:Number, y:Number, size:Number, color:uint, alpha:Number=1,thickness:Number=1):void
		{
			arrow(g,x,y+size,size,size*.6,-Math.PI*.5,Math.PI*.25,color,alpha,thickness);
		}
		
		public static function arrowRight(g:Graphics, x:Number, y:Number, size:Number, color:uint, alpha:Number=1,thickness:Number=1):void
		{
			arrow(g,x,y,size,size*.6,Math.PI,Math.PI*.25,color,alpha,thickness);
		}
		
		public static function arrowLeft(g:Graphics, x:Number, y:Number, size:Number, color:uint, alpha:Number=1,thickness:Number=1):void
		{
			arrow(g,x,y,size,size*.6,0,Math.PI*.25,color,alpha,thickness);
		}
		
		
		//
		public static function triangleLeft(g:Graphics, x:Number, y:Number, width:Number=5, height:Number=10, color:Number=0xffffff, alpha:Number=1):void
		{
			g.beginFill(color,alpha);
			g.moveTo(x,y);
			g.lineTo(x+width,y+height/2);
			g.lineTo(x,y+height);
			g.lineTo(x,y);
			g.endFill();
		}
		
		public static function triangleRight(g:Graphics, x:Number, y:Number, width:Number=5, height:Number=10, color:Number=0xffffff, alpha:Number=1):void
		{
			g.beginFill(color,alpha);
			g.moveTo(x+width,y);
			g.lineTo(x,y+height/2);
			g.lineTo(x+width,y+height);
			g.lineTo(x+width,y);
			g.endFill();
		}

	}
}
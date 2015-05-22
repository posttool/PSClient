package com.pagesociety.ux.decorator
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class Box extends Sprite
	{
		private var _visible:Boolean = true;

		private var _show_box:Boolean = false;
		private var _show_border:Boolean = false;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _corner_radius:Number = 0;
		private var _color:uint = 0x00ff00;
		private var _alpha:Number = 1;
		private var _border_thickness:Number = 1;
		private var _border_alpha:Number = 1
		private var _border_color:Number = 0
		private var _blur_quality:Number = 0;
		
		
		//
		
		public function Box()
		{
			super();
		}
		

	
		
		override public function set visible(b:Boolean):void
		{
			_visible = b;
		}

		override public function get visible():Boolean
		{
			return _visible;
		}

		public function set boxVisible(b:Boolean):void
		{
			_show_box = b;
		}

		public function get boxVisible():Boolean
		{
			return _show_box;
		}
		
		public function set borderVisible(b:Boolean):void
		{
			_show_border = b;
		}

		public function get borderVisible():Boolean
		{
			return _show_border;
		}
		

		
		override public function set x(x:Number):void
		{
			_x = x;
		}

		override public function get x():Number
		{
			return _x;
		}

		override public function set y(y:Number):void
		{
			_y = y;
		}

		override public function get y():Number
		{
			return _y;
		}

		override public function set width(w:Number):void
		{
			_width = w;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set height(h:Number):void
		{
			_height = h;
		}

		override public function get height():Number
		{
			return _height;
		}

		public function set cornerRadius(c:uint):void
		{
			_corner_radius = c;
		}
		
		public function get cornerRadius():uint
		{
			return _corner_radius;
		}

		public function set color(c:uint):void
		{
			_color = c;
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		override public function set alpha(a:Number):void
		{
			_alpha = a;
		}
		
		override public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set borderAlpha(a:Number):void
		{
			_border_alpha = a;
		}
		
		public function get borderAlpha():Number
		{
			return _border_alpha;
		}
		
		public function set borderThickness(a:Number):void
		{
			_border_thickness = a;
		}
		
		public function get borderThickness():Number
		{
			return _border_thickness;
		}
		
		public function set borderColor(c:uint):void
		{
			_border_color = c;
		}
		
		public function get borderColor():uint
		{
			return _border_color;
		}
		
		
		public function decorate():void
		{
			graphics.clear();
			super.visible = _visible;
			if (!_visible)
			{
				return;
			}
			
			if (_show_box)
			{
				graphics.beginFill(_color, _alpha);
	        	if (_corner_radius==0)
	        		graphics.drawRect(_x, _y, _width, _height);
	        	else
	        		graphics.drawRoundRect(_x, _y, _width, _height, _corner_radius, _corner_radius);
	        	graphics.endFill();
			}
			
			if (_show_border) 
			{
				//public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void
				graphics.lineStyle(_border_thickness, _border_color, _border_alpha, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER); 
				if (_corner_radius==0)
	        		graphics.drawRect(_x, _y, _width, _height);
	        	else
	        		graphics.drawRoundRect(_x, _y, _width, _height, _corner_radius, _corner_radius);
	        }
			
		}
		
		override public function toString():String
		{
			return "[Box {visible="+_visible+" showBox="+_show_box+" showBorder="+_show_border+"}]";
		}
		
		
		//
		private function drawGradientA(mc:Sprite, W:Number, H:Number):void
		{ 
			var fillType:String = "linear";
			var colors:Array = [0xffffff, 0xaaaaaa];
			var alphas:Array = [100, 100];
			var ratios:Array = [0, 255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(_width, _height, 90/180*Math.PI);
			mc.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix);
			mc.graphics.drawRect(_x, _y, _width, _height);
			mc.graphics.endFill();
		}

	}
}
package com.pagesociety.ux.decorator
{
	
	import flash.display.Graphics;
	
	public class ProgressDecorator extends Decorator
	{
		protected var _progress:Number = 0;
		protected var _c:uint = 0;
		
		public function ProgressDecorator()
		{
			super();
			
		}
		
		override public function decorate():void
		{
			updatePosition(x,y);
			var g:Graphics = midground.graphics;
            g.clear();
            if (!_visible)
            	return;
            g.beginFill(_c,.3);
            g.drawRect(0,0,width,height);
            g.endFill();
            if (_progress!=0)
			{
	            g.lineStyle(0,0,0);
	            g.beginFill(_c,1);
	            g.drawRect(0,0,width*_progress,height);
	            g.endFill();
            }
            
		}
		
		public function set progress(p:Number):void
		{
			_progress = p
		}
		
		override public function set color(c:uint):void
		{
			_c = c;
		}
		
		override public function get color():uint
		{
			return _c;
		}
		
	}
}
package com.pagesociety.ux.component
{
	import com.pagesociety.ux.decorator.Decorator;
	import com.pagesociety.ux.decorator.ProgressDecorator;
	
	import flash.net.FileReference;

	public class Progress extends Container
	{
		protected var _pdec:ProgressDecorator;
		protected var _progress:Number;
		public var fileReference:FileReference;

		public function Progress(parent:Container, file_ref:FileReference=null, index:int=-1)
		{
			super(parent, index);
			fileReference = file_ref;
			decorator = new ProgressDecorator();
		}
		
		override public function set decorator(new_decorator:Decorator):void
		{
			_pdec = new_decorator as ProgressDecorator;
			super.decorator = new_decorator;
		}
		
		public function set progress(p:Number):void
		{
			_progress = p;
			_pdec.progress = p;
		}
		
		public function get progress():Number
		{
			return _progress;
		}
		
		public function set color(c:uint):void
		{
			_pdec.color = c;
		}
		
	}
}
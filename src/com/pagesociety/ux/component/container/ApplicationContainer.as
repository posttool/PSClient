package com.pagesociety.ux.component.container
{
	import com.pagesociety.ux.Application;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.decorator.RootDecorator;
	
	import flash.display.Sprite;

	public class ApplicationContainer extends Container
	{
		public function ApplicationContainer(app:Application)
		{
			super(null);
			_application = app;
			_decorator = new RootDecorator();
			_application.addChild(_decorator as Sprite);
		}
		
	}
}
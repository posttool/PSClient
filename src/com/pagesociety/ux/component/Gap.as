package com.pagesociety.ux.component
{
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;

	public class Gap extends Component
	{
		public function Gap(parent:Container, size:Number)
		{
			super(parent);
			width = size;
			height = size;
			//decorator=null;
		}
		
	}
}
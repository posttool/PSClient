package com.pagesociety.ux.component.form
{
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Input;

	public class NumberEditor extends Input
	{
		public function NumberEditor(parent:Container)
		{
			super(parent);
			restrict = "0-9.\\-";
		}
		
		override public function get value():Object
		{
			if (isNaN(super.value as Number))
				return 0;
			return Number(super.value);
		}
		
		
		
	}
}
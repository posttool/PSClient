package com.pagesociety.ux.system
{
	public class SystemStyleProps
	{
		private var _props:Object;
		
		public function SystemStyleProps(props:Object)
		{
			if (!props.hasOwnProperty("name"))
				throw new Error("SystemStyleProps name is required");
			if (!props.hasOwnProperty("sections"))
				throw new Error("SystemStyleProps sections is required");
			if (!(props.sections is Array))
				throw new Error("SystemStyleProps sections must be an Array");
			//could do smore validation...
			_props = props;
		}
		
		public function get props():Object
		{
			return _props;
		}
		
		public function get name():String
		{
			return _props.name;
		}
		
		public function get sections():Array
		{
			return _props.sections;
		}
		
		public function getConvertionInfo(old_version:uint, new_version:uint):Object
		{
			return _props["convertionInfo"+old_version+"to"+new_version];
		}
		
		
	}
}
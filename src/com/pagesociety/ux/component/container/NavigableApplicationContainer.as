package com.pagesociety.ux.component.container
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.event.ComponentEvent;
	
	import flash.external.ExternalInterface;

	public class NavigableApplicationContainer extends Container
	{
		private var _pending_navigation:NavigationInfo;


		public function NavigableApplicationContainer(parent:Container)
		{
			super(parent);
		}
		
		
		/////////////////////////////////////////////////////////////////////
		// 'deep' linking 
		protected function on_everything_ready(e:ComponentEvent=null):void
		{
			//let swf address take over (note: on_address_change is automatically fired when the event is bound below)
			if (parent.parent==null)
				SWFAddress.addEventListener(SWFAddressEvent.CHANGE, on_address_change);
		}
		
		private function on_address_change(e:SWFAddressEvent=null):void
		{
			_pending_navigation = get_address_args_from_url(SWFAddress.getValue());
			var ok:Boolean = ok_to_go(on_address_change);
			if (!ok)
				return;
			ExternalInterface.call("pageTracker._trackPageview('#"+_pending_navigation.url+"')");
			create_ui(_pending_navigation);
		}
		
		public function createUi(address:NavigationInfo):void
		{
			create_ui(address);
		}
		
		protected function create_ui(address:NavigationInfo):void
		{
			throw new Error("ApplicationRoot.create_ui is abstract. Please extend this class and overload this function.");
		}
		
		// overload to block state changes
		protected function ok_to_go(try_again:Function):Boolean
		{
			return true;
		}
		
		public function navigate(address:String=null, args:*=null):void
		{
			//application.alert('address is '+address);
			if (address == null && args != null && _pending_navigation != null)
				address = _pending_navigation.address;
			if (address != null)
			{
				if (args==null)
					args = new Array();
				_pending_navigation = new NavigationInfo();
				_pending_navigation.address = address;
				_pending_navigation.args = args;
				_pending_navigation.url = get_url_from_address_args(address, args);
				//application.alert('pending url is '+_pending_navigation.url);
			}
			var ok:Boolean = ok_to_go(navigate);
			if (!ok)
				return;
			do_navigate();
		}
		
		public function navigateBack():void
		{
			SWFAddress.back();
		}
		
		public function get navigationInfo():NavigationInfo
		{
			return _pending_navigation;
		}
		
		private function do_navigate():void
		{
			if (_pending_navigation==null || _pending_navigation.url==null)
				throw new Error("_pending must be set before calling do_navigate"); 
			
			//trace(">NavigableAppContainer "+_pending_navigation.address+" ... "+_pending_navigation.url);
			ExternalInterface.call("pageTracker._trackPageview('#"+_pending_navigation.url+"')");
			SWFAddress.setValue(_pending_navigation.url);
			//_pending = null;
		}
		
		private function get_address_args_from_url(s:String):NavigationInfo
		{
			var p:NavigationInfo = new NavigationInfo();
			p.url = s;
			var ss:Array = s.split("/");
			ss.shift(); // throw first away
			p.address = ss.shift();
			for (var i:uint=0; i<ss.length; i++)
			{
				if (ss[i]=="null")
					ss[i]=null;
			}
			p.args = ss;
			return p;
		}
		
		private function get_url_from_address_args(addr:String, args:Array):String
		{
			var s:String  = addr;
			if (args!=null)
				for (var i:uint=0; i<args.length; i++)
					s+="/"+args[i];
			return s;
		}
		
	}
	
		
}



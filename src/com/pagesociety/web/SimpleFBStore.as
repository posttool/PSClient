package com.pagesociety.web
{
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	public class SimpleFBStore
	{
		private var _fbuid:String;
		private var _base_url:String;
		public function SimpleFBStore(fbuid:String,base_url:String)
		{
			_fbuid = fbuid;
			_base_url = base_url;
		}

		// util
		
		public function get_prop(key:String,callback:Function):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function (e:Event):void
			{
				callback(e.target.data);
			});
			var url:String = _base_url+"/store.php?action=get&fbuid="+_fbuid+"&key="+key+"&___t="+Math.random();
			Logger.log("get_prop "+url);
			loader.load(new URLRequest(url));
		}
		
		public function put_prop(key:String,value:String,callback:Function):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function (e:Event):void
			{
				callback(e.target.data);
			});
			var url:String = _base_url+"/store.php?action=put&fbuid="+_fbuid+"&key="+key+"&value="+escape(value)+"&___t="+Math.random();
			//Logger.log("put_prop "+url);
			loader.load(new URLRequest(url));
		}
		
		public function parse_int(v:Object):int
		{
			var i:int = v is String ? parseInt(v as String) : v as int;
			if (isNaN(i))
				i = 0;
			return i;
		}
		
		public function decode(s:String):Object
		{
			var quote_exp:RegExp = /\\\"/g;
			var f:String = s.replace(quote_exp, "\""); // maybe do it on the server...?
			return JSON.parse(f);
		}
		
	}
}
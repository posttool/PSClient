package com.pagesociety.web
{
	import flash.events.EventDispatcher;
	
	/**
 		var r:Object = 
			{
				requests: 
					[
						[ "System/GetGlobalSystems", [0, 500] ],
						[ "System/GetUserSystems", [0, 500] ],
						[ "System/GetCurrentEditSystem", [] ]
					],
				forEach: ["System/GetResourceURLs"]
			}
	 */
	public class ModuleRequests extends EventDispatcher
	{
		private var _requests:Object;
		private var _request_load_index:uint = 0;
		private var _results:Array;
		private var _load_complete:Function;
		private var _error:Function;
		
		public function ModuleRequests(load_complete:Function, error:Function)
		{
			_load_complete = load_complete;
			_error = error;
		}
		
		public function processRequest(r:Object):void
		{
			_requests = r;
			_request_load_index = 0;
			_results = new Array();
			do_request();
		}
		
		private function do_request():void
		{
			if (_request_load_index >= _requests.requests.length)
			{
				_load_complete(_results);
				return;
			}
			var r:Object = _requests.requests[_request_load_index];
			var m:ModuleRequest = new ModuleRequest(r[0], r[1]);
			m.addErrorHandler(err);
			m.addResultHandler(ok);
			m.execute();
		}
		
		private function ok(result:Object):void
		{
			_results.push(result);
			
			_request_load_index++;
			if (_requests.forEach != null)
				for_each();
			else
				do_request();
		}
		
		private function for_each():void
		{
			throw new Error("FOR EACH NOT OK RIGHT NOW");
			var r:Array = _requests.forEach;
			var t:Object = _results[_results.length-1];
			// if it is a paging query results (t.entities!=null)
			try {
			if (t.entities != null)
				t = t.entities;
			} catch (e:Error) {}
			if (t==null)
			{
				do_request();
				return;
			}
//			if (r.length == 1)
//				ObjectUtil.fillResourceUrls(t, -1, -1,  on_url);
//			else
//				ObjectUtil.fillResourceUrls(t, r[1], r[2], on_url);
		}

		
		private function on_url(o:Object):void
		{
			do_request();
		}
		
		private function err(e:ErrorMessage):void
		{
			_error(e);
		}

	}
}
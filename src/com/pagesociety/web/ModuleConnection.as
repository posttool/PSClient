package com.pagesociety.web
{
	public class ModuleConnection
	{
		public function ModuleConnection()
		{
		}
		
		public static function doModule(mm:String, a:Array, ok:Function, err:Function,concurrentOk:Boolean=false):void
		{
			if (err==null)
				err = function(e:*):void 
						{ 
							throw new Error("ERROR "+ModuleRequest.SERVICE_URL+" "+mm+"("+a.join(",")+") "+e.message); 
						}
			ModuleRequest.doModule(mm,a,ok,err,concurrentOk);
		}

	}
}
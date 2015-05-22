package com.pagesociety.web
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.util.ObjectUtil;
	import com.pagesociety.web.module.Resource;
	
	import flash.system.Security;
	
	public class PathProvider
	{
		private var base_url:String;
		
		public function PathProvider(s3_bucket:String):void
		{
			if (s3_bucket.indexOf("http://")==0)
			{
				var s:Array = s3_bucket.split("/");
				Security.loadPolicyFile("http://"+s[2]+"/crossdomain.xml");
				base_url = s3_bucket;
			}
			else
			{
				Security.loadPolicyFile("http://"+s3_bucket+".s3.amazonaws.com/crossdomain.xml");
				base_url = "http://"+s3_bucket+".s3.amazonaws.com/";
			}
			if (base_url.charAt(base_url.length-1)!="/")
				base_url += "/";
		}
		
		public function getPath(resource:Entity,options:Object):String
		{
			var path_token:String = resource.$[Resource.RESOURCE_FIELD_PATH_TOKEN];
			if (path_token==null)
				return null;
			
			var preview_name:String = new String();
			if (options==null || options.width==null || options.height==null || options.width<1 || options.height<1)
			{
				preview_name = path_token;
			}
			else
			{
				var dot_idx:int = path_token.lastIndexOf('.');
				var ext:String = "jpg";
				if(dot_idx != -1 && path_token.length-1 > dot_idx)
				{
					ext = path_token.substring(dot_idx+1).toLowerCase();
					path_token = path_token.substring(0,dot_idx);
				}
				preview_name += (path_token);
				preview_name += getOptionsSuffix(options, ext);
			}
			//trace(">>>>>"+base_s3_url+preview_name);
			return base_url+preview_name;
		}
		
		public static function getOptionsSuffix(options:Object,ext:String):String
		{
			var c:uint=0;
			if (options.type!=null)
			{
				ext = options.type;
			}
			for (var p:String in options)
			{
				if (p=='type')
					continue;
				c++;
			}
			if (c == 2 && options.width!=null && options.height!=null)
			{
				return '_' + options.width + 'x' + options.height + "." + ext;
			}
			var s:Array = [];
			for (p in options)
			{
				if (p=='type')
					continue;
				s.push(p);
			}
			s.sort();
			var b:String = "";
			for (var i:uint=0; i<s.length; i++)
			{
				b += (s[i]);
				b += ('.');
				b += (options[s[i]]);
				b += ('_');
			}
			return '_' + b.substring(0, b.length - 1) + "." + ext;
		}
		
//		public function getPreviewUrls(o:Object,width:int,height:int):void
//		{
//			if (o==null)
//			{
//				return;
//			}
//			var i:uint;
//			if (o is Array)
//			{
//				var results:Array = o as Array;
//				for (i=0; i<results.length; i++)
//					fill_e(results[i],width,height);
//			}
//			else if (o is Entity)
//			{
//				fill_e(o as Entity,width,height);
//			}
//			else
//			{
//				throw new Error("Can't fill that kind of thing");
//			}
//		}  
//		
//		private function fill_e(e:Entity,width:int,height:int):void
//		{
//			
//			if (e==null)
//				return;
//			var i:uint;
//			var j:uint;
//			if (ObjectUtil.isResource(e))
//			{
//				e.$.url = getPath(e,width,height);
//			}
//			else
//			{
//				for (var p:String in e.attributes)
//				{
//					var o:Object = e.$[p];
//					if (o is Entity)
//						fill_e(o as Entity,width,height);
//					else if (o is Array && o.length!=0 && o[0] is Entity)
//						for (j=0; j<o.length; j++)
//							fill_e(o[j],width,height);
//				}
//						
//			}
//		}

	}
}
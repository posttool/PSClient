package com.pagesociety.ux.system
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.util.StringUtil;
	import com.pagesociety.web.amf.AmfLong;
	
	public class SystemUtil
	{
		
		public static function getPropsAsString(o:Object):String
        {
        	var s:String = "{\n";
        	for (var p:String in o)
        	{
        		s += "\t"+p+": ";
        		if (o[p] is Number)
	        		s += o[p];
	        	else if (o[p] is String)
	        		s += o[p];
	        	else if (o[p] is Entity)
	        		s += o[p].id.longValue;
        		s += ";\n";
        	}
        	s+="}";
        	return s;
        }


		public static function setSystemDataString(s:String, props:Array):Object
		{
			var o:Object = new Object();
			var lines:Array = s.split("\n");
			for (var i:uint=1; i<lines.length-1; i++)
			{
				var nv:Array = lines[i].split(":");
				var n:String = StringUtil.trim(nv[0]);
				var v:String = StringUtil.trim(nv[1].substring(0,nv[1].indexOf(";")));  
				var prop:Object = get_prop_by_name(props,n);
				if (prop==null)
					continue;
            	switch (prop.type)
            	{
					case SystemProperty.TYPE_COLOR:
					case SystemProperty.TYPE_INTEGER:
						o[prop.name] = parseInt(v);
						break;
					case SystemProperty.TYPE_NUMBER:
						o[prop.name] = parseFloat(v);
						break;
//					case SystemProperty.TYPE_COLOR_PALETTE:
					case SystemProperty.TYPE_STRING:
					case SystemProperty.TYPE_FONT:
						o[prop.name] = v;
						break;
					case SystemProperty.TYPE_IMAGE:
						o[prop.name] = createResourceEntity(v);
						break;
            	}
			}
			return o;
		}
		
		private static function get_prop_by_name(props:Array,n:String):Object
		{
			for (var j:uint=0; j<props.length; j++)
            {
            	var prop:Object = props[j];
            	if (prop==null || prop is Number)
            		continue;
            	if (prop.name==n)
            		return prop;
            }
            return null;
		}
		
		
		
		public static function createResourceEntity(id:String):Entity
		{
			if (id=="" || isNaN(Number(id)))
				return null;
			var e:Entity = new Entity("SystemSupportResource");
			e.id = new AmfLong(parseInt(id));
			e.$["simple-type"] = "IMAGE"
			return e;
		}
	
		//...?
//		public static function transformColorPaletteProps(system:ISystemApplication, props:Object):Object
//		{
//			for (var p:String in props)
//			{
//				var prop_def:Object = system.getSystemPropertyValue(p);
//				if (prop_def==null)
//					continue;
//				if (prop_def.type == SystemProperty.TYPE_COLOR_PALETTE)
//				{
//					var s:String = props[p];
//					for (var i:uint = 0; i<prop_def.valueDescriptions.length; i++)
//					{
//						if (s == prop_def.valueDescriptions[i])
//						{
//							props[p] = prop_def.values[i];
//							break;
//						}
//					}
//				}
//			}
//			return props;
//		}
		
		
	
		
	}
}
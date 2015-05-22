package com.pagesociety.util
{
	public class XMLUtil
	{
		
		public static function rebuild(x:XML, exclude:Array, excluded:Array=null):XML
		{
			var root:XML = <ROOT/>
			rebuild0(root, x, exclude, excluded);
			return root;
		}
		
		private static function rebuild0(p:XML, x:XML, exclude:Array, exclded:Array):void
		{
			var xc:XML = p;
			if (excluded(x.name(),exclude))
			{
				if (exclded!=null) exclded.push(x);
				xc = x.copy();
				if (xc.children()!=null)
					xc.setChildren(new XMLList());
				p.appendChild(xc);
			}
			for each (var c:XML in x.children())
			{
				rebuild0(xc, c, exclude, exclded);
			}
		}
		
		public static function add_space_to_empty_ps(x:XML):void
		{
			if (x.name()=="P" && x.children().length()==0)
			{
				x.appendChild(new XML(" "));
			}
			for each (var c:XML in x.children())
			{
				add_space_to_empty_ps(c);
			}
		}
		
		public static function remove_events_from_as(x:XML):void
		{
			if (x.name()=="A" )
			{
				if (x.@HREF.indexOf("event:")==0)
					x.@HREF = x.@HREF.substring(6);
				x.@TARGET = "postera_link";
			}
			for each (var c:XML in x.children())
			{
				remove_events_from_as(c);
			}
		}
		
		public static function add_events_to_as(x:XML):void
		{
			if (x.name()=="A" )
			{
				if (x.@HREF.indexOf("event:")!=0)
					x.@HREF = "event:"+x.@HREF;
			}
			for each (var c:XML in x.children())
			{
				add_events_to_as(c);
			}
		}
		
		private static function excluded(name:String, names:Array):Boolean
		{
			return names.indexOf(name)==-1;
		}

	}
}
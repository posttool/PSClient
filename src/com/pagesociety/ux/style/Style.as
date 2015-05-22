package com.pagesociety.ux.style
{
	import com.pagesociety.util.ObjectUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	
	import org.antlr.runtime.ANTLRStringStream;
	import org.antlr.runtime.CommonTokenStream;
	import org.antlr.runtime.ParserRuleReturnScope;
	
	public class Style
	{
		private var loader:URLLoader;
		private var _style_sheet:StyleSheet;
		private var _const_map:Object = {};
		private var _callback:Function;
		
		public function Style(css:String):void
		{
			parse(css);
		}
		
        
        public function parse(css:String):void 
		{
			var lexer:PSStyleSheetLexer = new PSStyleSheetLexer (new ANTLRStringStream(css));
			var tokens:CommonTokenStream = new CommonTokenStream(lexer);

			var parser:PSStyleSheetParser = new PSStyleSheetParser(tokens);
			var r:ParserRuleReturnScope = parser.prog();

			if (_style_sheet==null)
				_style_sheet = new StyleSheet(); 
			
			
			var styles:Array = r.tree.children;
			for (var i:uint=0; i<styles.length; i++)
			{
				var s:* = styles[i];
				var style_name:String = "";
				var c:uint = 0;
				while (s.children[c].type!=PSStyleSheetParser.TBODY)
				{
					style_name += s.children[c].text;
					c++;
				}
				var b:* = s.children[c];
				if (b.children!=null)
				{
					var o:* = new Object();
					for (var j:uint=0; j<b.children.length; j++)
					{
						var prop:* = b.children[j]
						var name:String = prop.children[0].text;
						var val:String = "";
						for (var k:uint=1; k<prop.children.length; k++)
						{
							val += prop.children[k].text;
							if (k!=prop.children.length-1)
								val += " ";
						}
						o[name] = val;
						if (val is String)
						{
							// collect constant properties (starting with underscore '_')
							var C:String = val as String;
							if (C.charAt(0)=="_")
							{
								if (_const_map[C]==null)
									_const_map[C] = new Array();
								_const_map[C].push([style_name,name]);
							}
						}
					}
					
					if (getStyle(style_name)!=null)
						trace("Stylesheet style "+style_name+" exists...");
					
					_style_sheet.setStyle(style_name, o);
					
				}
			}
			if (_callback!=null)
				_callback();
 		}
 		
 		public static function xx(a:*, s:String=""):void
 		{
 			trace(s+a.text);
 			if (a.children!=null)
	 			for (var i:uint=0; i<a.children.length; i++)
 					xx(a.children[i], s+"  ");
 		}
        
        public function get styleSheet():StyleSheet
		{
			return _style_sheet;
		}
		
		public function setStyleConstantColorValue(name:String, value:uint):void
		{
			setStyleConstantValue(name, "#"+value.toString(16));
		}
		
		//DEPRECATED//JUST CREATE THE FONT//SEE setFontStyle
		public function setStyleConstantValue(name:String, value:Object):void
		{
			// for all uses in map
			var a:Array = _const_map[name];
			if (a==null)
			{
				//Logger.error("No such style constant "+name);
				return;
			}
			for (var i:uint=0; i<a.length; i++)
			{
				var style_name:String = a[i][0];
				var prop_name:String = a[i][1];
				var o:Object = _style_sheet.getStyle(style_name);
				o[prop_name] = value;
				_style_sheet.setStyle(style_name, o);
			}
		}
		
		public function setFontStyle(name:String, font:Object):void
		{
			var fo:Object = {};
			if (font.font_face==null || font.size==null)
				throw new Error("Invalid font definition");
			fo.fontFamily = font.font_face;
			fo.fontSize = String(font.size);
			if (font.color!=null)
				fo.color = "#"+font.color.toString(16);
			if (font.tracking!=null)
				fo.letterSpacing = String(font.tracking);
			if (font.leading!=null)
				fo.leading = String(font.leading-font.size);
			_style_sheet.setStyle(name, fo);
		}
		
		public function getStyle(s:String):Object
		{
			if (_style_sheet==null || s==null)
				return null;
			
			var style:Object = _style_sheet.getStyle(s);
			var c:uint = 0;
			for (var p:String in style) { c++; }
			if (c==0)
				return null;
			return style;
		}
		
		public function getStyleValue(style_name:String,prop_name:String):Object
		{
			var o:Object = getStyle(style_name);
			if (o==null)
				return null;
			var v:Object = o[prop_name];
			if (v.indexOf("#")==0)
				return parseInt(v.subtring(1),16);
			else
				return v;
		}
		
		public function apply(target:Object,style:Object):void
		{
			for (var p:String in style)
			{
				var type:Object = ObjectUtil.getAccessorType(target, p);
				var style_value:* = style[p]; // starts as a string
				//trace(">"+type+" "+style_value);
				if (type=="Boolean")
				{
					style_value = (style_value is Boolean) ? style_value : style_value=="true";
				}
				else if (type=="uint" && style_value is String && style_value.substring(0,1)=="#")
				{
					style_value = parseInt(style[p].toString().substring(1), 16);
				}
				
				ObjectUtil.setProperty(target, p, style_value);
			}
		}

	}
}
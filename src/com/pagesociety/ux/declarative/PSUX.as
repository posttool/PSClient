package com.pagesociety.ux.declarative
{
	import com.pagesociety.ux.component.Button;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Input;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.antlr.runtime.*;
	
	public class PSUX extends Container
	{
		private var loader:URLLoader;
		
		public function PSUX(p:Container)
		{
			super(p);
			
//			Style.init("css/testz.css", read_z, function(){trace("CANTREADCSS");});
		}
		
		private function read_z():void
		{
			var req:URLRequest = new URLRequest("test.z");
			loader = new URLLoader();
            loader.load(req);

//            loader.addEventListener(IOErrorEvent.IO_ERROR, err_callback);
            loader.addEventListener(Event.COMPLETE, parse);
            
		}
		
		public function parse(e:Event):void 
		{
			var lexer:PSUXLexer = new PSUXLexer (new ANTLRStringStream(loader.data));
			var tokens:CommonTokenStream = new CommonTokenStream(lexer);

			var parser:PSUXParser = new PSUXParser(tokens);
			var r:ParserRuleReturnScope = parser.prog();
			var root:Object = r.tree.children[0];

			get_component(this,root);
			render();
 		}
 		
 		public static function xx(a:*, s:String=""):void
 		{
 			trace(s+a.text);
 			if (a.children!=null)
	 			for (var i:uint=0; i<a.children.length; i++)
 					xx(a.children[i], s+"  ");
 		}


 		private function get_component(parent:Container,a:*):Component
 		{
 			var type:String = a.children[0];
 			var name:String = a.children[1];
 			var body:* = a.children[a.children[1].type==PSUXParser.TBODY ? 1 : 2];
 			
 			var c:Component;
 			if (type == "Container")
 				c = new Container(parent);
 			else if (type == "Input")
 				c = new Input(parent);
 			else if (type == "Button")
 				c = new Button(parent);
 			c.id = name;
 				
 			if (body!=null) 
 			{
 				var p:Object = new Object();
	 			for (var i:uint=0; i<body.children.length; i++)
	 			{
	 				switch (body.children[i].type)
	 				{
	 					case PSUXParser.TPROP_SIMPLE:
	 						p[body.children[i].children[0].text] = body.children[i].children[1].text;
	 						break;
	 					case PSUXParser.TBLOCK:
			 				if (c is Container)
			 					get_component(c as Container, body.children[i]);
	 						break;	 					
	 				}
	 			}
	 			application.style.apply(c,p);
 			}
 			return c;
 		}
 		
 		
		
	}
}
package com.pagesociety.util
{

	import com.pagesociety.ux.IApplication;
	import com.pagesociety.ux.system.ISystemApplication;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.text.Font;
	import flash.utils.Timer;
	
	[SWF(backgroundColor=0xffffff, frameRate=30)]
	public class BootstrapImpl extends Sprite
	{
		public static const VERSION:uint = 4006;
//		public static const FONT_REPOSITORY_ROOT:String = "http://psfonts.s3.amazonaws.com/";
		
		private static var _instance:BootstrapImpl;
		public static function get instance():BootstrapImpl
		{
			return _instance;
		}
		
		private var _is_loading:Boolean;
		private var _loading:Array;
		private var _load_index:uint;
		private var _app:IApplication;
		private var _system:ISystemApplication;
		private var _root_url:String;
		private var _params:Object;
		private var _dont_cache:Boolean;
		
		protected var _progress:Sprite;
		
		public function BootstrapImpl(dont_cache:Boolean=false)
		{
			_dont_cache 	= dont_cache;
			_params 		= (loaderInfo==null || loaderInfo.parameters==null) ? {} : loaderInfo.parameters;
			_root_url 		= (loaderInfo==null) ? "" : loaderInfo.url;
			var swf:String 	= _params.swf;
			
			if (stage==null)
				return;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align 	= StageAlign.TOP_LEFT;
			
			_progress = new Sprite();
			addChild(_progress);
			
			Logger.init(stage,stage.stageWidth-20,stage.stageHeight-20);
			Logger.log("BOOTSTRAP "+VERSION+" INIT");
			for (var p:String in _params)
				Logger.log("   "+p+"="+_params[p]);
			
			_loading = new Array();	
			
			if (_instance!=null)
				throw new Error("Only one instance of Bootstrap allowed.");
			
			_instance = this;

			if (swf == "Bootstrap.swf")
				return;
			else
				load(swf);
		}
		
		
		
		public function get url():String
		{
			return _root_url;
		}
		
		public function get isRunningOnFileSystem():Boolean
		{
			return _root_url.substring(0,4)=="file";
		}

		public function get isMac():Boolean
		{
			return Capabilities.os.toLowerCase().indexOf( "mac" ) != -1;
		}
		
		public function get params():Object
		{
			return _params;
		}
		
		public function load(url:String, on_complete:Function=null):void
		{
			var c:LibraryLoader = new LibraryLoader(url);
			if (on_complete!=null)
				c.addEventListener(ClassLoaderEvent.CLASS_LOADED, function(e:ClassLoaderEvent):void
				{
					var t:Timer = new Timer(0, 1);
					t.addEventListener(TimerEvent.TIMER_COMPLETE, function(te:TimerEvent):void
					{ 
						on_complete(e);
					});
					t.start();
				});
			_loading.push(c);
			if (!_is_loading)
				do_load();
		}
		
		public function loadFonts(f:Array, on_complete:Function, on_each:Function=null):void
		{
			if (f==null || f.length==0)
				on_complete(null);
			for (var i:uint=0; i<f.length; i++)
			{
				var c:Function = on_each;
				if (i==f.length-1)
					c = on_complete;
				if (isRunningOnFileSystem)
					load("static/fonts/"+f[i]+".swf", c);
				else if (_params.resourceRootUrl!=null)
					load(_params.resourceRootUrl+"static/fonts/"+f[i]+".swf", c);
				else
				{
					Logger.error("No params[resourceRootUrl], using / for font root");
					load("/static/fonts/"+f[i]+".swf", c);
				}
			}
		}
		
//		public function loadRemoteFonts(f:Array, on_complete:Function, on_each:Function=null):void
//		{
//			if (f==null || f.length==0)
//				on_complete(null);
//			for (var i:uint=0; i<f.length; i++)
//			{
//				var c:Function = on_each;
//				if (i==f.length-1)
//					c = on_complete;
//				//load(FONT_REPOSITORY_ROOT+f[i]+".swf", c);
//				var fl:FontLoader = new FontLoader(new URLRequest(FONT_REPOSITORY_ROOT+f[i]+".swf"));
//				fl.addEventListener(ProgressEvent.PROGRESS, on_progress);
//				if (c!=null) fl.addEventListener(Event.COMPLETE, c);
//
//			}
//		}
		
		private function do_load():void
		{
			if (_load_index==_loading.length)
			{
				_is_loading = false;
				return;
			}
			_is_loading = true;
			var c:LibraryLoader = _loading[_load_index];
			c.addEventListener(ClassLoaderEvent.PROGRESS, on_load_progress);
			c.addEventListener(ClassLoaderEvent.CLASS_LOADED, on_load_complete);
			c.addEventListener(ClassLoaderEvent.LOAD_ERROR, on_load_error);
			Logger.log("Bootstrap.do_load "+c.url);
			c.load(!isRunningOnFileSystem,_dont_cache);
			//when reloading systems, flash hangs and doesn't send the load init event
			// until another event occurs... noticed rolling over button triggers load init...
			// even though this isn't an event, it seems to trigger the load when the first
			// tick occurs 
			_timer = new Timer(200);
			_timer.start();
		}
		
		private var _timer:Timer;
		private function on_load_complete(e:ClassLoaderEvent):void
		{
			_timer.stop();
			var o:Object = e.loader.content;
//			var x:XML = describeType(o);
//			trace(x..implementsInterface);
			if (o is ISystemApplication)
				load_system(o as ISystemApplication);
			else if (o is IApplication)
				load_application(o as IApplication);
			else // is font
				load_font(e.loader.url, o);
			//
			_load_index++;
			do_load();
		}
		
		private function load_application(app:IApplication):void
		{
			if (_app != null)
				throw new Error("You may only load one application for now");
			
			Logger.log("STARTING APP");
			//_progress.graphics.clear();
			
			_app = app;	

			addChild(_app as DisplayObject);
			_app.init(_params);
			_app.render(); 
		}
		
		
		
		private function load_system(system:ISystemApplication):void
		{
			if (_app==null)
			{
				_system = system;
				addChild(_system as DisplayObject);
				system.initBootstrap(_params);
				//system.setSystemProperties( system.getDefaultSystemProperties() );
				//var fonts:Array = _system.getRequiredFontLibraries();
				//loadFonts(fonts, init_system);
			}
			
		}
		
//		private function init_system(c:ClassLoaderEvent=null):void
//		{
//			_progress.graphics.clear();
//			Logger.log("STARTING SYSTEM");
//			_system.initData();
//			_system.initComplete();
//		}
		
		
//		private var _font_map:Object = new Object();
		private function load_font(name:String, font_container:Object):void  //IFont
		{
//			_font_map[name] = new Object();
			try {
			    Font.registerFont(font_container.regular);
//				_font_map[name].regular = font_container.regular;
		 	} catch (e:Error) {}
			try {
				Font.registerFont(font_container.bold);
//				_font_map[name].bold = font_container.bold;
			} catch (e:Error) {}
			try {
				Font.registerFont(font_container.italic);
//				_font_map[name].italic = font_container.italic;
			} catch (e:Error) {}
			try {
				Font.registerFont(font_container.boldItalic);
//				_font_map[name].boldItalic = font_container.boldItalic;
			} catch (e:Error) {}
		}
		
		public function getFont(name:String):Font
		{
			var font:Object = null;
			var fonts:Array = Font.enumerateFonts();
			for each (var f:Font in fonts)
			{
				trace("F"+f.fontName);
				if (f.fontName.indexOf(name)!=-1)
					return f;
			}
			return null;
		}
		
		private function on_load_error(e:ClassLoaderEvent):void
		{
			Logger.error("Boostrap Error loading ["+e.loader.url+"]");
			//e.loader.unload();
			_load_index++;
			do_load();
		}
		
		public function unload(o:DisplayObject):void
		{
			for (var i:uint=0; i<_loading.length; i++)
			{
				var c:LibraryLoader = _loading[i];
				if (c!=null && c.content == o)
				{
					c.unload();
					_loading[i] = null;
					//remove from list
					return;
				}
			}
			throw new Error("Cannot unload "+o);
		}
		
		public function loadText(url:String, on_complete:Function):void
		{
			if (isRunningOnFileSystem)
				url = url;
			else if (url.indexOf("http://")==0)
				url = url;
			else if (_params.resourceRootUrl!=null)
				url = _params.resourceRootUrl+url;
			else
			{
				Logger.error("No params[resourceRootUrl], using / for root");
				url = "/"+url;
			}

			Logger.log("Bootstrap.loadText "+url);
			var req:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader();
            loader.load(req);
            loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void { throw new Error("CANT LOAD "+url); });
            loader.addEventListener(Event.COMPLETE, function(e:Event):void 
            { 
            	on_complete(loader.data); 
            });
		}
		
		private function on_progress(e:ProgressEvent):void
		{
			progress(e.bytesLoaded/e.bytesTotal);
		}
		protected function on_load_progress(e:ClassLoaderEvent):void
		{
			var pc:Number = e.loader.loadProgress;
			progress(pc);
		}
		
		protected function progress(pc:Number):void
		{
			var w:Number = 150;
			_progress.graphics.clear();
			_progress.graphics.beginFill(0,.3);
			_progress.graphics.drawRect(10,10,w,5);
			_progress.graphics.endFill();
			_progress.graphics.beginFill(0,1);
			_progress.graphics.drawRect(10,10,w*pc,5);
			_progress.graphics.endFill();
		}
		
		private function on_io_error(e:IOErrorEvent):void
		{
			Logger.error("BOOTSTRAP ERROR> "+e.type);
		}

		public function loadComplete():void
		{
			try {
				_progress.graphics.clear();
				removeChild(_progress);
			} 
			catch(e:*){};
		}

	}
}

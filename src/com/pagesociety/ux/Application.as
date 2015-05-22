package com.pagesociety.ux
{

	import com.pagesociety.persistence.Entity;
	import com.pagesociety.util.BootstrapImpl;
	import com.pagesociety.util.ObjectUtil;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.TakeOvers;
	import com.pagesociety.ux.component.ToolTip;
	import com.pagesociety.ux.component.container.ApplicationContainer;
	import com.pagesociety.ux.component.container.NavigableApplicationContainer;
	import com.pagesociety.ux.decorator.RootDecorator;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.style.Style;
	import com.pixelbreaker.ui.osx.MacMouseWheel;

	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.ui.Mouse;
	import flash.utils.getQualifiedClassName;


	// extends Sprite so that we can get it onto the flash stage...
	// otherwise this would extend container instead of containing it.
	//we dont do this nomo[Event(type="com.pagesociety.ux.Application", name="user_update")]
	public class Application extends Sprite implements IApplication
	{
		//public static const USER_UPDATE:String = "user_update";
		protected var _bootstrap:BootstrapImpl;
		protected var _container:Container;
		protected var _decorator:RootDecorator;
		protected var _takeovers:TakeOvers;
		protected var _focus:FocusManager;
		protected var _style:Style;
		protected var _user:Entity;
		protected var _config:Object;
		protected var _use_custom_cursor:Boolean;
		protected var _scroll_x_offset:Number;
		protected var _scroll_y_offset:Number;
		protected var _root_container:Container;

		public function Application(bootstrap:BootstrapImpl=null)
		{
			super();
			if (bootstrap==null)
				bootstrap = BootstrapImpl.instance;
			_bootstrap = bootstrap;
		}

		public function get bootstrap():BootstrapImpl
		{
			return _bootstrap;
		}

		override public function get name():String
		{
			return getQualifiedClassName(this);
		}

		public function get user():Entity
		{
			return _user;
		}

		public function set user(e:Entity):void
		{
			_user = e;
		}

		public function get config():Object
		{
			return _config;
		}

		public function set config(c:Object):void
		{
			_config = c;
		}

		public function get style():Style
		{
			return _style;
		}

		public function set style(s:Style):void
		{
			_style = s;
		}

		public function loadText(url:String, on_complete:Function):void
		{
			_bootstrap.loadText(url, function(data:String):void { on_complete(data); });
		}

		public function loadStyle(url:String, on_complete:Function):void
		{
			if (url==null)
				on_complete()
			else
				_bootstrap.loadText(url,
					function(css:String):void
					{
						if (style==null)
							style = new Style(css);
						else
							style.parse(css);
						on_complete();
					});
		}

		public function setStyle(s:String):void
		{
			style = new Style(s);
		}

		public function loadJson(url:String, on_complete:Function):void
		{
			_bootstrap.loadText(url, function(data:String):void { on_complete(JSON.parse(data)); });
		}

		public function loadFonts(urls:Array, on_complete:Function, on_each:Function=null):void
		{
			_bootstrap.loadFonts(urls, on_complete, on_each);
		}

//		public function loadRemoteFonts(urls:Array, on_complete:Function, on_each:Function=null):void
//		{
//			_bootstrap.loadRemoteFonts(urls, on_complete, on_each);
//		}

		public function init(params:Object=null):void
		{
//			_params = params;
			try{
				MacMouseWheel.setup( stage );
			}catch(e:Error){}
			ObjectUtil.registerDefaultEntities();
			initRootContainer();
		}


		public function error(e:*):void
		{
			Logger.error(e);
		}



		////////////////////


		public function initRootContainer():void
		{
			if (_container!=null)
				throw new Error("Application.initRootContainer ERROR cannot be called twice");

			if (stage!=null)
			{
				stage.addEventListener(Event.RESIZE, do_resize);
				stage.addEventListener(FullScreenEvent.FULL_SCREEN, on_fs);
			}

			_container = new ApplicationContainer(this);
			_decorator = _container.decorator as RootDecorator;

			_takeovers = new TakeOvers(_container);

			if (stage!=null)
			{
				_focus = new FocusManager(stage,_container);
				//stage.stageFocusRect = null;
			}

			if (_bootstrap!=null)
				_bootstrap.loadComplete();
		}

		public function get decorator():RootDecorator
		{
			return _decorator;
		}

		public function get focusManager():FocusManager
		{
			return _focus;
		}

		public function navigate(address:String,args:*=null):void
		{
			var n:NavigableApplicationContainer;
			for (var i:uint=0; i<_container.children.length; i++)
			{
				if (_container.children[i] is NavigableApplicationContainer)
				{
					n = _container.children[i];
					break;
				}
			}
			if (n==null)
			{
				Logger.log("Root component must be NavigableApplicationContainer to use application.navigate");
				return;
			}
			n.navigate(address,args);
		}


		public function get rootContainer():Container
		{
			return _root_container;
		}

		public function set rootContainer(c:Container):void
		{
			_root_container = c;
		}

		public function render():void
		{
			if (_container!=null)
				_container.render();
		}

		public function get container():Container
		{
			return _container;
		}

		protected function do_resize(e:Event):void
		{
			if (_fs)
				return;
			if (stage==null)
			{
				trace("NO STAGE! "+width+","+height);
				_container.render();
				return;
			}
			_container.width = stage.stageWidth;
			_container.height = stage.stageHeight;
			_container.render();
		}


		public function pushTakeOver(c:Component, callback:Function=null, takeOverColor:uint=0xffffff, takeOverAlpha:Number=.6, center:Boolean=true, align_to:Component=null, offset:Point=null):void
		{
			if (stage!=null)
				stage.focus = null;
			if (callback==null)
				callback = do_poptakeover;
			_takeovers.bringToFront();
			_takeovers.push(c, callback, takeOverColor, takeOverAlpha, center, align_to, offset);
			_takeovers.render();
		}

		private function do_poptakeover(e:ComponentEvent):void
		{
			popTakeOver();
		}

		public function doNothing(e:ComponentEvent):void
		{

		}

		public function popTakeOver():void
		{
			_takeovers.pop();
			_takeovers.render();
		}

		public function hideTakeOver():void
		{
			popTakeOver();
		}

		public function destroyTakeOver():void
		{
			popTakeOver();
		}

		public function isTakeover(c:Component):Boolean
		{
			return _takeovers.isTakeOver(c);
		}

		private var  _tooltip:IToolTip;
		public function showToolTip(s:String, c:Component):void
		{
			if (_tooltip==null)
			{
				_tooltip = get_tooltip();
				_tooltip.addEventListener(ComponentEvent.MOUSE_OVER, function(e:*):void { _tooltip.visible = true; _tooltip.render(); });
				_tooltip.addEventListener(ComponentEvent.MOUSE_OUT, function(e:*):void { _tooltip.visible = false; _tooltip.render(); });
			}
			_tooltip.text = s;
			var p:Point = c.getRootPosition().add(c.getToolTipOffset());
			_tooltip.x = p.x;
			_tooltip.y = p.y;
			_tooltip.visible = true;
			_tooltip.render();
		}

		public function hideToolTip(e:MouseEvent=null):void
		{
			_tooltip.visible = false;
			_tooltip.render();
		}

		protected function get_tooltip():IToolTip
		{
			return new ToolTip(container);
		}

		override public function get height():Number
		{
			if (stage==null)
				return _container.width;
			return stage.stageHeight;
		}

		override public function get width():Number
		{
			if (stage==null)
				return _container.height;
			return stage.stageWidth;
		}

		public function get scrollOffset():Object
		{
			return _decorator.scrollOffset;
		}

		public function set scrollOffset(o:Object):void
		{
			_decorator.scrollOffset = o;
		}

		public function get windowSize():Object
		{
			return _decorator.windowSize;
		}

		public function set windowSize(o:Object):void
		{
			_decorator.windowSize = o;
		}

		public function getLocation(c:Component):Point
		{
			return c.getRootPosition();
		}

		public function set useCustomCursor(b:Boolean):void
		{
			_use_custom_cursor = b;
			if (b)
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            	Mouse.hide();
            	_decorator.cursor.visible = true;
			}
			else
			{

           		stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            	Mouse.show();
            	_decorator.cursor.visible = false;
			}
		}

		public function get useCustomCursor():Boolean
		{
			return _use_custom_cursor;
		}


        private function mouseMoveHandler(event:MouseEvent):void
        {
            _decorator.cursor.x = event.stageX;
            _decorator.cursor.y = event.stageY;
            event.updateAfterEvent();
        }

        private function mouseLeaveHandler(event:Event):void
        {
           // _cursor.visible = false;
        }

        public function get cursor():Sprite
        {
        	return _decorator.cursor;
        }



        // FS
        public function goFullScreen(x:Number,y:Number,w:Number,h:Number):void
        {
        	_fs = true;
        	stage.fullScreenSourceRect = new Rectangle(x,y,w,h);
			stage.displayState = StageDisplayState.FULL_SCREEN;
        }

        private var _fs:Boolean;
        private function on_fs(e:FullScreenEvent):void
        {
        	_fs = e.fullScreen;
        }




        // SHARED OBJECT
        private var _so:SharedObject;
        public function initSharedObject(application_name:String):void
        {
        	_so = SharedObject.getLocal(application_name);
        }

        public function getSharedObject(name:String):*
		{
			return _so.data[name];
		}

		public function hasSharedObject(name:String):Boolean
		{
			return _so.data[name]!=null;
		}

		public function getSharedString(name:String):String
		{
			if (_so.data[name]==null)
				return "";
			return _so.data[name] as String;
		}

		public function removeSharedObject(name:String):void
		{
			setSharedObject(name,null);
		}

		public function setSharedObject(name:String, value:*, flush:Boolean=true):void
		{
			 _so.data[name] = value;

            var flushStatus:String = null;
            if (flush)
            {
	            try {
	                flushStatus = _so.flush(10000);
	            } catch (error:Error) {
	                Logger.error("Error...Could not write SharedObject to disk\n");
	            }
            }
            if (flushStatus != null) {
                switch (flushStatus) {
                    case SharedObjectFlushStatus.PENDING:
                        Logger.error("Requesting permission to save object...\n");
                        _so.addEventListener(NetStatusEvent.NET_STATUS, on_flush_status);
                        break;
                    case SharedObjectFlushStatus.FLUSHED:
                        //Logger.log("Value flushed to disk.\n");
                        break;
                }
            }
		}

		 private function on_flush_status(event:NetStatusEvent):void {
            Logger.error("User closed permission dialog...\n");
            switch (event.info.code) {
                case "SharedObject.Flush.Success":
                    Logger.log("User granted permission -- value saved.\n");
                    break;
                case "SharedObject.Flush.Failed":
                    Logger.error("User denied permission -- value not saved.\n");
                    break;
            }
            _so.removeEventListener(NetStatusEvent.NET_STATUS, on_flush_status);
        }



		 //THIS SHOULD BE IN APPLICATION ..toph

		 public function alert(msg:String):void
		 {
			 var C:Container = new Container(container);
			 C.BC();
			 C.add_label(msg,'default_text',true);
			 C.EC();
			 C.width = 400;
			 C.height = 200;
			 C.backgroundVisible = true;
			 C.backgroundColor = 0xffffff;
			 var APP:Application = this;
			 pushTakeOver(C, function(e:Event):void {APP.destroyTakeOver(); }, 0xffffff, .5, true);

		 }
	}
}




class ExternalClass
{
	public function ExternalClass()
	{
		trace("ExternalClass Constructor");
	}
}
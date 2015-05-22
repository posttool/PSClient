package com.pagesociety.ux.component.container
{
	import com.pagesociety.ux.MovingValue;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.Image;
	import com.pagesociety.ux.decorator.ImageDecorator;
	import com.pagesociety.ux.decorator.MaskedDecorator;
	import com.pagesociety.ux.event.ResourceEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	import com.pagesociety.ux.layout.Layout;
	
	import flash.geom.Point;
	
	public class PageContainer extends Container
	{
		private var _visible_page:int;
		private var _last_visible:int;
		
		public static var TYPE_SIMPLE:uint = 0;
		public static var TYPE_SIMPLE_FADE:uint = 1;
		public static var TYPE_HORIZONTAL:uint = 2;
		
		private var _type:uint = TYPE_SIMPLE_FADE;
		private var _needs_update:Boolean = true;
		
		private var _xo:Number = 0;
		private var _xoffset:Number = 0;//static xoffset
		private var _speed:uint = 700;  // transition speed in milliseconds
		private var _looping:Boolean = true;
		
		private var _after_render_callback:Function; 
		private var _pages:Container;
		
		public function PageContainer(parent:Container, clipped:Boolean=false)
		{
			super(parent);
			if (clipped)
				decorator = new MaskedDecorator();
			_pages = new Container(this);
			_visible_page = 0;
			_last_visible = -1;
		}
		
		public function set type(t:uint):void
		{
			_type = t;
			_needs_update = true;
		}
		
		public function set afterRender(f:Function):void
		{
			_after_render_callback = f;
		}
		
		public function get afterRender():Function
		{
			return _after_render_callback;
		}
		
		override public function clear():void
		{
			_pages.clear();
			_visible_page = 0;
			_last_visible = -1;
			_xo = 0;
		}
		
		override public function set layout(l:Layout):void
		{
			throw new Error("PageContainer does not support layouts");
		}
		
		override public function addComponent(c:Component,i:int=-1):void
		{
			if (_pages==null)
				super.addComponent(c,i);
			else
			{
				_pages.addComponent(c,i);
				c.visible = false;
				c.addEventListener(ResourceEvent.LOAD_RESOURCE, on_load);
			}
		}
		
		override public function get children():Array
		{
			if (_pages==null)
				return [];
			return _pages.children;
		}
		
		
		private function on_load(e:*):void
		{
			render();
		}
		
		public function set speed(s:uint):void
		{
			_speed = s;
		}
		
		public function get speed():uint
		{
			return _speed;
		}
		
		public function set looping(b:Boolean):void
		{
			_looping = b;
		}
		
		public function get looping():Boolean
		{
			return _looping;
		}
		
		public function next():void
		{
			var v:int = _visible_page+1;
			if (v >= children.length)
				if (_looping)
					v = 0;
				else
					v = children.length-1;
			showPage(v);
		}
		
		public function prev():void
		{
			var v:int = _visible_page-1;
			if (v < 0)
				if (_looping)
					v = children.length-1;
				else
					v = 0;
			showPage(v);
		}
		
		public function get page():int
		{
			return _visible_page;
		}
		
		public function set page(p:int):void
		{
			if (p<0) p = 0;
			if (p>=children.length) p = children.length-1;
			showPage(p);
		}
		
		public function showPage(i:uint,on_complete:Function = null):void
		{
			if (i==_visible_page)
				return;
			_last_visible = _visible_page;
			_visible_page = i;
			update();
		}
		
		private function get last():Component
		{
			return _pages.children[_last_visible];
		}
		
		public function get current():Component
		{
			return _pages.children[_visible_page];
		}
		
		private var _last_width:Number;
		private var _last_height:Number;
		public function get resized():Boolean
		{
			var b:Boolean = false;
			if (width!=_last_width||height!=_last_height)
				b = true;
			_last_width=width;
			_last_height=height;
			return b;
		}
		
		override public function render():void
		{
			if (_needs_update || resized)
				update(true);
			
			var dx:Number = 0;
			for (var i:uint=0; i<children.length; i++)
			{
				var c:Component = children[i];
				switch (_type)
				{
					case TYPE_SIMPLE:
					case TYPE_SIMPLE_FADE:
						c.x = 0;
						c.y = 0;
						c.visible = (i==_visible_page || i==_last_visible);
						break;
					case TYPE_HORIZONTAL:
						var cw:Number = get_width(c);
						c.x = dx;
						c.y = 0;
						var p:Point = c.getRootPosition();
						var r:Number = p.x + cw;
//						var vis:Boolean = (p.x < 0 && p.x + cw > 0) || p.x < application.width;
						c.visible = true;//vis;
						dx += cw;
						break;
				}
			}
			if (_after_render_callback != null)
				_after_render_callback();
			_pages.render();
			super.render();
		}
		
		public function update(now:Boolean=false):void
		{
			if (current==null)
				return;
			
			switch (_type)
			{
				case TYPE_SIMPLE:
					update_simple(now);
					break;
				case TYPE_SIMPLE_FADE:
					update_simple_fade(now);
					break;
				case TYPE_HORIZONTAL:
					update_horizontal(now);
					break;
			}
			_needs_update = false;
			
		}
		
		private function update_simple(now:Boolean):void
		{
			if (last!=null)
				last.alpha = 0;
			current.alpha = 1;
		}
		
		private function update_simple_fade(now:Boolean):void
		{
			if (now)
			{
				update_simple(now);
				return;
			}
			if (last!=null)
				move(last,["alpha",0,_speed]);
			current.alpha = 0;
			move(current, ["alpha",1,_speed]);
		}
		
		private var _gap:Number = 5;
		public function set gap(n:Number):void
		{
			_gap = n;
		}
		
		public function get gap():Number
		{
			return _gap;
		}
		
		public function set xoffset(n:Number):void
		{
			_xoffset = n;
//			_needs_update = true;
		}
		
		public function get xoffset():Number
		{
			return _xoffset;
		}
		
		private function update_horizontal(now:Boolean):void
		{
			if (now)
				px = _xoffset - current.x;
			else
				move(["px", _xoffset - current.x, _speed]);
		}
		
		public function get px():Number { return _pages.x; }
		
		public function set px(x:Number):void 
		{ 
//			if (x==0)
//				trace(x);
			_pages.x = x; 
		}
		
		public function get layoutWidth():Number
		{
			return get_horizontal_width();
		}
		
		private function get_horizontal_width():Number
		{
			var cx:Number = 0;
			for (var i:uint=0; i<children.length; i++)
				cx += get_width(children[i]) + _gap;
			return cx;
		}
		
		private function get_width(c:Component):Number
		{
			if (c is Image && Image(c).imageScalingType == ImageDecorator.IMAGE_SCALING_VALUE_FIT_HEIGHT)
			{
				var i:Image = c as Image;
				var w:uint = i.imageWidth;
				if (w==0)
					w = c.width;
				return w + _gap;
			}
			else
				return c.width + _gap;
		}
		
		private function get_height(c:Component):Number
		{
			if (c is Image)// && Image(c).imageScalingType == ImageDecorator.IMAGE_SCALING_VALUE_FIT_WIDTH)
			{
				var i:Image = c as Image;
				i.render(); 
				var h:uint = i.imageHeight;
				if (h==0)
					h = c.height;
				return h + _gap;
			}
			else
				return c.height + _gap;
		}
		
		private function update_vertical():void
		{
			
		}
		
		private function get_vertical_width():Number
		{
			var cy:Number = 0;
			for (var i:uint=0; i<children.length; i++)
				cy += children[i].height + _gap;
			return cy;
		}
		
		
		
	}
}
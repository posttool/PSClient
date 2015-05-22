package com.pagesociety.ux
{
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.event.FocusEvent;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class FocusManager
	{
		
		private var _root:Component;
		private var _focused_component:Component;
		
		private var _up_key:uint 		= Keyboard.UP;
		private var _down_key:uint 		= Keyboard.DOWN;
		private var _next_key:uint 		= Keyboard.RIGHT;
		private var _previous_key:uint 	= Keyboard.LEFT;
		
		private var _ensure_vis:Boolean = true;

		public function FocusManager(stage:Stage, root:Container)
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, do_key_down);
			stage.addEventListener(KeyboardEvent.KEY_UP, do_key_up);
			_root = root;
			_focused_component = root;
		}
		
		
		public function getFocus():Component
		{
			return _focused_component;
		}
		
		public function setFocus(c:Component):void
		{
			if (c == _focused_component || !c.focusable)
				return;
			var p:Container;
			if (_focused_component!=null)
			{
				_focused_component.onFocus(new FocusEvent(FocusEvent.UNFOCUS));
				p = _focused_component.parent;
				while (p != null && p != _root)
				{
					p.onFocus(new FocusEvent(FocusEvent.UNFOCUS_CHILD,_focused_component));
					p = p.parent;
				}
			}
			
			_focused_component = c;
			_focused_component.onFocus(new FocusEvent(FocusEvent.FOCUS));
			//Logger.log(">focused="+_focused_component);
			
			if (_ensure_vis)
			{
				p = _focused_component.parent;
				while (p != null && p != _root)
				{
					p.onFocus(new FocusEvent(FocusEvent.FOCUS_CHILD, _focused_component));
					p.ensureVisibility(_focused_component);
					p = p.parent;
				}
			}
		}
		
		public function set ensureVisibility(b:Boolean):void
		{
			_ensure_vis = b;
		}
		
		public function get ensureVisibility():Boolean
		{
			return _ensure_vis;
		}

		public function up():void
		{
			var p:Component = _focused_component.parent;
			if (p == null)
				return;
			while (!p.focusable)
				p = p.parent;
			setFocus(p);
		}
		
		public function down():void
		{
			if (!(_focused_component is Container))
				return;
			var c:Container = _focused_component as Container;
			var first_focusable:Component = get_first_focusable(c);
			if (first_focusable==null)
				return;
			setFocus(first_focusable);
		}
		
		private function get_first_focusable(c:Container):Component
		{
			for (var i:uint=0; i<c.children.length; i++)
			{
				var cc:Component = c.children[i];
				if (!cc.visible)
					continue;
				if (cc.focusable)
					return c.children[i];
				if (c.children[i] is Container)
				{
					var f:Component = get_first_focusable(c.children[i]);
					if (f!=null)
						return f;
				}
			}
			return null;
		}
		
		public function next():void
		{
			var cont:Container = _focused_component.parent;
			var comp:Component = null;
			var next_focusable:Component = null;
			var i:uint = 0;
			
			i = cont.indexOf(_focused_component)+1;
			while (i!=cont.children.length && next_focusable==null)
			{
				comp = cont.children[i];
				if (comp.focusable && comp.visible)
					next_focusable = comp;
				i++;
			}
			
			if (next_focusable==null)
				return;
			setFocus(next_focusable);
		}
		
		public function previous():void
		{
			var cont:Container = _focused_component.parent;
			var comp:Component = null;
			var prev_focusable:Component = null;
			var i:int = 0;

			i = cont.indexOf(_focused_component)-1;
			while (i!=-1 && prev_focusable==null)
			{
				comp = cont.children[i];
				if (comp.focusable && comp.visible)
					prev_focusable = comp;
				i--;
			}

			if (prev_focusable==null)
				return;

			setFocus(prev_focusable);
		}
		
		private function do_key_down(e:KeyboardEvent):void
		{
			var p:Component = _focused_component;
			while (p!=null)
			{
				if (p is IKeyListener)
				{
					IKeyListener(p).onKeyPress(e);
					return;
				}
				p = p.parent;
			}
		}
		
		private function do_key_up(e:KeyboardEvent):void
		{
			var p:Component = _focused_component;
			while (p!=null)
			{
				if (p is IKeyListener)
				{
					IKeyListener(p).onKeyRelease(e);
					return;
				}
				p = p.parent;
			}
			handleKeyRelease(e); 
		}
		
		/**
		 * Key listeners might call this method if they want to hand
		 * control back to the focus manager.
		 */
		public function handleKeyRelease(e:KeyboardEvent):void
		{
//			switch (e.keyCode)
//			{
//				case _up_key:
//					up();
//					break;
//				case _down_key:
//					down();
//					break;
//				case _next_key:
//					next();
//					break;
//				case _previous_key:
//					previous();
//					break;
//			}
		}
	}
}
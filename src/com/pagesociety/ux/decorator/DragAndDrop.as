package com.pagesociety.ux.decorator
{
	import com.pagesociety.ux.component.Component;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class DragAndDrop
	{
		
		protected var _decorator:Decorator;
		
		protected var _drag_component:Component;
		protected var _drop_targets:Array = [];
		
		protected var _down_timer:Timer;
		
		protected var _click_x:Number;
		protected var _click_y:Number;
		protected var _click_item_offset:Point;
		
		protected var _dragging:Boolean;

		protected var _drag_display:Sprite;
		protected var _drag_bg:Sprite;
		
		
		public function DragAndDrop(decorator:Decorator)
		{
			_decorator = decorator;
			_down_timer = new Timer(150, 1);
            _down_timer.addEventListener(TimerEvent.TIMER_COMPLETE, on_drag_start_after_slight_delay);
		}

		
		public function set dragComponent(c:Component):void
		{
			setDragComponent(c);
		}
		
		public function get dragComponent():Component
		{
			return _drag_component;
		}
		
		public function setDragComponent(c:Component):void
		{
			_decorator.dragArea.removeEventListener(MouseEvent.MOUSE_DOWN, on_drag_start);
			_drag_component = c;
			_decorator.dragArea.addEventListener(MouseEvent.MOUSE_DOWN, on_drag_start);
		}
		
		public function addDropComponent(drop_target_component:Component):void
		{
			_drop_targets.push(drop_target_component);
		}
		
		public function removeDropComponent(drop_target_component:Component):void
		{
			var i:int = _drop_targets.indexOf(drop_target_component);
			if (i==-1)
				return;
			_drop_targets.splice(i,1);
		}
		
		public function get dropTargets():Array
		{
			return _drop_targets;
		}
		
		public function set dropTargets(a:Array):void
		{
			 _drop_targets = a;
		}
		
		private function on_drag_start(e:MouseEvent):void
		{
			if (_drag_component == null || _drop_targets.length == 0)
				return;
			_dragging = false;
            _down_timer.start();
  			_click_item_offset = _decorator.getRootPosition();
            _click_x = e.stageX;
            _click_y = e.stageY;
            _decorator.stage.addEventListener(MouseEvent.MOUSE_UP, on_drag_end);
		}
		
		private function on_drag_start_after_slight_delay(e:TimerEvent):void
		{
			_dragging = true;
			_down_timer.reset();
			onDragStart(_click_x, _click_y);
			onDragging(_click_x, _click_y);
			for (var i:uint=0; i<_drop_targets.length; i++)
			{
				_drop_targets[i].onDragStart(_drag_component);
				//_drag_component.onDragStart();
			}
			_decorator.stage.addEventListener(MouseEvent.MOUSE_MOVE, on_dragging);
			
		}
		
		protected function initDragGraphics():void
		{
			_drag_bg = new Sprite();
			_decorator.stage.addChild(_drag_bg);
			_drag_display = new Sprite();
			_decorator.stage.addChild(_drag_display);
		}
		
		protected function destroyDragGraphics():void
		{
			if (_drag_bg != null)
			{
				if (_decorator.stage!=null)
					_decorator.stage.removeChild(_drag_bg);
				_drag_bg = null;
			}
			if (_drag_display != null)
			{
				if (_decorator.stage!=null)
					_decorator.stage.removeChild(_drag_display);
				_drag_display = null;
			}
		}
		
		public function onDragStart(x:Number, y:Number):void
		{
			initDragGraphics();
			
			_drag_display.addChild(_decorator.createBitmap());
			_drag_display.visible = true;
			_decorator.alpha = .3;
			
			_drag_bg.visible = true;
			_drag_bg.graphics.beginFill(0xFFFFFF,.333);
			_drag_bg.graphics.drawRect(0,0,_decorator.stage.stageWidth,_decorator.stage.stageHeight);
			for (var i:uint=0; i<_drop_targets.length; i++)
			{
				var c:Component = _drop_targets[i];
				if (!is_visible(c))
					continue;
				var p:Point = c.getRootPosition();
				_drag_bg.graphics.drawRect(p.x,p.y,c.width,c.height);
			}
			_drag_bg.graphics.endFill();
		}
		
		private var _drop_targets_over:Array = [];
		private function on_dragging(e:MouseEvent):void
		{
			onDragging(e.stageX, e.stageY);
			
			var new_drop_targets:Array = new Array();
			for (var i:uint=0; i<_drop_targets.length; i++)
			{
				if (hit_test_drag(_drop_targets[i], e.stageX, e.stageY) && is_visible(_drop_targets[i])) // && _drop_targets[i].decorator.visible
				{
					var p:Point = _drop_targets[i].decorator.globalToLocal(new Point(e.stageX, e.stageY));
					_drop_targets[i].onDragOver(_drag_component, p.x, p.y);
					//_drag_component.onDragOver();
					new_drop_targets.push(_drop_targets[i]);
				}
			}
			for (i=0; i<_drop_targets_over.length; i++)
			{
				if (new_drop_targets.indexOf(_drop_targets_over[i]) == -1)
				{
					_drop_targets[i].onDragExit(_drag_component);
				}
			}
			_drop_targets_over = new_drop_targets;
		}
		
		protected function hit_test_drag(drop_component:Component,x:Number,y:Number):Boolean
		{
			var drop_root_pos:Point = drop_component.getRootPosition();
			var drop_rect:Rectangle = new Rectangle(drop_root_pos.x, drop_root_pos.y, drop_component.width, drop_component.height);
			return drop_rect.contains(x,y);
		}
		
		protected function is_visible(c:Component):Boolean
		{
			if (c==null)
				return false;
			while (c.visible)
			{
				c = c.parent;
				if (c == null)
					return true;
			}
			return false;
		}
		
		public function onDragging(x:Number, y:Number):void
		{
			_drag_display.x = x - _click_x + _click_item_offset.x;
			_drag_display.y = y - _click_y + _click_item_offset.y;
		}

		
		private function on_drag_end(e:MouseEvent):void
		{
			_down_timer.stop();
			_down_timer.reset();
			
			_decorator.stage.removeEventListener(MouseEvent.MOUSE_MOVE, on_dragging);
			_decorator.stage.removeEventListener(MouseEvent.MOUSE_UP, on_drag_end);
			
			if (!_dragging)
				return;
			
			var p:Point;
			var i:uint;
			var dropped_on_something:Boolean = false;
			for (i=0; i<_drop_targets.length; i++)
			{
				if (hit_test_drag(_drop_targets[i], e.stageX, e.stageY) && is_visible(_drop_targets[i])) // && _drop_targets[i].decorator.visible)
				{
					p = _drop_targets[i].decorator.globalToLocal(new Point(e.stageX, e.stageY));
					_drop_targets[i].onDrop(_drag_component, p.x,p.y);
					//_drag_component.onDrop(_drop_targets[i]);
					dropped_on_something = true;
					break;
				}
			}
			for (i=0; i<_drop_targets.length; i++)
			{
				if (_drop_targets[i]!=null  && is_visible(_drop_targets[i])) // && _drop_targets[i].decorator.visible)
				{
					p = _drop_targets[i].decorator.globalToLocal(new Point(e.stageX, e.stageY));
					_drop_targets[i].onDragEnd(p.x,p.y)
				}	
			}
			onDragEnd(e.stageX, e.stageY);
			//notify whatever that dropped_on_something is false
			//if (!dropped_on_something)
				//_drag_component.onDragCanceled();
			//else
				//_drag_component.onDragEnd();

		}
		
		public function onDragEnd(x:Number,y:Number):void
		{
			destroyDragGraphics();
			_decorator.alpha = 1;
		}
		
	

	}
}
package com.pagesociety.ux.draw
{
	import com.adobe.serialization.json.JSON;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.event.ComponentEvent;

	public class DrawingEdit extends Container 
	{
		public static const DRAG_BG:String = "drag_bg";
		private var _draw:Drawing;
		private var _dots:Container;
		private var _handles:Container;
		
		private var _points:Array;
		
		public function DrawingEdit(parent:Container, index:int=-1)
		{
			super(parent, index);
			_draw = new Drawing(this);
			_draw.matteColor = 0xffffff;
			_draw.addEventListener(ComponentEvent.DRAG, on_drag_matte);
			_dots = new Container(this);
			_handles = new Container(this);
		}
		
		public function set points(p:Array):void
		{
			_points = Drawing.convert(p);
			update_ui();
		}
		
		public function get points():Array
		{
			return _points;
		}
		
		public function set showHandles(b:Boolean):void
		{
			_dots.visible = b;
			_handles.visible = b;
		}
		
		public function get showHandles():Boolean
		{
			return _dots.visible;
		}
		
		override public function render():void
		{
			if (_points==null)
				return;
			for (var i:uint=0; i<_points.length; i++)
			{
				_dots.children[i].x = _points[i].x;
				_dots.children[i].y = _points[i].y;
				
				var d:Array = calc_visual_cp_from_actual(i);
				_handles.children[i].x = d[0];//_points[i].cx;
				_handles.children[i].y = d[1];//_points[i].cy;
			}
			super.render();
		}
		
		private function calc_visual_cp_from_actual(i:uint):Array
		{
			var P1:DrawPoint = _points[i];
			var P3:DrawPoint = _points[(i+1)%_points.length];
			var ratio:Number = .5;
			
			var yx:Number = P1.x+(P1.cx-P1.x)*ratio;
		    var cx:Number = P1.cx+(P3.x-P1.cx)*ratio;
		    var mx:Number = yx+(cx-yx)*ratio;
		    var yy:Number = P1.y+(P1.cy-P1.y)*ratio;
		    var cy:Number = P1.cy+(P3.y-P1.cy)*ratio;
		    var my:Number = yy+(cy-yy)*ratio;
		    
		    return [ mx, my ];
		}
		
		protected function update_ui():void
		{
			_draw.points = _points;
			_dots.clear();
			_handles.clear();
			var c:Component;
			for (var i:uint=0; i<_points.length; i++)
			{
				c = new Handle(_dots);
				c.width = 10;
				c.height = 10;
				c.addEventListener(ComponentEvent.DRAG, on_drag);
				c.userObject = {type: 0, index: i};

				c = new HandleCurve(_handles);
				c.width = 10;
				c.height = 10;
				c.addEventListener(ComponentEvent.DRAG, on_drag);
				c.userObject = {type: 1, index: i};
			}
		}
		
		private function on_drag(e:ComponentEvent):void
		{
			var i:uint = e.component.userObject.index;
			var t:uint = e.component.userObject.type;
			if (t==0)
			{
				_points[i].x = e.data.x;
				_points[i].y = e.data.y;
			}
			else
			{
				_points[i].cx += e.data.dx;
				_points[i].cy += e.data.dy;
			}
			render();
		}
		
		private function on_drag_matte(e:ComponentEvent):void
		{
			dispatchComponentEvent(DRAG_BG, this, e.data);
		}
		
		
		
		
	}
}
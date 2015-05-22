package com.pagesociety.ux.decorator
{
	import com.pagesociety.ux.component.text.RichTextEditor;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.style.Style;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	[Event(type="com.pagesociety.ux.component.text.RichTextEditor",name="selection_change")]
	[Event(type="com.pagesociety.ux.component.text.RichTextEditor",name="rte_link")]
	public class RichTextDecorator extends InputDecorator
	{
		private var _link_color:uint 	= 0x0000cc;
		private var _normal_color:uint 	= 0x000000;
		private var _thumb_color:uint 	= 0xcc0000;
		private var _thumb_over_color:uint 	= 0xcccc00;
		private var _thumb_y:Number = 0;
		private var _thumb_h:Number = 0;;
		
		private var _scrollthumb:Sprite;
		
		public function RichTextDecorator(style:Style)
		{
			super(style);
			decorate();
			_font_style = null;
		}
		
		override public function initGraphics():void
		{
			super.initGraphics();
			_input.alwaysShowSelection = true;
//			_input.useRichTextClipboard = true;
			_input.addEventListener(MouseEvent.MOUSE_UP, on_update_selection);
			_input.addEventListener(Event.SCROLL, on_scroll);
			
			_scrollthumb = new Sprite();
			_scrollthumb.addEventListener(MouseEvent.MOUSE_DOWN, on_down_thumb);
			_scrollthumb.addEventListener(MouseEvent.ROLL_OVER, on_rollover_thumb);
			_scrollthumb.addEventListener(MouseEvent.ROLL_OUT, on_rollout_thumb);
			addChild(_scrollthumb);
		}
		
		override protected function text_input(e:Event):void
		{
			_dirty = true;
			_input_text = _input.text;
			dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE));
		}
		
		override public function decorate():void
		{
			super.decorate();
			fix_colors();
		}
		
		private function fix_colors():void
		{
			var f:TextFormat;
			for (var i:uint=0; i<_input.length-1; i++)
			{
				f = _input.getTextFormat(i, i+1);
				if (f.url!="")
				{
					var su:String = f.url;
					var si:uint = i;
					while (su==f.url && i<_input.length-1)
					{
						i++;
						f = _input.getTextFormat(i, i+1);
					}
					f = _input.getTextFormat(i-1, i);
					f.color =_link_color;
					_input.setTextFormat(f,si,i);
				}
			}
		}
		
		private function on_update_selection(e:MouseEvent):void
		{
			update_selection_format(); // get the text format for the current selection
			dispatchEvent(new ComponentEvent(RichTextEditor.SELECTION_CHANGE));
		}
		
		override public function set normalColor(c:uint):void
		{
			_normal_color = c;
		}
		
		override public function get normalColor():uint
		{
			return _normal_color;
		}
		
		public function set linkColor(c:uint):void
		{
			_link_color = c;
		}
		
		public function get linkColor():uint
		{
			return _link_color;
		}
		
		public function set thumbColor(c:uint):void
		{
			_thumb_color = c;
		}
		
		public function get thumbColor():uint
		{
			return _thumb_color;
		}
		
		public function set thumbOverColor(c:uint):void
		{
			_thumb_over_color = c;
		}
		
		public function get thumbOverColor():uint
		{
			return _thumb_over_color;
		}
		
		override protected function on_link(e:TextEvent):void
		{
			_selection_begin = _input.selectionBeginIndex;
			_selection_end = _input.selectionEndIndex;
			for (var i:uint=_selection_begin; i>0; i--)
			{
				var f:TextFormat = _input.getTextFormat(i-1, i);
				if (f.url != "event:"+e.text)
				{
					_selection_begin = i;
					break;
				}
				if (i==1)
					_selection_begin = 0;
			}
			for (i=_selection_begin; i<_input.text.length-1; i++)
			{
				f = _input.getTextFormat(i, i+1);
				if (f.url != "event:"+e.text)
				{
					_selection_end = i;
					break;
				}
				if (i==_input.text.length-2)
					_selection_end = _input.text.length;
			}
			setSelection(_selection_begin,_selection_end);
			dispatchEvent(new ComponentEvent(RichTextEditor.RTE_LINK, null, e.text));
		}
		
		override public function get inputValue():String
		{
			return _input.htmlText;
		}
		
		public function get selectionFormat():TextFormat
		{
			return _selection_format;
		}
		
		override public function setSelection(i:uint,j:uint):void
		{
			super.setSelection(i,j);
			_selection_begin = i;
			_selection_end = j;
		}
		
		public function plain():void
		{
			update_selection_format();
			_selection_format.bold = false;
			_selection_format.italic = false;
			_selection_format.underline = false;
			_selection_format.url = "";
			_selection_format.color = 0;
			end_style_change();
		}
		
		public function bold():void
		{
			update_selection_format();
			_selection_format.bold = !_selection_format.bold;
			end_style_change();
		}
		
		public function underline():void
		{
			update_selection_format();
			_selection_format.underline = !_selection_format.underline;
			end_style_change();
		}
		
		public function italic():void
		{
			update_selection_format();
			_selection_format.italic = !_selection_format.italic;
			end_style_change();
		}
		
		public function url(s:String,b:int=-1,e:int=-1):void
		{
			update_selection_format(b,e);
			_selection_format.url = s;
			if (s=="")
				_selection_format.color = _normal_color;
			else
				_selection_format.color = _link_color;
			end_style_change();
		}
		
		public function get value():String
		{
			return _input.htmlText;
		}
		
		public function replaceSelectedText(s:String):void
		{
			_input.replaceSelectedText(s);
		}
		
		
		
		private var _selection_format:TextFormat;
		private var _selection_begin:uint;
		private var _selection_end:uint;
		private function update_selection_format(b:int=-1,e:int=-1):void
		{
			if (_input.text=="")
			{
				_selection_format = new TextFormat();
				return
			}
			_selection_begin = b==-1?_input.selectionBeginIndex:b;
			_selection_end = e==-1?_input.selectionEndIndex:e;
			if (_selection_begin==_selection_end)
			{
				var pi:uint = (_selection_begin==0)?0:_selection_begin-1;
				_selection_format = _input.getTextFormat(pi);
			}
			else
			{
				_selection_format = _input.getTextFormat(_selection_begin, _selection_end);
			}	
		}
		
		private function end_style_change():void
		{
			if (_selection_begin==_selection_end)
			{
				_input.defaultTextFormat = _selection_format;
			}
			else
			{
				_input.setTextFormat(_selection_format, _selection_begin, _selection_end);				
			}
			focus();
		}
		
		public function get lineHeight():Number
		{
			if (_input.numLines==0)
				return 0;
			return _input.getLineMetrics(0).height;
		}
		
		public function get selectionX():Number
		{
			var rect:Rectangle = _input.getCharBoundaries(_input.selectionBeginIndex);
			return rect.x;
		}
		
		public function get selectionY():Number
		{
			var rect:Rectangle = _input.getCharBoundaries(_input.selectionBeginIndex);
			return rect.y - (_input.scrollV-1)*lineHeight;
		}
		
		private function on_scroll(e:Event):void
		{
			if (_dragging)
				return;
				
			_scrollthumb.graphics.clear();
			
			if (_input.scrollV==1 && _input.maxScrollV==1)
				return;
			
			calc_thumb();
			draw_thumb();
			dispatchEvent(new ComponentEvent(RichTextEditor.RTE_SCROLL))
			//trace("INPUTSCROLL: "+_input.scrollV+" "+_input.maxScrollV+" "+_input.numLines);
		}
		
		private function calc_thumb():void
		{
			var visible_lines:uint = (_input.numLines-_input.maxScrollV);
			var percent_scrolled:Number = 1-(_input.maxScrollV-_input.scrollV)/(_input.maxScrollV-1);
			_thumb_h = (visible_lines/_input.numLines)*(height);
			_thumb_y = (height-_thumb_h)*percent_scrolled;
		}

		private function draw_thumb(over:Boolean=false):void
		{
			_scrollthumb.y = _thumb_y;
			_scrollthumb.graphics.clear();
			_scrollthumb.graphics.beginFill(over?_thumb_over_color:_thumb_color,1);
			_scrollthumb.graphics.drawRoundRect(width-10,2,8,_thumb_h-4,8,8);
			_scrollthumb.graphics.endFill();
		}
		
		private function on_rollover_thumb(e:*):void
		{
			draw_thumb(true);
		}
		
		private function on_rollout_thumb(e:*):void
		{
			draw_thumb(false);
		}
		
		private var _click:Point;
		private var _start:Point;
		private var _dragging:Boolean;
		private function on_down_thumb(e:MouseEvent):void
		{
			_click = new Point(e.stageX, e.stageY);
			_start = new Point(_scrollthumb.x, _scrollthumb.y);
			_dragging = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, on_move_thumb);
			stage.addEventListener(MouseEvent.MOUSE_UP, on_release_thumb);
			dispatchEvent(new ComponentEvent(RichTextEditor.RTE_SCROLL))
		}
		
		private function on_move_thumb(e:MouseEvent):void
		{
			var d:Point = new Point(e.stageX, e.stageY).subtract(_click);
			var y:Number = d.y+_start.y;
			if (y+_thumb_h>height)
				y = height-_thumb_h;
			if (y<0)
				y=0;
			_scrollthumb.y = _thumb_y = y;
			var percent_scrolled:Number = y/(height-_thumb_h);
			_input.scrollV = _input.maxScrollV * percent_scrolled;
		}
		
		private function on_release_thumb(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, on_move_thumb);
			stage.removeEventListener(MouseEvent.MOUSE_UP, on_release_thumb);
			_dragging = false;
			_click = null;
			_start = null;
		}
		
	}
}
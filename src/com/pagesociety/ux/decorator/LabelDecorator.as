package com.pagesociety.ux.decorator
{
	
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.style.Style;
	
	import flash.events.TextEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	public class LabelDecorator extends Decorator
	{
		private var _style:Style;
		
		private var _label_x:Number = 0;
		private var _label_y:Number = 0;
		private var _label_width:Number = 0;
		private var _label_height:Number = 0;
		private var _label_alpha:Number = 1;
		private var _label_text_format:TextFormat = TextFormats.BLACK_LABEL;
		private var _label_font_style:String;
		private var _embedded:Boolean = false;
		private var _label_selectable:Boolean = true;
		private var _label_max_chars:uint = 8888;
		private var _label_text:String = "";
		private var _label_is_multiline:Boolean = false;
		private var _label_align:String = TextFieldAutoSize.NONE;
		
		protected var _label:Text;
		
		private var _needs_render:Boolean = true;

		public function LabelDecorator(style:Style)
		{
			super();
			_style = style;
		}
		
		override public function initGraphics():void
		{
			super.initGraphics();
			mouseChildren = false;
			_label = new Text();
			midground.addChild(_label);
		}
		
		public function get label():Text
		{
			return _label;
		}

		override public function decorate():void
		{
			super.decorate();
			if (!_needs_render || _label_text==null)
				return;

			_label.multiline 	= _label_is_multiline;
			_label.wordWrap 	= _label_is_multiline;
			_label.x 			= _label_x;
			_label.y 			= _label_y;
			_label.width 		= _label_width +5;
			_label.height 		= _label_height +5;
			_label.maxChars 	= _label_max_chars;
			_label.alpha 		= _label_alpha;
			if (_label.autoSize != TextFieldAutoSize.CENTER && _label.autoSize != TextFieldAutoSize.RIGHT)
				_label.autoSize 	= _label_is_multiline ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE; //_label_align;
			
			_label.embedFonts 	= _embedded;
			_label.selectable 	= true;//_label_selectable;
			
			var txt:String;
			var style:Object = _style==null?null:_style.getStyle("."+_label_font_style);
			if (style!=null)
			{
				if (_label_text.indexOf("<")!=-1)
				{
					if (_label.styleSheet == null)
						_label.styleSheet = _style.styleSheet;
					_label.htmlText  = _label_text;
				}
				else
				{
					if (_label.styleSheet == null)
						_label.styleSheet = _style.styleSheet;
					_label.htmlText  = "<span class='"+_label_font_style+"'>"+_label_text+"</span>";
				}
			}
			else
			{
//				if (_label_font_style!=null)
//					Logger.log("CANT FIND STYLE "+_label_font_style+" IN STYLESHEET");
				_label.textFormat = _label_text_format;
				_label.text = _label_text;
			}
			
			_label.autoSize 	= TextFieldAutoSize.NONE; //_label_align;
			_needs_render = false;
			
		}
		
		public function get selectable():Boolean
		{
			return _label_selectable;
		}
		
		public function set selectable(b:Boolean):void
		{
			if (b==_label_selectable)
				return;
			_label_selectable = b;
			_needs_render = true;
		}
		
		override public function get width():Number
		{
			decorate();
			var line_metrics:TextLineMetrics = _label.getLineMetrics(0);
			return line_metrics.width+5;
		}
		
		override public function set width(w:Number):void
		{
			if (w==_label_width)
				return;
			super.width = w;
			_label_width = w;
			_needs_render = true;
		}

		override public function get height():Number
		{
			decorate();
			var h:Number = 0;
			var s:uint = _label.numLines;
			for (var i:uint =0; i<s; i++)
			{
				 h += _label.getLineMetrics(i).height;
			}
			return h;
		}
				
		override public function set height(h:Number):void
		{
			if (h==_label_height)
				return;
			super.height = h;
			_label_height = h;
			_needs_render = true;
		}
		
		public function get descent():Number
		{
			decorate();
			var line_metrics:TextLineMetrics = _label.getLineMetrics(0);
			return line_metrics.descent;
		}
		
		public function get ascent():Number
		{
			decorate();
			var line_metrics:TextLineMetrics = _label.getLineMetrics(0);
			return line_metrics.ascent;
		}
		
		public function set labelText(s:String):void
		{
			if (s==_label_text)
				return;
			_label_text = s;
			_needs_render = true;
		}
		
		public function get labelText():String
		{
			return _label_text;
		}
		
		public function set labelX(s:Number):void
		{
			if (s==_label_x)
				return;
			_label_x = s;
			_needs_render = true;
		}
		
		public function get labelX():Number
		{
			return _label_x;
		}
		
		public function set labelY(s:Number):void
		{
			if (s==_label_y)
				return;
			_label_y = s;
			_needs_render = true;
		}
		
		public function get labelY():Number
		{
			return _label_y;
		}
		
		public function set labelTextFormat(t:TextFormat):void
		{
			if (t==_label_text_format)
				return;
			_label_text_format = t;
			_needs_render = true;
		}
		
		public function set labelIsMultiLine(b:Boolean):void
		{
			if (b==_label_is_multiline)
				return;
			_label_is_multiline = b;
			_needs_render = true;
		}
		
		public function get labelIsMultiLine():Boolean
		{
			return _label_is_multiline;
		}
		
		
		public function set fontStyle(s:String):void
		{
			if (s.substr(0,1)==".")
				s = s.substring(1);
			if (s==_label_font_style)
				return;
			_label_font_style = s;
			_needs_render = true;
		}
		
		public function get fontStyle():String
		{
			return _label_font_style;
		}
		
		public function set embedded(b:Boolean):void
		{
			if (b==_embedded)
				return;
			_embedded = b;
			_needs_render = true;
		}
		
		
		
		public function get embedded():Boolean
		{
			return _embedded;
		}
		
		public function set needsRender(b:Boolean):void
		{
			_needs_render = b;
		}
		
		public function get needsRender():Boolean
		{
			return _needs_render;
		}


		public function set linkEnabled(b:Boolean):void
		{
			if (b && !_label.hasEventListener(TextEvent.LINK))
			{
				mouseChildren = true;
				_label.addEventListener(TextEvent.LINK, on_link0);
			}
			else if (!b && _label.hasEventListener(TextEvent.LINK))
			{
				mouseChildren = false;
				_label.removeEventListener(TextEvent.LINK, on_link0);
			}
		}
		
		protected function on_link0(e:TextEvent):void
		{
			//dispatchEvent(new ComponentEvent(TextEvent.LINK, null, e.text));
		}
		
	}
}
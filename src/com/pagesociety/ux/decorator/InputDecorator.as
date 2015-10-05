package com.pagesociety.ux.decorator
{
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.event.InputEvent;
    import com.pagesociety.ux.style.Style;
    
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.events.TimerEvent;
    import flash.system.System;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    
    [Event(type="com.pagesociety.ux.event.ComponentEvent",name="change_value")]
    [Event(type="com.pagesociety.ux.event.InputEvent",name="press_enter_key")]
    [Event(type="com.pagesociety.ux.event.InputEvent",name="lose_focus_while_dirty")]
    public class InputDecorator extends Decorator
    {
        protected var _input:Text;

        protected var _style:Style;
        
        protected var _input_x:Number = 0;
        protected var _input_y:Number = 0;
        protected var _input_width_delta:Number = -12;
        protected var _input_height:Number = 20;
        protected var _input_alpha:Number = 1;
        protected var _input_text_format:TextFormat = TextFormats.BLACK_LABEL;
        protected var _font_style:String;
        protected var _embedded:Boolean = false;
        protected var _input_max_chars:uint = 0;
        protected var _input_text:String = "";
        protected var _input_is_multiline:Boolean = false;

        protected var _key_down_timer:Timer;
        protected var _dirty:Boolean;
        
        public static var TAB_INDEX:uint = 0;
        
        public function InputDecorator(style:Style)
        {
            super();
            _style = style;
        }

        override public function initGraphics():void
        {
            super.initGraphics();
            
            _input = new Text();
            _input.tabIndex = TAB_INDEX++;
            addChild(_input);
            _input.type = TextFieldType.INPUT;
            _input.selectable = true;
            _input.addEventListener(Event.CHANGE, text_input);
            _input.addEventListener(KeyboardEvent.KEY_UP, key_down_input);
            _input.addEventListener(FocusEvent.FOCUS_IN, on_focus);
            _input.addEventListener(FocusEvent.FOCUS_OUT, on_unfocus);
            _input.addEventListener(MouseEvent.MOUSE_OUT, on_mouse_out);
            _input.addEventListener(MouseEvent.MOUSE_OVER, on_mouse_over);
            _input.addEventListener(TextEvent.LINK, on_link);
            
            background.visible = true;
            background.addEventListener(MouseEvent.MOUSE_OVER, on_mouse_over);
            background.addEventListener(MouseEvent.MOUSE_OUT, on_mouse_out);
            
        }
        
        override public function decorate():void
        {
            super.decorate();

            _input.x = _input_x;
            _input.y = _input_y;
            _input.width = _width + _input_width_delta;
            _input.height = _input_height;
            _input.maxChars = _input_max_chars;
            _input.alpha = _input_alpha;
            _input.embedFonts = _embedded;

            var txt:String;
            var style:Object = _font_style==null?null:_style.getStyle("."+_font_style);
            // cannot set a stylesheet
            if (style!=null)
            {
                _input.textFormat = _style.styleSheet.transform(style);
                if (_input.normalColor!=-1)
                    _input.normalColor = _input.normalColor;
            }
            if (_input_text.substring(0,1)=="<")
                _input.htmlText =  _input_text;
            else
                _input.text =  _input_text;
            
            if (_input_is_multiline)
            {
                _input.multiline = true;
                _input.mouseWheelEnabled = true;
                _input.wordWrap = true;
            }
            else
            {
                _input.multiline = false;
                _input.mouseWheelEnabled = false;
                _input.wordWrap = false;                
            }
        }
        
        
        public function get inputField():Text
        {
            return _input;
        }
        
        protected function text_input(e:Event):void
        {
            
            _dirty = true;
            _input_text = _input.text;
            decorate();

            dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE));
        }
        
        private function key_down_input(e:KeyboardEvent):void
        {
            if (e.keyCode==Keyboard.ENTER)
                dispatchEvent(new InputEvent(InputEvent.PRESS_ENTER_KEY));
        }
        
        //unused
        private function do_delayed_keydown_dispatch():void
        {
            if (_key_down_timer==null)
            {
                _key_down_timer = new Timer(333,1);
                _key_down_timer.addEventListener(TimerEvent.TIMER_COMPLETE, on_key_down_timer_complete);
            }
            _key_down_timer.reset();
            _key_down_timer.start();
            _dirty = true;
            _input_text = _input.text;
        }
        //unused
        private function on_key_down_timer_complete(e:TimerEvent):void
        {
            dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE));
        }
        
        private function on_mouse_over(e:Event):void
        {
//          alpha = 1;
        }
        
        private function on_mouse_out(e:Event):void
        {
//          if (stage==null)
//              return;
//          if (stage.focus==_input)
//              alpha = 1;
//          else
//              alpha = _unfocused_alpha;
        }
        
        protected function on_link(e:TextEvent):void
        {
            trace(">T"+e.text);
        }
        
        private function on_focus(e:Event):void
        {
            alpha = 1;
            component.application.focusManager.setFocus(component);
            dispatchEvent(new InputEvent(InputEvent.FOCUS));
        }
        
        private function on_unfocus(e:Event):void
        {
            if (_key_down_timer!=null)
                _key_down_timer.stop();
            if (_dirty)
                dispatchEvent(new InputEvent(InputEvent.LOSE_FOCUS_WHILE_DIRTY));
            dispatchEvent(new InputEvent(InputEvent.LOSE_FOCUS));
        }
        
        
        override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
        {   
            
            super.addEventListener(type,listener,useCapture,priority,useWeakReference);
        }
        
        ////
        
        public function focus():void
        {
            if (stage==null)
                return;
            stage.focus = _input;
        }
         
        override public function set width(w:Number):void
        {
            super.width = w;
        }
        
        override public function set height(h:Number):void
        {
            _input_height = h;
            super.height = h;
        }
        
        public function set inputWidthDelta(w:Number):void
        {
            _input_width_delta = w;
        }
//      
//      public function set inputHeight(h:Number):void
//      {
//          _input_height = h
//      }
        
        public function set inputX(x:Number):void
        {
            _input_x = x;
        }
        
        public function get inputX():Number
        {
            return _input_x;
        }
        
        public function set inputY(y:Number):void
        {
            _input_y = y;
        }
        
        public function get inputY():Number
        {
            return _input_y;
        }
        
        public function get inputValue():String
        {
            return _input.text;
        }
        
        public function set inputValue(s:String):void
        {
            _dirty = false;
            _input_text = s;
        }
        
        public function get enabled():Boolean
        {
            return _input.selectable;
        }
        
        public function set enabled(b:Boolean):void
        {
            _input.selectable = b;
        }
        
        public function get password():Boolean
        {
            return _input.displayAsPassword;
        }
        
        public function set password(b:Boolean):void
        {
            _input.displayAsPassword = b;
        }
        

        public function set normalColor(c:uint):void
        {
            _input.normalColor = c;
        }
        
        public function get normalColor():uint
        {
            return _input.normalColor;
        }
        
        public function set selectedColor(c:uint):void
        {
            _input.selectedColor = c;
        }
        
        public function get selectedColor():uint
        {
            return _input.selectedColor;
        }
        
        public function set selectionColor(c:uint):void
        {
            _input.selectionColor = c;
        }
            
        public function get selectionColor():uint
        {
            return _input.selectionColor;
        }   

        
        public function set inputIsMultiline(b:Boolean):void
        {
            _input_is_multiline = b;
        }
        
        public function get inputIsMultiline():Boolean
        {
            return _input_is_multiline;
        }
        
        public function set inputTextFormat(f:TextFormat):void
        {
            _input_text_format = f;
        }
        
        public function get inputTextFormat():TextFormat
        {
            return _input_text_format;
        }
        
        public function set restrict(s:String):void
        {
            _input.restrict = s;
        }
        
        public function get restrict():String
        {
            return _input.restrict;
        }
        
        
        public function set fontStyle(s:String):void
        {
            if (s.substr(0,1)==".")
                s = s.substring(1);
            _font_style = s;
        }
        
        public function get fontStyle():String
        {
            return _font_style;
        }
        
        public function set embedded(b:Boolean):void
        {
            _embedded = b;
        }
        
        public function get embedded():Boolean
        {
            return _embedded;
        }
        
        public function setSelection(i:uint,j:uint):void
        {
            focus();
            _input.setSelection(i,j);
        }
        
        public function set caretIndex(i:uint):void
        {
            focus();
            _input.setSelection(i,i);
        }
        
        public function get caretIndex():uint
        {
            return _input.caretIndex;
        }

    }
}
package com.pagesociety.ux.component.text
{
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.decorator.Decorator;
    import com.pagesociety.ux.decorator.InputDecorator;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.event.InputEvent;
    
    import flash.events.Event;
    

    [Event(type="com.pagesociety.ux.event.ComponentEvent",name="change_value")]
    [Event(type="com.pagesociety.ux.event.InputEvent",name="submit")]
    [Event(type="com.pagesociety.ux.event.InputEvent",name="press_enter_key")]
    [Event(type="com.pagesociety.ux.event.InputEvent",name="lose_focus_while_dirty")]
    [Event(type="com.pagesociety.ux.event.InputEvent",name="focus")]
    [Event(type="com.pagesociety.ux.event.InputEvent",name="lose_focus")]
        
    public class Input extends Component implements IEditor
    {
        protected var _input_value:String;
        protected var _dirty:Boolean;
        protected var _pattern:RegExp;
        public static const PATTERN_EMAIL:RegExp = /([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}/;
            
        public function Input(parent:Container, index:int=-1)
        {
            super(parent, index);
            decorator = new InputDecorator(application.style);
            styleName = "Component";
            styleName = "Input";
            //value = "";
        }
        
        override public function set decorator(d:Decorator):void
        {
            super.decorator = d;
            d.addEventListener(ComponentEvent.CHANGE_VALUE, on_change_value);
            d.addEventListener(InputEvent.PRESS_ENTER_KEY, on_submit_value_enter);
            d.addEventListener(InputEvent.LOSE_FOCUS_WHILE_DIRTY, on_submit_value_lost_focus);
            d.addEventListener(InputEvent.FOCUS, on_focus);
            d.addEventListener(InputEvent.LOSE_FOCUS, on_lose_focus);
        }
        
        
        //event handlers
        private function on_change_value(e:Event):void
        {
            _input_value = inputDecorator.inputValue;
            if (_pattern!=null)
            {
                var b:Boolean = valid;
                if (!b)
                    trace("!!!!!!!!!!!!!!!DONTMATCH");
                else
                    trace("!!!OK");
            }
            _dirty = true;
            dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE, this));
        }
        
        private function on_submit_value_enter(e:InputEvent):void
        {
            if (valid)
            {
                dispatchEvent(new InputEvent(InputEvent.PRESS_ENTER_KEY,this,value));
                dispatchEvent(new InputEvent(InputEvent.SUBMIT,this,value));
            }
        }
        
        private function on_submit_value_lost_focus(e:InputEvent):void
        {
            if (valid)
            {
                dispatchEvent(new InputEvent(InputEvent.LOSE_FOCUS_WHILE_DIRTY,this,value));
                dispatchEvent(new InputEvent(InputEvent.SUBMIT,this,value));
            }
        }
        
        private function on_focus(e:InputEvent):void
        {
            dispatchEvent(new InputEvent(InputEvent.FOCUS,this,value));
        }
        
        private function on_lose_focus(e:InputEvent):void
        {
            dispatchEvent(new InputEvent(InputEvent.LOSE_FOCUS,this,value));
        }
        
        
        // properties
        public function get inputDecorator():InputDecorator
        {
            return decorator as InputDecorator;
        }
        
        public function set value(v:Object):void 
        {
            if (v==null)
                v = "";
            _input_value = v.toString();
            inputDecorator.inputValue = _input_value;
            //inputDecorator.caretIndex = _input_value.length;
            _dirty = false;
        }
        
        public function get value():Object
        {
            if (_input_value==null)
                return "";
            return _input_value;
        }
        
        public function get stringValue():String
        {
            return _input_value;
        }
        
        public function get enabled():Boolean
        {
            return inputDecorator.enabled;
        }
        
        public function set enabled(b:Boolean):void
        {
            inputDecorator.enabled = b;
        }
        
        public function get password():Boolean
        {
            return inputDecorator.password;
        }
        
        public function set password(b:Boolean):void
        {
            inputDecorator.password = b;
        }
        
        
        public function get valid():Boolean
        {
            if (_pattern!=null)
            {
                var b:Boolean = _pattern.test(_input_value);
                return b;
            }
            return true;
        }
        
        public function get dirty():Boolean
        {
            return _dirty;
        }
        
        public function set dirty(b:Boolean):void
        {
            _input_value = inputDecorator.inputValue;
            _dirty = b;
        }
        
        public function set pattern(r:RegExp):void
        {
            _pattern = r;
        }
        
        public function get pattern():RegExp
        {
            return _pattern;
        }
        
        public function set restrict(s:String):void
        {
            inputDecorator.restrict = s;
        }
        
        public function get restrict():String
        {
            return inputDecorator.restrict;
        }
        
        public function set multiline(b:Boolean):void
        {
            inputDecorator.inputIsMultiline = b;
        }
        
        public function get multiline():Boolean
        {
            return inputDecorator.inputIsMultiline;
        }
        
        public function set fontStyle(s:String):void
        {
            if (s==null)
                return;
            inputDecorator.fontStyle = s;
        }
        
        public function get fontStyle():String
        {
            return inputDecorator.fontStyle;
        }
        
        public function focus():void
        {
            inputDecorator.focus();
        }
    }
}
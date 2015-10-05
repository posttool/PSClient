package com.pagesociety.ux.component
{
    import com.pagesociety.ux.decorator.ButtonDecorator;
    import com.pagesociety.ux.decorator.Decorator;
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.events.MouseEvent;
    import flash.text.TextFormat;
    
    public class ToggleButton extends Button
    {
        private var _value:Boolean;
        private var _true_color:uint = 0x0066ff;
        private var _false_color:uint = 0xff0000;
        private var _over_color:uint = 0xcccccc;
        
        public function ToggleButton(parent:Container, index:int=-1)
        {
            super(parent, index);
            backgroundVisible = true;
            add_mouse_over_default_behavior();
        }
        
        public function set value(b:Boolean):void
        {
            _value = b;
        }
        
        public function get value():Boolean
        {
            return _value;
        }
        
        public function set trueColor(c:uint):void
        {
            _true_color = c;
        }
        
        public function get trueColor():uint
        {
            return _true_color;
        }
        
        public function set falseColor(c:uint):void
        {
            _false_color = c;
        }
        
        public function get falseColor():uint
        {
            return _false_color;
        }
        
        public function set overColor(c:uint):void
        {
            _over_color = c;
        }
        
        public function get overColor():uint
        {
            return _over_color;
        }
        
        override public function render():void
        {
            if (_over)
                backgroundColor = _over_color;
            else if (_value)
                backgroundColor = _true_color;
            else
                backgroundColor = _false_color;
            super.render();
        }
        
        
        
        
    }
}
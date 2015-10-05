package com.pagesociety.ux.component
{
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.events.MouseEvent;
    import flash.geom.Point;

    [Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
    public class ColorChooserPopUp extends Container implements IEditor
    {
        // 
        private var _chooser:ColorChooser;
        private var _small_swatch:Component;
        private var _color:uint;
        private var _dirty:Boolean;
        
        public function ColorChooserPopUp(parent:Container, index:int=-1)
        {
            super(parent, index);
            
            _small_swatch = new Component(this);
            _small_swatch.backgroundVisible = true;
            _small_swatch.backgroundBorderVisible = false;
            _small_swatch.backgroundBorderAlpha = .5;
            _small_swatch.backgroundBorderColor = 0xffffff;
            _small_swatch.addEventListener(ComponentEvent.CLICK, on_click_swatch);
        }
        
        private function on_click_swatch(e:ComponentEvent):void
        {
            if (_chooser==null)
            {
                _chooser = new ColorChooser(this);
                _chooser.addEventListener(ComponentEvent.CHANGE_VALUE, on_change_color_chooser_value);
            }
            _chooser.value = _color;
            //position chooser
            _chooser.x = -200;
            var p:Point = _chooser.getRootPosition();
            if (p.y+_chooser.height>application.height)
                _chooser.y = p.y-application.height;
            else
                _chooser.y = 0;
            //show chooser
            _chooser.visible = true;
            application.pushTakeOver(_chooser, on_close_chooser, 0, 0, false);
        }
        
        private function on_close_chooser(e:*):void
        {
            application.hideTakeOver();
        }
        
        private function on_change_color_chooser_value(e:ComponentEvent):void
        {
            _color = e.data;
            _dirty = true;
            render();
            dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, _color);
        }
        
        public function get value():Object
        {
            return _color;
        }
        
        public function set value(o:Object):void
        {
            _color = o as uint;
            _dirty = false;
        }
        
        public function get dirty():Boolean
        {
            return _dirty;
        }
        
        public function set dirty(b:Boolean):void
        {
            _dirty = b;
        }
        
        override public function render():void
        {
            if (_chooser!=null)
                _chooser.value = _color;
            _small_swatch.backgroundColor = _color;
//          _small_swatch.backgroundBorderVisible = (_color<0x333333);
            super.render();
        }
        
    }
}
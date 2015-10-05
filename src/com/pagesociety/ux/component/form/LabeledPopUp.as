package com.pagesociety.ux.component.form
{
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.PopUpMenu;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.event.ComponentEvent;
    
    [Event(type="com.pagesociety.ux.event.ComponentEvent",name="change_value")]
    public class LabeledPopUp extends Container implements IEditor
    {
        private var _label:Label;
        private var _popup:PopUpMenu;
        
        public function LabeledPopUp(parent:Container, fieldname:String, label:String, options:Array, fs_label:String=null, fs_input:String=null)
        {
            super(parent);
            id = fieldname;

            _label = new Label(this);
            _label.text = label;
            if (fs_label!=null)
                _label.fontStyle = fs_label;
            
            _popup = new PopUpMenu(this,PopUpMenu.TYPE_SCROLL_BAR);
            if (fs_input!=null)
                _popup.styleName = fs_input;
            _popup.button.label = "Choose...";
            _popup.lineHeight = 30;
            _popup.y = 15;
            _popup.width = 100;
            _popup.addEventListener(ComponentEvent.CHANGE_VALUE, onBubbleEvent);
            
            for (var i:uint=0; i<options.length; i++)
            {
                if (options is Array)   
                    _popup.addOption(options[i][0],options[i][1]);
                else
                    _popup.addOption(options[i]);
            }
        }
                
        public function get popup():PopUpMenu
        {
            return _popup;
        }
        
        public function get value():Object
        {
            return _popup.value;
        }
        
        public function set value(o:Object):void
        {
            _popup.value = o;
        }
        
        public function get dirty():Boolean
        {
            return _popup.dirty;
        }
        
        public function set dirty(b:Boolean):void
        {
            _popup.dirty = b;
        }
        
        override public function get height():Number
        {
            return 55;
        }
        
        
        
        
        
    }
}
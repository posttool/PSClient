package com.pagesociety.ux.component.form
{
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.PopUpMenu;
    
    public class BooleanEditor extends PopUpMenu
    {
        public function BooleanEditor(parent:Container, type:uint)
        {
            super(parent, type);
            button.label = "Choose...";
            addOption("yes");
            addOption("no");
        }
        
        override public function get value():Object
        {
            return selectedIndex == 0;
        }
        
        override public function set value(o:Object):void
        {
            if (o)
                selectedIndex = 0;
            else
                selectedIndex = 1;
        }
        
    }
}
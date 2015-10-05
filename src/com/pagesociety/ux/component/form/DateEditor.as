package com.pagesociety.ux.component.form
{
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.text.Input;

    public class DateEditor extends Input
    {
        public function DateEditor(parent:Container)
        {
            super(parent);
        }
        
        override public function get value():Object
        {
            return new Date(super.value);
        }
        
        
        
    }
}
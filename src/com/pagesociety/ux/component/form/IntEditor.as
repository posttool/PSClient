package com.pagesociety.ux.component.form
{
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.text.Input;

    public class IntEditor extends Input
    {
        public function IntEditor(parent:Container)
        {
            super(parent);
//          restrict = "0-9";
        }
        
        override public function get value():Object
        {
            var i:String = super.value as String;
            var ii:int = parseInt(i);
            if (isNaN(ii))
                return 0;
            return ii;
        }
        
        
        
    }
}
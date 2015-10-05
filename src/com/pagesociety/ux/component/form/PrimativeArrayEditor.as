package com.pagesociety.ux.component.form
{
    import com.pagesociety.persistence.FieldDefinition;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.text.Input;
    
    public class PrimativeArrayEditor  extends Input
    {
        private var _field:FieldDefinition;
        public function PrimativeArrayEditor(parent:Container)
        {
            super(parent);
        }
        
        override public function get value():Object
        {
            return super.value.split(",");
        }
        
        
        
    }
}
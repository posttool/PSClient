package com.pagesociety.ux.component.form
{
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.text.Label;
    

    public class LabeledEditor extends Container
    {
        private var _label:Label;
        
        public function LabeledEditor(parent:Container, fieldname:String, label:String, fs_label:String=null)
        {
            super(parent);
            id = fieldname;

            _label = new Label(this);
            _label.text = label;
            if (fs_label!=null)
                _label.fontStyle = fs_label;
            
            
        }
        
        public function get editor():Component
        {
            if (children.length<2)
                return null;
            return children[1];
        }
        
        
        
    }
}
package com.pagesociety.ux.component
{
    import com.pagesociety.ux.IToolTip;
    import com.pagesociety.ux.component.text.Label;
    
    public class ToolTip extends Label implements IToolTip
    {
        public function ToolTip(parent:Container, index:int=-1)
        {
            super(parent, index);
            styleName = "ToolTip";
        }
        
    }
}
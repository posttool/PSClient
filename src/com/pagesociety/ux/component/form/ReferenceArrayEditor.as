package com.pagesociety.ux.component.form
{
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.container.Browser;
    import com.pagesociety.ux.event.BrowserEvent;

    [Event(type="com.pagesociety.ux.component.form.ReferenceEditor", name="create_reference")]
    [Event(type="com.pagesociety.ux.component.form.ReferenceEditor", name="link_reference")]
    [Event(type="com.pagesociety.ux.event.BrowserEvent", name="dragging")]
    [Event(type="com.pagesociety.ux.event.BrowserEvent", name="double_click")]
    [Event(type="com.pagesociety.ux.event.BrowserEvent", name="add")]
    [Event(type="com.pagesociety.ux.event.BrowserEvent", name="remove")]
    public class ReferenceArrayEditor extends ReferenceEditor implements IEditor
    {
        
        public function ReferenceArrayEditor(parent:Container,create_add:Boolean=true,create_link:Boolean=true)
        {
            super(parent,create_add,create_link);

        }
        
        
        public function get browser():Browser
        {
            return _browser;
        }
        
        override public function set value(o:Object):void
        {
            if (o==null)
                _browser.value = [];
            else
                _browser.value = o;

            render();
        }
        
        override public function get value():Object
        {
            
            return _browser.value;
        }
        
    
        
        
        public function get lastChildIndex():uint
        {
            return _browser.children.length;
        }
        
        
        public function like(o:Array, p:Array):Boolean
        {
            if (o==null && p==null)
                return true;
            if (o==null && p!=null)
                return false;
            if (o!=null && p==null)
                return false;
            if (o.length!=p.length)
                return false;
            for (var i:uint=0; i<o.length; i++)
            {
                if (o[i] is Entity)
                {
                    if (o[i].id.longValue != p[i].id.longValue)
                        return false;
                }
                else if (o[i] != p[i]) 
                {
                    return false;
                }
            }
            return true;
        }

        
    }
}
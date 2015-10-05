package com.pagesociety.ux.component.text
{
    import com.pagesociety.ux.ISelectable;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.decorator.LinkDecorator;

    public class Link extends Label implements ISelectable
    {   
        private var _link_color_normal:uint;
        private var _link_color_over:uint;
        private var _link_thickness_normal:int;
        private var _link_thickness_over:int;
        private var _link_color_selected:uint;
        
        private var _is_selected:Boolean = false;
                
        public function Link(parent:Container, index:int=-1)
        {
            super(parent, index);
            decorator = new LinkDecorator(application.style);
            styleName = "Link";
        }
        public function get linkDecorator():LinkDecorator
        {
            return decorator as LinkDecorator;
        }
        
        public function set selected(b:Boolean):void
        {
            _is_selected = b;
            linkDecorator.selected = b;
        }
        
        public function get selected():Boolean
        {
            return _is_selected;
        }
        
        public function set normalColor(c:uint):void
        {
            _link_color_normal = c;
            linkDecorator.normalColor = c;
        }
        
        public function get normalColor():uint
        {
            return _link_color_normal;
        }
        
        public function set normalThickness(c:int):void
        {
            _link_thickness_normal = c;
            linkDecorator.normalThickness = c;
        }
        
        public function get normalThickness():int
        {
            return _link_thickness_normal;
        }
        
        public function set overColor(c:uint):void
        {
            _link_color_over = c;
            linkDecorator.overColor = c;
        }
        
        public function get overColor():uint
        {
            return _link_color_over;
        }
        
        public function set overThickness(c:int):void
        {
            _link_thickness_over = c;
            linkDecorator.overThickness = c;
        }
        
        public function get overThickness():int
        {
            return _link_thickness_over;
        }
        
        public function set selectedColor(c:uint):void
        {
            _link_color_selected = c;
            linkDecorator.selectedColor = c;
        }
        
        public function get selectedColor():uint
        {
            return _link_color_selected;
        }
        
        override public function get height():Number
        {
            if (!isHeightUnset)
                return super.height;
            if (decorator == null)
                return 0;
            return linkDecorator.height;
        }
        
    }
}
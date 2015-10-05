package com.pagesociety.ux.component.form
{
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.ISelectable;
    import com.pagesociety.ux.Margin;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.container.Browser;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.component.text.Link;
    import com.pagesociety.ux.event.BrowserEvent;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.layout.GridLayout;

    [Event(type="com.pagesociety.ux.component.form.ReferenceEditor", name="create_reference")]
    [Event(type="com.pagesociety.ux.component.form.ReferenceEditor", name="link_reference")]
    [Event(type="com.pagesociety.ux.event.BrowserEvent", name="dragging")]
    [Event(type="com.pagesociety.ux.event.BrowserEvent", name="double_click")]
    [Event(type="com.pagesociety.ux.event.BrowserEvent", name="add")]
    [Event(type="com.pagesociety.ux.event.BrowserEvent", name="remove")]
    
    public class ReferenceEditor extends Container implements IEditor
    {
        public static var CREATE_REFERENCE:String = "create_reference";
        public static var LINK_REFERENCE:String = "link_reference";
        
        protected var _browser:Browser;
        protected var _add:Component;
        protected var _link:Component;
        
        public function ReferenceEditor(parent:Container,create_add:Boolean=true,create_link:Boolean=true)
        {
            super(parent);
            
            _browser = new Browser(this);
            _browser.decoratorType = Browser.DECORATOR_SCROLL_BAR;
            _browser.layoutType = Browser.LAYOUT_GRID_VERTICAL;
            Object(_browser.layout).cellWidth = 200;
            Object(_browser.layout).cellHeight = 30;
            _browser.layout.margin.top = 3;
            _browser.layout.margin.right = 3;
                
                    
            _browser.addDropTargetForChildren(_browser);
            _browser.reorderable = true;
            _browser.deletable = true;
//          _browser.addEventListener(BrowserEvent.SINGLE_CLICK, select_component_event);
            _browser.addEventListener(BrowserEvent.DOUBLE_CLICK, onBubbleEvent);
            _browser.addEventListener(BrowserEvent.DRAGGING, onBubbleEvent);
            _browser.addEventListener(BrowserEvent.ADD, onBubbleEvent);
            _browser.addEventListener(BrowserEvent.REMOVE, onBubbleEvent);
            _browser.addEventListener(ComponentEvent.CHANGE_VALUE, onBubbleEvent);
            
            if (create_add)
            {
                _add = get_add_button();
                if (_add != null)
                    _add.addEventListener(ComponentEvent.CLICK, on_click_add);
            }
            if (create_link)
            {
                _link = get_link_button();
                if (_link != null)
                    _link.addEventListener(ComponentEvent.CLICK, on_click_link);
            }
            
            
        }
        
        protected function get_add_button():Component
        {
            var add:Link = new Link(this);
            //add.fontStyle = "black_small";
            add.text = "+ CREATE";
            add.align = Label.ALIGN_RIGHT;
            add.x = -70;
            add.y = -15;
            return add;
        }
        
        protected function get_link_button():Component
        {
            var link:Link = new Link(this);
            //link.fontStyle = "black_small";
            link.text = "> BROWSE";
            link.align = Label.ALIGN_RIGHT;
            link.x = -5;
            link.y = -15;
            return link
        }
        
        protected function on_click_add(e:ComponentEvent):void
        {
            dispatchComponentEvent(ReferenceEditor.CREATE_REFERENCE, this);
        }
        
        protected function on_click_link(e:ComponentEvent):void
        {
            dispatchComponentEvent(ReferenceEditor.LINK_REFERENCE, this);
        }
        
        public function set cellWidth(n:Number):void
        {
            _browser.cellWidth = n;
        }
        
        public function get cellWidth():Number
        {
            return _browser.cellWidth;
        }
        
        public function set cellHeight(n:Number):void
        {
            _browser.cellHeight = n;
        }
        
        public function get cellHeight():Number
        {
            return _browser.cellHeight;
        }
        
        public function get selectionIndex():int
        {
            return _browser.selectionIndex;
        }
        
        public function set selectionIndex(i:int):void
        {
            _browser.selectionIndex = i;
            //select_component(_browser.selectionComponent);
        }
        
        public function get dirty():Boolean
        {
            return _browser.dirty;
        }
        
        public function set dirty(b:Boolean):void
        {
            _browser.dirty = b;
        }
        
        public function set value(o:Object):void
        {
            if (o==null)
                _browser.value = [];
            else
                _browser.value = [ o ];
            render();
        }
        
        public function get value():Object
        {
            var v:Array = _browser.value as Array;
            if (v==null || v.length==0)
                return null;
            return v[0];
        }
        
        public function set cellRenderer(f:Function):void
        {
            _browser.cellRenderer = f;
        }
//      
//      protected function select_component_event(c:BrowserEvent):void
//      {
//          select_component(c.changeTarget);
//          render();
//      }
//      
//      protected var _single_select:Boolean = true;
//      protected var _last_selected:ISelectable;
//      
//      protected function select_component(c:Component):void
//      {
//          var s:ISelectable = c as ISelectable;
//          if (s==null)
//          {
//              Logger.error("Component "+c+" is not ISelectable");
//              return;
//          }
//          if (_single_select && _last_selected != null)
//          {
//              _last_selected.selected = false;
//          }
//          _last_selected = s;
//          s.selected = !s.selected;
//      }
//      
        
        
//      override public function onFocus(e:FocusEvent):void
//      {
//          if (e.type==FocusEvent.UNFOCUS_CHILD)
//          {
//              for (var i:uint=0; i<_browser.children.length; i++)
//              {
//                  if (_browser.children[i] is ISelectable)
//                      _browser.children[i].selected = false;
//              }
//              render();
//          }
//      }
        
    
        
    }
}
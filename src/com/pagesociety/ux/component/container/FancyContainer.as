package com.pagesociety.ux.component.container
{

    import com.pagesociety.persistence.Entity;
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.IErrorHandler;
    import com.pagesociety.ux.ISelectable;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.event.ComponentEvent;

    public class FancyContainer extends Container
    {
        private var _use_single_selection:Boolean;
        private var _selected:Component;

        public function FancyContainer(parent:Container, use_single_selection:Boolean=false, index:int=-1)
        {
            super(parent, index);
            _use_single_selection = use_single_selection;
        }
        
    
//      protected function get root():NCRoot
//      {
//          return application.container.children[0] as NCRoot;
//      }
        
    
        
        
        // for containers with selectable children
        override public function addComponent(child:Component,i:int=-1):void
        {
            super.addComponent(child,i);
            if (_use_single_selection && child is ISelectable)
                child.addEventListener(ComponentEvent.CLICK, on_click);
        }
        
        private function on_click(e:ComponentEvent):void
        {
            select(e.component);
            render();
            dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this);
        }
        
        public function select(c:Component):void
        {
            var s:ISelectable;
            if (_selected!=null)
            {
                s = _selected as ISelectable;
                if (s!=null)
                    s.selected = false;
            }
            _selected = c;
            s = c as ISelectable;
            if (s!=null)
                s.selected = true;
        }
        
        public function get selectedComponent():Component
        {
            return _selected;
        }
        
        
        
        
        
        
        
        // form value get & set
        
        public function transferToEntity(e:Entity, fields:Array=null):void
        {
            if (fields==null)
            {
                fields = new Array();
                for (var p:String in e.attributes)
                    fields.push(p);
            }
            for (var i:uint=0; i<fields.length; i++)
            {
                e.$[fields[i]] = getFormValue(fields[i]);
            }
        }
        
        public function transferFromEntity(e:Entity, fields:Array=null):void
        {
            if (fields==null)
            {
                fields = new Array();
                for (var p:String in e.attributes)
                    fields.push(p);
            }
            for (var i:uint=0; i<fields.length; i++)
            {
                setFormValue(fields[i], e.$[fields[i]]);
            }
        }
        
        public function clearFormValues(node:Component=null):void
        {
            if (node==null)
                node = this;
            if (node is IEditor)
                IEditor(node).value = null;
            if (node is Container)
                for (var i:uint=0; i<Container(node).children.length; i++)
                    clearFormValues(Container(node).children[i]);
        }
        
        
        public function getFormValue(field_name:String):*
        {
            var v:Component = getById("field_"+field_name);
            if (v!=null && v is IEditor)
                return IEditor(v).value;
            else
                throw new Error("No such field editor: "+field_name);
        }
        
        public function setFormValue(field_name:String, value:*):void
        {
            var v:* = getById("field_"+field_name);
            if (v==null)
            {
                //trace("No such field editor: "+field_name);
                //throw new Error
                return;
            }
            try 
            {
                v.value = value;
            }
            catch (e:Error)
            {
                Logger.error(e);
            }
        }
        
        public function setText(id:String, value:String):void
        {
            var v:* = getById(id);
            if (v==null)
            {
                trace("No such label: "+id);
                return;
            }
            try 
            {
                v.text = value;
            }
            catch (e:Error)
            {
                Logger.error(e);
            }
        }
        
        public function clearErrors(node:Component=null):void
        {
            if (node==null)
                node = this;
            if (node is IErrorHandler)
                IErrorHandler(node).clearError();
            if (node is Container)
                for (var i:uint=0; i<Container(node).children.length; i++)
                    clearErrors(Container(node).children[i]);
        }
        
        public function clearFormError(field_name:String):void
        {
            var v:Component = getById("field_"+field_name);
            if (v==null)
                throw new Error("No such field editor: "+field_name);
            if (!(v is IErrorHandler))
                throw new Error("Component: "+v+" is not an IErrorHandler");
            IErrorHandler(v).clearError();
            v.render();

        }
        
        public function setFormError(field_name:String, error_message:String):void
        {
            var v:Component = getById("field_"+field_name);
            if (v==null)
                throw new Error("No such field editor: "+field_name);
            if (!(v is IErrorHandler))
                throw new Error("Component: "+v+" is not an IErrorHandler");
            IErrorHandler(v).errorMessage = error_message;
            v.render();

        }
        
        
        
        
        
    }
}
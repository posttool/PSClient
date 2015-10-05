package com.pagesociety.ux.component.form
{
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    
    public class EntityContainerUtil
    {
        
        public static function getEditors(c:Container):Array
        {
            var a:Array = [];
            for (var i:uint; i<c.children.length; i++)
            {
                get_editors(c.children[i],a);
            }
            return a;
        }
        
        private static function get_editors(c:Component,a:Array):void
        {
            if (c is IEditor)
            {
                a.push(c as IEditor);
            }
            if (c is Container)
            {
                var cc:Container = c as Container;
                for (var i:uint=0; i<cc.children.length; i++)
                {
                    get_editors(cc.children[i],a);
                }
            }
        }
        
        
        public static function getValuesFromEditors(c:Container,e:Entity=null):Entity
        {
            if (e==null)
                e = new Entity("untyped");
            for (var i:uint; i<c.children.length; i++)
            {
                collect_values(c.children[i],e);
            }
            return e;
        }
        
        private static function collect_values(c:Component,entity:Entity):void
        {
            if (!c.visible)
                return;
            if (c is IEditor)
            {
                var ec:IEditor = c as IEditor;
                if (c.id != null && (ec.dirty || entity.$[c.id]!=ec.value))
                {
                    entity.setAttribute(c.id, ec.value);
                }
            }
            if (c is Container)
            {
                var cc:Container = c as Container;
                for (var i:uint=0; i<cc.children.length; i++)
                {
                    collect_values(cc.children[i],entity);
                }
            }
        }
        
        
        public static function setEditorValuesFromEntity(entity:Entity,c:Container):void
        {
            for (var i:uint; i<c.children.length; i++)
            {
                set_values(c.children[i],entity);
            }
        }
        
        private static function set_values(c:Component,entity:Entity):void
        {
            if (!c.visible)
                return;
            if (entity==null)
                throw new Error("Can't set values of null entity");
        
            if (c is IEditor && c.id != null)
            {
                var ec:IEditor = c as IEditor;
                var v:Object = entity.$[c.id];
                ec.value = v;
            }
            if (c is Container)
            {
                var cc:Container = c as Container;
                for (var i:uint=0; i<cc.children.length; i++)
                {
                    set_values(cc.children[i],entity);
                }
            }
        }
        
        
        public static function isUploading(c:Component):Boolean
        {
            return find_uploading_resource_editor(c);
        }

        private static function find_uploading_resource_editor(c:Component):Boolean
        {
            if (c is ResourceEditor)
            {
                var r0:ResourceEditor = c as ResourceEditor;
                if (r0.uploading)
                    return true;
            }
            
            if (c is ResourceArrayEditor1)
            {
                var r2:ResourceArrayEditor1 = c as ResourceArrayEditor1;
                if (r2.uploading)
                    return true;
            }
            if (c is Container)
            {
                var cc:Container = c as Container;
                for (var i:uint=0; i<cc.children.length; i++)
                {
                    if (find_uploading_resource_editor(cc.children[i]))
                        return true;
                }
            }
            return false;
        }
        
        public static function isDirty(c:Component):Boolean
        {
            return is_dirty(c);
        }
        
        private static function is_dirty(c:Component):Boolean
        {
            if (c is IEditor)
            {
                var ec:IEditor = c as IEditor;
                if (c.id != null && ec.dirty)
                {
                    //trace("EntityContainerUtil: dirty field="+c.id);
                    return true;
                }
            }
            if (c is Container)
            {
                var cc:Container = c as Container;
                for (var i:uint=0; i<cc.children.length; i++)
                {
                    if (is_dirty(cc.children[i]))
                        return true;
                }
            }
            return false;
        }
        
        public static function setDirty(c:Component,b:Boolean):void
        {
            set_dirty(c,b);
        }
        
        private static function set_dirty(c:Component,b:Boolean):void
        {
            if (c is IEditor)
            {
                var ec:IEditor = c as IEditor;
                ec.dirty = b;
            }
            if (c is Container)
            {
                var cc:Container = c as Container;
                for (var i:uint=0; i<cc.children.length; i++)
                    set_dirty(cc.children[i], b);
            }
        }
    }
}
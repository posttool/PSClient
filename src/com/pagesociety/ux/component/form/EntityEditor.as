package com.pagesociety.ux.component.form
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;

	public class EntityEditor extends Container implements IEditor
	{

		public function EntityEditor(parent:Container, index:Number=-1)
		{
			super(parent, index);
		}
		
		public function set value(o:Object):void
		{
			super.userObject = o as Entity;
			for (var i:uint; i<children.length; i++)
			{
				set_values(children[i]);
			}
		}
		
		public function get value():Object
		{
			for (var i:uint; i<children.length; i++)
			{
				collect_values(children[i]);
			}
			return userObject;
		}
		
		private function get entity():Entity
		{
			return userObject as Entity;
		}
		
		private function collect_values(c:Component):void
		{
			if (!c.visible)
				return;
			if (c is IEditor)
			{
				var ec:IEditor = c as IEditor;
				if (ec.dirty && c.id!=null)
				{
					entity.setAttribute(c.id, ec.value);
				}
			}
			if (c is Container)
			{
				var cc:Container = c as Container;
				for (var i:uint=0; i<cc.children.length; i++)
				{
					collect_values(cc.children[i]);
				}
			}
		}
		
		private function set_values(c:Component):void
		{
			if (!c.visible)
				return;
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
					set_values(cc.children[i]);
				}
			}
		}
		
		public function get dirty():Boolean
		{
			return is_dirty(children);
		}
		
		public function set dirty(b:Boolean):void
		{
			//_dirty = b;
		}
		
		private function is_dirty(a:Array):Boolean
		{
			for (var i:uint=0; i<a.length; i++)
			{
				var c:Component = a[i];
				if (c is IEditor)
				{
					var ec:IEditor = c as IEditor;
					if (ec.dirty)
						return true;
				}
				if (c is Container)
				{
					var d:Boolean = is_dirty(Container(c).children);
					if (d)
						return true;
	  			}
	  		}
	  		return false;
		}
		
		public function get uploading():Boolean
		{
			return find_uploading_resource_editor(this);
		}

		private function find_uploading_resource_editor(c:Component):Boolean
		{
			if (c is ResourceEditor)
			{
				var r0:ResourceEditor = c as ResourceEditor;
				if (r0.uploading)
					return true;
			}
			if (c is ResourceArrayEditor1)
			{
				var r1:ResourceArrayEditor1 = c as ResourceArrayEditor1;
				if (r1.uploading)
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
		
	}
}
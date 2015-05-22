package com.pagesociety.ux.system
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.web.module.TreeModule;
	
	public class TreeUtil
	{
		public static function atHome(node:Entity):Boolean
		{
			return node.$[TreeModule.TREENODE_FIELD_PARENT_NODE]==null;
		}
		
		public static function addParents(n:Entity):Entity
		{
			add_parent(n, n.$.children);
			return n;
		}
		
		public static function add_parent(p:Entity, c:Array):void
		{
			if (c==null)
				return;
			for (var i:uint=0; i<c.length; i++)
			{
				c[i].$[TreeModule.TREENODE_FIELD_PARENT_NODE] = p;
				add_parent(c[i], c[i].$.children);
			}
		}
		
		public static function getById(root:Entity, id:uint):Entity
		{
			if (root==null)
				return null;
			return get_by_id(root, id, 0);
		}
		
		private static function get_by_id(n:Entity, search_id:uint, depth:uint):Entity
		{
			//var s:String = "";
			//for (var q:uint=0; q<depth; q++)
			//	s+="  ";
			//trace(">"+s+" "+n+" ("+search_id+") "+n.$.data.$.title);
			if (n.id.longValue == search_id)
				return n;
			if (n.$.children != null)
				for (var i:uint=0; i<n.$.children.length; i++)
				{
					var nc:Entity = get_by_id(n.$.children[i], search_id, depth+1);
					if (nc != null)
						return nc;
				}
			return null;
		}
		
		public static var TNIDF:String = TreeModule.TREENODE_FIELD_NODE_ID;
		public static function getByPermalink(root:Entity, pl:String):Entity
		{
			if (root==null)
				return null;
			if (pl=="" || pl=="/")
				return root;
			return get_by_pl(root, pl, 0);
		}
		
		private static function get_by_pl(n:Entity, pl:String, depth:uint):Entity
		{
			if (n.$[TNIDF] == pl)
				return n;
			var chl:Array = n.$[TreeModule.TREENODE_FIELD_CHILDREN];
			if (chl != null)
				for (var i:uint=0; i<chl.length; i++)
				{
					var nc:Entity = get_by_pl(chl[i], pl, depth+1);
					if (nc != null)
						return nc;
				}
			return null;
		}
		
		
		public static function getAncestors(root:Entity, id:uint):Array
		{
			var a:Array = new Array();
			var p:Entity = get_by_id(root, id, 0);
			while (p != null)
			{
				a.unshift(p);
				p = p.$.parent_node;
				if (p != null)
					p = get_by_id(root, p.id.longValue, 0);
			}
			return a;
		}
		
		public static function getByType(root:Entity, type:String):Entity
		{
			var a:Array = getAllByType(root,type);
			if (a.length==0)
				return null;
			else
				return a[0];
		}
		
		public static function getAllByType(root:Entity, type:String):Array
		{
			var a:Array = new Array();
			if (root==null)
				return a;
			get_by_type(root, type, a);
			return a;
		}
		
		private static function get_by_type(n:Entity, type:String, a:Array):void
		{
			if (n.$.data==null)
				throw new Error("WHY IS data null");
			if (n.$.data.type == type)
				a.push(n);
			if (n.$.children != null)
				for (var i:uint=0; i<n.$.children.length; i++)
					get_by_type(n.$.children[i], type, a);
		}
		
		public static function getRandom(root:Entity):Entity
		{
			if (root==null)
				return null;
			var tn:Entity = get_random(root);
			if (tn==null)
				return root;
			else
				return tn;
		}
		
		private static function get_random(n:Entity):Entity
		{
			if (Math.random()<.1)
				return n;
			if (n.$.children != null)
				for (var i:uint=0; i<n.$.children.length; i++)
				{
					var nc:Entity = get_random(n.$.children[i]);
					if (nc != null)
						return nc;
				}
			return null;
		}
		
		//////
	
		
		public static function get_sibling_or_ancestors_sibling(root:Entity,node:Entity):Entity
		{
			var sib:Entity = get_sibling_leaf(root, node);
			while (sib==null && node!=null)
			{
				node = TreeUtil.getById(root, node.$[TreeModule.TREENODE_FIELD_PARENT_NODE].id);
				sib = get_sibling_leaf(root, node);
			}
			return sib;
		}
		public static function get_sibling_leaf(root:Entity,node:Entity):Entity
		{
			var sib:Entity = null;
			if (node.$[TreeModule.TREENODE_FIELD_PARENT_NODE]==null)
				return node;
			var parent:Entity = expand(root,node.$[TreeModule.TREENODE_FIELD_PARENT_NODE]);
			var siblings:Array = parent.$[TreeModule.TREENODE_FIELD_CHILDREN];
			var index:int = get_index(node,parent);
			if (siblings.length>index+1)
			{
				return get_leaf(siblings[index+1]);
			}
			return null;
		}
		
		public static function get_sibling(root:Entity,node:Entity):Entity
		{
			if (node.$[TreeModule.TREENODE_FIELD_PARENT_NODE]==null)
				return null;
			var parent:Entity = expand(root,node.$[TreeModule.TREENODE_FIELD_PARENT_NODE]);
			var siblings:Array = parent.$[TreeModule.TREENODE_FIELD_CHILDREN];
			var index:int = get_index(node,parent)+1;
			if (index>siblings.length-1)
				return null;
			return siblings[index];
		}
		
		public static function get_previous_sibling(root:Entity,node:Entity):Entity
		{
			if (node.$[TreeModule.TREENODE_FIELD_PARENT_NODE]==null)
				return null;
			var parent:Entity = expand(root,node.$[TreeModule.TREENODE_FIELD_PARENT_NODE]);
			var siblings:Array = parent.$[TreeModule.TREENODE_FIELD_CHILDREN];
			var index:int = get_index(node,parent)-1;
			if (index<0)
				return null;
			return siblings[index];
		}
		
		public static function get_parent(root:Entity,node:Entity):Entity
		{
			if (node.$[TreeModule.TREENODE_FIELD_PARENT_NODE]==null)
				return null;
			return expand(root,node.$[TreeModule.TREENODE_FIELD_PARENT_NODE]);
		}
		
		public static function get_ancestors_sibling(root:Entity,node:Entity):Entity
		{
			var p:Entity = node.$[TreeModule.TREENODE_FIELD_PARENT_NODE];
			while (p!=null)
			{
				var s:Entity = get_sibling(root,expand(root,p));
				if (s!=null)
					return s;
				p = p.$[TreeModule.TREENODE_FIELD_PARENT_NODE];
			}
			return null;
			
		}
		
		public static function get_first_child(node:Entity):Entity
		{
			var c:Array = node.$[TreeModule.TREENODE_FIELD_CHILDREN];
			if (c==null||c.length==0)
				return null;
			return c[0];
		}
		
		
		
		public static function get_index(node:Entity,parent:Entity):int
		{
			var pc:Array = parent.$[TreeModule.TREENODE_FIELD_CHILDREN];
			var s:uint = pc.length;
			for (var i:uint=0; i<s; i++)
			{
				if (pc[i].eq(node))
					return i;
			}
			return -1;
		}
		
		public static function get_leaf(node:Entity):Entity
		{
			while (has_children(node))
				node = node.$[TreeModule.TREENODE_FIELD_CHILDREN][0];
			return node;
		}
		
		
		public static function expand(root:Entity,p:Entity):Entity
		{
			return TreeUtil.getById(root,p.id.longValue);
		}
		
		public static function has_children(node:Entity):Boolean
		{
			return node.$[TreeModule.TREENODE_FIELD_CHILDREN]!=null && node.$[TreeModule.TREENODE_FIELD_CHILDREN].length!=0;
		}

	}
}
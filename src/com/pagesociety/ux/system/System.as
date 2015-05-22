package com.pagesociety.ux.system
{
	
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.web.module.TreeModule;
	
	import flash.external.ExternalInterface;
	
	public class System extends Container
	{ 
		
		public static const NAVIGATE_TO					:String = "navigate_to";//{node: node, index: node_content_offset}
		public static const NAVIGATE_TO_NEXT			:String = "navigate_to_next";
		public static const NAVIGATE_TO_NEXT_LEAF		:String = "navigate_to_next_leaf";
		public static const NAVIGATE_TO_PREVIOUS		:String = "navigate_to_previous";

		protected var _tree:Entity;
		protected var _init_id:uint;
		protected var _init_index:uint;
		protected var _selected_node:Entity;
		protected var _selected_index:uint;
	
		public function System(p:Container):void
		{
			super(p);
		}
		
		private function address_change(e:SWFAddressEvent):void
		{
			var addr:String = SWFAddress.getValue();
			//Logger.log(">ADDR "+addr);
			ExternalInterface.call("pageTracker._trackPageview('"+addr+".html')");
			
			var s:Array = addr.split("/");
			
			if (_tree==null)
				return;
				
			var ns:String = s.pop();
				
			var node_permalink:String = s.join("/").substring(1);
			var index:uint = Number(ns);
			var node:Entity = TreeUtil.getByPermalink(_tree.$[TreeModule.TREE_FIELD_ROOT], node_permalink);
			if (node==null)
				node = tree_root;
			var ancestors:Array = TreeUtil.getAncestors(tree_root, node.id.longValue);
			var title:String = "";
			for (var i:uint=0; i<ancestors.length; i++)
			{
				title += ancestors[i].$.data.$.title +" > "
			}
			if (!node.eq(ancestors[ancestors.length-1]))
				title += node.$.data.$.title;
			else
				title = title.substring(0,title.length-3);
			SWFAddress.setTitle(title);
			select_node(node,index);
			render();
		}
		
		public function init(tree:Entity, id:int, index:uint):void
		{
			//trace("System.init");
			_tree = tree;
			TreeUtil.addParents(treeRoot);
			_init_id = id;
			_init_index = index;
			// create components
			// initEnd();
		}
		
		public function initEnd():void
		{
			//trace("System.init_end");
			if (!isEditTree && !SWFAddress.hasEventListener(SWFAddressEvent.CHANGE))
			{
				SWFAddress.addEventListener(SWFAddressEvent.CHANGE, address_change);
			}
			else
			{
				var node:Entity = TreeUtil.getById(_tree.$[TreeModule.TREE_FIELD_ROOT], _init_id);
				if (node==null)
					node = _tree.$[TreeModule.TREE_FIELD_ROOT];
				select_node(node,_init_index);
			}
		}
		
		public function get isEditTree():Boolean
		{
			return (_tree.$[TreeModule.TREE_FIELD_NAME]=="EDIT");
		}
		
		public function get treeRoot():Entity
		{
			return _tree.$[TreeModule.TREE_FIELD_ROOT];
		}
		
		public function get selectedNode():Entity
		{
			return _selected_node;
		}
		
		public function get selectedIndex():uint
		{
			return _selected_index;
		}
		
		protected function on_select_menu_item(e:ComponentEvent=null) :void
		{
			select_menu_item(e.data.node, e.data.index);
		}
		
		protected function select_menu_item(node:Entity, index:uint=0) :void
		{
			if (!isEditTree)
			{
				SWFAddress.setValue("/"+node.$[TreeUtil.TNIDF]+"/"+index);
			}
			else
			{
				select_node(node,index);
				render();
			}
		}
		
		protected function select_home(e:ComponentEvent=null) :void
		{
			if (!isEditTree)
			{
				SWFAddress.setValue("/"+_tree.$[TreeModule.TREE_FIELD_ROOT].$[TreeUtil.TNIDF]+"/0");
			}
			else
			{
				select_node(_tree.$[TreeModule.TREE_FIELD_ROOT],0);
				render();
			}	
		}
		
		protected function select_resource_item(e:ComponentEvent=null) :void
		{
			if (!isEditTree)
				SWFAddress.setValue("/"+_selected_node.$[TreeUtil.TNIDF]+"/"+e.data.index);
			else
			{
				select_node(_selected_node,e.data.index);
				render();
			}	
		}
		
		protected function on_navigate_to_next_leaf(e:ComponentEvent):void
		{
			var sib:Entity = get_sibling_or_ancestors_sibling(_selected_node);
			select_menu_item(sib, 0);
		}

		
		protected function select_node(node:Entity,index:uint):void
		{
			if (node==null)
				node = _tree.$[TreeModule.TREE_FIELD_ROOT];
			
			_selected_node = node;
			_selected_index = index;
			
			//do stuff to components...
		}
		
		// helper that reapplies changed styles to existing components
		protected function apply_style(clazz:Class, c:Container=null):void
		{
			if (c == null)
				c = application.container;
			if (c is clazz)
			{
				c.styleName = c.styleName;
			}
			for (var i:uint=0; i<c.children.length; i++)
				if (c.children[i] is Container)
					apply_style(clazz, c.children[i]);
		}


		// tree functions
		protected function get_sibling_or_ancestors_sibling(node:Entity):Entity
		{
			return TreeUtil.get_sibling_or_ancestors_sibling(tree_root, node);
		}
		
		protected function get_sibling_leaf(node:Entity):Entity
		{
			return TreeUtil.get_sibling_leaf(tree_root, node);
		}
		
		protected function get_sibling(node:Entity):Entity
		{
			return TreeUtil.get_sibling(tree_root, node);
		}
		
		protected function get_previous_sibling(node:Entity):Entity
		{
			return TreeUtil.get_previous_sibling(tree_root, node);
		}
		
		protected function get_parent(node:Entity):Entity
		{
			return TreeUtil.get_parent(tree_root, node);
		}
		
		protected function get_ancestors_sibling(node:Entity):Entity
		{
			return TreeUtil.get_ancestors_sibling(tree_root, node);
		}
		
		protected static function get_first_child(node:Entity):Entity
		{
			return TreeUtil.get_first_child(node);
		}
		
		protected static function get_index(node:Entity,parent:Entity):int
		{
			return TreeUtil.get_index(node,parent);
		}
		
		protected static function get_leaf(node:Entity):Entity
		{
			return TreeUtil.get_leaf(node);
		}
		
		protected function get tree_root():Entity
		{
			return _tree.$[TreeModule.TREE_FIELD_ROOT];
		}
		
	
	}
}
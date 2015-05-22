package com.pagesociety.ux.component
{
	import com.pagesociety.ux.ISelectable;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.decorator.Decorator;
	import com.pagesociety.ux.decorator.TreeNodeDecorator;
	import com.pagesociety.ux.layout.Layout;	

	public class TreeNode extends Container implements ISelectable
	{
		protected var _parent_node:TreeNode;
		protected var _child_nodes:Array;
		protected var _label:Label;
		protected var _selected:Boolean = false;
		protected var _dragging:Boolean = false;
		
		public function TreeNode(parent:Container) 
		{
			super(parent);
			decorator = new TreeNodeDecorator();
			
			_child_nodes = new Array();
			_label = new Label(this);
			_label.widthDelta = -8;
			
			styleName = "Node";
		}
		
		public function set selected(b:Boolean):void
		{
			if (decorator is ISelectable)
			{
				ISelectable(decorator).selected = b;
			}
			_selected = b;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set dragging(b:Boolean):void
		{
			_dragging = b;
			for (var i:uint=0; i<_child_nodes.length; i++)
				_child_nodes[i].dragging = b;
		}
		
		public function get dragging():Boolean
		{
			return _dragging;
		}
		
		public function get label():Label
		{
			return _label;
		}
		
		public function get parentNode():TreeNode
		{
			return _parent_node;
		}
		
		public function set parentNode(p:TreeNode):void
		{
			_parent_node = p;
		}
		
		public function addChildNode(n:TreeNode):void
		{
			n._parent_node = this;
			_child_nodes.push(n);
		}
		
		public function get childNodes():Array
		{
			return _child_nodes;
		}
		
		public function removeNode(child:TreeNode):void
		{
			childNodes.splice(childNodes.indexOf(child),1);
		}
		
		public function reParentNode(child:TreeNode, new_index:int):void
		{
			var old_parent:TreeNode = child.parentNode;
			child.parentNode = this;
			if (new_index<0)
				new_index = 0;
			var old_index:uint;
			if (old_parent == this)
			{
				old_index = childNodes.indexOf(child);
				childNodes.splice(old_index,1);
				if (new_index>=old_index)
					new_index--;
				childNodes.splice(new_index,0,child);
			}
			else
			{
				if (old_parent!=null)
				{
					old_index = old_parent.childNodes.indexOf(child);
					old_parent.childNodes.splice(old_index,1);
				}
				childNodes.splice(new_index,0,child);
			}
		}
		
		override public function toString():String
		{
			return "TreeNode "+(label!=null?label.text:"");//to_string(0);
		}
		
		private function to_string(d:uint):String
		{
			var s:String = "";
			s += tab(d)+"TreeNode "+id+"\n";
			for (var i:uint=0; i<_child_nodes.length; i++)
			{
				s += _child_nodes[i].to_string(d+1);
			}
			return s;
		}
		
		private function tab(n:uint):String
		{
			var s:String = "";
			for (var i:uint=0; i<n; i++)
				s+=" ";
			return s;
		}
		
		public function acceptsChild(t:TreeNode):Boolean
		{
			return true;
		}
	}
}
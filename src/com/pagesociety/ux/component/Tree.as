package com.pagesociety.ux.component
{
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.util.ObjectUtil;
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.ISelectable;
    import com.pagesociety.ux.decorator.TreeDecorator;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.event.DragAndDropTreeNodeEvent;
    import com.pagesociety.ux.event.TreeEvent;
    import com.pagesociety.ux.layout.TreeLayout;
    
    import flash.geom.Point;
    
    public class Tree extends Container implements IEditor
    {
    
        private var _selected_node:TreeNode;
        
        private var _view:Function;
        private var _data:Object;
        private var _data_name_key:String = "name";
        private var _data_children_key:String = "children";
        
        private var _dirty:Boolean = false;
        private var _size:uint;
        
            
        public function Tree(parent:Container,index:int=-1) 
        {   
            super(parent,index);
            layout = new TreeLayout(this);
            decorator = new TreeDecorator(this);
            
            _view = default_tree_node_view;
        }
        
        public function get treeLayout():TreeLayout
        {
            return layout as TreeLayout;
        }
        
        public function get treeDecorator():TreeDecorator
        {
            return decorator as TreeDecorator;
        }
        
        public function set valueLabelPropName(s:String):void
        {
            _data_name_key = s;
        }
        
        public function get valueLabelPropName():String
        {
            return _data_name_key;
        }
        
        public function set valueChildrenPropKey(s:String):void
        {
            _data_children_key = s;
        }
        
        public function get valueChildrenPropKey():String
        {
            return _data_children_key;
        }
        
        public function get dirty():Boolean
        {
            return _dirty;
        }
        
        public function set dirty(b:Boolean):void
        {
            _dirty = b;
        }
        
        public function set cellRenderer(f:Function):void
        {
            _view = f;
        }
        
        private function default_tree_node_view(parent:Container, o:Object):TreeNode
        {
            var n:TreeNode = new TreeNode(parent);
            n.label.text = ObjectUtil.getProperty(o, _data_name_key) as String;
            return n;
        }
        
        public function set value(o:Object):void
        {
            _data = o;
            _size = 0;
            _dirty = false;
            clear();
            if (_data==null)
                return;
            var c:TreeNode = create_view(_data);
        }
        
        public function get value():Object
        {
            return _data;
        }
        
        protected function create_view(o:Object):TreeNode
        {
            var n:TreeNode = _view(this, o);
            n.userObject = o;
            _size++;

            var c:Array;
            if (o is Entity)
                c = o.attributes[_data_children_key];
            else if (o[_data_children_key]!=null)
                c = o[_data_children_key];
            
            
            if (c!=null)
                for (var i:uint = 0; i<c.length; i++)
                {
                    n.addChildNode(create_view(c[i]));
                }

            return n;
        }
        
        
        override public function addComponent(p:Component,i:int=-1):void
        {
            super.addComponent(p,i);
            
            p.addEventListener(ComponentEvent.CLICK, select_node);
            p.addEventListener(ComponentEvent.DOUBLE_CLICK, select_node);
        }
        
        
        override public function toString():String
        {
            return "Tree "+id;
        }
        
        override public function get width():Number
        {
            return _layout.calculateWidth()+20;
        }
        
        override public function get height():Number
        {
            return _layout.calculateHeight();
        }
        
        
        public function get rootNode():TreeNode
        {
            return _children[0];
        }
        
        
        public function select_node(c:ComponentEvent):void
        {
            var p:TreeNode = TreeNode(c.component);         
            selectNode(p);
            if (c.type == ComponentEvent.DOUBLE_CLICK)
                dispatchEvent(new TreeEvent(this, TreeEvent.ACTION, _selected_node));
            else
                dispatchEvent(new TreeEvent(this, TreeEvent.SELECT, _selected_node));

        }
        
        public function selectNode(p:TreeNode):void
        {
            if (_selected_node!=null && _selected_node is ISelectable)
            {
                ISelectable(_selected_node).selected = false;
                _selected_node.render();
            }
            
            _selected_node = p;
            
            if (_selected_node!=null && _selected_node is ISelectable)
            {
                ISelectable(_selected_node).selected = true;
                _selected_node.render();
            }
            
        }
        
        public function get selectedNode():TreeNode
        {
            return _selected_node;
        }
        
        
        
        
        
        //// 
        private var _last_drag_op:DragAndDropTreeNodeEvent;
        override public function onDragStart(c:Component):void
        {
            selectNode(c as TreeNode);
            _selected_node.dragging = true;
            render_node(_selected_node);
        }
        
        override public function onDragOver(c:Component,dx:Number,dy:Number):void
        {
            var p:Point = new Point(dx,dy);
            var drag_op:DragAndDropTreeNodeEvent = treeLayout.getDropOp(p);
            drag_op = transform_drag_op(drag_op);
            markup(_last_drag_op,false);
            markup(drag_op,true);
            _last_drag_op = drag_op;
            
        }
        
        override public function onDragExit(c:Component):void
        {
            markup(_last_drag_op,false);
            _last_drag_op = null;
        }
        
        override public function onDrop(c:Component,dx:Number,dy:Number):void
        {
            markup(_last_drag_op, false);
            _last_drag_op = null;
            _selected_node.dragging = false;
            render_node(_selected_node);
            //
            var p:Point = new Point(dx,dy);
            var drag_op:DragAndDropTreeNodeEvent = treeLayout.getDropOp(p);
            drag_op = transform_drag_op(drag_op);
            
            if (drag_op.subtype==DragAndDropTreeNodeEvent.DROP_CANCELED)
                return;
            dispatchEvent(drag_op);
        }
        
        override public function onDragEnd(dx:Number,dy:Number):void
        {
            markup(_last_drag_op,false);
            _last_drag_op = null;
            _selected_node.dragging = false;
            render_node(_selected_node);
        }
        
        protected function transform_drag_op(o:DragAndDropTreeNodeEvent):DragAndDropTreeNodeEvent
        {
            switch (o.subtype)
            {
                case DragAndDropTreeNodeEvent.DROP_ON:
                    if (!TreeNode(o.targetNode).acceptsChild(selectedNode))
                        o.cancel();
                    break;
                case DragAndDropTreeNodeEvent.DROP_BETWEEN:
                    if (!TreeNode(o.leftNode.parentNode).acceptsChild(selectedNode))
                        o.cancel();
                    break;
                case DragAndDropTreeNodeEvent.DROP_LAST:
                case DragAndDropTreeNodeEvent.DROP_FIRST:
                    if (o.targetNode.parentNode==null || !TreeNode(o.targetNode.parentNode).acceptsChild(selectedNode))
                        o.cancel();
                    break;
            }
            return o;
        }
        
        private function markup(o:DragAndDropTreeNodeEvent,b:Boolean):void
        {
            if (o==null)
            { return; }
            switch (o.subtype)
            {
                case DragAndDropTreeNodeEvent.DROP_ON:
                    _drop(o.targetNode as TreeNode, b);
                    break;
                case DragAndDropTreeNodeEvent.DROP_BETWEEN:
                    _nudge(o.leftNode as TreeNode, o.rightNode as TreeNode, b);
                    break;
                case DragAndDropTreeNodeEvent.DROP_LAST:
                    _nudge(o.targetNode as TreeNode, null, b);
                    break;
                case DragAndDropTreeNodeEvent.DROP_FIRST:
                    _nudge(null, o.targetNode as TreeNode, b);
                    break;
            }
        }
        
        
        protected function _drop(n:TreeNode, b:Boolean):void
        {
            n.selected = b;
            n.y -= 10 *(b?1:-1);
            n.render();
        }
        
        protected function _nudge(left:TreeNode,right:TreeNode, b:Boolean):void
        {
            if(left!=null)
            {
                left.x -= 10 *(b?1:-1);
                render_node(left);
            }
            if(right!=null)
            {
                right.x += 10 *(b?1:-1);
                render_node(right);
            }
        }
        
        
        private function render_list(_last_over:Array):void
        {
            for (var i:uint=0; i<_last_over.length; i++)
                _last_over[i].render();
        }
        
        protected function render_node(n:TreeNode):void
        {
            n.render();
            for (var i:uint=0; i<n.childNodes.length; i++)
                render_node(n.childNodes[i]);
        }
        
        override public function render():void
        {
            updatePosition(x,y); //TODO?
            treeLayout.layout();
            if (rootNode!=null)
                render_node(rootNode);
            decorator.decorate();
        }
        
        
        
        public function getTreeSize():uint
        {
            return _size;
        }
        
        
        
        
        
        
//      public function deleteNode(p:Node):void{}
//      public function reparentNode(p:Node, d:Node, i:uint):void{}
        
    
        
    }
}
package com.pagesociety.ux.layout
{
import com.pagesociety.ux.Margin;
import com.pagesociety.ux.component.Component;
import com.pagesociety.ux.component.Container;
import com.pagesociety.ux.component.Tree;
import com.pagesociety.ux.component.TreeNode;
import com.pagesociety.ux.event.DragAndDropTreeNodeEvent;

import flash.geom.Point;

    // TODO port this:
    // http://www.ddj.com/cpp/184402320?pgno=1

    public class TreeLayout implements Layout
    {
        private var _cursor_x:Number = 0;
        private var _max_depth:uint = 0;
        private var _cell_height:Number = 80;
        private var _margin:Margin = new Margin(8,8,8,8);
        private var _tree:Tree;
        private var _layout_in_rows:Array;
        
        public function TreeLayout(t:Tree) 
        {
            this._tree = t;
        }
        
        public function get container():Container
        {
            return _tree;
        }
        
        public function set container(c:Container):void
        {
            _tree = container as Tree;
        }
        
        public function get x():Number
        {
            return _cursor_x;
        }
        
        public function get y():Number
        {
            return getY(_max_depth+1);
        }
        
        public function layout():void
        {
            _layout_in_rows = new Array(); 
            _cursor_x = _margin.left;
            _max_depth = 0;
            if (_tree.children.length!=0)
                layoutNode(_tree.children[0] as TreeNode,0);
        }
        
        public function get cellHeight():Number
        {
            return _cell_height;
        } 
        
        public function set cellHeight(h:Number):void
        {
            _cell_height = h;
        }
        
        public function calculateHeight():Number
        {
            return getY(_max_depth+1);
        }
        
        public function calculateWidth():Number
        {
            if (_cursor_x == 0)
                return 0;
            return _cursor_x + (_cell_height + _margin.top + _margin.bottom);
        }
        
        public function calculateIndex(x:Number,y:Number):uint
        {
            throw new Error("TreeLayout.calculateIndex... Use getNodesNear instead");
        }
        
        public function get margin():Margin{ return _margin; }
        private var XO:Number = 10;
        private function layoutNode(page:TreeNode, depth:Number):void
        {
            
            page.updatePosition(_cursor_x + XO, getY(depth));
            
            if (depth>_max_depth)
                _max_depth = depth;
            
            var num_children:uint = page.childNodes.length;
    
            for(var i:uint = 0;i < num_children; i++) {
                if(i != 0)
                    _cursor_x += page.width + _margin.left + _margin.right;
        
                layoutNode(page.childNodes[i],depth + 1);
            }
            if(num_children != 0) {
                //reposition parent over children
                var first_child_start:Number = page.childNodes[0].x;
                var last_child_end:Number    = page.childNodes[num_children - 1].x;
                var w:Number                 = last_child_end - first_child_start; 
                
                page.updatePosition(first_child_start + (w/2), page.y);
            }
            
            if (_layout_in_rows[depth]==null) {
                _layout_in_rows[depth] = new Array();
            }
            _layout_in_rows[depth].push(page);
        }
        
        private function getY(depth:Number):Number
        {
            return depth * (_cell_height + _margin.top + _margin.bottom);
        }
        
        private function getDepth(y:Number):Number
        {
            return y / (_cell_height + _margin.top + _margin.bottom);
        }
        
        
        
        private function dist(c:Component, p:Point):Number
        {
            return Math.abs(p.x - c.x);//*(p.y - c.y);
        }
//      


        
        public function getDropOp(p:Point):DragAndDropTreeNodeEvent
        {
            var d:Number = Math.floor(getDepth(p.y + _cell_height/2));
            if (d<0) d=0;
            if (d>_max_depth) d = _max_depth;
            //
            var row:/*Node*/Array = _layout_in_rows[d];
            if (row==null)
                return new DragAndDropTreeNodeEvent(DragAndDropTreeNodeEvent.DROP_CANCELED);
        
            var on:TreeNode = null;
            var left:TreeNode = null;
            var right:TreeNode = null;
            var tn:TreeNode;
            var tnx:Number;
            
            for (var i:uint=0; i < row.length; i++) 
            {
                tn  = row[i] as TreeNode;
                tnx = tn.x+tn.width/2;
                if (Math.abs(tnx-p.x)<tn.width/3)
                {
                    on = tn
                }
                else if (tnx < p.x)
                {
                    left = tn;
                }
                else if (tnx > p.x)
                {
                    right = tn;
                    break;
                }
            }
            if (on!=null && on.dragging) on = null;
            if (left!=null && left.dragging) left = null;
            if (right!=null && right.dragging) right = null;
            
            //trace("on="+on+" left="+left+" right="+right);
            var _drag_op:DragAndDropTreeNodeEvent;
            if (on != null)
            {
                _drag_op = new DragAndDropTreeNodeEvent(DragAndDropTreeNodeEvent.DROP_ON, on);
            }
            else if (left != null && right != null)
            {
                if (left.parentNode == right.parentNode)
                {
                    _drag_op = new DragAndDropTreeNodeEvent(DragAndDropTreeNodeEvent.DROP_BETWEEN, left, right);
                }   
                else 
                { // between 2, not of the same parent...
                    _drag_op = new DragAndDropTreeNodeEvent(DragAndDropTreeNodeEvent.DROP_FIRST, right);
                }
            }
            else if (left != null && right == null)
            {
                _drag_op = new DragAndDropTreeNodeEvent(DragAndDropTreeNodeEvent.DROP_LAST, left);
            }
            else if (left == null && right != null)
            {
                _drag_op = new DragAndDropTreeNodeEvent(DragAndDropTreeNodeEvent.DROP_FIRST, right);
            }
            
            if (_drag_op==null)
            {
                _drag_op = new DragAndDropTreeNodeEvent(DragAndDropTreeNodeEvent.DROP_CANCELED);
            }
            return _drag_op;
        }
        
    
    }
}
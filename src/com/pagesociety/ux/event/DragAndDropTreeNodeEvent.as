package com.pagesociety.ux.event
{
    import com.pagesociety.ux.component.TreeNode;
    
    import flash.events.Event;

    public class DragAndDropTreeNodeEvent extends Event
    {
        public static var DROP:String = "drag_and_drop";

        public static var DROP_ON:uint = 0;
        public static var DROP_BETWEEN:uint = 1;
        public static var DROP_LAST:uint = 2;
        public static var DROP_FIRST:uint = 3; 
        public static var DROP_CANCELED:uint = 4;
        
        public static var TYPES:Array = [ "on","between", "last", "first", "canceled" ];
        
        private var _type:uint;
        private var _a:TreeNode;
        private var _b:TreeNode;
        
        public function DragAndDropTreeNodeEvent(type:uint, a:TreeNode=null, b:TreeNode=null, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(DROP, bubbles, cancelable);
            _type = type;
            _a = a;
            _b = b;
        }
        
        public function get subtype():uint
        {
            return _type;
        }
        
        public function get dropNode():TreeNode
        {
            switch (_type)
            {
                case DROP_ON:
                    return _a;
                case DROP_BETWEEN:
                case DROP_FIRST:
                case DROP_LAST:
                    return _a.parentNode;
            }
            return null;
        }
        
        public function get targetNode():TreeNode
        {
            return _a;
        }
        
        public function get leftNode():TreeNode
        {
            return _a;
        }
        
        public function get rightNode():TreeNode
        {
            return _b;
        }
        
        public function get dropIndex():uint
        {
            switch (_type)
            {
                case DROP_ON:
                    return _a.childNodes.length;
                case DROP_BETWEEN:
                    return _a.parentNode.childNodes.indexOf(_a)+1;
                case DROP_FIRST:
                    return 0;
                case DROP_LAST:
                    throw new Error("DROP_LAST Unhandled");
            }
            return 0;
        }
        
        public function cancel():void
        {
            _type = DROP_CANCELED;
        }
        
        override public function toString():String
        {
            return "DragAndDropEvent "+TYPES[_type]+" "+leftNode+" "+rightNode;
        }
    }
}
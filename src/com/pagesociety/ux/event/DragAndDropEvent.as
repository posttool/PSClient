package com.pagesociety.ux.event
{
    import com.pagesociety.ux.component.Component;

    public class DragAndDropEvent extends ComponentEvent
    {
        public static var DRAG_START:String = "drag_start";
        public static var DRAG_END:String = "drag_end";
        public static var DRAG_EXIT:String = "drag_exit";
        public static var DRAG_OVER:String = "drag_over";
        public static var DROP:String = "drop";
        
        public var dropped_on:Component;
        public var x:Number;
        public var y:Number;
        
        public function DragAndDropEvent(type:String, dragged:Component=null, dropped_on:Component=null, x:Number=0, y:Number=0, bubbles:Boolean=true, cancelable:Boolean=false)
        {
            super(type, dragged, bubbles, cancelable);
            this.dropped_on = dropped_on;
            this.x = x;
            this.y = x;
        }
        
    }
}
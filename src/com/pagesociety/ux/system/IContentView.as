package com.pagesociety.ux.system
{
    import com.pagesociety.persistence.Entity;
    
    [Event(type="com.pagesociety.ux.system.System",name="navigate_to")]
    [Event(type="com.pagesociety.ux.system.System",name="navigate_to_next")]
    [Event(type="com.pagesociety.ux.system.System",name="navigate_to_next_leaf")]
    [Event(type="com.pagesociety.ux.system.System",name="navigate_to_previous")]
    public interface IContentView
    {
        function set value(node:Entity):void;
        function get value():Entity;
        function set index(i:int):void;
        function get index():int;
        function set props(p:Object):void;
        function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void;
        function destroy():void;
    }
}
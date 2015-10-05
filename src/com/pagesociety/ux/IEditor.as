package com.pagesociety.ux
{
    
    [Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
    
    public interface IEditor extends IValue
    {
        function get dirty():Boolean;
        function set dirty(b:Boolean):void;
    }
}
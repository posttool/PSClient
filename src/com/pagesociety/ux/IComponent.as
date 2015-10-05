package com.pagesociety.ux
{
    import com.pagesociety.ux.decorator.Decorator;
    
    import flash.events.IEventDispatcher;

    public interface IComponent extends IEventDispatcher
    {
        function get x():Number;
        function set x(x:Number):void;
        function set xDelta(x:Number):void;
        function get y():Number;
        function set y(y:Number):void;
        function set yDelta(y:Number):void;
        function get width():Number;
        function set width(width:Number):void;
        function set widthDelta(width:Number):void;
        function get height():Number;
        function set height(height:Number):void;
        function set heightDelta(height:Number):void;
        function get visible():Boolean;
        function set visible(is_visible:Boolean):void;
        function get userObject():*;
        function set userObject(uo:*):void;
        function get decorator():Decorator;
        function render():void;
    }
}
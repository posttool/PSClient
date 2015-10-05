package com.pagesociety.ux.component
{
    public interface IComponentFactory
    {
        function gap(p:Container, h:Number):Component;
        
        function label(p:Container, text:String, style_props:Object=null):Component;
        
        function input(p:Container, field_name:String, style_props:Object=null):Component;
        
        function password(p:Container, field_name:String, style_props:Object=null):Component;
        
        function button(p:Container, text:String, click_function:Function, style_props:Object=null):Component;
        
        function link(p:Container, text:String, click_function:Function):Component;
        
        function link_bar(p:Container, values:Array,style_props:Object=null):Component;

        function popup(p:Container, fieldname:String,values:Array,empty_message:String,style_props:Object=null):Component;
        
    }
}
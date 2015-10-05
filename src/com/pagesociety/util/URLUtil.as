package com.pagesociety.util
{
    import flash.external.ExternalInterface;
    import flash.net.URLVariables;

    public class URLUtil
    {
        public var url:String;
        public var vars:Object;
        
        public function URLUtil()
        {
            url = ExternalInterface.call("function(){ return document.location.href; }");
            var i:int = url.indexOf("?");
            if (i !=-1)
            {
                vars = new URLVariables(url.substring(i+1));
                url = url.substring(0,i);
            }
            else
                vars = new Object();
        }
        
        public function toString():String
        {
            var s:String = url;
            if (vars is URLVariables)
            {
                s += "?";
                for (var ss:String in vars)
                {
                    s += "&"+ss+"="+encodeURIComponent(vars[ss]);
                }
            }
            return s;
        }
        
        
    }
}
package com.pagesociety.web.amf
{
    public class AmfFloat 
    {
        private var _v:String;
        
        public function AmfFloat(v:Number=0)
        {
            _v = v.toString();
        }
        
        public function get floatValue():Number
        {
            return Number(_v);
        }
        
        public function set stringValue(v:String):void
        {
            _v = v;
        }
        
        public function get stringValue():String
        {
            return _v;
        }
        
        public function toString():String
        {
            return floatValue.toString();
        }

    }
}
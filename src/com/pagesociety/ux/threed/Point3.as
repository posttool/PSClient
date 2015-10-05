package com.pagesociety.ux.threed
{
    
    public class Point3 implements IPoint3
    {
        private var _x:Number;
        private var _y:Number;
        private var _z:Number;
        
        public function Point3(x:Number,y:Number,z:Number)
        {
            _x=x;
            _y=y;
            _z=z;
        }
        
        public function get x():Number
        {
            return _x;
        }
        public function set x(x:Number):void
        {
            _x = x;
        }
        
        public function get y():Number
        {
            return _y;
        }
        public function set y(y:Number):void
        {
            _y = y;
        }
        
        public function get z():Number
        {
            return _z;
        }
        public function set z(z:Number):void
        {
            _z = z;
        }       

    }
}
package com.pagesociety.ux.threed
{
    public class Transformer { // TODO push/pop matrix
    
        private var combined:Matrix;
        private var temp:Matrix;
    
        public function Transformer() 
        {
            init();
        }
    
        public function init():void 
        {
            combined = new Matrix(4);
            combined.loadIdentity();
            temp = new Matrix(4);
        }
        
        public function rotate(theta:Number, x:Number, y:Number, z:Number):void 
        {
            var rotation:Matrix = rotate_matrix(theta, x, y, z);
            combined = Matrix.multiply(combined, rotation);
        }
    
        public function translate(x:Number, y:Number, z:Number):void 
        {
            temp.loadIdentity();
            temp.setValue(0, 3, x);
            temp.setValue(1, 3, y);
            temp.setValue(2, 3, z);
            combined = Matrix.multiply(combined, temp);
        }
    
        public function scale(x:Number, y:Number, z:Number):void 
        {
            temp.loadIdentity();
            temp.setValue(0, 0, x);
            temp.setValue(1, 1, y);
            temp.setValue(2, 2, z);
            combined = Matrix.multiply(combined, temp);
        }
    
        public function getMatrix():Matrix 
        {
            return combined;
        }
        
        private function rotate_matrix(theta:Number, x:Number, y:Number, z:Number):Matrix 
        {
            temp.loadIdentity();

            // normalize... too close to 0 = can't make the vector
            var length:Number = Math.sqrt(x * x + y * y + z * z);
            if (length < .000001)
                return temp;//new Matrix(4, 3);
            //
            x /= length;
            y /= length;
            z /= length;
            var c:Number = Math.cos(theta * (Math.PI / 180));
            var s:Number = Math.sin(theta * (Math.PI / 180));
            var t:Number = 1 - c;
            //
            temp.setValue(0, 0, t * x * x + c);
            temp.setValue(0, 1, t * x * y - s * z);
            temp.setValue(0, 2, t * x * z + s * y);
            temp.setValue(0, 3, 0);
            //
            temp.setValue(1, 0, t * x * y + s * z);
            temp.setValue(1, 1, t * y * y + c);
            temp.setValue(1, 2, t * y * z - s * x);
            temp.setValue(1, 3, 0);
            //
            temp.setValue(2, 0, t * x * z - s * y);
            temp.setValue(2, 1, t * y * z + s * x);
            temp.setValue(2, 2, t * z * z + c);
            temp.setValue(2, 3, 0);
            //
            temp.setValue(3, 0, 0);
            temp.setValue(3, 1, 0);
            temp.setValue(3, 2, 0);
            temp.setValue(3, 3, 1);
            //
            return temp;
        }
    
        
    }
}
package com.pagesociety.ux.decorator
{
    public class LineStyle
    {
        public var color:uint;
        public var alpha:Number;
        public var thickness:Number;
        
        public function LineStyle(thickness:Number, color:uint, alpha:Number)
        {
            this.color = color;
            this.alpha = alpha;
            this.thickness = thickness;
        }
        
        public function clone():LineStyle
        {
            return new LineStyle(thickness,color,alpha);
        }

    }
}
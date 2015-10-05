package com.pagesociety.ux.draw
{
    import com.pagesociety.ux.component.Container;

    public class Drawing extends Container 
    {
        public static const DRAW_STYLE_INVERSE:uint=0;
        public static const DRAW_STYLE_POSITIVE:uint=1;
        
        protected var _draw_dec:DrawingDecorator;
        protected var _points:Array;
        protected var _closed:Boolean;
        
        public function Drawing(parent:Container, index:int=-1)
        {
            super(parent, index);
            decorator = _draw_dec = new DrawingDecorator();
            _points = new Array();
            _closed = true;
        }
        
        public function addPoint(p:DrawPoint):void
        {
            _points.push(p);
            update_ui();
        }
        
        public function set points(p:Array):void
        {
            _points = convert(p);
            update_ui();
        }
        
        public static function convert(p:Array):Array
        {
            var points:Array = new Array();
            for (var i:uint=0; i<p.length; i++)
            {
                if (p[i] is DrawPoint)
                    points.push(p[i]);
                else
                    points.push(new DrawPoint(p[i]));
            }
            return points;
        }
        
        override public function clear():void
        {
            _points = new Array();
            update_ui();
        }
        
        protected function update_ui():void
        {
            _draw_dec.points = _points;
        }
        
        public function set matteColor(c:uint):void
        {
            _draw_dec.matteColor = c;
        }
        
        public function set matteAlpha(a:Number):void
        {
            _draw_dec.matteAlpha = a;
        }
        
        public function set lineColor(c:uint):void
        {
            _draw_dec.lineColor = c;
        }
        
        public function set lineAlpha(a:Number):void
        {
            _draw_dec.lineAlpha = a;
        }
        
        public function set lineThickness(t:Number):void
        {
            _draw_dec.lineThickness = t;
        }
        
        public function set scale(s:Number):void
        {
            _draw_dec.scale = s;
        }
        
        public function set xoffset(s:Number):void
        {
            _draw_dec.xoffset = s;
        }
        
        public function set yoffset(s:Number):void
        {
            _draw_dec.yoffset = s;
        }
        
        public function set drawStyle(s:uint):void
        {
            _draw_dec.drawStyle = s;
        }
        
    }
}
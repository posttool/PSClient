package com.pagesociety.ux.draw
{
    import com.pagesociety.ux.decorator.Decorator;
    
    import flash.display.Graphics;
    
    public class DrawingDecorator extends Decorator
    {
        private var _points:Array;
        private var _matte_color:uint = 0xffff00;
        private var _matte_alpha:Number = .7;
        private var _line_color:uint = 0x333333;
        private var _line_alpha:Number  = 1;
        private var _line_thickness:Number = 1.5;
        private var _scale:Number = 1;
        private var _xoffset:Number = 0;
        private var _yoffset:Number = 0;
        private var _draw_style:uint= Drawing.DRAW_STYLE_INVERSE;
        
        public function DrawingDecorator()
        {
            super();
        }
        
        override public function initGraphics():void
        {
            super.initGraphics();
//          _dots = new Sprite();
//          addChild(_dots);
        }
        
        
        override public function decorate():void
        {
            if (_points==null || _points.length==0)
                return;
            var g:Graphics = _mid.graphics;
            g.clear();
            switch(_draw_style)
            {
                case Drawing.DRAW_STYLE_INVERSE:
                    g.lineStyle(_line_thickness,_line_color,_line_alpha);
                    draw_shape(g);
                    g.lineStyle(0,0,0);
                    g.beginFill(_matte_color,_matte_alpha);
                    g.drawRect(0,0,width,height);
                    draw_shape(g);
                    g.endFill();
                    break;
                case Drawing.DRAW_STYLE_POSITIVE:
                    g.beginFill(_matte_color,_matte_alpha);
                    draw_shape(g);
                    break;
            }
            super.decorate();
        }
        
        private function draw_shape(g:Graphics):void
        {
            g.moveTo(_points[0].x*_scale+_xoffset, _points[0].y*_scale+_yoffset);
            for (var i:uint=0; i<_points.length; i++)
            {
                var ni:uint = (i+1)%_points.length;
                g.curveTo(_points[i].cx*_scale+_xoffset, _points[i].cy*_scale+_yoffset,_points[ni].x*_scale+_xoffset, _points[ni].y*_scale+_yoffset);
            }
        }
        
        public function set points(a:Array):void
        {
            _points = a;
        }
        
        public function get points():Array
        {
            return _points
        }
        
        public function set matteColor(c:uint):void
        {
            _matte_color = c;
        }
        
        public function set matteAlpha(a:Number):void
        {
            _matte_alpha = a;
        }
        
        public function set lineColor(c:uint):void
        {
            _line_color = c;
        }
        
        public function set lineAlpha(a:Number):void
        {
            _line_alpha = a;
        }
        
        public function set lineThickness(t:Number):void
        {
            _line_thickness = t;
        }
        
        override public function set scale(s:Number):void
        {
            _scale = s;
        }
        
        public function set xoffset(s:Number):void
        {
            _xoffset = s;
        }
        
        public function set yoffset(s:Number):void
        {
            _yoffset = s;
        }
        
        public function set drawStyle(s:Number):void
        {
            _draw_style = s;
        }
        
    }
}
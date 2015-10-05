package com.pagesociety.ux.decorator
{
    
    import com.pagesociety.util.ColorUtil;
    import com.pagesociety.ux.decorator.Decorator;
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.display.BitmapData;
    import flash.display.GradientType;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    
    public class ColorChooserDecorator extends Decorator
    {
        public static const CHANGE_COLOR_VALUE:String = "change_color_value";
        private var _color_swatch:Sprite;
        private var _color_bar:Sprite;
        private var _color_bar_slider:Sprite;
        private var _color_bar_bitmap_data:BitmapData;
        private var _color_box:Sprite;
        private var _color_box_point:Sprite;
        private var _color_box_bitmap_data:BitmapData;
        
        private var _c:uint;
        private var _c1:uint;
        
        public function ColorChooserDecorator()
        {
            super();
        }
        
        
        override public function initGraphics():void
        {
            super.initGraphics();
            
            _color_swatch = new Sprite();
            addChild(_color_swatch);
            
            _color_bar = new Sprite();
            _color_bar.addEventListener(MouseEvent.MOUSE_DOWN, on_click_color_bar);
            init_color_bar(_color_bar.graphics, 20, 150);
            addChild(_color_bar);
            _color_bar_bitmap_data = new BitmapData(_color_bar.width, _color_bar.height);
            _color_bar_bitmap_data.draw(_color_bar);
            
            _color_bar_slider = new Sprite();
            init_color_bar_slider(_color_bar_slider.graphics);
            _color_bar.addChild(_color_bar_slider);
            
            _color_box = new Sprite();
            _color_box.addEventListener(MouseEvent.MOUSE_DOWN, on_click_color_box);
            addChild(_color_box);
            _color_box_bitmap_data = new BitmapData(150, 150);

            _color_box_point = new Sprite();
            _color_box_point.mouseEnabled = false;
            _color_box_point.mouseChildren = false;
            init_color_box_point(_color_box_point.graphics);
            _color_box.addChild(_color_box_point);
            
        }
        
        override public function decorate():void
        {
            var g:Graphics;
            g = _color_swatch.graphics;
            g.clear();
            g.beginFill(_c1);
            g.drawRect(0,0,width,80);
            
            _color_bar.x = width-50;
            _color_bar.y = 90;
            
            _color_box.x = 20;
            _color_box.y = 90;

            super.decorate();
        }
        
        override public function get color():uint
        {
            return _c1;
        }
        
        override public function set color(c:uint):void
        {
            if (_c1==c)
                return;
            _c1 = c;
            
            var info:Object = closet_color(_color_bar_bitmap_data, _c1, 1, 50);
            _color_bar_slider.y = info.y;
            init_color_box(_color_box.graphics, info.closest);
            _color_box_bitmap_data.draw(_color_box);
            info = closet_color(_color_box_bitmap_data, _c1, 50, 50);
            _color_box_point.x = info.x;
            _color_box_point.y = info.y;
        }
        
        private function on_click_color_bar(e:MouseEvent):void
        {
            update_color_bar(e.localY);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, on_move_color_bar);
            stage.addEventListener(MouseEvent.MOUSE_UP, on_up_color_bar);
        }
        
        private function on_move_color_bar(e:MouseEvent):void
        {
            var l:Point = _color_bar.globalToLocal(new Point(0, e.stageY));
            update_color_bar(l.y);
        }
        
        private function on_up_color_bar(e:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, on_move_color_bar);
            stage.removeEventListener(MouseEvent.MOUSE_UP, on_up_color_bar);
            dispatchEvent(new ComponentEvent(CHANGE_COLOR_VALUE));
        }
        
        private function update_color_bar(y:Number):void
        {
            if (y<0) y=0;
            if (y>149) y=149;
            _color_bar_slider.y = y;
            _c = _color_bar_bitmap_data.getPixel(0,y);
            init_color_box(_color_box.graphics, _c);
            _color_box_bitmap_data.draw(_color_box);
            _c1 = _color_box_bitmap_data.getPixel(_color_box_point.x,_color_box_point.y);
            decorate();
        }
        
        private function on_click_color_box(e:MouseEvent):void
        {
            var l:Point = _color_box.globalToLocal(new Point(e.stageX, e.stageY));
            update_color_box(l.x,l.y);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, on_move_color_box);
            stage.addEventListener(MouseEvent.MOUSE_UP, on_up_color_box);
        }
        
        private function on_move_color_box(e:MouseEvent):void
        {
            var l:Point = _color_box.globalToLocal(new Point(e.stageX, e.stageY));
            update_color_box(l.x,l.y);
        }
        
        private function on_up_color_box(e:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, on_move_color_box);
            stage.removeEventListener(MouseEvent.MOUSE_UP, on_up_color_box);
            dispatchEvent(new ComponentEvent(CHANGE_COLOR_VALUE));
        }

        private function update_color_box(x:Number,y:Number):void
        {
            if (x<0)
                x=0;
            else if (x>149)
                x=149;
            if (y<0)
                y=0;
            else if (y>149)
                y=149;
            _color_box_point.x = x;
            _color_box_point.y = y;
            _c1 = _color_box_bitmap_data.getPixel(x,y);
            decorate();
        }
        
        /// drawings
        
        public static function init_color_bar(g:Graphics, w:Number=100, h:Number=100):void
        {
            g.clear();
            var fillType:String = GradientType.LINEAR;
            var colors:Array = new Array();
            var alphas:Array = new Array();
            var ratios:Array = new Array();
            for (var i:Number=0; i<=1; i+=.125)
            {
                colors.push(get_rgb(i*Math.PI*2));
                alphas.push(1);
                ratios.push(0xFF*i);
            }
            var matr:Matrix = new Matrix();
            matr.createGradientBox(w, h, Math.PI/2, 0, 0);
            g.beginGradientFill(fillType, colors, alphas, ratios, matr);  
            g.drawRect(0,0,w,h);
        }
        
        public static function init_color_box(g:Graphics, c:uint, w:Number=150, h:Number=150):void
        {
            g.clear();
            var white:Object = {r:255,g:255,b:255};
            var black:Object = {r:0,g:0,b:0};
            var color:Object = ColorUtil.toRgb(c);
            for (var y:Number=0; y<h; y+=1)
            {
                var p:Number = y/h;
                var lc:uint = ColorUtil.toInt(ColorUtil.between(white,black,p));
                var rc:uint = ColorUtil.toInt(ColorUtil.between(color,black,p));;
                var matr:Matrix = new Matrix();
                matr.createGradientBox(w, h, 0, 0, 0);
                g.lineStyle(2);
                g.lineGradientStyle(GradientType.LINEAR, [lc, rc], [1, 1], [0, 0xFF], matr);
                g.moveTo(0, y);
                g.lineTo(w, y);
            }
        }
        
        public static function get_rgb(radians:Number):uint
        {
            var o:Object = new Object();
            o.r = Math.cos(radians)                   * 127 + 128;
            o.g = Math.cos(radians + 2 * Math.PI / 3) * 127 + 128;
            o.b = Math.cos(radians + 4 * Math.PI / 3) * 127 + 128;
            return ColorUtil.toInt(o);
        }
        
        public static function init_color_bar_slider(g:Graphics):void
        {
            var x:Number = 20;
            var y:Number = 0;
            g.clear();
            g.beginFill(0xffffff,1);
            g.moveTo(x+0, y+0);
            g.lineTo(x+5, y-5);
            g.lineTo(x+15,y-5);
            g.lineTo(x+15,y+5);
            g.lineTo(x+5, y+5);
            g.lineTo(x+0, y+0);
            g.endFill();
        }
        
        public static function init_color_box_point(g:Graphics):void
        {
            g.clear();
            g.lineStyle(2,0,.8);
            g.drawCircle(0,0,8);
            g.lineStyle(1,0xffffff,1);
            g.drawCircle(0,0,4);
                        
        }
        
        //
        private static function closet_color(bmd:BitmapData, c:uint, xres:uint=4, yres:uint=4):Object
        {
            var cc:Object = ColorUtil.toRgb(c);
            var low:uint=0xFFFFFF;
            var x:uint;
            var y:uint;
            var closest:uint;
            for (var xo:uint=0; xo<bmd.width; xo+=(bmd.width/xres))
            {
                for (var yo:uint=0; yo<bmd.height; yo+=(bmd.height/yres))
                {
                    var cbbc:Object = ColorUtil.toRgb(bmd.getPixel(xo,yo));
                    var l:uint = Math.abs(cc.r-cbbc.r)+Math.abs(cc.g-cbbc.g)+Math.abs(cc.b-cbbc.b);
                    if (l<low) 
                    {
                        low=l;
                        y=yo;
                        x=xo;
                        closest = bmd.getPixel(xo,yo);
                    }
                }
            }
            return { x:x, y:y, closest:closest};
        }
    }
}
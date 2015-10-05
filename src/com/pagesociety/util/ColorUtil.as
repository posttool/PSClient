package com.pagesociety.util
{
    public class ColorUtil
    {
        public static function random():Object
        {
            var C:Array = new Array(3);
            C[0] = Random.R(256);
            C[1] = Random.R(256);
            C[2] = Random.R(256);
            while (C[0]+C[1]+C[2]>720)
            {
                C[Random.R(3)] *= Math.random();
            }
            return { r: C[0], g: C[1], b: C[2] };
        }
        
        public static function alter(c:Object, f:Number=1):Object
        {
            if (f<0)
            {
                return { 
                    r: c.r*(1+f), 
                    g: c.g*(1+f), 
                    b: c.b*(1+f) 
                };
            }
            else
            {
                return { 
                    r: c.r+(255-c.r)*f, 
                    g: c.g+(255-c.g)*f, 
                    b: c.b+(255-c.b)*f 
                };
            }
            
        }
        
        public static function between(c0:Object, c1:Object, percent:Number):Object
        {
            return {
                r: (c1.r-c0.r)*percent+c0.r,
                g: (c1.g-c0.g)*percent+c0.g,
                b: (c1.b-c0.b)*percent+c0.b
            }
        }
        
        
        public static function toInt(o:Object):uint
        {
            return o.r<<16 | o.g<<8 | o.b;
        }
        
        
        public static function toRgb(c:uint):Object
        {
            var o:Object = new Object();
            o.r = c >> 16 & 0xFF
            o.g = c >> 8 & 0xFF
            o.b = c & 0xFF
            return o;
        }
        
        public static function toHexString(c:uint):String
        {
            var s:String = "000000"+c.toString(16);
            return s.substr(s.length-6,6);
        }
        
        public static function random1():uint
        {
            return toInt(HSBToRGB(Math.random()*0xff, 0xff, 0xff));
        }
        
        


        ///
        public static function RGBToHex(r:int,g:int,b:int):uint
        {
            var hex:uint = r<<16 | g<<8 | b;
            return hex;
        }
        
        // 16進数からRGBへ変換
        public static function HexToRGB(value:uint):Object
        {
            var rgb:Object = new Object();
            rgb.r = (value >> 16) & 0xFF
            rgb.g = (value >> 8) & 0xFF
            rgb.b = value & 0xFF            
            return rgb;
        }
        
        // RGBからHSBへ変換
        public static function RGBToHSB(r:int,g:int,b:int):Object
        {
            var hsb:Object = new Object;
            var _max:Number = Math.max(r,g,b);//rgbを比較し最大値を取得
            var _min:Number = Math.min(r,g,b);//rgbを比較し最小値を取得
            
            // 彩度
            hsb.s = (_max != 0) ? (_max - _min) / _max * 100: 0;
            // 明度
            hsb.b = _max / 255 * 100;
            // 色相
            if(hsb.s == 0){
                hsb.h = 0;
            }else{
                switch(_max)
                {
                    case r:
                        hsb.h = (g - b)/(_max - _min)*60 + 0;
                        break;
                    case g:
                        hsb.h = (b - r)/(_max - _min)*60 + 120;
                        break;
                    case b:
                        hsb.h = (r - g)/(_max - _min)*60 + 240;
                        break;
                }
            }
            
            hsb.h = Math.min(360, Math.max(0, Math.round(hsb.h)))
            hsb.s = Math.min(100, Math.max(0, Math.round(hsb.s)))
            hsb.b = Math.min(100, Math.max(0, Math.round(hsb.b)))
            
            return hsb;
        }
        
        // HSBからRGBへ変換
        public static function HSBToRGB(h:int,s:int,b:int):Object
        {
            var rgb:Object = new Object();
        
            var max:Number = (b*0.01)*255;
            var min:Number = max*(1-(s*0.01));
            
            if(h == 360){
                h = 0;
            }
            
            if(s == 0){
                rgb.r = rgb.g = rgb.b = b*(255*0.01) ;
            }else{
                var _h:Number = Math.floor(h / 60);
                
                switch(_h){
                    case 0:
                        rgb.r = max ;                                                                                                                                                                                                                   
                        rgb.g = min+h * (max-min)/ 60;
                        rgb.b = min;
                        break;
                    case 1:
                        rgb.r = max-(h-60) * (max-min)/60;
                        rgb.g = max;
                        rgb.b = min;
                        break;
                    case 2:
                        rgb.r = min ;
                        rgb.g = max;
                        rgb.b = min+(h-120) * (max-min)/60;
                        break;
                    case 3:
                        rgb.r = min;
                        rgb.g = max-(h-180) * (max-min)/60;
                        rgb.b =max;
                        break;
                    case 4:
                        rgb.r = min+(h-240) * (max-min)/60;
                        rgb.g = min;
                        rgb.b = max;
                        break;
                    case 5:
                        rgb.r = max;
                        rgb.g = min;
                        rgb.b = max-(h-300) * (max-min)/60;
                        break;
                    case 6:
                        rgb.r = max;
                        rgb.g = min+h  * (max-min)/ 60;
                        rgb.b = min;
                        break;
                }
        
                rgb.r = Math.min(255, Math.max(0, Math.round(rgb.r)))
                rgb.g = Math.min(255, Math.max(0, Math.round(rgb.g)))
                rgb.b = Math.min(255, Math.max(0, Math.round(rgb.b)))
            }
            return rgb;
        }
    }
}
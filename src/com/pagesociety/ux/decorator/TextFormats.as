package com.pagesociety.ux.decorator
{
    import flash.text.TextFormat;
    
    public class TextFormats
    {
        

        public static function get CYAN_BIG():TextFormat
        {
            var tf:TextFormat = new TextFormat();
            tf.font = "_sans";
            tf.size = 24;
            tf.color = 0;
            tf.letterSpacing = 0;
            tf.color = 0x00bfff;
            return tf;
        }

        public static function get CYAN_LABEL():TextFormat
        {
            
            var tf:TextFormat = new TextFormat();
            tf.font = "_sans";
            tf.size = 12.5;
            tf.color = 0x00bfff;
            tf.letterSpacing = 0;
            return tf;
        }


        public static function get BLACK_TITLE():TextFormat
        {
            var tf:TextFormat = new TextFormat();
            tf.font = "_sans";
            tf.size = 23;
            tf.color = 0x000000;
            tf.letterSpacing = 0;
            return tf;
        }
        
        public static function get BLACK_BIG():TextFormat
        {
            var tf:TextFormat = new TextFormat();
            tf.font = "_sans";
            tf.size = 17;
            tf.color = 0;
            tf.letterSpacing = 0;
            return tf;
        }

        public static function get BLACK_LABEL():TextFormat
        {
            var tf:TextFormat = new TextFormat();
            tf.font = "_sans";
            tf.size = 12.5;
            tf.color = 0x000000;
            tf.letterSpacing = 0;
            return tf;
        }
        
        public static function get BLACK_SMALL():TextFormat
        {
            var tf:TextFormat = new TextFormat();
            tf.font = "_sans";
            tf.size = 8;
            tf.color = 0;
            tf.leading = 1;
            tf.letterSpacing = 1;
            return tf;
        }
        
        public static function get GRAY_SMALL():TextFormat
        {
            var tf:TextFormat = new TextFormat();
            tf.font = "_sans";
            tf.size = 8;
            tf.color = 0x555555;
            tf.leading = 1;
            tf.letterSpacing = 1;
            return tf;
        }   
        
        public static function get TINY_WHITE():TextFormat
        {
            var tf:TextFormat = new TextFormat();
            tf.font = "_sans";
            tf.size = 7;
            tf.color = 0xffffff;
            tf.letterSpacing = 2;
            return tf;
        }
        
        public static function get MEDIUM_WHITE():TextFormat
        {
            var tf:TextFormat = new TextFormat();
            tf.font = "_sans";
            tf.size = 13;
            tf.color = 0xffffff;
            tf.letterSpacing = 1;
            return tf;
        }
        
        public static function get BIG_WHITE():TextFormat
        {
            var tf:TextFormat = new TextFormat();
            tf.font = "_sans";
            tf.size = 27;
            tf.color = 0xffffff;
            tf.letterSpacing = 0;
            return tf;
        }
        
        






    }
}
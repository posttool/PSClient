package com.pagesociety.util
{
    public class StringUtil
    {
        public static function replace(str:String, oldSubStr:String, newSubStr:String):String 
        {
            return str.split(oldSubStr).join(newSubStr);
        }
    
        public static function trim(str:String):String 
        {
            str = trimBack(trimFront(str, " "), " ");
            str = trimBack(trimFront(str, "\t"), "\t");
            str = trimBack(trimFront(str, "\n"), "\n");
            return str;
        }
        
        public static function trimFront(str:String, char:String):String 
        {
            if (str==null)
                return "";
            char = stringToCharacter(char);
            if (str.charAt(0) == char) {
                str = trimFront(str.substring(1), char);
            }
            return str;
        }
        
        
        public static function trimBack(str:String, char:String):String 
        {
            char = stringToCharacter(char);
            if (str.charAt(str.length - 1) == char) {
                str = trimBack(str.substring(0, str.length - 1), char);
            }
            return str;
        }
        
        public static function shorten(s:String, max_length:uint):String
        {
            if (s==null)
                return "";
            if (s.length<=max_length)
                return s;
            return s.substr(0,max_length)+"...";
        }
        
        public static function stripTags(s:String):String
        {
            if (s==null)
                return "";
            var b:StringBuffer = new StringBuffer();
            var open:Boolean = false;
            for (var i:uint = 0; i < s.length; i++)
            {
                if (s.charAt(i) == '<')
                {
                    open = true;
                }
                if (!open)
                {
                    b.append(s.charAt(i));
                }
                if (s.charAt(i) == '>')
                {
                    open = false;
                    b.append(" ");
                }
            }
            return trim(b.toString());
        }
    
       
    
    
        public static function stringToCharacter(str:String):String 
        {
            if (str.length == 1) {
                return str;
            }
            return str.slice(0, 1);
        }
        
        public static function twoDigitNumber(i:uint):String
        {
            if (i<10)
                return "0"+i;
            else
                return i.toString();
        }

        public static function formatPrice(n:Number, add_currency_symbol:Boolean=true):String
        {
            var cs:String = add_currency_symbol ? "$" : "";
            var ni:int = n;
            var nd:String = String( Math.floor((n-ni)*100) );
            if (nd.length==1)
                nd = nd+"0";
            if (ni==0)
                return cs+"."+nd;
            else
                return cs+ni+"."+nd;
                
        }
        public static function formatTime(timeMillis:uint):String
        {
            var time:Number = Math.floor(timeMillis / 1000);  
            var seconds:String = String(time % 60);  
            var minutes:String = String(Math.floor((time % 3600) / 60));  
            var hours:String = String(Math.floor(time / 3600));  
            for (var i:uint = 0; i < 2; i++) {  
                if (seconds.length < 2) 
                    seconds = "0" + seconds;  
                if (minutes.length < 2)  
                    minutes = "0" + minutes;  
                if (hours.length < 2)   
                    hours = "0" + hours;  
            }
            if (hours=="00")
                return minutes+":"+seconds;
            else
                return hours+":"+minutes+":"+seconds;
        }

        public static function formatDate(d:Date):String
        {
            if (d==null)
                return "";
            return d.fullYear+"."+twoDigitNumber(d.month+1)+"."+twoDigitNumber(d.date)
                +" "+twoDigitNumber(d.hours)+":"+twoDigitNumber(d.minutes);
        }
        
        public static function formatDateNoTime(d:Date):String
        {
            if (d==null)
                return "";
            return d.fullYear+"."+twoDigitNumber(d.month+1)+"."+twoDigitNumber(d.date);
        }
        
        public static function formatTimeNoDate(d:Date):String
        {
            return twoDigitNumber(d.hours)+":"+twoDigitNumber(d.minutes)+":"+twoDigitNumber(d.seconds);
        }
        
        public static function startsWith(input:String,prefix:String):Boolean
        {
            return input.length>=prefix.length && input.substr(0,prefix.length)==prefix;
        }
        
        public static function beginsWith(input:String,prefix:String):Boolean
        {
            return startsWith(input,prefix);
        }
        
        public static function endsWith(input:String,suffix:String):Boolean
        {
            return input.indexOf(suffix)==(input.length-suffix.length);
        }
        
        public static function getExtension(s:String):String
        {
            var lid:int = s.lastIndexOf(".");
            if (lid==-1)
                return "";
            return s.substr(lid+1).toLowerCase();
        }
        
        public static function trimExtension(s:String):String
        {
            var lid:int = s.lastIndexOf(".");
            if (lid==-1)
                return s;
            return s.substr(0, lid);
        }
        
        public static function getFileName(s:String):String
        {
            var lid:int = s.lastIndexOf(".");
            if (lid==-1)
                return s;
            return s.substr(0,lid);
        }
    }
}
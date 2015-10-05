package com.pagesociety.ux.component.text
{
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.container.ScrollingContainer;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.decorator.Decorator;

    public class ScrollingText extends ScrollingContainer
    {
        private var _text_area:Label;
        public function ScrollingText(parent:Container, d:Decorator=null, index:int=-1)
        {
            super(parent, d, index);
            
            _text_area = new Label(this);
            _text_area.multiline = true;
            _text_area.widthPercent = 70;
            _text_area.labelDecorator.linkEnabled = true;
        }
        
        public function get textArea():Label
        {
            return _text_area;
        }
        
        public function set text(h:String):void
        {
//          h = add_events(h);
            _text_area.text = h;
        }
        
        public function get text():String
        {
            return _text_area.text;
        }
        
        override public function render():void
        {
            contentHeight = _text_area.height;
            super.render();
        }
        
        override public function set widthDelta(pw:Number):void
        {
            _text_area.widthDelta = pw;
        }
        
        
        //
        public function clearText():void
        {
            _text_area.text = "";
        }
        
        public function beginSpan(style:String):void
        {
            _text_area.append("<span class='"+style+"'>");
        }
        
        public function endSpan():void
        {
            _text_area.append("</span>");
        }
        
        public function append(s:String, style:String=null):void
        {
//          s = add_events(s);
            if (s==null)
                return;
                
            if (style==null)
            {
                _text_area.append(s);
                return;
            }
            
            if (s.indexOf("<ROOT>")==0)
                _text_area.append(addStyleToParagraphs(s,style));
            else
                _text_area.append("<p class='"+style+"'>"+s+"</p>");
            _text_area.append("\n");
        }
        
        public function br():void
        {
            _text_area.append("<p class='body'> </p>\n");
        }
        
        private function add_events(v:String):String
        {
            var p:RegExp = /HREF=\"(.*?)\"/g;
            var s:String = v.replace(p,"HREF=\"event:$1\"");
            return s;
        }
        
        public static function addStyleToParagraphs(v:String,style:String):String
        {
            if (v==null)
                return "";
            var p:RegExp = /\<P\>/g;
            var s:String = v.replace(p,"<P class='"+style+"'>");
            return s;
        }
        
    }
}
package com.pagesociety.ux.component.text
{
    import com.pagesociety.util.StringUtil;
    import com.pagesociety.util.XMLUtil;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.decorator.RichTextDecorator;
    import com.pagesociety.ux.event.ComponentEvent;

    [Event(type="com.pagesociety.ux.component.text.RichTextEditor",name="selection_change")]
    [Event(type="com.pagesociety.ux.component.text.RichTextEditor",name="rte_link")]
    [Event(type="com.pagesociety.ux.component.text.RichTextEditor",name="rte_scroll")]
    public class RichTextEditor extends Input //implements KeyListener
    {
        public static const SELECTION_CHANGE:String = "selection_change";
        public static const RTE_LINK:String = "rte_link";
        public static const RTE_SCROLL:String = "rte_scroll";

        public function RichTextEditor(p:Container)
        {
            XML.prettyPrinting = false;
            XML.ignoreWhitespace = false;
            super(p);
            decorator = new RichTextDecorator(application.style);
            decorator.addEventListener(SELECTION_CHANGE, on_selection_change);
            decorator.addEventListener(RTE_LINK, on_link);
            decorator.addEventListener(RTE_SCROLL, on_scroll);
            styleName = "Component";
            styleName = "Input";
            multiline = true;
            value = "";
        }
        
        private function on_selection_change(e:ComponentEvent):void
        {
            dispatchComponentEvent(SELECTION_CHANGE, this, value);
        }
        
        private function on_link(e:ComponentEvent):void
        {
            dispatchComponentEvent(RTE_LINK, this, e.data);
        }
        
        private function on_scroll(e:ComponentEvent):void
        {
            dispatchComponentEvent(RTE_SCROLL, this);
        }
        
        public function get richTextDecorator():RichTextDecorator
        {
            return decorator as RichTextDecorator;
        }
        
        public function append(s:String, xtra:String):void
        {
            var v:String = value as String;
            if (v.indexOf("<ROOT>")!=-1)
            {
                value = v.substring(0,v.length-7)+s+xtra+"</ROOT>";
            }
            else
            {
                value += s+xtra;
            }
        }
        
        private function sync_component():void
        {
            _input_value = inputDecorator.inputValue;
            _input_value = value as String;
            inputDecorator.inputValue = _input_value;
            _dirty = true;
        }
        
        public function set bold(b:Boolean):void
        {
            richTextDecorator.bold();
            sync_component();
        }
        
        public function get bold():Boolean
        {
            return richTextDecorator.selectionFormat.bold;
        }
        
        public function set underline(b:Boolean):void
        {
            richTextDecorator.underline();
            sync_component();
        }
        
        public function get underline():Boolean
        {
            return richTextDecorator.selectionFormat.underline;
        }
        
        public function set italic(b:Boolean):void
        {
            richTextDecorator.italic();
            sync_component();
        }
        
        public function get italic():Boolean
        {
            return richTextDecorator.selectionFormat.italic;
        }
        
        public function set url(s:String):void
        {
            richTextDecorator.url(s);
            sync_component();
        }
        
        public function setUrl(s:String,beg_sel:uint,end_sel:uint):void
        {
            richTextDecorator.url(s,beg_sel,end_sel);
            sync_component();
        }
        
        public function get url():String
        {
            if (richTextDecorator.selectionFormat.url==null)
                return "";
            return richTextDecorator.selectionFormat.url;
        }
        
        public function get link():Boolean
        {
            return url!="";
        }
        
        public function replaceSelectedText(s:String):void
        {
            richTextDecorator.replaceSelectedText(s);
        }
        
        override public function set value(o:Object):void
        {
            if (richTextDecorator!=null)
            {
                richTextDecorator.setSelection(0,0);
                richTextDecorator.plain();
            }
            //
            if (o==null)
                o = "";
            var x:XML;
            try {
                x = new XML(o);
            } catch (e:Error)
            {
                try {
                    x = new XML("<ROOT>"+o+"</ROOT>");
                }
                catch (e:Error)
                {
                    x = new XML(StringUtil.stripTags(o.toString()));
                }
            }
            XMLUtil.add_events_to_as(x);
            _input_value = x.toXMLString();
            inputDecorator.inputValue = _input_value;
            inputDecorator.caretIndex = _input_value.length;
            _dirty = false;
        }
        
        override public function get value():Object
        {
            var s:String = super.value as String;
            if(s == null)
                return null;
            if (s.substring(0,6)!="<ROOT>")
                s = "<ROOT>"+s+"</ROOT>";
            var x:XML = new XML(s);
            x = XMLUtil.rebuild(x, ["ROOT","TEXTFORMAT","FONT"]);
            XMLUtil.add_space_to_empty_ps(x);
            XMLUtil.remove_events_from_as(x);
            delete x..P.@*;
            return x.toXMLString();
        }
        
        
    }
}
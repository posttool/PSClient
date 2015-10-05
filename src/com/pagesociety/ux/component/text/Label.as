package com.pagesociety.ux.component.text
{
    import com.pagesociety.util.StringUtil;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.decorator.LabelDecorator;
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.events.TextEvent;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class Label extends Component
    {   
        private var _label_value:String;
        
        public static var ALIGN_LEFT:uint = 0;
        public static var ALIGN_CENTER:uint = 1;
        public static var ALIGN_RIGHT:uint = 2;
        
        private var _align:uint = ALIGN_LEFT;
        
        public function Label(parent:Container, index:int=-1)
        {
            super(parent, index);
            decorator = new LabelDecorator(application.style);
            decorator.addEventListener(TextEvent.LINK, on_link);
            styleName = "Component";
            styleName = "Label";
            _label_value = "";
        }
        
        private function on_link(e:TextEvent):void
        {
            dispatchComponentEvent(ComponentEvent.LINK, this, e.text);
        }
        
        public function append(s:String, append_too_if_s_not_empty:String=""):void
        {
            if (s==null || s=="")
                return;
            text += (s+append_too_if_s_not_empty);
        }

        public function get labelDecorator():LabelDecorator
        {
            return decorator as LabelDecorator;
        }
        
        public function get text():String 
        {
            return _label_value;
        }
        
        public function set text(v:String):void 
        {
            if (v==null)
                v="";
//          if (v.indexOf("<ROOT>")==0)
//          {
//              var x:XML = new XML(v);
//              XMLUtil.remove_events_from_as(x);
//              v = x.toXMLString();
//          }
            _label_value = v;
            labelDecorator.labelText = v;
        }
        
        public function set date(d:Date):void
        {
            text = StringUtil.formatDate(d);
        }
    
        
        public function set align(a:uint):void
        {
            _align = a;
            //labelDecorator.align = a;
        }
        
        override public function set width(w:Number):void
        {
            super.width = w;
            decorator.width = w;
        }
        
        override public function get width():Number
        {
            if (!isWidthUnset)
                return super.width;
            return labelDecorator.width;
        }
        
        override public function set height(h:Number):void
        {
            super.height = h;
        }
        
        override public function get height():Number
        {
            if (!isHeightUnset)
                return super.height;
            if (decorator == null)
                return 0;
            labelDecorator.width = width;
            return labelDecorator.height;
        }
        
        public function get descent():Number
        {
            if (decorator==null)
                return 0;
            return labelDecorator.descent;
        }
        
        public function get ascent():Number
        {
            if (decorator==null)
                return 0;
            return labelDecorator.ascent;
        }
        
        public function get multiline():Boolean
        {
            return labelDecorator.labelIsMultiLine;
        }
        
        public function set multiline(b:Boolean):void
        {
            labelDecorator.labelIsMultiLine = b;
            if (b && isWidthUnset)
                widthPercent = 100;
            else if (!b)
                widthUnset();
        }
        
        public function get selectable():Boolean
        {
            return labelDecorator.selectable;
        }
        
        public function set selectable(b:Boolean):void
        {
            labelDecorator.selectable = b;
        }
        
        public function set textFormat(tf:TextFormat):void
        {
            labelDecorator.labelTextFormat = tf;;
        }
        
        public function set fontStyle(s:String):void
        {
            labelDecorator.fontStyle = s;
        }
        
        public function get fontStyle():String
        {
            return labelDecorator.fontStyle;
        }
        
        override public function render():void
        {
            if (multiline)
            {
//              switch(_align)
//              {
//                  case ALIGN_CENTER:
//                      labelDecorator.label.autoSize = TextFieldAutoSize.CENTER;
//                      break;
//                  case ALIGN_RIGHT:
//                      labelDecorator.label.autoSize = TextFieldAutoSize.RIGHT;
//                      break;
//              }
            }
            else
            {
                var xa:Number = labelDecorator.labelX;
                switch(_align)
                {
                    case ALIGN_LEFT:
                        xa = 0;
                        break;
                    case ALIGN_CENTER:
                        xa = Math.floor((super.width - labelDecorator.width)/2);
                        break;
                    case ALIGN_RIGHT:
                        xa = super.width - labelDecorator.width;
                        break;
                }
                labelDecorator.labelX = xa;
            }
            super.render();
        }
    }
}
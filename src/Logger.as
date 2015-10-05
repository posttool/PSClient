package
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.ui.Keyboard;

    public class Logger 
    {
        
        private static var mc:Sprite;
        private static var bg:Sprite;
        private static var tf:TextField;
        private static var clear:Sprite;
        private static var hide:Sprite;
        
        public static function init(stage:Stage,x:Number=-1,y:Number=-1):void 
        {
            if (mc!=null)
            {
                update_position(x,y);
                return;
            }
                
            mc = new Sprite();
            mc.visible = false;
            stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void
            {
                if (e.keyCode==Keyboard.ESCAPE)
                    mc.visible = !mc.visible;
            });

            bg = new Sprite();
            mc.addChild(bg);
            bg.graphics.beginFill(0x222222,.5);
            bg.graphics.drawRect( 0,0,400, 300);
            bg.graphics.endFill();
            
            bg.addEventListener(MouseEvent.MOUSE_DOWN,start_drag);
            bg.addEventListener(MouseEvent.MOUSE_UP,end_drag);

            tf = getTextField();
            mc.addChild(tf);        

            update_position(x,y);
            if(mc.parent==null)
                stage.addChild(mc);
            log("DEBUG",true);
            
        }
        
        public static function getTextField(face:String="_sans",size:Number=12,letterspacing:Number=1,leading:Number=1):TextField
        {
            var textFormat:TextFormat = new TextFormat();
            textFormat.font = face;
            textFormat.size = size;
            textFormat.leading = leading;
            textFormat.kerning = true;
            textFormat.letterSpacing = letterspacing;
            textFormat.color = 0;

            var tf:TextField = new TextField();
            tf.embedFonts = false; 
            tf.multiline = true;
            tf.wordWrap = false; 
            tf.condenseWhite = false;
            tf.selectable = true;
            tf.antiAliasType = "advanced"       
            tf.defaultTextFormat = (textFormat);
            tf.width = 400;
            tf.height = 280;
            tf.y = 20;
            
            return tf;      
        }
        
        private static function update_position(x:Number,y:Number):void
        {
            mc.x = (x == -1) ? mc.stage.stageWidth - 20 : x;
            mc.y = (y == -1) ? mc.stage.stageHeight - 20 : y;
        }
        
            
        public static function log(o:Object, clear:Boolean=false):void {
            trace(o);
            if (o==null)o="null";
            if (tf!=null)
            {
                var txt:String = clear ? o.toString() : tf.text + "\n"+ o.toString();
                tf.text = txt;
                var mci:uint = mc.stage.getChildIndex(mc);
                if (mci==mc.stage.numChildren-1)
                    return;
                mc.stage.swapChildrenAt(mci,mc.stage.numChildren-1);
            }
        }
        
        public static function debug(o:Object, clear:Boolean=false):void {
            trace(o);
            if (o==null)o="null";
            if (tf!=null)
            {
                var txt:String = clear ? o.toString() : tf.text + "\n"+ o.toString();
                tf.text = txt;
                var mci:uint = mc.stage.getChildIndex(mc);
                if (mci==mc.stage.numChildren-1)
                    return;
                mc.stage.swapChildrenAt(mci,mc.stage.numChildren-1);
            }
        }
        
        public static function error(o:Object, clear:Boolean=false):void 
        {
            trace(o);
            if (o==null) o="null";
            if (tf!=null)
            {
                var txt:String = clear ? o.toString() : tf.text + "\nERROR ["+ o.toString()+"]";
                tf.text = txt;
        
                var mci:uint = mc.stage.getChildIndex(mc);
                if (mci==mc.stage.numChildren-1)
                    return;
                mc.stage.swapChildrenAt(mci,mc.stage.numChildren-1);
            }

        }   
         
        private static function togglevisibility():void
        {
            bg.visible = !bg.visible;
            tf.visible = !tf.visible;       
        }
        
        
        private static function start_drag(e:MouseEvent):void 
        {
            mc.startDrag();
        }
        
        private  static function end_drag(e:MouseEvent):void 
        {
            mc.stopDrag();
        }
        
    }
}
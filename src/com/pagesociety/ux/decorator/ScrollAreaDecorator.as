package com.pagesociety.ux.decorator
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.ui.Mouse;
    
    public class ScrollAreaDecorator extends ScrollingDecorator 
    {
        
        private var _scroll_speed:Number = .3;

        
        private var vertical_buttons:Sprite;
        private var vb0:Sprite;
        private var vb1:Sprite;
        private var horizontal_buttons:Sprite;
        private var hb0:Sprite;
        private var hb1:Sprite;

        protected var _button_width:Number = 20;
        protected var _button_height:Number = 20;
        protected var _xoffset:Number = 0;
        protected var _yoffset:Number = 0;
        

        
        public function ScrollAreaDecorator(scroll_type:String=null)
        {
            super(scroll_type);
        }

    
    
        //////////////////////////////////////////////////////////////////////////
        
        override public function initGraphics():void
        {
            super.initGraphics();
            
            vertical_buttons = new Sprite();
            
            vb0 = new Sprite();
            vb0.addEventListener(MouseEvent.MOUSE_DOWN,over_up_vertical);
            vb1 = new Sprite();
            vb1.addEventListener(MouseEvent.MOUSE_DOWN,over_down_vertical);
            vertical_buttons.addChild(vb0);
            vertical_buttons.addChild(vb1);
            addChild(vertical_buttons);
            
            horizontal_buttons = new Sprite();
            //horizontal_buttons.addEventListener(MouseEvent.MOUSE_OVER,over_horizontal);
        }
    
        
//      override public function addChild(child:DisplayObject):DisplayObject
//      {
//          super.addChild(child);
//          child.addEventListener(MouseEvent.MOUSE_WHEEL, do_mouse_wheel);
//          return child;
//      }
        
        override public function decorate():void 
        {
            
                super.decorate();

                
                if (scrollsHorizontally() && _content_width>_width) 
                {
                    horizontal_buttons.visible = true;
                    
                    
                    //todo
                } 
                else 
                {
                    horizontal_buttons.visible = false;
                }
                if (scrollsVertically() && _content_height>_height) 
                {
                    vertical_buttons.visible = true;
                    
                    vb0.graphics.clear();
                    vb0.graphics.beginFill(0xff0000, 0);
                    vb0.graphics.drawRect(_xoffset, 0, _button_width, _button_height);
                    vb0.graphics.endFill();
                    
                    vb1.graphics.clear();
                    vb1.graphics.beginFill(0xff0000, 0);
                    vb1.graphics.drawRect(_xoffset, _height-_button_height, _button_width, _button_height);
                    vb1.graphics.endFill();
                } 
                else 
                {
                    vertical_buttons.visible = false;
                }

        }
        
        

        ///////////////////////// mouse vertical
        
        private var _dir:int=1;
        protected function over_up_vertical(e:MouseEvent):void
        {
            _dir = -1;
            over_vertical();
        }
        
        protected function over_down_vertical(e:MouseEvent):void
        {
            _dir = 1;
            over_vertical();
        }
        
        private function over_vertical():void
        {
            stage.addEventListener(Event.ENTER_FRAME, move_vertical);
            stage.addEventListener(MouseEvent.MOUSE_UP, release_vertical);
            _scroll_speed = 0;
        }
        
        protected function move_vertical(e:Event):void
        {
            _scroll_speed += .5;
            if (_scroll_speed<0)
                return;
            setScrollVertical(getScrollVertical() + _scroll_speed*_dir);
        }
        
        protected function release_vertical(e:MouseEvent):void
        {
            stage.removeEventListener(Event.ENTER_FRAME, move_vertical);
            stage.removeEventListener(MouseEvent.MOUSE_UP, release_vertical);
        }
        
        override protected function scroll_vertical(y:Number):void 
        {   
            var max_scroll:Number = _content_height - _height;
            if (y > max_scroll)
            {
                vb1.visible = false;
                y = max_scroll;
            }
            else
            {
                vb1.visible = true;
            }
            if (y <= 0) 
            {
                vb0.visible = false;
                y=0;
            }
            else
            {
                vb0.visible = true;
            }
            maskY = y;
        }
        
        override public function setScrollVertical(y:Number):void 
        {
            scroll_vertical(y);
            decorate();
        }
        
        
        
        // horizontal
        //TODO convert: vert to horz & y to x
        private function over_horizontal(e:MouseEvent):void
        {
        }
        
        private function move_horizontal(e:Event):void
        {
        }
        
        private function release_horizontal(e:MouseEvent):void
        {
        }
        
        override protected function scroll_horizontal(y:Number):void 
        {   
        }
        
        override public function setScrollHorizontal(y:Number):void 
        {
        }
        
        

        
        
                
        // scroll wehelele
        private function do_mouse_wheel(e:MouseEvent):void
        {
            if (scrollsVertically())
            {
                if(e.delta<0)
                    setScrollVertical(getScrollVertical() + 50*_scroll_speed);
                else
                    setScrollVertical(getScrollVertical() - 50*_scroll_speed);
            }
            
        }
    }
}
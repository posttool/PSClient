package com.pagesociety.ux.component
{
    import com.pagesociety.ux.AnimationManager;
    import com.pagesociety.ux.Application;
    import com.pagesociety.ux.FocusManager;
    import com.pagesociety.ux.IComponent;
    import com.pagesociety.ux.Tween;
    import com.pagesociety.ux.component.dim.ComponentDimension;
    import com.pagesociety.ux.component.dim.ComponentPoint;
    import com.pagesociety.ux.decorator.Decorator;
    import com.pagesociety.ux.decorator.ScrollingDecorator;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.event.DragAndDropEvent;
    import com.pagesociety.ux.event.FocusEvent;
    
    import flash.display.Sprite;
    import flash.events.EventDispatcher;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;

    [Event(type="com.pagesociety.ux.event.ComponentEvent", name="click")]
    [Event(type="com.pagesociety.ux.event.ComponentEvent", name="double_click")]
    [Event(type="com.pagesociety.ux.event.ComponentEvent", name="mouse_over")]
    [Event(type="com.pagesociety.ux.event.ComponentEvent", name="mouse_out")]
    public class Component extends EventDispatcher implements IComponent
    {
        public static var USE_BUTTON_MODE:Boolean = true;
        protected var _use_button_mode:Boolean = true; // both must be true to work!
        
        protected var _application:Application;
        protected var _parent:Container;
        //
        protected var _decorator:Decorator;
        protected var _id:String;
        protected var _user_object:Object;
        protected var _focusable:Boolean = true;
//      protected var _focus_order:uint = 0;
        protected var _style_name:String;
        protected var _tooltip:String;
        
        protected var _x:ComponentPoint;
        protected var _y:ComponentPoint;
        protected var _width:ComponentDimension;
        protected var _height:ComponentDimension;
        
        public static const  PIXEL:uint         = 0x01;
        public static  const PERCENT:uint       = 0x02;
        
        public function Component(parent:Container, index:int=-1)
        {
            super();
            _x      = new ComponentPoint(this,ComponentPoint.X);
            _y      = new ComponentPoint(this,ComponentPoint.Y);
            _width  = new ComponentDimension(this,ComponentDimension.WIDTH);
            _height = new ComponentDimension(this,ComponentDimension.HEIGHT);
            
            decorator = new Decorator();
            styleName = "Component";
            
            if (parent!=null)
                parent.addComponent(this,index);
        }
        
        
        public function get decorator():Decorator
        {
            return _decorator;
        }
                
        public function set decorator(new_decorator:Decorator):void
        {
            if (new_decorator==null)
                return;
            
            if (_decorator != null)
                _decorator.destroy();
            
            _decorator = new_decorator;
            _decorator.component = this;
            
            styleName = "Component";//should be the entire style stack (todo)
            update_decorator_listeners();
            
            if (this is Container)
            {
                var c:Array = Container(this).children;
                for (var i:uint=0; i<c.length; i++)
                {
                    c[i].bindToSprite(_decorator.midground);
                }
            }
        }
        
        public function bringToFront():void
        {
            decorator.bringToFront();
        }
        
        public function sendToBack():void
        {
            decorator.sendToBack();
        }
        
        public function bindToSprite(p:Sprite):void
        {
            var s:Sprite = Sprite(_decorator);
            if (s!=null && s.parent!=null)
                s.parent.removeChild(s);
            p.addChild(s);
        }
        
        public function destroy():void
        {

            _decorator.destroy();
            //_decorator = null;
            removeAllEventListeners();
            cancel_execute_laters();
            if (_tween!=null)
                _tween.destroy();
        }
        
        public function setParent(p:Container):void
        {
            if (_parent!=null)
                _parent.children.splice(_parent.children.indexOf(this),1);
            _parent = p;
            _application = _parent.application;
            bindToSprite(_parent.decorator.midground);
        }
        
        public function get parent():Container
        {
            return _parent;
        }
        
        public function hasAncestor(c:Container):Boolean
        {
            var p:Container = _parent;
            while(p!=null)
            {
                if (p==c)
                    return true;
                p = p._parent;
            }
            return false;
        }
        
        public function get application():Application
        {
            return _application;
        }
        
        public function get focusManager():FocusManager
        {
            return application.focusManager; 
        }
        
        public function get userObject():*
        {
            return _user_object;
        }
        
        public function set userObject(o:*):void
        {
            _user_object = o;
        }
        
        
        public function render():void
        {
            if (_decorator == null)
                return;
            
            _decorator.visible                      = _visible;
            if (!_visible)
            {
                decorator.decorate();
                return;
            }

            _decorator.x                            = x;
            _decorator.y                            = y;    
            _decorator.width                        = width;
            _decorator.height                       = height;

            _decorator.alpha                        = _alpha;
            _decorator.blur                         = _blur;
            
            _decorator.background.visible           = _backgroundVisible;
            _decorator.background.boxVisible        = _backgroundVisible;
            _decorator.background.color             = _backgroundColor
            _decorator.background.alpha             = _backgroundAlpha;

            _decorator.background.borderVisible     = _backgroundBorderVisible;
            _decorator.background.borderAlpha       = _backgroundBorderAlpha;
            _decorator.background.borderThickness   = _backgroundBorderThickness;
            _decorator.background.borderColor       = _backgroundBorderColor;
            
            _decorator.shadowSize                   = _backgroundShadowSize;
            _decorator.shadowStrength               = _backgroundShadowStrength;
            _decorator.shadowColor                  = _backgroundShadowColor;
            _decorator.shadowDistance               = _backgroundShadowDistance;
            
            _decorator.cornerRadius                 = _cornerRadius;
            
            _decorator.decorate();
            
        }
        
        
        // tween helpers
        protected var _tween:Tween;
        public function animate(moving_values:Array, ms:uint, on_complete:Function=null):void
        {
            if (ms==0)
            {
                for (var i:uint=0; i<moving_values.length; i++)
                {
                    moving_values[i].percentComplete = 1;
                    render();
                }
                if (on_complete!=null) on_complete();
                return;
            }
            if (_tween==null)
                _tween = new Tween(0);
            _tween.render(this, moving_values, ms, on_complete);
        }
        
        
        /** new animation manager*/
        protected var animation_manager:AnimationManager; 
        /**
        multiple sigs
        move([component], animation info, [global duration], [global on complete callback])
        animation info is an array of [propName,value,duration]
        
        examples:
        move(["x",Math.random()*400,1000],["alpha",Math.random(),1300],function():void{trace("hey!")});
        move(["y",Math.random()*400],["x",Math.random()*10],["alpha",1],500);
        */
        public function move(...a):void
        {
            if (a==null || a.length==0)
                return;
            if (animation_manager == null)
                animation_manager = AnimationManager.getInstance()
            var target:Component = this;
            if (a[0] is Component)
                target = a.shift();
            var callback:Function = null;
            if (a[a.length-1] is Function || a[a.length-1] == null)
                callback = a.pop();
            var global_duration:Number = -1;
            if (a[a.length-1] is Number)
                global_duration = a.pop();
            for (var i:uint=0; i<a.length; i++)
            {
                var prop:String = a[i].shift();
                var animation:Array = a[i];
                if (global_duration!=-1)
                    animation.push(global_duration);
                animation_manager.addAnimation(target, prop, animation, callback);
            }
        }
        
        public function stop():void
        {
            if (_tween!=null)
                _tween.stop();
        }
        
        public function get moving():Boolean
        {
            if (_tween==null)
                return false;
            return _tween.moving;
        }
        
        
        public function onStartAnimation():void
        {
            // overload for component level notification...
        }
        
        public function onStopAnimation():void
        {
            // overload for component level notification...
        }
        
        
        // function delay helpers
        private var _timers:Object = {};
        protected function execute_later(id:String, f:Function, delay:uint, args:*=null, cancel_last:Boolean=false):void
        {
            var t:Timer = _timers[id];
            if (cancel_last)
                cancel_execute_late(id);
            if (t==null)
            {
                t = new Timer(delay,1);
                _timers[id] = t;
                t.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void
                {
                    _timers[id] = null;
                    if (args==null)
                        f();
                    else
                        f(args);
                });
                t.start();
            }
        }
        protected function cancel_execute_late(id:String):void
        {
            var t:Timer = _timers[id];
            if (t!=null)
                t.stop();
            _timers[id] = null;
        }
        
        protected function cancel_execute_laters():void
        {
            for (var p:String in _timers)
            {
                cancel_execute_late(p);
            }
        }
        
        
        // default mouse over handling
        protected var _over:Boolean;
        protected function add_mouse_over_default_behavior():void
        {
            if (hasEventListener(ComponentEvent.MOUSE_OVER))
                return;
            addEventListener(ComponentEvent.MOUSE_OVER, on_mouse_over);
            addEventListener(ComponentEvent.MOUSE_OUT, on_mouse_out);
        }
        
        protected function on_mouse_over(e:ComponentEvent):void
        {
            _over = true;
            render();
            if (_tooltip!=null)
                application.showToolTip(_tooltip,this);
        }
        
        protected function on_mouse_out(e:ComponentEvent):void
        {
            _over = false;
            render();
            if (_tooltip!=null)
                application.hideToolTip();
        }
        
        public function get over():Boolean
        {
            return _over;
        }
        
        public function set over(b:Boolean):void
        {
            _over = b;
        }
        
        
        // properties
        public function get x():Number
        {
            return _x.getValue();
        }
        public function get componentX():ComponentPoint
        {
            return _x;
        }
        
        public function set x(x:Number):void
        {
            _x.setAbsolute(x);
        }
        
        
        public function set xPercent(pw:Number):void
        {
            _x.setRelativeToParent(pw/100);
        }
        
        public function set xDelta(pw:Number):void
        {
            _x.setRelativeToParent(1,pw);
        }
        

        public function alignX(guide:int, offset:Number=0, dim_percent_offset:Number=Number.MAX_VALUE):void
        {
            _x.setAlign(guide,offset,dim_percent_offset,_parent.xGuides);
        }
        
        public function setXRelativeToParent(percent:Number,offset:Number=0,dim_percent_offset:Number=0):void
        {
            _x.setRelativeToParent(percent,offset,dim_percent_offset);
        }
        
        public function setXRelativeToSibling(sibling:Component,alignment:uint,offset:Number=0,dim_percent_offset:Number=Number.MAX_VALUE):void
        {
            _x.setRelativeToSibling(sibling,alignment,offset,dim_percent_offset);
        }
        
        public function set y(y:Number):void
        {
            _y.setAbsolute(y);
        }
        
        
        
        public function get y():Number
        {
            return _y.getValue();
        }
        
        public function set yPercent(pw:Number):void
        {
            _y.setRelativeToParent(pw/100);
        }
        
        public function set yDelta(pw:Number):void
        {
            _y.setRelativeToParent(1,pw);
        }
        

        public function alignY(guide:int, offset:Number=0, dim_percent_offset:Number=Number.MAX_VALUE):void
        {
            _y.setAlign(guide,offset,dim_percent_offset,_parent.yGuides);
        }
        
        public function setYRelativeToParent(percent:Number,offset:Number=0,dim_percent_offset:Number=0):void
        {
            _y.setRelativeToParent(percent,offset,dim_percent_offset);
        }
        
        public function setYRelativeToSibling(sibling:Component,alignment:uint,offset:Number=0,dim_percent_offset:Number=Number.MAX_VALUE):void
        {
            _y.setRelativeToSibling(sibling,alignment,offset,dim_percent_offset);
        }
        
        public function get componentY():ComponentPoint
        {
            return _y;
        }
        
        public function updatePosition(x0:Number,y0:Number):void
        {
            x = x0;
            y = y0;
            if (decorator!=null)
                decorator.updatePosition(x0,y0);
        }
        
        public function updateX(x0:Number):void
        {
            x = x0;
            if (decorator!=null)
                decorator.updateX(x0);
        }
        
        public function updateY(y0:Number):void
        {

            y = y0;
            if (decorator!=null)
                decorator.updateY(y0);
        }
        
        public function get width():Number
        {
            return _width.getValue();
        }
        
        public function get componentWidth():ComponentDimension
        {
            return _width;
        }
        
        public function get isWidthUnset():Boolean
        {
            return _width.isUnset;
        }
        
        public function widthUnset():void
        {
            _width.unset();
        }

        public function set width(w:Number):void
        {
            _width.setAbsolute(w);
        }
        
        public function set widthPercent(pw:Number):void
        {
            _width.setPercent(pw/100);
        }
        
        public function setWidthPercent(pw:Number,delta:Number=0):void
        {
            _width.setPercent(pw/100,delta);
        }
        
        public function set widthDelta(pw:Number):void
        {
            _width.setDelta(pw);
        }
        
        public function get height():Number
        {
            return _height.getValue();
        }
        
        public function get isHeightUnset():Boolean
        {
            return _height.isUnset;
        }
        
        public function heightUnset():void
        {
            _height.unset();
        }
        
        public function get componentHeight():ComponentDimension
        {
            return _height;
        }
        
        public function set height(h:Number):void
        {
            _height.setAbsolute(h);
        }
        
        public function set heightPercent(ph:Number):void
        {
            _height.setPercent(ph/100);
        }
        
        public function setHeightPercent(pw:Number,delta:Number=0):void
        {
            _height.setPercent(pw/100,delta);
        }
        
        public function set heightDelta(ph:Number):void
        {
            _height.setDelta(ph);
        }


        public function getRootPosition():Point
        {
            var p:Point = new Point(x,y);
            if (application.isTakeover(this))
                return p;
            
            var pp:Component = _parent;
            while (pp!=null)
            {
                p.x += pp.x;
                p.y += pp.y;
                if (application.isTakeover(pp))
                    return p;
                if (pp.decorator is ScrollingDecorator)
                {
                    var sdec:ScrollingDecorator = pp.decorator as ScrollingDecorator;
                    p.x -= sdec.getScrollHorizontal();
                    p.y -= sdec.getScrollVertical();
                }
                pp = pp._parent;
            }
        
            return p;
        }
        
        public function set id(s:String):void
        {
            _id = s;
        }
        
        public function get id():String
        {
            return _id;
        }

        //todo keep a stack of applied styles
        public function set styleName(s:String):void
        {
            _style_name = s;
            if (application!=null && application.style!=null)
                application.style.apply(this, application.style.getStyle(s));
        }
        
        public function get styleName():String
        {
            return _style_name;
        }
        
        
        private var _alpha:Number = 1;
        public function set alpha(a:Number):void
        {
            _alpha = a;
        }
        
        public function get alpha():Number
        {
            return _alpha;
        }
        
        public function alphaTo(a:Number,s:uint=400,on_complete:Function=null):void
        {
            move(["alpha",a,s],on_complete);
        }
        
        private var _blur:Number = 0;
        public function set blur(b:Number):void
        {
            if (_blur<0) 
                _blur = 0;
            _blur = b;
        }
        
        public function get blur():Number
        {
            return _blur;
        }
        
        private var _visible:Boolean = true;
        public function get visible():Boolean
        {
            return _visible;
        }
        
        public function set visible(b:Boolean):void
        {
            _visible = b;
        }
        
        private var _backgroundColor:uint = 0;
        public function set backgroundColor(c:uint):void
        {
            _backgroundColor = c;
        }
        
        public function get backgroundColor():uint
        {
            return _backgroundColor;
        }
        
        private var _backgroundVisible:Boolean = false;
        public function set backgroundVisible(b:Boolean):void
        {
            _backgroundVisible = b;
        }
        
        public function get backgroundVisible():Boolean
        {
            return _backgroundVisible;
        }
        
        private var _backgroundAlpha:Number = 1;
        public function set backgroundAlpha(a:Number):void
        {
            _backgroundAlpha = a;
        }
        
        public function get backgroundAlpha():Number
        {
            return _backgroundAlpha;
        }
        
        private var _backgroundBorderVisible:Boolean = false;
        public function set backgroundBorderVisible(b:Boolean):void
        {
            _backgroundBorderVisible = b;
        }
        
        public function get backgroundBorderVisible():Boolean
        {
            return _backgroundBorderVisible;
        }
        
        private var _backgroundBorderAlpha:Number = .5;
        public function set backgroundBorderAlpha(a:Number):void
        {
            _backgroundBorderAlpha = a;
        }
        
        public function get backgroundBorderAlpha():Number
        {
            return _backgroundBorderAlpha;
        }
        
        private var _backgroundBorderThickness:Number = 1;
        public function set backgroundBorderThickness(a:Number):void
        {
            _backgroundBorderThickness = a;
        }
        
        public function get backgroundBorderThickness():Number
        {
            return _backgroundBorderThickness;
        }
        
        private var _backgroundBorderColor:uint = 0;
        public function set backgroundBorderColor(c:uint):void
        {
            _backgroundBorderColor = c;
        }
        
        public function get backgroundBorderColor():uint
        {
            return _backgroundBorderColor;
        }
        
        private var _backgroundShadowSize:Number = 0;
        public function set backgroundShadowSize(s:Number):void
        {
            _backgroundShadowSize = s;
        }
        
        public function get backgroundShadowSize():Number
        {
            return _backgroundShadowSize;
        }
        
        private var _backgroundShadowStrength:Number = 2;
        public function set backgroundShadowStrength(s:Number):void
        {
            _backgroundShadowStrength = s;
        }
        
        public function get backgroundShadowStrength():Number
        {
            return _backgroundShadowStrength;
        }
        
        private var _backgroundShadowColor:Number = 0x000000;
        public function set backgroundShadowColor(s:Number):void
        {
            _backgroundShadowColor = s;
        }
        
        public function get backgroundShadowColor():Number
        {
            return _backgroundShadowColor;
        }
        
        private var _backgroundShadowDistance:Number = 0;
        public function set backgroundShadowDistance(s:Number):void
        {
            _backgroundShadowDistance = s;
        }
        
        public function get backgroundShadowDistance():Number
        {
            return _backgroundShadowDistance;
        }

        private var _cornerRadius:Number = 0;
        public function set cornerRadius(r:Number):void
        {
            _cornerRadius = r;
        }
        
        public function get cornerRadius():Number
        {
            return _cornerRadius;
        }       
        
        public function get focusable():Boolean
        {
            if (application.isTakeover(this))
                return false;
            return _focusable;
        }
        
        public function set focusable(b:Boolean):void
        {
            _focusable = b;
        }
        
//      public function get focusOrder():uint
//      {
//          return _focus_order;
//      }
//      
//      public function set focusOrder(i:uint):void
//      {
//          _focus_order = i;
//      }

        public function get tooltip():String
        {
            return _tooltip;
        }
        
        public function set tooltip(s:String):void
        {
            _tooltip = s;
            add_mouse_over_default_behavior();
        }

        public function getToolTipOffset():Point
        {
            return new Point(0,0)
        }
        
        public function set useButtonMode(b:Boolean):void
        {
            _use_button_mode = b;
        }
        
        public function get useButtonMode():Boolean
        {
            return _use_button_mode;
        }
        
        override public function toString():String
        {
            var idstring:String = "";
            if (_id!=null)
                idstring = " {"+_id+"}";
            return "["+getQualifiedClassName(this)+idstring+"]";
        }
        
        public function toStringIndented():String
        {
            var s:String = "";
            var p:Container = _parent;
            while(p!=null)
            {
                p = p._parent;
                s += "  ";
            }
            return s+toString();
        }
        
        private var _listeners:Array = [];
        override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
        {   
//          if (hasEventListener(type))
//              throw new Error("Component.addEventListener Error: Event type ["+type+"] already handled.");
            
            super.addEventListener(type,listener,useCapture,priority,useWeakReference);
            _listeners.push({type:type, listener:listener});

            update_decorator_listeners();
                
        }
        
        public function addEventListenerIfUnhandled(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
        {   
            if (hasEventListener(type))
                return;
            addEventListener(type,listener,useCapture,priority,useWeakReference);
        }
                
        public function addEventListeners(a:Array, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
        {   
            for (var i:uint=0; i<a.length; i++)
            {
                var type:String = a[i][0];
                var listener:Function = a[i][1];
                if (hasEventListener(type))
                    throw new Error("Component.addEventListener Error: Event type ["+type+"] already handled.");
                
                super.addEventListener(type,listener,useCapture,priority,useWeakReference);
                _listeners.push({type:type, listener:listener});
            }
            update_decorator_listeners();
                
        }
        
        public function removeAllEventListeners():void
        {
            for (var i:uint=0; i<_listeners.length; i++)
            {
                if(hasEventListener(_listeners[i].type))
                    super.removeEventListener(_listeners[i].type, _listeners[i].listener);
            }
            _listeners = [];
            update_decorator_listeners();
        }
        
        public function removeEventListenersByType(type:String):void
        {
            for (var i:uint=0; i<_listeners.length; i++)
            {
                if (_listeners[i].type==type)
                {
                    removeEventListener(_listeners[i].type, _listeners[i].listener);
                    i--;
                }
            }
            update_decorator_listeners();
        }
        
        override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
        {
            super.removeEventListener(type,listener,useCapture);
            for (var i:uint=0; i<_listeners.length; i++)
            {
                if (_listeners[i].type==type && _listeners[i].listener==listener)
                {
                    _listeners.splice(i,1);
                    break;
                }
            }
            update_decorator_listeners();
        }
        
        public function dispatchComponentEvent(type:String,component:Component=null,data:*=null):void
        {
            if (component==null)
                component = this;
            if (data==null)
                data = userObject;
            dispatchEvent(new ComponentEvent(type,component,data));
        }
         
        public function onBubbleEvent(e:ComponentEvent):void
        {
            dispatchEvent(e.clone());
        }
        
        public function translateEvent(e:String, data:*=null):Function
        {
            var event:String = e;
            var _this:Component = this;
            var _data:* = data;
            var f:Function = function():void
            {
                dispatchComponentEvent(event, _this, _data);
            }
            return f;
        }
        
        
        private function update_decorator_listeners():void
        {
            if (_decorator==null)
                return;
                
            if (hasEventListener(ComponentEvent.CLICK) || hasEventListener(ComponentEvent.DOUBLE_CLICK))
            {
                _decorator.buttonMode = (USE_BUTTON_MODE && _use_button_mode);
                if (!_decorator.hasEventListener(MouseEvent.CLICK))
                    _decorator.addEventListener(MouseEvent.CLICK, onClick); 
            }
            else
            {
                _decorator.buttonMode = false;
            }

            if (hasEventListener(ComponentEvent.MOUSE_OVER) )
                _decorator.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);

            if (hasEventListener(ComponentEvent.MOUSE_OUT) )
                _decorator.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

            if (hasEventListener(ComponentEvent.MOUSE_DOWN) )
                _decorator.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                    
            if (hasEventListener(ComponentEvent.MOUSE_MOVE) )
                _decorator.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveSimple);

            if (hasEventListener(ComponentEvent.DRAG))
            {
                _decorator.addEventListener(MouseEvent.MOUSE_DOWN, 
                    function(e:*):void { execute_later("drag", onStartMouseMove, _drag_delay, e)});
                _decorator.addEventListener(MouseEvent.MOUSE_UP, 
                    function(e:*):void { cancel_execute_late("drag"); });
            }

            if (hasEventListener(ComponentEvent.ROLL_OVER) )
                _decorator.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
            
            if (hasEventListener(ComponentEvent.ROLL_OUT) )
                _decorator.addEventListener(MouseEvent.ROLL_OUT, onRollOut);

        }
        
        
        public function clone():Component
        {
            var copier:ByteArray = new ByteArray();
            copier.writeObject(this);
            copier.position = 0;
            var o:Object = copier.readObject();
            return Component(copier.readObject());
        }
        
        private var _time_since_last_click:uint = 0;
        private var _mouse_x:Number = 0;
        private var _mouse_y:Number = 0;
        private var _drag_event:ComponentEvent;
        private var _drag_delay:uint = 0;
        private static var DOUBLE_CLICK_SPEED:uint = 700;
        protected function onClick(e:MouseEvent):void
        {
            _mouse_x = e.localX;
            _mouse_y = e.localY;
            if (focusManager!=null)
                focusManager.setFocus(this);
            if (hasEventListener(ComponentEvent.DOUBLE_CLICK) && flash.utils.getTimer()-_time_since_last_click < DOUBLE_CLICK_SPEED)
                dispatchComponentEvent(ComponentEvent.DOUBLE_CLICK);
            else
                dispatchComponentEvent(ComponentEvent.CLICK);
            _time_since_last_click = flash.utils.getTimer();
        }
        
        public function get mouseX():Number
        {
            return _mouse_x;
        }

        public function get mouseY():Number
        {
            return _mouse_y;
        }

        protected function onMouseOver(e:MouseEvent):void
        {
            dispatchComponentEvent(ComponentEvent.MOUSE_OVER, this, e);
        }
        
        protected function onMouseOut(e:MouseEvent):void
        {
            dispatchComponentEvent(ComponentEvent.MOUSE_OUT);
        }
        
        protected function onRollOver(e:MouseEvent):void
        {
            dispatchComponentEvent(ComponentEvent.ROLL_OVER);
        }
        
        protected function onRollOut(e:MouseEvent):void
        {
            dispatchComponentEvent(ComponentEvent.ROLL_OUT);
        }
        
        protected function onMouseDown(e:MouseEvent):void
        {
            dispatchComponentEvent(ComponentEvent.MOUSE_DOWN);
        }
        
        public function set dragDelay(d:uint):void
        {
            _drag_delay = d;
        }
        
        public function get dragDelay():uint
        {
            return _drag_delay;
        }
        
        protected function onMouseMoveSimple(e:MouseEvent):void
        {
            var dx:Number = e.stageX - _mouse_x;
            var dy:Number = e.stageY - _mouse_y;
            _mouse_x = e.stageX;
            _mouse_y = e.stageY;
            var lx:Number = _mouse_x - this.getRootPosition().x;
            var ly:Number = _mouse_y - this.getRootPosition().y;
            
            dispatchComponentEvent(ComponentEvent.MOUSE_MOVE, this, {x:_mouse_x, y:_mouse_y, dx: dx, dy: dy,lx: lx, ly:ly});
        }
        
        protected function onStartMouseMove(e:MouseEvent):void
        {
            _application.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            _application.stage.addEventListener(MouseEvent.MOUSE_UP, onStopMouseMove);
            //_application.addEventListener(MouseEvent.MOUSE_OUT, onStopMouseMove);

            _mouse_x = e.stageX;
            _mouse_y = e.stageY;
            dispatchComponentEvent(ComponentEvent.DRAG_START, this, {x:_mouse_x, y:_mouse_y, dx: 0, dy: 0});
            _drag_event = new ComponentEvent(ComponentEvent.DRAG, this, {x:_mouse_x, y:_mouse_y, dx: 0, dy: 0});
            dispatchEvent(_drag_event);
        }
        
        protected function onMouseMove(e:MouseEvent):void
        {
            var dx:Number = e.stageX - _mouse_x;
            var dy:Number = e.stageY - _mouse_y;
            _mouse_x = e.stageX;
            _mouse_y = e.stageY;
            _drag_event.data.x = _mouse_x;
            _drag_event.data.y = _mouse_y;
            _drag_event.data.dx = dx;
            _drag_event.data.dy = dy;
            dispatchEvent(_drag_event);
        }
        
        protected function onStopMouseMove(e:MouseEvent):void
        {
            _application.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            _application.stage.removeEventListener(MouseEvent.MOUSE_UP, onStopMouseMove);
            //_application.removeEventListener(MouseEvent.MOUSE_OUT, onStopMouseMove);
            dispatchComponentEvent(ComponentEvent.DRAG_STOP, this);
        }

        
        /// drag & drop
        public function addDropTarget(t:Component):void
        {
            decorator.setDragComponent(this);
            decorator.addDropComponent(t);;
        }
        
        public function setDropTargets(a:Array):void
        {
            decorator.setDragComponent(this);
            decorator.dropTargets = a;
        }
        
        public function removeDropTarget(t:Component):void
        {
            decorator.removeDropComponent(t);
        }
        
        public function removeDropTargets():void
        {
            decorator.dropTargets = new Array();
        }
        
        public function onDragStart(c:Component):void
        {
            dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_START, this));
        }
        
        public function onDragOver(c:Component,x:Number,y:Number):void
        {
            dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_OVER, this, c, x, y));
        }
        
        public function onDragExit(c:Component):void
        {
            dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_EXIT, this, c));
        }
        
        public function onDrop(c:Component,x:Number,y:Number):void
        {
            dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DROP, this, c, x, y));
        }
        
        public function onDragEnd(x:Number,y:Number):void
        {
            dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_END, this, this, x, y));
        }

    
        public function onFocus(e:FocusEvent):void
        {
            //Logger.log("FOCUS EVENT "+this+" "+userObject+" focused="+e.type);
        }
        

    }
}
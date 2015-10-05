package com.pagesociety.ux.decorator
{
    import flash.display.Sprite;
    
    public class RootDecorator extends ContainerDecorator
    {
        
        private var _network_indicator:Sprite;
        private var _cursor:Sprite;
        
        public var windowSize:Object;
        public var scrollOffset:Object;

        public function RootDecorator()
        {
            super();
        }
        
        override public function initGraphics():void
        {
            super.initGraphics();
            
            _network_indicator = new Sprite();
            addChild(_network_indicator);
            
            _cursor = new Sprite();
            addChild(_cursor);
        }
        
        public function get cursor():Sprite
        {
            return _cursor;
        }
        
        
        
        
    }
}
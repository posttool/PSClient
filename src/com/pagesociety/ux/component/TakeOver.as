package com.pagesociety.ux.component
{
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.geom.Point;
    
    public class TakeOver extends Container
    {
        private var _gauze:Component;
        private var _c:Component;
        private var _center:Boolean;
        private var _init_root_pos:Point;
        private var _align_to:Component;
        private var _alignment_offset:Point;
        private var _cwidth:Number;
        public function TakeOver(parent:Container,c:Component,callback:Function,color:uint,alpha:Number,center:Boolean,align_relative_to:Component=null,offset:Point=null)
        {
            super(parent);
            _center = center;
            _gauze = new Component(this);
            _gauze.backgroundVisible = true;
            _gauze.backgroundColor = color;
            _gauze.backgroundAlpha = alpha;
            _gauze.addEventListener(ComponentEvent.CLICK,callback);
            _c = c;
//          _c.render();
            _init_root_pos = _c.getRootPosition();
            _align_to = align_relative_to;
            _alignment_offset = offset;
            _cwidth = _c.width;
            _c.setParent(this);
            _c.visible = true;
            _c.alpha = 1;
        }
        
        public function get component():Component
        {
            return _c;
        }
        
        override public function render():void
        {
            var cx:Number, cy:Number;
            if (_center)
            {
                if (application.windowSize!=null && application.scrollOffset!=null)
                {
                    cx = (application.windowSize.width - _c.width  )/2  + application.scrollOffset.xOffset;
                    cy = (application.windowSize.height - _c.height)/2  + application.scrollOffset.yOffset;
                }
                else
                {
                    cx = (application.width - _c.width)/2 ;
                    cy = (application.height - _c.height)/2 ;
                }
                _c.x = cx;
                _c.y = cy;
                _c.render();
            }
            else 
            {
                if (_align_to==null)
                {
                    cx = _init_root_pos.x;
                    cy = _init_root_pos.y;
                }
                else
                {
                    var p:Point = _align_to.getRootPosition();
                    cx = p.x;
                    cy = p.y;
                }
                if (_alignment_offset!=null)
                {
                    cx += _alignment_offset.x;
                    cy += _alignment_offset.y;
                    
                }
                _c.x = cx;
                _c.y = cy;
                _c.width = _cwidth;
                _c.render();
            }
            super.render();
        }
    }
}
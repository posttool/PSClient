package com.pagesociety.ux.component.button
{
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.decorator.ShapeFactory;
    
    import flash.display.Graphics;
    
    public class DeleteButton extends SmallCircleButton
    {
        public var xoverColor:uint = 0xffffff;
        public var xnormalColor:uint = 0x000000;
        public var xThickness:uint = 1;
        public var xoffset:uint = 5;
        public var xsize:uint = 5;

        public function DeleteButton(parent:Container)
        {
            super(parent);
        }
        
        override public function render():void
        {
            var g:Graphics = decorator.midground.graphics;
            g.clear();
            draw_circle(g);
            ShapeFactory.x(g, xoffset, xoffset, xsize, _over ? xoverColor : xnormalColor, 1, xThickness);
            super.render();
        }
        
    }
}
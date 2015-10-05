package com.pagesociety.ux.component.button
{
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.decorator.ShapeFactory;
    
    import flash.display.Graphics;
    
    public class ForwardButton extends SmallCircleButton
    {
        public function ForwardButton(parent:Container)
        {
            super(parent);
        }
        
        override public function render():void
        {
            var g:Graphics = decorator.midground.graphics;
            g.clear();
            draw_circle(g);
            ShapeFactory.chevron_right(g,5,5,2.5,5,5, _over ? 0xffffff : 0,1);
            super.render();
        }
        

    }
}
package com.pagesociety.ux.component.button
{
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    
    import flash.display.Graphics;
    
    public class GraphicLink extends Component
    {
        private var _normal:Function;
        private var _overf:Function;
        public function GraphicLink(parent:Container, normal:Function, over:Function)
        {
            super(parent);
            _normal = normal;
            _overf = over;
            backgroundVisible = true;
            backgroundAlpha = 1;
            backgroundColor = 0xffffff;
            add_mouse_over_default_behavior();
        }
        override public function render():void
        {
            var g:Graphics = decorator.midground.graphics;
            g.clear();
            if (over)
                _overf(g);
            else
                _normal(g);
            super.render();
        }
    }
}
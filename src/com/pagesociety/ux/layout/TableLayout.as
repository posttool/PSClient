package com.pagesociety.ux.layout
{
    import com.pagesociety.ux.Margin;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;

    public class TableLayout implements Layout
    {
        private var _columns:uint = 0;
        private var _column_widths:Array;
        private var _row_height:Number = 22;
        private var _x:Number = 0;
        private var _y:Number = 0;
        private var _margin:Margin;
        private var _container:Container;
        
        public function TableLayout()
        {
            _column_widths = new Array(20);
            _margin = new Margin(0,0,0,0);
        }
        
        public function set columns(n:uint):void
        {
            _columns = n;
        }
        
        public function get columns():uint
        {
            return _columns;
        }
        
        public function set rowHeight(n:uint):void
        {
            _row_height = n;
        }
        
        public function get rowHeight():uint
        {
            return _row_height;
        }
        
        public function get columnWidths():Array
        {
            return _column_widths;
        }
        

        public function get container():Container
        {
            return _container;
        }
        
        public function set container(c:Container):void
        {
            _container = c;
        }
        
        public function get margin():Margin
        {
            return _margin;
        }
        
        public function get x():Number
        {
            return _x;
        }
        
        public function get y():Number
        {
            return _y;
        }
        
        public function layout():void
        {
            var c:uint=0;
            var s:uint=_container.children.length;
            while (c<s)
            {
                _x=0;
                _y=Math.floor(c/_columns)*_row_height;
                for (var i:uint=0; i<_columns && c<s; i++)
                {
                    var p:Component = _container.children[c];
                    p.updatePosition(_x,_y);
                    if (_column_widths[i]!=null)
                        _x+=_column_widths[i];
                    else
                        _x+=p.width;
                    c++;
                }
            }
        }
        
        public function calculateHeight():Number
        {
            return Math.ceil(_container.children.length/_columns)*_row_height;
        }
        
        public function calculateWidth():Number
        {
            return _container.width;
        }
        
        public function calculateIndex(x:Number, y:Number):uint
        {
            return 0;
        }
        
        public function calculateWidthForUnset():Number
        {
            var w:Number=0;
            var c:Number=_columns;
            for (var i:uint=0; i<_columns; i++)
            {
                if (_column_widths[i]!=null)
                {
                    w+=_column_widths[i];
                    c--;
                }
            }
            return (_container.width-w)/c;
        }
        
        public function calculateHeightForUnset():Number
        {
            return _row_height;
        }
        
    }
}
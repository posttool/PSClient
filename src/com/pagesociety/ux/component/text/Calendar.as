package com.pagesociety.ux.component.text
{
    import com.pagesociety.util.StringUtil;
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.button.BackButton;
    import com.pagesociety.ux.component.button.DotButton;
    import com.pagesociety.ux.component.button.ForwardButton;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.layout.FlowLayout;
    
    public class Calendar extends Container implements IEditor
    {
        
        public var selectedBackgroundColor:uint = 0xff6600;
        public var normalBackgroundColor:uint = 0xffffff;
        public var todayBackgroundColor:uint = 0x999999;
        public var rollOverBackgroundColor:uint = 0xdddddd;
        
        public static const MONTHS:Array = [ 
            "January", "February", "March", "April", "May", "June", 
            "July", "August", "September", "October", "November", "December" 
        ];
        
        private var _ui:Container;
        private var _back:BackButton;
        private var _today:DotButton;
        private var _forward:ForwardButton;

        private var _month:Label;
        private var _numbers:Container;
        
        private var _calendar_date:Date;
        private var _selected_date:Date;
        private var _today_date:Date;
        
        private var _dirty:Boolean;
        
        public function Calendar(p:Container,i:int=-1)
        {
            super(p,i);
            
            _ui = new Container(this);
            _ui.layout = new FlowLayout(FlowLayout.RIGHT_TO_LEFT);
            _ui.y = 3;
            
            _forward = new ForwardButton(_ui);
            _forward.addEventListener(ComponentEvent.CLICK, on_click_forward);
            _today = new DotButton(_ui);
            _today.addEventListener(ComponentEvent.CLICK, on_click_today);
            _back = new BackButton(_ui);
            _back.addEventListener(ComponentEvent.CLICK, on_click_back);
            
            _month = new Label(this);
            _month.y = 0;
            _numbers = new Container(this);
            _numbers.y = 20;
            
            height = CH*6+15;
        }
        
        public function set value(o:Object):void
        {
            if (o != null && !(o is Date))
                throw new Error("Calendar.set value requires type Date");
                
            _dirty = false;
            if (o == null)
                _selected_date = new Date();
            else
                _selected_date = o as Date;

            if (_calendar_date!=null)
                reset(_calendar_date.month, _calendar_date.fullYear);
            else
                reset(_selected_date.month, _selected_date.fullYear);
        }
        
        public function get value():Object
        {
            return _selected_date;
        }
        
        public function get dirty():Boolean
        {
            return _dirty;
        }
        
        public function set dirty(b:Boolean):void
        {
             _dirty = b;
        }
        
        private var CW:Number = 22;
        private var CH:Number = 22;
        public function reset(month:uint, year:uint):void
        {
            _today_date             = new Date();
            _calendar_date          = new Date(year,month,1)
            //
            _month.text             = MONTHS[month]+" "+year;
            _numbers.clear();
            var offset:uint     = _calendar_date.getDay();
            var dim:uint        = daysInMonth(month,year);
            var cy:Number = 0;
            for (var i:uint=0; i<dim; i++)
            {
                var dl:Label = new Label(_numbers);
                dl.fontStyle = "black_small";
                dl.userObject = i+1;
                dl.text = (i+1).toString()
                dl.x = offset*CW;
                dl.y = cy;
                dl.align = Label.ALIGN_RIGHT;
                dl.width = CW;
                dl.height = CH;
                dl.backgroundVisible = true;
                dl.backgroundBorderVisible = true;
                out_cell(dl);
                dl.addEventListener(ComponentEvent.MOUSE_OVER, on_over_cell);
                dl.addEventListener(ComponentEvent.MOUSE_OUT, on_out_cell);
                dl.addEventListener(ComponentEvent.CLICK, on_click_cell);
                offset++;
                if (offset>6)
                {
                    offset = 0;
                    cy += CH;
                }
            }
        }
        
        private function over_cell(l:Label):void
        {
            var d:int = l.userObject;
            if (_calendar_date.fullYear == _selected_date.fullYear 
                    && _calendar_date.month == _selected_date.month 
                    && d == _selected_date.date)
                l.backgroundColor = selectedBackgroundColor;
            else
                l.backgroundColor = rollOverBackgroundColor;
        }
        

            
        private function out_cell(l:Label):void
        {
            var d:int = l.userObject;
            if (_calendar_date.fullYear == _selected_date.fullYear 
                    && _calendar_date.month == _selected_date.month 
                    && d == _selected_date.date)
                l.backgroundColor = selectedBackgroundColor;
            else if (_calendar_date.fullYear == _today_date.fullYear 
                    && _calendar_date.month == _today_date.month 
                    && d == _today_date.date)
                l.backgroundColor = todayBackgroundColor;
            else
                l.backgroundColor = normalBackgroundColor;
        }
        
        private function select_cell(l:Label):void
        {
            var d:int = l.userObject;
            value = new Date(_calendar_date.fullYear, _calendar_date.month, d, 
                _selected_date.hours, _selected_date.minutes, _selected_date.seconds, 
                _selected_date.milliseconds);
        }
        
        public function daysInMonth(month:uint, year:uint):uint
        {
            return 32 - new Date(year, month, 32).getDate();
        }
        
        override public function render():void
        {
            width = CW*7;
            super.render();
        }
        
        private function on_click_back(e:ComponentEvent):void
        {
            var m:int = _calendar_date.month-1;
            var y:int = _calendar_date.fullYear;
            if (m<0)
            {
                m=11;
                y--;
            }
            reset(m,y);
            render();
        }

        private function on_click_forward(e:ComponentEvent):void
        {
            var m:int = _calendar_date.month+1;
            var y:int = _calendar_date.fullYear;
            if (m>11)
            {
                m=0;
                y++;
            }
            reset(m,y);
            render();
        }
        
        private function on_click_today(e:ComponentEvent):void
        {
            var m:int = _today_date.month;
            var y:int = _today_date.fullYear;
            reset(m,y);
            render();
        }
        
        private function on_over_cell(e:ComponentEvent):void
        {
            var l:Label = e.component as Label;
            over_cell(l);
            render();
        }
        
        private function on_out_cell(e:ComponentEvent):void
        {
            var l:Label = e.component as Label;
            out_cell(l);
            render();
        }
        
        private function on_click_cell(e:ComponentEvent):void
        {
            var l:Label = e.component as Label;
            select_cell(l);
            render();
            _dirty = true;
            dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, value);
        }
        
        

    }
}
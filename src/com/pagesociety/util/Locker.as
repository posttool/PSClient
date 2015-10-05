package com.pagesociety.util
{
    public class Locker
    {

        private var _func:Function;
        private var _locked:Boolean;
        
        public function Locker(locked:Boolean=false)
        {
            _locked = locked;
        }
        
        public function lock():void
        {
            if (_locked)
                return;
                
            _locked = true;
        }
        
        public function unlock():void
        {
            if (!_locked)
                return;

            if (_func!=null)
            {
                _func();
                _func = null;
            }
            _locked = false; 
        }
        
        public function wait(func:Function):void
        {
            if (!_locked)
            {
                func();
                return;
            }
            _func = func;
        }
        
        

    }
}
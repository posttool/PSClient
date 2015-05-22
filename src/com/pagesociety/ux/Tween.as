package com.pagesociety.ux
{
	import com.pagesociety.ux.component.Component;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import gs.easing.Quart;

	public class Tween
	{
		private var _easing_function:Function;
		private var _duration:Number;
		private var _moving:Boolean;
		private var _completed:Boolean;
		private var _init:Number;
		private var _dest:Number;
		private var _do_update:Function;
		private var _do_complete:Function;
		private var _start_time:Number;
		private var _moving_vals:Array;
		private var _component:Component;
	
		private static var INTERVAL:Number = 40;
		private var _timer:Timer;

		public function Tween(init:Number=0, easingFunction:Function=null) 
		{
			reset(init, easingFunction);
		}
		
		
		
		public function tween(a:Array,duration:uint,callback:Function,complete:Function=null):void
		{
			_moving_vals = a;
			setCallback(callback,complete);
			reset(0);
			goto(1, duration);
		}

		public function render(c:Component,a:Array,duration:uint, on_complete:Function=null):void
		{
			reset(0);
			_moving = false;
			_do_complete = on_complete;
			_moving_vals = a;
			_component = c;
			goto(1, duration);
		}

		public function setCallback(on_update:Function, on_complete:Function=null):void  
		{
			_do_update = on_update;
			_do_complete = on_complete;
		}
	
		public function stop():void  
		{
			_moving = false;
			_timer.stop();
		}
		
		public function get moving():Boolean
		{
			return _moving;
		}
	
		public function reset(init:Number, easingFunction:Function=null):void {
			this._init = init;
			this._easing_function = easingFunction == null ?
				(this._easing_function == null ? Quart.easeOut : this._easing_function) : easingFunction;
			this._moving = false;
		}
	
		public function goto(x:Number, milliseconds:Number):void {
			if (_moving) 
				this._init = getX();
			if (_component != null)
				_component.onStartAnimation();
				
			this._dest = x;
			this._duration = milliseconds;
			this._start_time = getTimer();
			this._moving = true;
			this._completed = false;
			if (_timer == null) {
				_timer = new Timer(INTERVAL);
				_timer.addEventListener(TimerEvent.TIMER, updateX);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timer_complete);
			}
			_timer.start();
		}
	
		private function updateX(e:TimerEvent):void {
			var x:Number = getX();
			if (_moving_vals!=null)
			{
				for (var i:uint=0; i<_moving_vals.length; i++)
					_moving_vals[i].percentComplete = x;
			}
			if (_component!=null)
				_component.render();
			else
				_do_update(x);
			var time:Number = getTimer() - _start_time;
			if (time>=_duration)
			{
				_timer.stop();
				if (_component!=null)
					_component.onStopAnimation();
			}
		}
		
		private function timer_complete(e:TimerEvent):void
		{
			trace("TIMER COMPLETE");
		}
	
		private function getX():Number {
			var time:Number = getTimer() - _start_time;
			if (time >= _duration && !_completed) {
				if (_do_complete!=null)
					_do_complete();
				_completed = true;
			}
			if (time >= _duration) {
				this._moving = false;
				this._init = _easing_function(_duration,_init,_dest-_init,_duration);
				return this._init;
			}
			return _easing_function(time,_init,_dest-_init,_duration);
		}
		
		public function destroy():void
		{
			if(_timer!=null)
			{
				_timer.stop();
				_timer.addEventListener(TimerEvent.TIMER, updateX);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timer_complete);
			}
		}

	}
	

}
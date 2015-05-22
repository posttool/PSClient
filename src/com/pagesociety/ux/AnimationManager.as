package com.pagesociety.ux
{
	import com.pagesociety.ux.component.Component;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import gs.easing.Quart;

	public class AnimationManager //extends EventDispatcher
	{
		private static var INSTANCE:AnimationManager = new AnimationManager();
		public static function getInstance():AnimationManager { return INSTANCE; }
		
		private var animated_components:Dictionary;
		private var timer:Timer;
		
		public function AnimationManager()
		{
			animated_components = new Dictionary();
			timer = new Timer(50);
			timer.addEventListener(TimerEvent.TIMER, on_tick);
		}
		
		public function addAnimation(c:Component, prop:String, args:Array, on_complete:Function):void
		{
			if (animated_components[c]==null)
				animated_components[c] = 
					{ 
						component: c,
						easing_function: Quart.easeOut, 
						props: {}
					};
			var a:Object = animated_components[c];
				a.props[prop] = 
					{ 
						time: getTimer(), 
						init_val: c[prop], 
						args: args, 
						args_offset: 0

					};
				a.on_complete_function = on_complete;
				start_tick();
		}
		
		private function start_tick():void
		{
			timer.start();
		}
		
//		var t:int = 0;
		private function on_tick(e:*):void
		{
			var now:int = getTimer();
//			trace("!!!"+(now-t));
//			t = now;
			var all_complete:Boolean = true;
			for each (var a:Object in animated_components) 
			{
				if (a==null)
					continue;
				var c:Component = a.component;
				var easing_function:Function = a.easing_function;
				var complete:Boolean = true;
				for (var p:String in a.props)
				{
					var anim:Object = a.props[p];
					if (anim==null)
						continue;
					//var currentv:Number = c[p];
					var initv:Number = anim.init_val;
					var destv:Number = anim.args[anim.args_offset];
					if (isNaN(destv))
						continue;
					var d:Number = destv-initv
					var timed:int = now - anim.time;
					var duration:int = anim.args[anim.args_offset+1];
					var nv:Number = easing_function(timed<duration?timed:duration,initv,d,duration);
					c[p] = nv;
					if (timed>duration)
					{
						anim.args_offset +=2;
						if (anim.args_offset==anim.args.length)
						{
							a.props[p] = null;
							//dispatchEvent(new ComponentEvent("PROPERTY_COMPLETE", c, p));
							continue;
						}
					}
					complete = false;
					all_complete = false;
				}
				c.render();
				if (complete)
				{
					if (a.on_complete_function!=null)
						a.on_complete_function();
					animated_components[c] = null;
					//dispatchEvent(new ComponentEvent("COMPLETE", c));
				}
			}
			if (all_complete)
			{
				timer.stop();
			}
		}
	}
}
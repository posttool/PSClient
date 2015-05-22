package com.pagesociety.ux.decorator
{
	import com.google.maps.controls.ControlBase;
	import com.google.maps.controls.ControlPosition;
	import com.google.maps.interfaces.IMap;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MapDecoratorControlA extends ControlBase
	{
		public function MapDecoratorControlA()
		{
			super(new ControlPosition(ControlPosition.ANCHOR_TOP_LEFT, 7, 7));
		}
		  
		public override function initControlWithMap(map:IMap):void 
		{
			createButton("ZOOM IN", 0, 0, function(event:Event):void { map.zoomIn(); });
			createButton("ZOOM OUT", 0, 20, function(event:Event):void { map.zoomOut(); });
		}
		
		private function createButton(text:String,x:Number,y:Number,callback:Function):void 
		{
			var button:Sprite = new Sprite();
			button.x = x;
			button.y = y;
			
			var label:Text = new Text();
			label.text = text;
			label.x = 2;
			label.selectable = false;
			label.setTextFormat(TextFormats.BLACK_LABEL);
			  
			var buttonWidth:Number = 100;
			var background:Shape = new Shape();
			background.graphics.beginFill(0xFFFFFF, 0);
			background.graphics.drawRoundRect(0, 0, buttonWidth, 16, 4);
			
			button.addChild(background);
			button.addChild(label);
			button.addEventListener(MouseEvent.CLICK, callback);
			
			addChild(button);
		}

	}
}
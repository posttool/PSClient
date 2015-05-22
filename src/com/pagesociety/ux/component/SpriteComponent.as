package com.pagesociety.ux.component
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	public class SpriteComponent extends Component
	{
		private var _sprite:Sprite;
		public function SpriteComponent(parent:Container, s:Sprite)
		{
			super(parent);
			sprite = s;
		}
		
		public function get sprite():Sprite
		{
			return _sprite;
		}
		
		public function set sprite(s:Sprite):void
		{
			if (_sprite!=null)
				decorator.removeChild(_sprite);
				
			if (s!=null)
			{
				_sprite = s;
				decorator.addChild(_sprite);
			}
		}
		
		public function get movieClip():MovieClip
		{
			return _sprite as MovieClip;
		}
		
		public function set color(c:uint):void
		{
			var color:ColorTransform = new ColorTransform();
			color.color = c;
			_sprite.transform.colorTransform = color;
		}
		
		override public function get height():Number
		{
			if (isHeightUnset)
				return _sprite.height*_sprite.scaleY;
			else
				return super.height;
		}
		
		override public function get width():Number
		{
			if (isWidthUnset)
				return _sprite.width*_sprite.scaleX;
			else
				return super.width;
		}
		
	}
}
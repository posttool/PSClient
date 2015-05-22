package com.pagesociety.ux.component
{
	import com.google.maps.LatLng;
	import com.pagesociety.ux.decorator.MapDecorator;
	
	public class Map extends Component
	{
		private var _zoom:int = 3;
		private var _center:LatLng = new LatLng(37,-122);  
		public function Map(parent:Container,index:int=-1)
		{
			super(parent,index);
			decorator = new MapDecorator();
		}
		
		public function get mapDecorator():MapDecorator
		{
			return decorator as MapDecorator;
		}
		
		public function set zoom(z:int):void
		{
			_zoom = z;
		}
		
		public function get zoom():int
		{
			return _zoom;
		}
		
		public function set center(l:LatLng):void
		{
			_center = l;
		}
		
		public function get center():LatLng
		{
			return _center;
		}
		
		override public function render():void
		{
			mapDecorator.zoom = _zoom;
			mapDecorator.center = _center;
			super.render();
		}

		public function get gmap():com.google.maps.Map
		{
			return mapDecorator.map;
		}
	}
}
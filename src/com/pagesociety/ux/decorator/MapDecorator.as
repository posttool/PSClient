package com.pagesociety.ux.decorator
{
	import com.google.maps.Alpha;
	import com.google.maps.Color;
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapAction;
	import com.google.maps.MapEvent;
	import com.google.maps.MapOptions;
	import com.google.maps.MapType;
	import com.pagesociety.web.ModuleRequest;
	
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	public class MapDecorator extends Decorator
	{
		
		public static var GOOGLE_MAP_API_KEY:Object = { 
			"http://posttool.com/"			: "ABQIAAAAfE-nqRoCvvMnlRrb0x9p-hRqWG7SgMEQqb4BAN0b3gKk1pUK3RQr_I-ceroA7M5fSeGhoFHUId9QTQ",
			"http://66.121.135.58/"			: "ABQIAAAAfE-nqRoCvvMnlRrb0x9p-hRqnbCFxZcGnXZ0qvooAoAu67y2QxQLX9o8PF__yCGw7DBAv6gEeb2-nA",
			"http://72.14.182.162/"			: "ABQIAAAAfE-nqRoCvvMnlRrb0x9p-hSGYjb09VZyxjlIvLQEYzgbOAOJpBSSXUR320hdWgNrb94JU7833RW3PQ",
			"http://67.18.208.225/"			: "ABQIAAAAfE-nqRoCvvMnlRrb0x9p-hTiHGc18DWvba48TmFRKPTN744CNBSunndkGIWsqx5crTWiRXc10wXEfQ",
			"http://digabo.com/"			: "ABQIAAAAfE-nqRoCvvMnlRrb0x9p-hQcHbUoWN3bw79zM7cdOW8xn8FPNRR8LKF3Ld4lSv_rqNVvVq4e1Zxk9A",
			"http://postera.com/Digabo/"	: "ABQIAAAAfE-nqRoCvvMnlRrb0x9p-hQX85bsoU0Ysmcu7KPEk-NpA2zSnRSk_ua8jfMgMgT24Zb4W3q7zRDS9Q"
		};
		private var _map:Map;
		private var _zoom:int;
		private var _center:LatLng;
		public function MapDecorator()
		{
			super();
			shadowSize = 3;
		}
		
		override public function initGraphics():void
		{
			super.initGraphics();
			var key:String = GOOGLE_MAP_API_KEY[ModuleRequest.SERVICE_URL];
			if (key==null) 
			{
				Logger.error("Map could not find api key for "+ModuleRequest.SERVICE_URL);
				key = GOOGLE_MAP_API_KEY["http://66.121.135.58/"];
			}
			_map = new Map();
		    _map.key = key;
		    _map.addEventListener(MapEvent.MAP_READY, on_map_ready);
		    _map.addEventListener(MapEvent.MAP_PREINITIALIZE, on_map_pre_init);
			midground.addChild(_map);

			var grayscale_matrix:Array = [0.3, 0.59, 0.11, 0, 0,
	            0.3, 0.59, 0.11, 0, 0,
	            0.3, 0.59, 0.11, 0, 0,
	            0, 0, 0, 1, 0];
		    var grayscale_filter:ColorMatrixFilter = new ColorMatrixFilter(grayscale_matrix);
		    midground.filters = [grayscale_filter];
		}
		
		private function on_map_pre_init(e:MapEvent):void
		{
			var options:MapOptions = new MapOptions({
			  backgroundFillStyle: {
			    alpha: Alpha.OPAQUE,
			    color: Color.GRAY14
			  },
			  crosshairs: false,
			  crosshairsStrokeStyle: {
			    thickness: 1,
			    color: Color.BLACK,
			    alpha: 1,
			    pixelHinting: false
			  },
			  controlByKeyboard: false,
			  overlayRaising: true,
			  doubleClickMode: MapAction.ACTION_PAN_ZOOM_IN,
			  dragging: true,
			  continuousZoom: true,
			  mapType: MapType.PHYSICAL_MAP_TYPE,
			  mapTypes: null,
			  center: new LatLng(0, 0),
			  zoom: 1,
			  mouseClickRange: 2
			});
			_map.setInitOptions(options);
		}
		
		private function on_map_ready(e:MapEvent):void 
		{
			_map.setSize(new Point(width,height));
			_map.disableDragging();
			_map.disableControlByKeyboard();
			_map.disableScrollWheelZoom();
			decorate();
		}
		
		private var _dz:Boolean = false;
		override public function decorate():void
		{
		   super.decorate();
			if (!_map.isLoaded())
				return;
			if (!_dz)
				return;
			if (_center!=null)
				_map.setCenter(_center, _zoom);
		   _dz = false;
		}
		
		public function get map():Map
		{
			return _map;
		}
		
		public function set zoom(z:int):void
		{
			if (z==_zoom)
				return;
			_dz = true;
			_zoom = z;
		}
  
		public function set center(l:LatLng):void
		{
			if (_center != null && _center.equals(l))
				return;
			_dz = true;
			_center = l;
		}
		
		


	}	
}
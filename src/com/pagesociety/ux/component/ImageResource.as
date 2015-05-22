package com.pagesociety.ux.component
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.util.ObjectUtil;
	import com.pagesociety.ux.event.ResourceEvent;
	import com.pagesociety.web.PathProvider;
	import com.pagesociety.web.ResourceUtil;
	import com.pagesociety.web.module.Resource;
	
	[Event(type="com.pagesociety.ux.event.ResourceEvent",name="load_resource")]
	[Event(type="com.pagesociety.ux.event.ResourceEvent",name="load_error")]
	public class ImageResource extends Image
	{
		public static const DEFAULT_JPEG_QUALITY:uint = 78;
		private var _resource:Entity;
		private var _preview_width:Number=-1;
		private var _preview_height:Number=-1;
		private var _jpeg_quality:uint=DEFAULT_JPEG_QUALITY;
		private var _file_type:String;
		private var _cant_load_src:String;
		private var _tried_server:Boolean;
		
		public var nonImageCellRenderer:Function;

		public function ImageResource(parent:Container,index:int=-1)
		{
			super(parent,index);
		}
		
		public function get resource():Entity
		{
			return _resource;
		}
		
		public function load():void
		{
			imageDecorator.load();
		}
		
		public function set previewWidth(w:Number):void
		{
			_preview_width = w;
		}
		
		public function get previewWidth():Number
		{
			return _preview_width;
		}
		
		public function set previewHeight(h:Number):void
		{
			_preview_height = h;
		}
		
		public function get previewHeight():Number
		{
			return _preview_height;
		}
		
		public function set jpegQuality(q:Number):void
		{
			_jpeg_quality = q;
		}
		
		public function get jpegQuality():Number
		{
			return _jpeg_quality;
		}
		
		public function set fileType(ext:String):void
		{
			_file_type = ext;
		}
		
		public function get fileType():String
		{
			return _file_type;
		}
		
		public function set resource(resource:Entity):void
		{
			setResource(resource,true);
		}
		
		public function setResource(resource:Entity,do_render:Boolean):void
		{
			_resource = resource;
			
			if (resource==null)
				return;
			
			if (!ObjectUtil.isResource(resource))
				throw new Error("I don't know how to do anything with "+resource);

			if (_preview_width<1||_preview_height<1)
			{
				_preview_width = 200;
				_preview_height = 200;
			}

			//Logger.log("ImageResource.set resource("+resource+") // "+resource.$.width+" "+resource.$.height);
			if (resource.$.width != null && resource.$.width!=-1 && resource.$.height != null && resource.$.height!=-1)
			{
				//mimic imagemagick behavior...
				//if image is smaller than preview, use same size
				var s:Number = 1;
				if (resource.$.width>_preview_width || resource.$.height>_preview_height)
				{
					//fit to preview size
					s = Math.min(_preview_width/resource.$.width, _preview_height/resource.$.height);
				}
				_image_decorator.imageWidth = Math.round(resource.$.width*s);
				_image_decorator.imageHeight = Math.round(resource.$.height*s);
				_image_decorator.update_scale();
			}

			switch (resource.$[Resource.RESOURCE_FIELD_SIMPLE_TYPE])
			{
				case Resource.SIMPLE_TYPE_IMAGE_STRING:
					src = ResourceUtil.getPath(resource,options);
					break;
				case Resource.SIMPLE_TYPE_SWF_STRING:
					src = ResourceUtil.getPath(resource);
					break;
				default:
					draw_preview_unavailable();
					return;
			}
			
			if (src==null)
				do_load_resource_error();
			
			if (do_render)
				render();
			else
				imageDecorator.autoLoad = false;
		}
		
		private function get options():Object
		{
			var options:Object = {
				width:_preview_width,
				height:_preview_height
			};
			if (_jpeg_quality!=DEFAULT_JPEG_QUALITY)
				options.quality = _jpeg_quality;
			if (_file_type!=null)
				options.type = _file_type;
			return options;
		}
		
		private function draw_preview_unavailable():void
		{
			if (nonImageCellRenderer!=null)
			{
				nonImageCellRenderer();
				return;
			}
			visible = true;
			imageDecorator.generatingPreview = true;
			backgroundColor = 0x333333;
			backgroundAlpha = .6;
			render();
		}
		
	
		override protected function on_load_resource_error(e:ResourceEvent=null):void
		{
	        _cant_load_src = _src;
			super.on_load_resource_error(e);
			do_load_resource_error();
		}
		
		private function do_load_resource_error():void
		{
			if (_tried_server)
			{
	        	Logger.log("IMAGE RESOURCE: cant load "+_cant_load_src);
				dispatchEvent(new ResourceEvent(ResourceEvent.LOAD_ERROR,this));
				return;
	  		}
			if (_resource!=null)
			{
				imageDecorator.generatingPreview = true;

				Logger.log("IMAGE RESOURCE: GENERATING PREVIEW ["+options+"]");
				_tried_server = true;
				ResourceUtil.getPreviewUrl(_resource,options,on_get_generated_image);
			}
		}
		
		private function on_get_generated_image(url:String):void
		{
			//trace("IMAGE: got generated url "+resource.$.url);
			var b:Boolean = _cant_load_src == url;
			if (!b)
				Logger.error("ImageResource/S3 ERROR: My S3PathProvider said this: "+_cant_load_src+". Network said: "+url);
			imageDecorator.generatingPreview = false;
			src = url;
			load();
			render();
		}
		
		
	}
}
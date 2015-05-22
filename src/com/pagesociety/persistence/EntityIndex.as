package com.pagesociety.persistence
{

	public class EntityIndex
	{
		
		public static const TYPE_SIMPLE_SINGLE_FIELD_INDEX:uint 			= 0x01;
		public static const TYPE_SIMPLE_MULTI_FIELD_INDEX:uint  			= 0x02;
	
		public static const TYPE_ARRAY_MEMBERSHIP_INDEX:uint    			= 0x11;
		public static const TYPE_MULTIFIELD_ARRAY_MEMBERSHIP_INDEX:uint   	= 0x12;
		
		public static const TYPE_FREETEXT_INDEX:uint   		 				= 0x21;
		public static const TYPE_MULTI_FIELD_FREETEXT_INDEX:uint   		 	= 0x22;
		
		private var _name:String;
		private var _entity:String;
		private var _type:int;
		private var _fields:Array;//FieldDefinition
		private var _attributes:Object;

		
		public function EntityIndex()
		{
			super();
		}

		public function get name():String
		{
			return _name;
		}
	
		public function set name(name:String):void
		{
			_name = name;
		}
		
		public function get entity():String
		{
			return _entity;
		}
	
		public function set entity(entity:String):void
		{
			_entity = entity;
		}
		
		public function get attributes():Object
		{
			return _attributes;
		}
	
		public function set attributes(attributes:Object):void
		{
			_attributes = attributes;
		}
//		
//		public function get queryParameters():Array
//		{
//			return _query_params;
//		}
//	
//		public function set queryParameters(params:Array):void
//		{
//			_query_params = params;
//		}
		
//		public function get entityIndexDefinition():EntityIndexDefinition
//		{
//			return _eid;
//		}
//		
//		public function set entityIndexDefinition(eid:EntityIndexDefinition):void
//		{
//			_eid = eid;
//		}
		
		
		public function set fields(fields:Array):void
		{
			_fields = fields;
		}
		
		public function get fields():Array
		{
			return _fields;
		}
		
	
		public function set type(type:uint):void
		{
			_type = type;
		}
		
		public function get type():uint
		{
			return _type;
		}
		
	
		public function setIndexField(field:FieldDefinition):void
		{
			_fields = new Array();
			_fields.push(field);
		}
	
		public function addIndexField(field:FieldDefinition):void
		{
			if (_fields == null)
				_fields = new Array();
			_fields.add(field);
		}
		
		public function toString():String
		{
			var a:String = "";
			for (var p:String in _attributes)
			{
				a += p+"="+_attributes[p];
				a += "/";
			}
			a = a.substring(0, a.length-1);
			return "Index "+_name+" \n\tfields["+_fields+"] \n\tattributes ["+a+"]";
		}
		
	}
}
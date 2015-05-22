package com.pagesociety.persistence
{
	public class Definitions
	{
		private var _entities:Array;
		private var _indices:Array;
		private var _relationships:Array;
		
		public function Definitions()
		{
			_entities = new Array();
			_indices = new Array();
			_relationships = new Array();
		}
		
		public function get entities():Array
		{
			return _entities;
		}

		public function set entities(a:Array):void
		{
			_entities = a;
		}
		
		public function getEntity(name:String):EntityDefinition
		{
			for (var i:int=0; i<_entities.length; i++)
        	{
        		if (_entities[i].name == name)
        			return _entities[i];
        	}
        	return null;
		}
		
		public function deleteEntity(e:EntityDefinition):void
        {
        	for (var i:int=0; i<_entities.length; i++)
        	{
        		if (_entities[i] == e)
        		{
        			_entities.splice(i,1);
        			break;
        		}
        	}
        }
        
        public function deleteField(e:EntityDefinition,f:FieldDefinition):void
        {
        	for (var i:int=0; i<e.fields.length; i++)
        	{
        		if (e.fields[i]==f)
        		{
        			e.fields.splice(i,1);
        			break;
        		}
        	}
        }

		// index definitions
		public function get indices():Array
		{
			return _indices;
		}
		
		public function set indices(a:Array):void
		{
			_indices = a;
		}

		public function deleteIndex(e:EntityDefinition,index:EntityIndex):void
        {
        	for (var i:int=0; i<e.indices.length; i++)
        	{
        		if (e.indices[i]==index)
        		{
        			e.indices.splice(i,1);
        			break;
        		}
        	}
        }

		public function get relationships():Array
		{
			return _relationships;
		}

		public function set relationships(a:Array):void
		{
			_relationships = a;
		}

	}
}
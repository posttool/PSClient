package com.pagesociety.persistence
{   
    public class EntityDefinition
    {   
        private var _name:String;
        private var _fields:Array;
        private var _ref_fields:Array;
        private var _field_fields:Array;
        private var _indices:Array;
        private var _reference_field_names:Array;
        
        public function EntityDefinition()
        {
            super();
            _fields = new Array();
            _indices = new Array();
        }
        
        public function get name():String
        {
            return _name;
        }
        
        public function set name(name:String):void
        {
            _name = name;
        }

        public function get fields():Array
        {
            return _fields;
        }
        
        public function set fields(fields:Array):void
        {
            _fields = fields;
        }
        
        public function get referenceFields():Array
        {
            return _ref_fields;
        }
        
        public function set referenceFields(fields:Array):void
        {
            _ref_fields = fields;
        }
        
        public function get referenceFieldNames():Array
        {
            return _reference_field_names;
        }
        
        public function set referenceFieldNames(fields:Array):void
        {
            _reference_field_names = fields;
        }
        
        public function get fieldNames():Array
        {
            return _field_fields;
        }
        
        public function set fieldNames(fields:Array):void
        {
            _field_fields = fields;
        }
        
        public function get indices():Array
        {
            return _indices;
        }
        
        public function set indices(indices:Array):void
        {
             _indices = indices;
        }
        
        public function getField(name:String):FieldDefinition
        {
            for (var i:uint = 0; i < fields.length; i++)
            {
                var field:FieldDefinition = fields[i];
                if (field.name==name)
                    return field;
            }
            return null;
        }

        public function toString():String
        {
            var ret:String = new String();
            ret += ("ENTITY DEFINITION: " + name + "\n");
            for (var i:uint = 0; i < fields.length; i++)
            {
                var field:FieldDefinition = fields[i];
                ret += ("\t" + field.toString() + "\n");
            }
            for (i = 0; i < indices.length; i++)
            {
                var index:EntityIndex = indices[i];
                ret += ("\t" + index.toString() + "\n");
            }
            return ret;
        }


    }
}
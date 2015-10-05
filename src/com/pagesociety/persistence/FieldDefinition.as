package com.pagesociety.persistence
{
    public class FieldDefinition
    {
    
        //
        public static var TYPES:Array = [];
        TYPES[Types.TYPE_BLOB]      = "Blob";
        TYPES[Types.TYPE_BOOLEAN]   = "Boolean";
        TYPES[Types.TYPE_INT]       = "Int";
        TYPES[Types.TYPE_LONG]      = "Long";
        TYPES[Types.TYPE_FLOAT]     = "Float";
        TYPES[Types.TYPE_DOUBLE]    = "Double";
        TYPES[Types.TYPE_STRING]    = "String";
        TYPES[Types.TYPE_TEXT]      = "Text";
        TYPES[Types.TYPE_DATE]      = "Date";
        TYPES[Types.TYPE_REFERENCE] = "Reference";
        TYPES[Types.TYPE_UNDEFINED] = "Undefined";
        //
        private var _name:String;
        private var _type:uint;
        private var _ref_type:String;
        private var _required:Boolean;
        private var _cascade_on_delete:Boolean;
        private var _comment:String;
        private var _description:String;
        private var _default_value:Object;
    
        public function FieldDefinition()
        {
        }
    
        public function set name(name:String):void
        {
            _name = name;
        }
    
        public function get name():String
        {
            return _name;
        }
        
        public function set isRequired(b:Boolean):void
        {
            _required = b;
        }
        
        public function get isRequired():Boolean
        {
            return _required;
        }
        
        public function set comment(c:String):void
        {
            _comment = c;
        }
        
        public function get comment():String
        {
            return _comment;
        }
        
        public function set description(s:String):void
        {
            _description = s;
        }
        
        public function get description():String
        {
            return _description;
        }
    
        public function get type():uint
        {
            return _type;
        }
        
        public function set type(type:uint):void
        {
            _type = type;
        }
        
        public function get defaultValue():Object
        {
            return _default_value;
        }
        
        public function set defaultValue(o:Object):void
        {
            _default_value = o;
        }
        
        public function get referenceType():String
        {
            return _ref_type;
        }
        
        public function set referenceType(ref_type:String):void
        {
            _ref_type = ref_type;
        }
        
        
    
        
        public function get baseType():uint
        {
            return _type & ~Types.TYPE_ARRAY;
        }
    
        public function isArray():Boolean
        {
            return ((_type & Types.TYPE_ARRAY) == Types.TYPE_ARRAY);
        }
        
        public function get isReference():Boolean
        {
            return ((_type & Types.TYPE_REFERENCE) == Types.TYPE_REFERENCE);
        }
    
        public function setIsArray(b:Boolean):void
        {
            if (b)
            {
                if (isArray())
                    return;
                _type = _type | Types.TYPE_ARRAY;
            }
            else
            {
                if (!isArray())
                    return;
                _type = _type & ~Types.TYPE_ARRAY;
            }
        }
        
        public function set isCascadeOnDelete(b:Boolean):void
        {
            _cascade_on_delete = b;
        }
        
        public function get isCascadeOnDelete():Boolean
        {
            return _cascade_on_delete;
        }
    
        /* utility function for decoding type directly from encoded type uint */
        public function toString():String
        {
            var buf:String = new String();
            buf += ("Field: " + name + " is a ");
            if (isArray())
            {
                buf += ("Array of ");
            }
            buf += TYPES[baseType];
            if (baseType==Types.TYPE_REFERENCE)
                buf += " "+_ref_type;
            return buf;
        }
    
        
    }
}
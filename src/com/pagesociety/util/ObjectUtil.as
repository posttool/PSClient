package com.pagesociety.util
{
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.persistence.EntityDefinition;
    import com.pagesociety.persistence.EntityIndex;
    import com.pagesociety.persistence.FieldDefinition;
    import com.pagesociety.web.ErrorMessage;
    import com.pagesociety.web.ResourceUtil;
    import com.pagesociety.web.amf.AmfDouble;
    import com.pagesociety.web.amf.AmfFloat;
    import com.pagesociety.web.amf.AmfLong;
    import com.pagesociety.web.upload.UploadProgressInfo;
    
    import flash.net.registerClassAlias;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    public class ObjectUtil
    {
        public static var _meta_info:Object = {};
        public static function getAccessorType(target:Object, name:String):String 
        {
            var s:Array = name.split(".");
            var o:Object = target;
            for (var i:uint=0; i<s.length-1; i++)
            {
                o = o[s[i]];
                if (o==null)
                {
                    trace("Style error "+name+" not found");
                    return null;
                }
            }
            var lf:String = s[s.length-1];
            var info_key:String = getQualifiedClassName(o);
            var cmi:Object = _meta_info[info_key];
            if (cmi==null)
            {
                cmi = {};
                _meta_info[info_key] = cmi;
            }
            var type:String = cmi[lf];
            if (type==null)
            {
                var description:XML = describeType(o);
                var accessor:XMLList = description.accessor.(@name==lf);
                if (accessor.length()!=0)
                    type = accessor[0].@type;                   
                var variable:XMLList = description.variable.(@name==lf);
                if (variable.length()!=0)
                    type = variable[0].@type;
                cmi[lf] = type;
            }
            return type;
        }
        
        
        public static function getProperty(target:Object,prop_expr:String):Object
        {
            var s:Array = prop_expr.split(".");
            var o:Object = target;
            for (var i:uint=0; i<s.length-1; i++)
            {
                o = o[s[i]];
                if (o==null)
                {
                    trace("Style error "+prop_expr+" not found");
                    return null;
                }
            }
            var lf:String = s[s.length-1];
            try {
                var lo:Object = o[lf];
                return lo;
            } catch (e:Error)
            {
                //trace(e);
            }
            return null;
        }
        
        public static function setProperty(target:Object,prop_expr:String, val:*):void
        {
            var s:Array = prop_expr.split(".");
            var o:Object = target;
            for (var i:uint=0; i<s.length-1; i++)
            {
                o = o[s[i]];
                if (o==null)
                {
                    trace("Style error "+prop_expr+" not found");
                    return;
                }
            }
            var lf:String = s[s.length-1];
            try {
                o[lf] = val;
            } catch (e:Error)
            {
                //trace("ObjectUtil.setProperty ERROR: "+e);
            }
        }
        
        /////////////////////////////
        private static var _eclass:Object = new Object();

        public static function replaceEntitiesWithObjects(o:*):*
        {
            var no:* = null;
            var p:String;
            if (o is Entity)
            {
                var e:Entity = o as Entity;
                no = get_instance(e.type);
                if (no!=null)
                {
                    no.id = e.id;
                    no.type = e.type;
                    for (p in e.attributes)
                    try {
                        no[p] = replaceEntitiesWithObjects(e.attributes[p]);
                    } catch (e:Error) {
                        //trace("ObjectUtil.replaceEntitiesWithObjects ERROR ["+e.type+":"+p+"] "+e.message);
                    }
                }
            }
            if (no==null) 
            {
                no = o;
                for (p in o)
                    no[p] = replaceEntitiesWithObjects(o[p]);
            }
            return no;
        }
        
        public static function registerEntityClass(name:String, clazz:Class):void
        {
            _eclass[name] = clazz;
        }
        
        private static function get_instance(type:String):*
        {
            if (_eclass[type]==null)
                return null;
            return new _eclass[type];
        }
        ////////////////////////
        private static var default_entities_registered:Boolean = false;
        public static function registerDefaultEntities():void
        {
            if (default_entities_registered)
                return;
            registerClassAlias("com.pagesociety.web.ErrorMessage", ErrorMessage);
            registerClassAlias("com.pagesociety.persistence.Entity", Entity);
            registerClassAlias("com.pagesociety.persistence.EntityIndex", EntityIndex);
            registerClassAlias("com.pagesociety.persistence.EntityDefinition", EntityDefinition);
            registerClassAlias("com.pagesociety.persistence.FieldDefinition", FieldDefinition);
            registerClassAlias("com.pagesociety.web.upload.UploadProgressInfo", UploadProgressInfo); 
            registerClassAlias("com.pagesociety.web.amf.AmfLong", AmfLong); 
            registerClassAlias("com.pagesociety.web.amf.AmfDouble", AmfDouble); 
            registerClassAlias("com.pagesociety.web.amf.AmfFloat", AmfFloat); 
            default_entities_registered = true;
        }
        
        
        
        
        public static function isResource(e:Entity):Boolean
        {
            return ResourceUtil.hasResourceModuleProvider(e.type);
        }
        
        
        
        
        //////////CLONE
        
        public static function clone(source:Object):* 
        {
            var copier:ByteArray = new ByteArray();
            copier.writeObject(source);
            copier.position = 0;
            return(copier.readObject());
        }
        
        public static function newSibling(sourceObj:Object):* {
            if(sourceObj) {
                
                var objSibling:*;
                try {
                    var classOfSourceObj:Class = getDefinitionByName(getQualifiedClassName(sourceObj)) as Class;
                    objSibling = new classOfSourceObj();
                }
                
                catch(e:Object) {}
                
                return objSibling;
            }
            return null;
        }
        
        public static function clone1(source:Object):Object {
            
            var clone:Object;
            if(source) {
                clone = newSibling(source);
                
                if(clone) {
                    copyData(source, clone);
                }
            }
            
            return clone;
        }
        
        public static function copyData(source:Object, destination:Object):void {
            
            //copies data from commonly named properties and getter/setter pairs
            if((source) && (destination)) {
                
                try {
                    var sourceInfo:XML = describeType(source);
                    var prop:XML;
                    
                    for each(prop in sourceInfo.variable) {
                        
                        if(destination.hasOwnProperty(prop.@name)) {
                            destination[prop.@name] = source[prop.@name];
                        }
                        
                    }
                    
                    for each(prop in sourceInfo.accessor) {
                        if(prop.@access == "readwrite") {
                            if(destination.hasOwnProperty(prop.@name)) {
                                destination[prop.@name] = source[prop.@name];
                            }
                            
                        }
                    }
                }
                catch (err:Object) {
                    ;
                }
            }
        }

        
        public static function print(o:Object):String
        {
            var s:String = printo(o,"");
            Logger.log(s);
            return s;
        }
        
        private static function printo(o:Object, pad:String):String
        {
            var s:String = "";
            if (o is String)
            {
                s += "\""+o+"\"";
            }
            else if (o is Number || o is Boolean)
            {
                s += o;
            }
            else if (o is Array)
            {
                s += "\n"+pad+"[\n";
                for (var i:int=0; i<o.length; i++)
                {
                    s += pad;
                    s += printo(o[i], pad+"  ");
                    s += ",\n";
                }
                s += pad+"]\n";
            }
            else if (o is Object)
            {
                s += "\n"+pad+"{\n";
                for (var p:String in o)
                {
                    s += pad+p+": ";
                    s += printo(o[p],  pad+"  ");
                    s += ",\n";
                }
                s += pad+"}\n";
            }
            
            return s;
        }
    }


}
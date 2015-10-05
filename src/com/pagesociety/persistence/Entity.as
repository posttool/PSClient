package com.pagesociety.persistence
{
    import com.pagesociety.web.amf.AmfLong; 
    
    public class Entity //extends Proxy
    {
        public static var UNDEFINED:AmfLong = new AmfLong(-1);
        public static var DEF_PROVIDER:EntityDefinitionProvider;
        public static var INDICES:Object;
        public static function setDefinitions(defs:Array):void
        {
            DEF_PROVIDER = new DefaultEntityProvider(defs);
        }
        
        public static function getDefinitions():Array
        {
            return DEF_PROVIDER.provideEntityDefinitions();
        }
        
        public static function getDefinition(type:String):EntityDefinition
        {
            return DEF_PROVIDER.provideEntityDefinition(type);
        }
        
        public static function setIndices(indices:Object):void
        {
            INDICES = indices;
            var defs:Array = DEF_PROVIDER.provideEntityDefinitions();
            for (var i:uint=0; i<defs.length; i++)
            {
                var def:EntityDefinition = defs[i];
                def.indices = indices[def.name];
            }
        }
        
        private var _def:EntityDefinition;
        private var _type:String;
        private var _id:AmfLong;
        private var _attributes:Object = {};
        private var _dirty_attributes:Array = [];
        private var _fieldnames:Array = [];
        
        public function Entity(type:String=null,id:Number=-1)
        {
            super();
            this.type = type;
            this.id = id<1 ? UNDEFINED : new AmfLong(id);
            _attributes.id = this.id;
        }
        
        public function get type():String
        {
            return _type;
        }
        
        public function set type(type:String):void
        {
            _type = type;
            if (DEF_PROVIDER!=null)
            {
                _def = DEF_PROVIDER.provideEntityDefinition(_type);
                //TODO clone the array
//              if (_def!=null)
//                  for (var i:uint=0; i<_def.fields.length; i++)
//                  {
//                      var f:FieldDefinition = _def.fields[i];
//                      if ($[f.name]==null)
//                          $[f.name] = f.defaultValue;
//                  }
            }
        }
        
        public function get id():AmfLong
        {
            return _id;
        }
        
        public function set id(id:AmfLong):void
        {
            _id = id;
            _attributes.id = id;
        }
        
        public function get definition():EntityDefinition
        {
            return _def;
        }
        
        public function get attributes():Object
        {
            return _attributes;
        }
    
        public function get $():Object
        {
            return _attributes;
        }
        
        public function set attributes(attr:Object):void
        {
            _attributes = attr;
            _fieldnames = new Array();
            for (var p:String in _attributes)
                _fieldnames.push(p);
        }
        
        public function setAttribute(name:String, attr:Object):void
        {
            if (name==null)
                throw new Error("NULL name?");
            if (_dirty_attributes.indexOf(name)==-1)
                _dirty_attributes.push(name);
            _attributes[name] = attr;
            if (_fieldnames.indexOf(name)==-1)
                _fieldnames.push(name);
        }


        private function get dirtyAttributes():Array
        {
            return _dirty_attributes;
        }
        
        private function set dirtyAttributes(attr:Array):void
        {
            _dirty_attributes = attr;
        }
        
        public function get dirtyValues():Object
        {
            var a:Object = {};
            for (var i:uint=0; i<_dirty_attributes.length; i++)
                a[_dirty_attributes[i]] = _attributes[_dirty_attributes[i]];
            return a;
        }
        
        public function eq(e:Entity):Boolean
        {
            if (e==null)
                return false;
            return _type==e.type && _id.longValue==e.id.longValue;
        }

        public function toString():String
        {
            return _type+" "+_id;
        }
        

        public function toStringLong(masked_fields:Array=null):String
        {
            var s:String = "Entity "+type+" "+id+"\n";
            for (var p:String in attributes)
            {
                if (masked_fields!=null && masked_fields.indexOf(p)!=-1)
                    continue;
                var o:Object = attributes[p];
                s+="  "+p+"=";
                if (o == null)
                {
                    p+="null";
                }
                else if (o is Date)
                {
                    var d:Date =  o as Date;
                    if (isNaN(d.fullYear))
                        continue;
                    s += (d.month+1)+"-"+d.day+"-"+d.fullYear+" "+d.hours+":"+d.minutes;
                }
                else if (o is Entity)
                {
                    s+=o.type+":"+o.id;
                }
                else if (o is Array)
                {
                    s+="["+o.length+"]";
                }
                else
                {
                    s+=o;
                }
                s+="\n";
            }
            return s;
        }
        
        public static function dump(e:Entity,pf:String=""):void
        {
            if (pf.length>10)
                throw new Error("TOO DEEEEP");
            for (var p:String in e.attributes)
            {
                var v:Object = e.attributes[p];
                if (v is Array && v.length!=0 && v[0] is Entity)
                {
                    for (var i:uint=0; i<v.length; i++)
                        dump(v[i],pf+"  ");
                }
                else if (v is Entity)
                {
                    dump(v as Entity,pf+"  ");
                }
                else
                {
                    trace(pf+p+"="+v);
                }
            }
        }
        
        public function clone(seen:Object=null,show_seen:Boolean=true,masked_fields:Array=null):Entity
        {
            if (seen==null)
                seen = new Object();
            var sid:String = type+id;
            if (seen[sid]!=null)
                return show_seen ? seen[sid] : null;
            var target:Entity = new Entity(type,id.longValue);
            seen[sid] = target;
            var p:String;
            var i:uint;
            for (p in attributes)
            {
                if (masked_fields!=null && masked_fields.indexOf(p)!=-1)
                    continue;
                var v:Object = attributes[p];
                if (v is Array && v.length!=0 && v[0] is Entity)
                {
                    target.attributes[p] = new Array(v.length);
                    for (i=0; i<v.length; i++)
                        target.attributes[p][i] = (v[i] as Entity).clone(seen,show_seen,masked_fields);
                }
                else if (v is Array)
                {
                    target.attributes[p] = new Array(v.length);
                    for (i=0; i<v.length; i++)
                    {
                        target.attributes[p][i] = v[i];
                    }
                }
                else if (v is Entity)
                {
                    target.attributes[p] = (v as Entity).clone(seen,show_seen,masked_fields);
                }
                else
                {
                    target.attributes[p] = v;
                }
            }
            return target;
        }
        
        public function cloneShallow():Entity
        {
            var target:Entity = new Entity(type,id.longValue);
            target.dirtyAttributes = dirtyAttributes;
            var p:String;
            var i:uint;
            var e0:Entity;
            for (p in attributes)
            {
                var v:Object = attributes[p];
                if (v is Array && v.length!=0 && v[0] is Entity)
                {
                    target.attributes[p] = new Array(v.length);
                    for (i=0; i<v.length; i++)
                    {
                        e0 = v[i] as Entity;
                        target.attributes[p][i] = new Entity(e0.type, e0.id.longValue);
                    }
                }
                else if (v is Array)
                {
                    target.attributes[p] = new Array(v.length);
                    for (i=0; i<v.length; i++)
                    {
                        target.attributes[p][i] = v[i];
                    }
                }
                else if (v is Entity)
                {
                    e0 = v as Entity;
                    target.attributes[p] = new Entity(e0.type,e0.id.longValue);
                }
                else
                {
                    target.attributes[p] = v;
                }
            }
            return target;
        }
        

    }

    
}
    import com.pagesociety.persistence.EntityDefinitionProvider;
    import com.pagesociety.persistence.EntityDefinition;
    


    class DefaultEntityProvider implements EntityDefinitionProvider
    {
        private var _entity_defs:Array;
        
        public function DefaultEntityProvider(defs:Array)
        {
            _entity_defs = defs;
//          _entity_defs.sortOn("name",Array.CASEINSENSITIVE);

        }
        
        public function provideEntityDefinition(n:String):EntityDefinition
        {
            for (var i:uint=0; i<_entity_defs.length; i++)
            {
                if (_entity_defs[i].name == n)
                    return _entity_defs[i];
            }
            return null;
        }
        
        public function provideEntityDefinitions():Array
        {
            return _entity_defs;
        }
    
    }
    



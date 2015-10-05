package com.pagesociety.ux.component
{
    import flash.geom.Point;
    
    
    public class TakeOvers extends Container
    {
        public function TakeOvers(parent:Container)
        {
            super(parent);
        }
        
        public function push(c:Component,callback:Function,color:uint,alpha:Number,center:Boolean,align_to:Component=null,offset:Point=null):void
        {
            var t:TakeOver = new TakeOver(this, c, callback, color, alpha,center,align_to,offset);
            t.alpha = 0;
            t.render();
            t.alphaTo(1, 700);
        }
        
        public function pop():void
        {
            if (children.length==0)
                return;
            var l:Component = lastChild;
            l.alphaTo(0, 400, 
                function():void {
                    removeComponent(l);
                });
        }
        
        public function isTakeOver(c:Component):Boolean
        {
            var t:TakeOver = c as TakeOver;
            if (t==null)
            {
                var p:Container = c.parent;
                while (p!=null)
                {
                    if (p is TakeOver)
                    {
                        t = p as TakeOver;
                        break;
                    }
                    p = p.parent;
                }
            }
            if (t==null)
                return false;
            for (var i:uint=0; i<children.length; i++)
                if (children[i].component == t)
                    return true;
            return false;
        }
        
        
        
    }
}
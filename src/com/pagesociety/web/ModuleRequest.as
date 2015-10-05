
package com.pagesociety.web {
    
import com.pagesociety.ux.INetworkEventHandler;

import flash.events.AsyncErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.net.NetConnection;
import flash.net.Responder;
import flash.utils.Timer;
    

public class ModuleRequest extends Event
{
    // static for app... might want to group this by Application instead
    public static var SERVICE_URL:String;
    
    //
    private static var _concurrent_ok:Boolean;
    private static var _networking:Boolean;
    private static var _net_event_handler:INetworkEventHandler;
    private static var _timeout:int = 12000;//ms
    private static var _timer:Timer;
    private static var _last_event:int = 0;

    // a convenience function for creating and executing a ModuleRequest
    public static function doModule(mm:String, a:Array, ok:Function, err:Function, concurrentOk:Boolean=false):void
    {
        var m:ModuleRequest = new ModuleRequest(mm, a);
        m.concurrentOk = concurrentOk;
        m.addErrorHandler(err);
        m.addResultHandler(ok);
        m.execute();
    }
    
    public static function set networkEventHandler(n:INetworkEventHandler):void
    {
        if (_timer==null)
        {
            _timer = new Timer(_timeout);
            _timer.addEventListener(TimerEvent.TIMER, on_timeout);
        }
        _timer.reset();
        _timer.start();
        _net_event_handler = n;
    }

    
    public static function set timeout(timeout:int):void
    {
        _timeout = timeout;
    }
    
    public static function get timeout():int
    {
        return _timeout;
    }
    
    private static function on_timeout(e:Event=null) : void 
    {
        if (_net_event_handler==null)
            return;
        _net_event_handler.timeout();
    }

    // the network wrapper for module calls 
    private var _connection:NetConnection;
    private var _module_name:String;
    private var _method_name:String;
    private var _arguments:Array;
    private var _result_handlers:Array;//Function;
    private var _error_handlers:Array;//Function;
    
    public function ModuleRequest(module_and_method:String=null, args:Array=null) 
    {
        super("ModuleRequest");
        
        _result_handlers = new Array();
        _error_handlers = new Array();
        _arguments = (args == null) ? new Array() : args;
        if (module_and_method!=null)
        {
            var s:Array = module_and_method.split("/");
            if (s.length==2)
            {
                _module_name = s[0];
                _method_name = s[1];
            }
        }
    }

    public  function get connected() : Boolean 
    {
        return (_connection != null);
    }
    
    public function set module(name:String):void
    {
        _module_name =  name;
    }
    
    public function get module():String
    {
        return _module_name;
    }
    
    public function get method():String
    {
        return _method_name;
    }
    
    public function set arguments(args:Array):void
    {
        _arguments = args;
    }
    
    public function get arguments():Array
    {
        return _arguments;
    }
    
    public function set concurrentOk(b:Boolean):void
    {
        _concurrent_ok = b;
    }
    
    public function get concurrentOk():Boolean
    {
        return _concurrent_ok;
    }
    
    public function addResultHandler(f:Function):void
    {
        _result_handlers.push(f);
    }
    
    public function addErrorHandler(f:Function):void
    {
        _error_handlers.push(f)
    }

    public  function execute () : void 
    {
        if (_concurrent_ok)
            do_execute();
        else
            QUEUE_LOAD(this);
    }
    
    private function do_execute () : void 
    {
        Logger.log("MODULE REQUEST: "+_module_name+"/"+_method_name+"("+_arguments+")");
        if (_timer!=null)
        {
            _timer.reset();
            _timer.start();
        }
        connect(_module_name+"/"+_method_name+"/.amf");
    }
    
    
    
    private  function connect (url:String) : void 
    {
        
        if (url==null || url.indexOf("/")==-1 || url.indexOf("amf")==-1)
            throw new Error("Cannot connect to "+url);
        
        var con:NetConnection = new NetConnection();
        con.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
        con.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        con.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
        con.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
        
        try {
            con.connect(SERVICE_URL+url);
        } catch (e:Error) {
            Logger.log(e.message);
            Logger.log(SERVICE_URL+url);
            return; // TODO - 
        }
        _connection = con;
        _connection.call("PSWebModuleRequest", new Responder(on_result, on_error), _arguments);
    }
    
    public static const STATUS_OK:uint  = 0;
    public static const STATUS_ERR:uint = 1;
    private function on_result(o:Object):void
    {
        close();
        for (var i:int=0; i<_result_handlers.length; i++)
            _result_handlers[i](o);
        QUEUE_COMPLETE(this,STATUS_OK,o);
    }
    
    private function on_error(o:Object):void
    {
        Logger.log("ERROR:");
        Logger.log(o);
        close();
        for (var i:int=0; i<_error_handlers.length; i++)
            _error_handlers[i](o);
        QUEUE_COMPLETE(this,STATUS_ERR,o);
    }

    private function close() : void 
    {
        if (_connection != null) {
            _connection.close();
            _connection = null;
        }
    } 

    

    
    
    


    // TODO -  error event handling
    private function onAsyncError (evt:AsyncErrorEvent) : void 
    {
        on_error("onAsyncError: " + evt.error + " - " + evt.text);
    }
    
    private function onIOError (evt:IOErrorEvent) : void 
    {
        on_error("onIOError: " + evt.text);
    }
    
    private function onNetStatus (evt:NetStatusEvent) : void 
    {
        var info:Object = evt.info;
        switch(info.code)
        {

            case "":
            case "NetConnection.Connect.Closed":
                return;
                
            case "NetConnection.Call.Failed":
                on_error(new ErrorMessage("onNetStatus: "+info.code+" "+_module_name+" "+_method_name+" "+_arguments));
                return;
            
            default:
                trace("onNetStatus: "+info.code+" "+_module_name+" "+_method_name+" "+_arguments);
                for (var key:String in info) 
                    trace(" " + key + ": " + info[key]);
        }
        
    }
    
    private function onSecurityError (evt:SecurityErrorEvent) : void 
    {
        close();
        QUEUE_COMPLETE(this);
        Logger.log("onSecurityError: " + evt.text);
    }

      
    ///////////////////////////////
    //
    private static var _QUEUE:Array = [];
    private static var _QUEUE_LOAD_COUNT:int = 0;
    public static var _QUEUE_MAX_SIMULATANEOUS_LOAD:int = 1;
    
    
    private static function QUEUE_LOAD(r:ModuleRequest):void
    {
        _QUEUE.push(r);
        QUEUE_DO_LOAD();
    }
    
    private static function QUEUE_DO_LOAD():void
    {
        var s:uint = _QUEUE_MAX_SIMULATANEOUS_LOAD - _QUEUE_LOAD_COUNT; 
        if (_QUEUE.length==0)
        {
        /*  _networking = false;
            if (_net_event_handler!=null)
                _net_event_handler.networking = _networking;
            */
            return;
        }
        /*
        if (!_networking && _QUEUE.length!=0)
        {
            _networking = true;
            if (_net_event_handler!=null)
                _net_event_handler.networking = _networking;
        }
        */
        for (var i:uint = 0; i < s && _QUEUE.length != 0; i++)
        {
            var r:ModuleRequest = _QUEUE.shift();
            r.do_execute();
            if(_net_event_handler != null)
                _net_event_handler.beginModuleRequest(r);
            _QUEUE_LOAD_COUNT++;
        }
    }
    
    private static function QUEUE_COMPLETE(r:ModuleRequest,status:uint = STATUS_OK,arg:Object = null):void
    {
        if(_net_event_handler != null)
            _net_event_handler.endModuleRequest(r,status,arg);
        _QUEUE_LOAD_COUNT--;
        QUEUE_DO_LOAD();
    }
    
    
}

}
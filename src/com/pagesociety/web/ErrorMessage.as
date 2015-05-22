

package com.pagesociety.web {
	

public class ErrorMessage {
	
	
	private var _message:String;
	private var _exceptionType:String;
	private var _exception:*;
	private var _stacktrace:String;
	
	 
	function ErrorMessage (s:String=null) {
		_message = s;
	}
	
	public function get message () : String {
		return _message;
	}
	
	public function set message (value:String) : void {
		_message = value;
	}
	

	public function get exceptionType () : String {
		return _exceptionType;
	}
	
	public function set exceptionType (value:String) : void {
		_exceptionType = value;
	}
	
	public function get exception () : * {
		return _exception;
	}
	
	public function set exception (value:*) : void {
		_exception = value;
	}


	public function get stacktrace () : String {
		return _stacktrace;
	}
	
	public function set stacktrace (value:String) : void {
		_stacktrace = value;
	}
	

	public function toString () : String {
		return "ErrorMessage: " 
			+ "\n Message: " + _message
			+ "\n ExceptionType: " + _exceptionType
			+ "\n Stacktrace: " + _stacktrace;
	}
	
	
}

}
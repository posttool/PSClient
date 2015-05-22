package com.pagesociety.mail
{
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	
	public class Test
	{
		private var s:Socket;
		public function Test()
		{
			s = new Socket("mail.posttool.com", 110);
			s.addEventListener(ProgressEvent.SOCKET_DATA, openSocketConnection);
		}
		
		private function openSocketConnection(evt:ProgressEvent):void 
		{
			s.writeUTFBytes("david@posttool.com\n");
			s.writeUTFBytes("poppies\n");
			s.writeUTFBytes("STAT\n");
			s.writeUTFBytes("LIST\n");
			s.flush();
		}

	}
}
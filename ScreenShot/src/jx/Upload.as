/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package jx
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class Upload implements Save
	{
		
		private var url:String;
		private var loggerEnabled:Boolean;
		
		public function Upload(url:String, loggerEnabled:Boolean=false)
		{
			this.url = url;
			this.loggerEnabled = loggerEnabled;
		}
		
		public function save(name:String, screenShot:BitmapData):void
		{
			var image:ByteArray = convertScreen(screenShot);
			var request:URLRequest = createRequest(name, image);
			var loader:URLLoader = new URLLoader()
				loader.addEventListener(Event.COMPLETE, function(event:Event):void
				{
					if (loader.data != "done") log(loader.data);
				});
				loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event):void
				{
					log(event.toString());
				});
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:Event):void
				{
					log(event.toString());
				});
				loader.load(request);
		}
		
		private function createRequest(name:String, image:ByteArray):URLRequest
		{
			var request:URLRequest = new URLRequest(url);
				request.requestHeaders.push(new URLRequestHeader("Content-type", "application/octet-stream"));
				request.requestHeaders.push(new URLRequestHeader("X-File-Name", name));
				request.method = "POST";
				request.data = image;
			
			return request;
		}
		
		private function convertScreen(screen:BitmapData):ByteArray
		{
			return new PNGEncoder().encode(screen);
		}
		
		private function log(message:String):void
		{
			if (loggerEnabled)
			{
				trace("Uploader:", message);
			}
		}
		
	}
}
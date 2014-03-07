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
		private var pool:UploadPool;
		
		public function Upload(url:String)
		{
			this.url = url;
			pool = new UploadPool();
		}
		
		public function save(name:String, screenShot:BitmapData):void
		{
			var image:ByteArray = convertScreen(screenShot);
			
			var request:URLRequest = createRequest(name, image);
			var loader:URLLoader = pool.getLoader();
				loader.addEventListener(Event.COMPLETE, loader_eventHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, loader_eventHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_eventHandler);
				loader.load(request);
		}
		
		private function convertScreen(screen:BitmapData):ByteArray
		{
			return new PNGEncoder().encode(screen);
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
		
		private function loader_eventHandler(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
				loader.removeEventListener(Event.COMPLETE, loader_eventHandler);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, loader_eventHandler);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_eventHandler);
			
			pool.disposeLoader(loader);
		}
		
	}
}
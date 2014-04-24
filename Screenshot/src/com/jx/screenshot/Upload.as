/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package com.jx.screenshot
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.sendToURL;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class Upload implements Save
	{
		
		public static const EXTENSION:String = ".png";
		
		private var url:String;
		
		public function Upload(url:String)
		{
			this.url = url;
		}
		
		public function save(name:String, screenShot:BitmapData):void
		{
			var image:ByteArray = convertScreen(screenShot);
			var request:URLRequest = createRequest(name, image);
			sendToURL(request);
		}
		
		private function convertScreen(screen:BitmapData):ByteArray
		{
			return new PNGEncoder().encode(screen);
		}
		
		private function createRequest(name:String, image:ByteArray):URLRequest
		{
			var request:URLRequest = new URLRequest(url);
				request.requestHeaders.push(new URLRequestHeader("Content-type", "application/octet-stream"));
				request.requestHeaders.push(new URLRequestHeader("X-File-Name", name + EXTENSION));
				request.method = "POST";
				request.data = image;
			
			return request;
		}
		
	}
}
/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package com.jx.screenshot
{
	import flash.display.BitmapData;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.sendToURL;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.IImageEncoder;
	import mx.graphics.codec.PNGEncoder;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class Upload implements Save
	{
		
		private var url:String;
		private var encoder:IImageEncoder;
		private var _extension:String = "png";
		
		public function Upload(url:String)
		{
			this.url = url;
			encoder = new PNGEncoder();
		}
		
		public function get extension():String
		{
			return _extension;
		}
		
		public function set extension(value:String):void
		{
			_extension = value;
		}
		
		protected function createEncoder():IImageEncoder
		{
			return new PNGEncoder();
		}
		
		public function save(name:String, screenshot:BitmapData):void
		{
			var image:ByteArray = encoder.encode(screenshot);
			var request:URLRequest = createRequest(name, image);
			sendToURL(request);
		}
		
		private function createRequest(name:String, image:ByteArray):URLRequest
		{
			var request:URLRequest = new URLRequest(url);
				request.requestHeaders.push(new URLRequestHeader("Content-type", "application/octet-stream"));
				request.requestHeaders.push(new URLRequestHeader("X-File-Name", name + "." + extension));
				request.method = "POST";
				request.data = image;
			
			return request;
		}
		
	}
}
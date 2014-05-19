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
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class Upload implements Save
	{
		
		private var url:String;
		private var encoder:IImageEncoder;
		private var extension:String;
		
		public function Upload(url:String, extension:String = "png", encoder:IImageEncoder = null)
		{
			this.url = url;
			this.extension = extension;
			this.encoder = encoder || createEncoderByExtension();
		}
		
		public function save(name:String, screenshot:BitmapData):void
		{
			var image:ByteArray = encoder.encode(screenshot);
			var request:URLRequest = createRequest(name, image);
			sendToURL(request);
		}
		
		private function createEncoderByExtension():IImageEncoder
		{
			var encoder:IImageEncoder;
			
			switch (extension) {
				case "png": encoder = new PNGEncoder(); break;
				case "jpg": encoder = new JPEGEncoder(); break;
				default: throw new ArgumentError("Invalid extension " + extension + " given. Only png and jpg are supported.");
			}
			
			return encoder;
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
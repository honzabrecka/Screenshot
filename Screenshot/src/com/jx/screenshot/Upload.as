/*
Screenshot util for integration testing of ui components
Copyright 2013 Jan Břečka. All Rights Reserved.

This program is free software. You can redistribute and/or modify it
in accordance with the terms of the accompanying license agreement.
*/

package com.jx.screenshot
{
	import flash.display.BitmapData;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
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
		
		public static const PNG_EXTENSION:String = "png";
		public static const JPEG_EXTENSION:String = "jpg";
		
		private var url:String;
		private var encoder:IImageEncoder;
		private var extension:String;
		
		public function Upload(url:String, extension:String = PNG_EXTENSION, encoder:IImageEncoder = null)
		{
			this.url = url;
			this.extension = extension;
			this.encoder = encoder || createEncoderByExtension();
		}
		
		public function save(name:String, screenshot:BitmapData):void
		{
			var image:ByteArray = encoder.encode(screenshot);
			var request:URLRequest = createRequest(name, image);
			new URLLoader().load(request);
		}
		
		private function createEncoderByExtension():IImageEncoder
		{
			var encoder:IImageEncoder;
			
			switch (extension) {
				case PNG_EXTENSION: encoder = new PNGEncoder(); break;
				case JPEG_EXTENSION: encoder = new JPEGEncoder(); break;
				default: throw new ArgumentError("Invalid extension " + extension + " given. Only " + PNG_EXTENSION + " and " + JPEG_EXTENSION + " are supported.");
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
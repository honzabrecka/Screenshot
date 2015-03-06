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
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.IImageEncoder;
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	
	/**
	 * Everytime it's complete - can be dispatched multiple times.
	 */
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class Upload extends EventDispatcher implements Save
	{
		
		public static const PNG_EXTENSION:String = "png";
		public static const JPEG_EXTENSION:String = "jpg";
		
		private var url:String;
		private var encoder:IImageEncoder;
		private var extension:String;
		private var activeLoaders:uint = 0;
		
		public function Upload(url:String, extension:String = PNG_EXTENSION, encoder:IImageEncoder = null)
		{
			this.url = url;
			this.extension = extension;
			this.encoder = encoder || createEncoderByExtension();
		}
		
		public function save(name:String, screenshot:BitmapData):void
		{
			function onComplete(event:Event):void
			{
				destroy(event.target);
			}
			
			function onError(event:Event):void
			{
				trace("Unable to upload to", url, ". Please, make sure your server is running.");
				destroy(event.target);
			}
			
			function destroy(loader:URLLoader):void
			{
				loader.removeEventListener(Event.COMPLETE, onComplete);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				loader = null;
				
				if (--activeLoaders == 0) {
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
			
			var image:ByteArray = encoder.encode(screenshot);
			var request:URLRequest = createRequest(name, image);
			var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, onComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				activeLoaders++;
				loader.load(request);
		}
		
		public function get pending():uint
		{
			return activeLoaders;
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
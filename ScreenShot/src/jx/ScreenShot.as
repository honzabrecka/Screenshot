/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package jx
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
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
	
	public class ScreenShot
	{
		
		public static var dictionary:LoadQueue;
		
		/**
		 * Are we in testing or upload mode.
		 */
		
		public static var uploadMode:Boolean = false;
		public static var uploadUrl:String = "";
		
		public function ScreenShot()
		{
			throw new IllegalOperationError("Can't be instantiated.");
		}
		
		/**
		 * Compare screen shot with component.
		 * 
		 * <p>Before use this method you have to set <code>screenLoader</code> property.</p>
		 * 
		 * @return Return true when the component looks exactly the same as is on screen shot.
		 */
		
		public static function compare(name:String, component:DisplayObject):Boolean
		{
			var screen:BitmapData = new BitmapData(component.width, component.height);
				screen.draw(component);
			
			if (uploadMode)
			{
				uploadScreen(name, screen);
				return true;
			}
			
			var originalScreen:BitmapData = dictionary.getScreen(name);
			
			if (!originalScreen) return false;
			
			return compareBitmapData(originalScreen, screen);
		}
		
		/**
		 * Compare two bitmap data, pixel by pixel.
		 * @return Return true when bitmap data are exactly the same.
		 */
		
		public static function compareBitmapData(original:BitmapData, test:BitmapData):Boolean
		{
			var originalPixels:Vector.<uint> = original.getVector(original.rect);
			var testPixels:Vector.<uint> = test.getVector(test.rect);
			
			if (originalPixels.length == testPixels.length)
			{
				for (var i:uint = 0; i < originalPixels.length; i++)
				{
					if (originalPixels[i] != testPixels[i])
					{
						return false;
					}
				}
				
				return true;
			}
			
			return false;
		}
		
		private static function uploadScreen(name:String, screen:BitmapData):void
		{
			var image:ByteArray = new PNGEncoder().encode(screen);
			
			var request:URLRequest = new URLRequest(uploadUrl);
				request.requestHeaders.push(new URLRequestHeader("Content-type", "application/octet-stream"));
				request.requestHeaders.push(new URLRequestHeader("X-File-Name", name + ".png"));
				request.method = "POST";
				request.data = image;
			
			var loader:URLLoader = new URLLoader()
				loader.addEventListener(Event.COMPLETE, function(event:Event):void
				{
					if (loader.data != "done") trace(loader.data);
				});
				loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event):void
				{
					trace(event);
				});
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:Event):void
				{
					trace(event);
				});
				loader.load(request);
		}
		
	}
}
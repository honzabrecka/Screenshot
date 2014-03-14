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

	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class ScreenShot
	{
		
		public static var dictionary:Object;
		public static var save:Save;
		
		public function ScreenShot()
		{
			throw new IllegalOperationError("Can't be instantiated.");
		}
		
		public static function compare(name:String, component:DisplayObject):Boolean
		{
			var screen:BitmapData = new BitmapData(component.width, component.height);
				screen.draw(component);
			
			if (save) {
				save.save(name, screen);
				return true;
			}
			
			if (!dictionary) {
				throw new IllegalOperationError("You have to set the dictionary first.");
			}
			
			var originalScreen:BitmapData = dictionary[name];
			
			if (!originalScreen) {
				return false;
			}
			
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
			
			if (originalPixels.length == testPixels.length) {
				for (var i:uint = 0; i < originalPixels.length; i++) {
					if (originalPixels[i] != testPixels[i]) {
						return false;
					}
				}
				
				return true;
			}
			
			return false;
		}
		
	}
}
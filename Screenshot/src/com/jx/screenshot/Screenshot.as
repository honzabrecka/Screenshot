/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package com.jx.screenshot
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class Screenshot
	{
		
		public static const INCLUDE_BOUNDS:Boolean = true;
		
		public static var dictionary:Object;
		public static var save:Save;
		public static var comparator:Comparator;
		public static var resizer:Resizer;
		
		public function Screenshot()
		{
			throw new IllegalOperationError("Can't be instantiated.");
		}
		
		public static function compare(fixtureName:String, component:DisplayObject, includeBounds:Boolean = false):Boolean
		{
			checkPreconditions();
			comparator = comparator || new NativeComparator(save);
			resizer = resizer || new Resizer();
			
			var matrix:Matrix;
			var newWidth:uint = component.width;
			var newHeight:uint = component.height;
			
			if (includeBounds) {
				var bounds:Rectangle = component.getBounds(component);
				
				matrix = new Matrix();
				matrix.translate(-1 * bounds.x, -1 * bounds.y);
				
				newWidth = bounds.width;
				newHeight = bounds.height;
			}
			
			var screenshot:BitmapData = new BitmapData(newWidth, newHeight);
				screenshot.draw(component, matrix);
			var resizedScreenshot:BitmapData = resizer.resize(screenshot);
			var originalScreen:BitmapData = dictionary[fixtureName];
			
			// for manual comparison
			save.save(fixtureName + "-actual", resizedScreenshot);
			
			return comparator.compare(fixtureName, originalScreen, resizedScreenshot);
		}
		
		private static function checkPreconditions():void
		{
			if (!dictionary) {
				throw new IllegalOperationError("You have to set the dictionary first.");
			}
			
			if (!save) {
				throw new IllegalOperationError("You have to set the save first.");
			}
		}
		
	}
}
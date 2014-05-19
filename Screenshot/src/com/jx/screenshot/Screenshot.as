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
		
		public static const CREATION:uint = 0;
		public static const COMPARISON:uint = 1;
		
		public static var dictionary:Object;
		public static var save:Save;
		public static var comparer:Comparer;
		public static var resizer:Resizer;
		public static var phase:uint = COMPARISON;
		public static var includeBounds:Boolean = false;
		
		public function Screenshot()
		{
			throw new IllegalOperationError("Can't be instantiated.");
		}
		
		public static function compare(name:String, component:DisplayObject):Boolean
		{
			checkPreconditions();
			comparer = comparer || new NativeComparer(save);
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
			
			// for manual comparison
			save.save(name + "-actual", resizedScreenshot);
			
			if (phase == CREATION) {
				save.save(name, resizedScreenshot);
				return true;
			}
			
			var originalScreen:BitmapData = dictionary[name];
			trace("---", name);
			return comparer.compare(name, originalScreen, resizedScreenshot);
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
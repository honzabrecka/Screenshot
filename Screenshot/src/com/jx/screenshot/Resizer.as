/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package com.jx.screenshot
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class Resizer
	{
		
		/**
		 * Max size of BitmapData.
		 */
		private static const DEFAULT_MAX_SIZE:uint = 2880;
		
		private var _maxSize:uint;
		
		public function Resizer(maxSize:uint = DEFAULT_MAX_SIZE)
		{
			this.maxSize = maxSize;
		}
		
		public function get maxSize():uint
		{
			return _maxSize;
		}
		
		public function set maxSize(value:uint):void
		{
			if (value < 1 || value > DEFAULT_MAX_SIZE) {
				throw new ArgumentError("MaxSize has to be between 1 and " + DEFAULT_MAX_SIZE + ".");
			}
			
			_maxSize = value;
		}
		
		public function resize(original:BitmapData):BitmapData
		{
			if (original.width > maxSize || original.height > maxSize) {
				var newWidth:uint = original.width;
				var newHeight:uint = original.height;
				var ratio:Number = original.width / original.height;
				var scale:Number = 1;
				
				if (newWidth > maxSize) {
					newWidth = maxSize;
					newHeight = newWidth / ratio;
					scale = newWidth / original.width;
				}
				
				if (newHeight > maxSize) {
					newHeight = maxSize;
					newWidth = newHeight * ratio;
					scale = newHeight / original.height;
				}
				
				var matrix:Matrix = new Matrix();
					matrix.scale(scale, scale);
				var resized:BitmapData = new BitmapData(newWidth, newHeight);
					resized.draw(original, matrix, null, null, null, true);
				
				return resized;
			}
			
			return original;
		}
		
	}
}
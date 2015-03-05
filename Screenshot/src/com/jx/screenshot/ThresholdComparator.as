/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package com.jx.screenshot
{
	import flash.display.BitmapData;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class ThresholdComparator implements Comparator
	{
		
		private var threshold:uint;
		
		public function ThresholdComparator(threshold:uint)
		{
			this.threshold = threshold;
		}
		
		public function compare(name:String, expected:BitmapData, actual:BitmapData):Boolean
		{
			if (!expected) {
				throw new Error("Fixture '" + name + "' was not found.");
			}
			
			return actual && checkSize(expected, actual) && checkPixels(expected, actual);
		}
		
		private function checkSize(expected:BitmapData, actual:BitmapData):Boolean
		{
			return expected.width == actual.width && expected.height == actual.height;
		}
		
		private function checkPixels(expected:BitmapData, actual:BitmapData):Boolean
		{
			for (var i:uint = 0; i < expected.width; i++) {
				for (var j:uint = 0; j < expected.height; j++) {
					if (Math.abs(expected.getPixel32(i, j) - actual.getPixel32(i, j)) > threshold) {
						return false;
					}
				}
			}
			
			return true;
		}
		
	}
}
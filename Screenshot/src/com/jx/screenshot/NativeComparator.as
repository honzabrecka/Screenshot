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
	
	public class NativeComparator implements Comparator
	{
		
		private var save:Save;
		
		public function NativeComparator(save:Save)
		{
			this.save = save;
		}
		
		public function compare(name:String, expected:BitmapData, actual:BitmapData):Boolean
		{
			if (!expected) {
				throw new Error("Fixture '" + name + "' was not found.");
			}
			
			if (!actual) {
				return false;
			}
			
			var diff:Object = expected.compare(actual);
			
			if (diff == 0) {
				// bitmaps are the same
				return true;
			} else if (diff is BitmapData) {
				
				
				// for manual comparison (diff)
				save.save(name + "-diff", BitmapData(diff));
			}
			
			return false;
		}
		
	}
}
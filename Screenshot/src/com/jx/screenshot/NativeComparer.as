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
	
	public class NativeComparer implements Comparer
	{
		
		private var save:Save;
		
		public function NativeComparer(save:Save)
		{
			this.save = save;
		}
		
		public function compare(name:String, original:BitmapData, actual:BitmapData):Boolean
		{
			if (!original || !actual) {
				return false;
			}
			
			var diff:Object = original.compare(actual);
			
			if (diff == 0) {
				// same
				return true;
			} else if (diff is BitmapData) {
				// for manual compare (diff)
				save.save(name + "-diff", BitmapData(diff));
				return false;
			}
			
			return false;
		}
		
	}
}
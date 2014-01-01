/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.jx
{
	import flash.display.BitmapData;
	
	import jx.Save;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class TestSave implements Save
	{
		
		public var saveCalledCount:uint = 0;
		public var name:String;
		public var screenShot:BitmapData;
		
		public function TestSave() { }
		
		public function save(name:String, screenShot:BitmapData):void
		{
			saveCalledCount++;
			this.name = name;
			this.screenShot = screenShot;
		}
		
	}
}
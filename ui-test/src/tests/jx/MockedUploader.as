/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.jx
{
	import flash.display.BitmapData;
	
	import jx.Uploader;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class MockedUploader extends Uploader
	{
		
		public var uploadCalled:uint = 0;
		
		public function MockedUploader(url:String)
		{
			super(url);
		}
		
		override public function upload(name:String, screen:BitmapData):void
		{
			uploadCalled++;
		}
		
	}
}
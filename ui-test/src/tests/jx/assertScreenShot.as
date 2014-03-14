/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.jx
{
	import flash.display.DisplayObject;
	
	import flexunit.framework.Assert;
	
	import jx.Screenshot;
	
	/**
	 * Component with its screen shot assertion helper
	 * 
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public function assertScreenshot(screenShotName:String, displayObject:DisplayObject):void
	{
		Assert.assertTrue(Screenshot.compare(screenShotName, displayObject));
	}
	
}
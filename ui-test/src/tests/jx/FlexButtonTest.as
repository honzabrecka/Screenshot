/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.jx
{
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	
	import org.flexunit.async.Async;
	
	import tests.TestCase;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class FlexButtonTest extends TestCase
	{
		
		private var button:Button;
		
		[Before(async)]
		public function setUp():void
		{
			button = new Button();
			Async.proceedOnEvent(this, button, FlexEvent.CREATION_COMPLETE);
			FlexGlobals.topLevelApplication.addElement(button);
		}
		
		[After(async)]
		public function tearDown():void
		{
			FlexGlobals.topLevelApplication.removeElement(button);
			button = null;
		}
		
		[Test(async)]
		public function labelAndSize():void
		{
			button.width = 100;
			button.height = 40;
			button.label = "Hello";
			
			waitToTest(function(event:Event, data:Object):void
			{
				assertScreenShot("FlexButtonTest.labelAndSize", button);
			});
		}
		
	}
}
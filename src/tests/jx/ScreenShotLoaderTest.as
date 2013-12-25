/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.jx
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import flexunit.framework.Assert;
	
	import jx.ScreenShotLoader;
	
	import org.flexunit.async.Async;
	import tests.TestCase;

	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class ScreenShotLoaderTest extends TestCase
	{
		
		public function ScreenShotLoaderTest()
		{
			super();
		}
		
		private var loader:ScreenShotLoader;
		
		[Before]
		public function setUp():void
		{
			loader = new ScreenShotLoader("../data/");
		}
		
		[After]
		public function tearDown():void
		{
			loader = null;
		}
		
		[Test(expects="ArgumentError")]
		public function emptyQueueArgument():void
		{
			loader.load(null);
		}
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function loadWhileLoading():void
		{
			var queue:Vector.<String> = new <String>["a", "b", "c"];
			loader.load(queue);
			loader.load(queue);
		}
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function getFromNonready():void
		{
			loader.getScreen("nonready");
		}
		
		[Test(async)]
		public function completeEvent():void
		{
			Async.handleEvent(this, loader, Event.COMPLETE, completeEvent_asyncHandler);
			
			var queue:Vector.<String> = new <String>["a", "b", "c"];
			loader.load(queue);
		}
		
		private function completeEvent_asyncHandler(event:Event, data:Object):void
		{
			Assert.assertTrue(loader.getScreen("a") is BitmapData);
			Assert.assertNull(loader.getScreen("undefinedScreen"));
		}
		
	}
}
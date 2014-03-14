/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.com.jx.screenshot
{
	import com.jx.screenshot.Save;
	import com.jx.screenshot.Screenshot;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import flexunit.framework.Assert;
	
	import jx.Square;
	
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	
	import tests.TestCase;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class ScreenshotTest extends TestCase
	{
		
		[Embed(source="../../../../../data/SquareTest.defaultColor.png")]
		private static const SquareScreen:Class;
		
		private var square:Square;
		private var save:TestSave;
		
		private static var tempDictionary:Object;
		private static var tempSaver:Save;
		
		[BeforeClass]
		public static function setUpClass():void
		{
			tempDictionary = Screenshot.dictionary;
			tempSaver = Screenshot.save;
		}
		
		[AfterClass]
		public static function tearDownClass():void
		{
			Screenshot.dictionary = tempDictionary;
			Screenshot.save = tempSaver;
		}
		
		[Before(async, ui)]
		public function setUp():void
		{
			square = new Square();
			
			save = new TestSave();
			Screenshot.save = save;
			
			Screenshot.dictionary = {};
			Screenshot.dictionary["Square"] = Bitmap(new SquareScreen()).bitmapData;
			Screenshot.phase = Screenshot.COMPARE;
			
			Async.proceedOnEvent(this, square, Event.ADDED);
			UIImpersonator.addChild(square);
		}
		
		[After(async, ui)]
		public function tearDown():void
		{
			Screenshot.dictionary = null;
			Screenshot.save = null;
			
			UIImpersonator.removeChild(square);
			square = null;
		}
		
		[Test(async, expects="flash.errors.IllegalOperationError")]
		public function missingDictionary():void
		{
			Screenshot.dictionary = null;
			Screenshot.compare("whatever, because dictionary is null...", square);
		}
		
		[Test(async, expects="flash.errors.IllegalOperationError")]
		public function missingSave():void
		{
			Screenshot.save = null;
			Screenshot.compare("whatever, because save is null...", square);
		}
		
		[Test(async)]
		public function compareGood():void
		{
			Assert.assertTrue(Screenshot.compare("Square", square));
		}
		
		[Test(async)]
		public function compareBad():void
		{
			square.color = 0x0000ff;
			Assert.assertFalse(Screenshot.compare("Square", square));
		}
		
		[Test(async)]
		public function compareInCreationPhase():void
		{
			Screenshot.phase = Screenshot.CREATION;
			Assert.assertTrue(Screenshot.compare("Square", square));
			Assert.assertEquals(2, save.saveCalledCount);
			Assert.assertEquals("Square", save.name);
			Assert.assertNotNull(save.screenShot);
		}
		
		[Test(async)]
		public function saveActual():void
		{
			Assert.assertTrue(Screenshot.compare("Square", square));
			Assert.assertEquals(1, save.saveCalledCount);
			Assert.assertEquals("Square-actual", save.name);
			Assert.assertNotNull(save.screenShot);
		}
		
	}
}
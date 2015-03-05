/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.com.jx.screenshot
{
	import com.jx.screenshot.Comparator;
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
		
		[Embed(source="../../../../../fixtures/SquareTest.defaultColor.png")]
		private static const SquareScreen:Class;
		
		private var square:Square;
		private var save:TestSave;
		
		private static var tempDictionary:Object;
		private static var tempSaver:Save;
		private static var tempComparator:Comparator;
		
		[BeforeClass]
		public static function setUpClass():void
		{
			tempDictionary = Screenshot.dictionary;
			tempSaver = Screenshot.save;
			tempComparator = Screenshot.comparator;
		}
		
		[AfterClass]
		public static function tearDownClass():void
		{
			Screenshot.dictionary = tempDictionary;
			Screenshot.save = tempSaver;
			Screenshot.comparator = tempComparator;
		}
		
		[Before(async, ui)]
		public function setUp():void
		{
			square = new Square();
			
			save = new TestSave();
			Screenshot.save = save;
			
			Screenshot.dictionary = {};
			Screenshot.dictionary["Square"] = Bitmap(new SquareScreen()).bitmapData;
			Screenshot.resizer = null;
			
			Async.proceedOnEvent(this, square, Event.ADDED);
			UIImpersonator.addChild(square);
		}
		
		[After(ui)]
		public function tearDown():void
		{
			Screenshot.dictionary = null;
			Screenshot.save = null;
			
			UIImpersonator.removeChild(square);
			square = null;
		}
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function cannotBeInstantiated():void
		{
			new Screenshot();
		}
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function missingDictionary():void
		{
			Screenshot.dictionary = null;
			Screenshot.compare("whatever, because dictionary is null...", square);
		}
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function missingSave():void
		{
			Screenshot.save = null;
			Screenshot.compare("whatever, because save is null...", square);
		}
		
		[Test]
		public function compareGood():void
		{
			Assert.assertTrue(Screenshot.compare("Square", square));
		}
		
		[Test]
		public function compareBad():void
		{
			square.color = 0x0000ff;
			Assert.assertFalse(Screenshot.compare("Square", square));
		}
		
		[Test]
		public function saveActual():void
		{
			Assert.assertTrue(Screenshot.compare("Square", square));
			Assert.assertEquals(1, save.saveCalledCount);
			Assert.assertEquals("Square-actual", save.name);
			Assert.assertNotNull(save.screenshot);
		}
		
		[Test]
		public function includeBounds():void
		{
			redrawSquare(5, -20, 1, 1);
			Assert.assertTrue(Screenshot.compare("Square", square, Screenshot.INCLUDE_BOUNDS));
		}
		
		[Test]
		public function doNotIncludeBounds():void
		{
			redrawSquare(5, -20, 1, 1);
			Assert.assertFalse(Screenshot.compare("Square", square));
		}
		
		private function redrawSquare(x:int, y:int, width:uint, height:uint):void
		{
			square.graphics.clear();
			square.graphics.beginFill(0);
			square.graphics.drawRect(x, y, width, height);
			square.graphics.endFill();
		}
		
	}
}
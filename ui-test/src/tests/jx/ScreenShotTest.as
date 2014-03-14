/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.jx
{
	import flash.display.Bitmap;
	
	import flexunit.framework.Assert;
	
	import jx.Save;
	import jx.ScreenShot;
	import jx.Square;
	
	import mx.events.FlexEvent;
	
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	
	import tests.TestCase;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class ScreenShotTest extends TestCase
	{
		
		[Embed(source="../../../data/SquareTest.defaultColor.png")]
		private static const SquareScreen:Class;
		
		private var square:Square;
		private var save:TestSave;
		
		private static var tempDictionary:Object;
		private static var tempSaver:Save;
		
		[BeforeClass]
		public static function setUpClass():void
		{
			tempDictionary = ScreenShot.dictionary;
			tempSaver = ScreenShot.save;
		}
		
		[AfterClass]
		public static function tearDownClass():void
		{
			ScreenShot.dictionary = tempDictionary;
			ScreenShot.save = tempSaver;
		}
		
		[Before(async, ui)]
		public function setUp():void
		{
			square = new Square();
			
			save = new TestSave();
			ScreenShot.save = save;
			
			ScreenShot.dictionary = {};
			ScreenShot.dictionary["Square"] = Bitmap(new SquareScreen()).bitmapData;
			ScreenShot.phase = ScreenShot.COMPARE;
			
			Async.proceedOnEvent(this, square, FlexEvent.CREATION_COMPLETE);
			UIImpersonator.addChild(square);
		}
		
		[After(async, ui)]
		public function tearDown():void
		{
			ScreenShot.dictionary = null;
			ScreenShot.save = null;
			
			UIImpersonator.removeChild(square);
			square.clear();
			square = null;
		}
		
		[Test(async, expects="flash.errors.IllegalOperationError")]
		public function missingDictionary():void
		{
			ScreenShot.dictionary = null;
			ScreenShot.compare("whatever, because dictionary is null...", square);
		}
		
		[Test(async, expects="flash.errors.IllegalOperationError")]
		public function missingSave():void
		{
			ScreenShot.save = null;
			ScreenShot.compare("whatever, because save is null...", square);
		}
		
		[Test(async)]
		public function compareGood():void
		{
			Assert.assertTrue(ScreenShot.compare("Square", square));
		}
		
		[Test(async)]
		public function compareBad():void
		{
			square.color = 0x0000ff;
			Assert.assertFalse(ScreenShot.compare("Square", square));
		}
		
		[Test(async)]
		public function compareInCreationPhase():void
		{
			ScreenShot.phase = ScreenShot.CREATION;
			Assert.assertTrue(ScreenShot.compare("Square", square));
			Assert.assertEquals(2, save.saveCalledCount);
			Assert.assertEquals("Square", save.name);
			Assert.assertNotNull(save.screenShot);
		}
		
		[Test(async)]
		public function saveActual():void
		{
			Assert.assertTrue(ScreenShot.compare("Square", square));
			Assert.assertEquals(1, save.saveCalledCount);
			Assert.assertEquals("Square-actual", save.name);
			Assert.assertNotNull(save.screenShot);
		}
		
		[Test(async)]
		public function saveActualAndDiff():void
		{
			square.color = 0xffff00;
			
			Assert.assertFalse(ScreenShot.compare("Square", square));
			Assert.assertEquals(2, save.saveCalledCount);
			Assert.assertEquals("Square-diff", save.name);
			Assert.assertNotNull(save.screenShot);
		}
		
		
	}
}
/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.jx
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import mx.events.FlexEvent;
	
	import flexunit.framework.Assert;
	
	import jx.Save;
	import jx.ScreenShot;
	import jx.Square;
	
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	
	import tests.TestCase;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class ScreenShotTest extends TestCase
	{
		
		[Embed(source="../../../data/a.png")]
		private static const A:Class;
		
		[Embed(source="../../../data/b.png")]
		private static const B:Class;
		
		[Embed(source="../../../data/c.png")]
		private static const C:Class;
		
		[Embed(source="../../../data/Square.png")]
		private static const SquareScreen:Class;
		
		public function ScreenShotTest()
		{
			super();
		}
		
		private var a:BitmapData;
		private var b:BitmapData;
		private var c:BitmapData;
		private var square:Square;
		
		private static var tempDictionary:Dictionary;
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
			a = Bitmap(new A()).bitmapData;
			b = Bitmap(new B()).bitmapData;
			c = Bitmap(new C()).bitmapData;
			square = new Square();
			
			ScreenShot.dictionary = new Dictionary();
			ScreenShot.dictionary["Square"] = Bitmap(new SquareScreen()).bitmapData;
			
			Async.proceedOnEvent(this, square, FlexEvent.CREATION_COMPLETE);
			UIImpersonator.addChild(square);
		}
		
		[After(async, ui)]
		public function tearDown():void
		{
			a.dispose();
			a = null;
			b.dispose();
			b = null;
			c.dispose();
			c = null;
			
			ScreenShot.dictionary = null;
			ScreenShot.save = null;
			
			UIImpersonator.removeChild(square);
			square.clear();
			square = null;
		}
		
		[Test]
		public function compareSameBitmapData():void
		{
			Assert.assertTrue(ScreenShot.compareBitmapData(a.clone(), a.clone()));
		}
		
		[Test]
		public function compareBitmapDataWithDifferentSize():void
		{
			Assert.assertFalse(ScreenShot.compareBitmapData(b.clone(), c.clone()));
		}
		
		[Test]
		public function compareBitmapDataWithDifferentColor():void
		{
			Assert.assertFalse(ScreenShot.compareBitmapData(a.clone(), b.clone()));
		}
		
		[Test(async, expects="flash.errors.IllegalOperationError")]
		public function missingDictionary():void
		{
			ScreenShot.dictionary = null;
			ScreenShot.compare("whatever, because dictionary is null...", square);
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
		public function upload():void
		{
			var uploader:TestSave = new TestSave();
			ScreenShot.save = uploader;
			
			Assert.assertTrue(ScreenShot.compare("Square", square));
			Assert.assertEquals(1, uploader.saveCalledCount);
			Assert.assertEquals("Square.png", uploader.name);
			Assert.assertNotNull(uploader.screenShot);
		}
		
	}
}
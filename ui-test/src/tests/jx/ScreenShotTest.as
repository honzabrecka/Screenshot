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
	
	import flexunit.framework.Assert;
	
	import jx.ScreenShot;
	import jx.Square;
	import jx.UIComponentEvent;
	
	import org.flexunit.async.Async;
	
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
		
		[Embed(source="../../../data/SquareTest.defaultColor.png")]
		private static const SquareScreen:Class;
		
		public function ScreenShotTest()
		{
			super();
		}
		
		private var a:BitmapData;
		private var b:BitmapData;
		private var c:BitmapData;
		private var square:Square;
		
		private static var tempScreenShotDictionary:Dictionary;
		
		[BeforeClass]
		public static function setUpClass():void
		{
			tempScreenShotDictionary = ScreenShot.dictionary;
		}
		
		[AfterClass]
		public static function tearDownClass():void
		{
			ScreenShot.dictionary = tempScreenShotDictionary;
		}
		
		[Before]
		public function setUp():void
		{
			a = Bitmap(new A()).bitmapData;
			b = Bitmap(new B()).bitmapData;
			c = Bitmap(new C()).bitmapData;
			square = new Square();
			
			ScreenShot.dictionary = new Dictionary();
			ScreenShot.dictionary["SquareTest.defaultColor"] = Bitmap(new SquareScreen()).bitmapData;
		}
		
		[After]
		public function tearDown():void
		{
			a.dispose();
			a = null;
			b.dispose();
			b = null;
			c.dispose();
			c = null;
			square = null;
			ScreenShot.dictionary = null;
			ScreenShot.uploader = null;
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
			Async.proceedOnEvent(this, square, UIComponentEvent.CREATION_COMPLETE);
			containerForUIComponent.addChild(square);
			ScreenShot.compare("whatever, because dictionary is null...", square);
		}
		
		[Test(async)]
		public function compareGood():void
		{
			Async.proceedOnEvent(this, square, UIComponentEvent.CREATION_COMPLETE);
			containerForUIComponent.addChild(square);
			Assert.assertTrue(ScreenShot.compare("SquareTest.defaultColor", square));
		}
		
		[Test(async)]
		public function compareBad():void
		{
			Async.proceedOnEvent(this, square, UIComponentEvent.CREATION_COMPLETE);
			containerForUIComponent.addChild(square);
			square.color = 0x0000ff;
			Assert.assertFalse(ScreenShot.compare("SquareTest.defaultColor", square));
		}
		
		[Test(async)]
		public function upload():void
		{
			var uploader:MockedUploader = new MockedUploader("");
			ScreenShot.uploader = uploader;
			Async.proceedOnEvent(this, square, UIComponentEvent.CREATION_COMPLETE);
			containerForUIComponent.addChild(square);
			Assert.assertTrue(ScreenShot.compare("SquareTest.defaultColor", square));
			Assert.assertEquals(1, uploader.uploadCalled);
		}
		
	}
}
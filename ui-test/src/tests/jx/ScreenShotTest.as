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
	
	import jx.Square;
	import jx.UIComponentEvent;
	import jx.ScreenShot;
	
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
		
		public function ScreenShotTest()
		{
			super();
		}
		
		private var a:Bitmap;
		private var b:Bitmap;
		private var c:Bitmap;
		private var square:Square;
		
		[Before]
		public function setUp():void
		{
			a = new A();
			b = new B();
			c = new C();
			square = new Square();
		}
		
		[After]
		public function tearDown():void
		{
			a = null;
			b = null;
			c = null;
			square = null;
		}
		
		[Test]
		public function compareSameBitmapData():void
		{
			Assert.assertTrue(ScreenShot.compareBitmapData(a.bitmapData.clone(), a.bitmapData.clone()));
		}
		
		[Test]
		public function compareBitmapDataWithDifferentSize():void
		{
			Assert.assertFalse(ScreenShot.compareBitmapData(b.bitmapData.clone(), c.bitmapData.clone()));
		}
		
		[Test]
		public function compareBitmapDataWithDifferentColor():void
		{
			Assert.assertFalse(ScreenShot.compareBitmapData(a.bitmapData.clone(), b.bitmapData.clone()));
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
		
	}
}
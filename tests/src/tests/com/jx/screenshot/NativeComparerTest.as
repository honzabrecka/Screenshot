/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.com.jx.screenshot
{
	import com.jx.screenshot.NativeComparer;
	
	import flash.display.BitmapData;
	
	import flexunit.framework.Assert;
	
	import tests.TestCase;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class NativeComparerTest extends TestCase
	{
		
		private var comparer:NativeComparer;
		private var save:TestSave;
		
		[Before]
		public function setUp():void
		{
			save = new TestSave();
			comparer = new NativeComparer(save);
		}
		
		[Test(expects="Error")]
		public function emptyOriginal():void
		{
			comparer.compare("", null, new BitmapData(1, 1));
		}
		
		[Test]
		public function emptyActual():void
		{
			Assert.assertFalse(comparer.compare("", new BitmapData(1, 1), null));
		}
		
		[Test]
		public function same():void
		{
			var data:BitmapData = new BitmapData(1, 1);
			Assert.assertTrue(comparer.compare("", data, data));
		}
		
		[Test]
		public function differentWidth():void
		{
			var original:BitmapData = new BitmapData(1, 1);
			var actual:BitmapData = new BitmapData(2, 1);
			Assert.assertFalse(comparer.compare("", original, actual));
		}
		
		[Test]
		public function differentHeight():void
		{
			var original:BitmapData = new BitmapData(1, 1);
			var actual:BitmapData = new BitmapData(1, 2);
			Assert.assertFalse(comparer.compare("", original, actual));
		}
		
		[Test]
		public function differentColor():void
		{
			var original:BitmapData = new BitmapData(1, 1);
			var actual:BitmapData = new BitmapData(1, 1, true, 0xff0000);
			Assert.assertFalse(comparer.compare("", original, actual));
			Assert.assertEquals(1, save.saveCalledCount);
			Assert.assertEquals("-diff", save.name);
			Assert.assertEquals(0xffffff, save.screenshot.getPixel(0, 0));
		}
		
	}
}
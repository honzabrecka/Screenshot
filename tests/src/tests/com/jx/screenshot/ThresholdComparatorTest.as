/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.com.jx.screenshot
{
	
	import com.jx.screenshot.ThresholdComparator;
	
	import flash.display.BitmapData;
	
	import flexunit.framework.Assert;
	
	import tests.TestCase;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class ThresholdComparatorTest extends TestCase
	{
		
		private var comparator:ThresholdComparator;
		
		[Before]
		public function setUp():void
		{
			comparator = new ThresholdComparator(0x010001);
		}
		
		[Test(expects="Error")]
		public function emptyOriginal():void
		{
			comparator.compare("", null, new BitmapData(1, 1));
		}
		
		[Test]
		public function emptyActual():void
		{
			Assert.assertFalse(comparator.compare("", new BitmapData(1, 1), null));
		}
		
		[Test]
		public function same():void
		{
			var data:BitmapData = new BitmapData(1, 1);
			Assert.assertTrue(comparator.compare("", data, data));
		}
		
		[Test]
		public function differentWidth():void
		{
			var original:BitmapData = new BitmapData(1, 1);
			var actual:BitmapData = new BitmapData(2, 1);
			Assert.assertFalse(comparator.compare("", original, actual));
		}
		
		[Test]
		public function differentHeight():void
		{
			var original:BitmapData = new BitmapData(1, 1);
			var actual:BitmapData = new BitmapData(1, 2);
			Assert.assertFalse(comparator.compare("", original, actual));
		}
		
		[Test]
		public function differentColorOut():void
		{
			var original:BitmapData = new BitmapData(1, 1);
			var actual:BitmapData = new BitmapData(1, 1, true, 0xff0000);
			Assert.assertFalse(comparator.compare("", original, actual));
		}
		
		[Test]
		public function differentColorOutSlightly():void
		{
			var original:BitmapData = new BitmapData(1, 0xE700E7);
			var actual:BitmapData = new BitmapData(1, 1, true, 0xE900E9);
			Assert.assertFalse(comparator.compare("", original, actual));
		}
		
		[Test]
		public function differentColorIn():void
		{
			var original:BitmapData = new BitmapData(1, 1, true, 0xDB00DB);
			var actual:BitmapData = new BitmapData(1, 1, true, 0xDA00DA);
			Assert.assertTrue(comparator.compare("", original, actual));
		}
		
		[Test]
		public function sameColor():void
		{
			var original:BitmapData = new BitmapData(1, 1, true, 0xDB00DB);
			var actual:BitmapData = new BitmapData(1, 1, true, 0xDB00DB);
			Assert.assertTrue(comparator.compare("", original, actual));
		}
		
	}
}
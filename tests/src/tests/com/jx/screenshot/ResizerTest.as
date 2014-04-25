/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.com.jx.screenshot
{
	import com.jx.screenshot.Resizer;
	
	import flash.display.BitmapData;
	
	import org.flexunit.asserts.assertEquals;
	
	import tests.TestCase;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class ResizerTest extends TestCase
	{
		
		private var resizer:Resizer;
		
		[Before]
		public function setUp():void
		{
			resizer = new Resizer(5);
		}
		
		[Test]
		public function bothWidthAndHeightSmallerThanMaxSize():void
		{
			var result:BitmapData = createAndResize(2, 3);
			assertEquals(2, result.width);
			assertEquals(3, result.height);
		}
		
		[Test]
		public function widthBiggerThanMaxSize():void
		{
			var result:BitmapData = createAndResize(10, 4);
			assertEquals(5, result.width);
			assertEquals(2, result.height);
		}
		
		[Test]
		public function heightBiggerThanMaxSize():void
		{
			var result:BitmapData = createAndResize(4, 10);
			assertEquals(2, result.width);
			assertEquals(5, result.height);
		}
		
		[Test(expects="ArgumentError")]
		public function invalidTooSmallMaxSize():void
		{
			new Resizer(0);
		}
		
		[Test(expects="ArgumentError")]
		public function invalidTooBigMaxSize():void
		{
			new Resizer(5000);
		}
		
		private function createAndResize(width:uint, height:uint):BitmapData
		{
			return resizer.resize(new BitmapData(width, height));
		}
		
	}
}
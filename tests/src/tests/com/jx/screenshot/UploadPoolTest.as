/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.com.jx.screenshot
{
	import flash.net.URLLoader;
	
	import flexunit.framework.Assert;
	
	import com.jx.screenshot.UploadPool;
	
	import tests.TestCase;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class UploadPoolTest extends TestCase
	{
		
		private var pool:UploadPool;
		
		[Before]
		public function setUp():void
		{
			pool = new UploadPool();
		}
		
		[Test]
		public function reusedAndNewInstance():void
		{
			var instance:URLLoader = new URLLoader();
			pool.disposeLoader(instance);
			
			Assert.assertTrue(instance === pool.getLoader());
			Assert.assertFalse(instance === pool.getLoader());
		}
		
	}
}
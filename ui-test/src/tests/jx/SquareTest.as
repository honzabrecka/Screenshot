/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.jx
{
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
	
	public class SquareTest extends TestCase
	{
		
		public function SquareTest()
		{
			super();
		}
		
		private var component:Square;
		
		[Before(async)]
		public function setUp():void
		{
			component = new Square();
			Async.proceedOnEvent(this, component, UIComponentEvent.CREATION_COMPLETE);
			containerForUIComponent.addChild(component);
		}
		
		[After(async)]
		public function tearDown():void
		{
			component.clear();
			containerForUIComponent.removeChild(component);
			component = null;
		}
		
		[Test(async)]
		public function defaultColor():void
		{
			
			Assert.assertEquals(0x000000, component.color);
			Assert.assertTrue(ScreenShot.compare("SquareTest.defaultColor", component));
		}
		
		[Test(async)]
		public function changedColor():void
		{
			component.color = 0xFF0000;
			Assert.assertEquals(0xFF0000, component.color);
			Assert.assertTrue(ScreenShot.compare("SquareTest.changedColor", component));
		}
		
	}
}
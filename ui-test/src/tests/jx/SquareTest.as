/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.jx
{
	import mx.events.FlexEvent;
	
	import flexunit.framework.Assert;
	
	import jx.Square;
	
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	
	import tests.TestCase;

	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class SquareTest extends TestCase
	{
		
		private var component:Square;
		
		[Before(async, ui)]
		public function setUp():void
		{
			component = new Square();
			Async.proceedOnEvent(this, component, FlexEvent.CREATION_COMPLETE);
			UIImpersonator.addChild(component);
		}
		
		[After(async, ui)]
		public function tearDown():void
		{
			component.clear();
			UIImpersonator.removeChild(component);
			component = null;
		}
		
		[Test(async)]
		public function defaultColor():void
		{
			
			Assert.assertEquals(0x000000, component.color);
			assertScreenShot("SquareTest.defaultColor", component);
		}
		
		[Test(async)]
		public function changedColor():void
		{
			component.color = 0xFF0000;
			Assert.assertEquals(0xFF0000, component.color);
			assertScreenShot("SquareTest.changedColor", component);
		}
		
	}
}
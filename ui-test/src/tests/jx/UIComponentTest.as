/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.jx
{
	import jx.UIComponent;
	import jx.UIComponentEvent;
	
	import org.flexunit.async.Async;
	import tests.TestCase;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class UIComponentTest extends TestCase
	{
		
		public function UIComponentTest()
		{
			super();
		}
		
		private var component:UIComponent;
		
		[Before]
		public function setUp():void
		{
			component = new UIComponent();
		}
		
		[After]
		public function tearDown():void
		{
			component.clear();
			component = null;
		}
		
		[Test(async)]
		public function creationCompleteEvent():void
		{
			Async.handleEvent(this, component, UIComponentEvent.CREATION_COMPLETE, null);
			containerForUIComponent.addChild(component);
		}
		
	}
}
/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package jx
{
	import flash.events.Event;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class UIComponentEvent extends Event
	{
		
		public static const CREATION_COMPLETE:String = "creationComplete";
		
		public function UIComponentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new UIComponentEvent(type, bubbles, cancelable);
		}
		
	}
}
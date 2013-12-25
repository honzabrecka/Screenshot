/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package jx
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	[Abstract]
	public class UIComponent extends Sprite
	{
		
		private var _childrenCreated:Boolean = false;
		
		public function UIComponent()
		{
			super();
			addEventListener(Event.ADDED, addedToStageHandler);
		}
		
		protected function get childrenCreated():Boolean
		{
			return _childrenCreated;
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED, addedToStageHandler);
			drawBackground();
			createChildren();
			_childrenCreated = true;
			dispatchEvent(new UIComponentEvent(UIComponentEvent.CREATION_COMPLETE));
		}
		
		protected function drawBackground():void
		{
			
		}
		
		protected function createChildren():void
		{
			
		}
		
		public function clear():void
		{
			removeEventListener(Event.ADDED, addedToStageHandler);
		}
		
		protected function invalidateDisplayList():void
		{
			
		}
		
	}
}
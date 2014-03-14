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
	
	public class Square extends Sprite
	{
		
		private var _color:uint = 0;
		
		public function Square()
		{
			super();
			addEventListener(Event.ADDED, addedHandler);
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			if (value == _color) return;
			
			_color = value;
			draw();
		}
		
		private function addedHandler(event:Event):void
		{
			removeEventListener(Event.ADDED, addedHandler);
			draw();
		}
		
		private function draw():void
		{
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(0, 0, 1, 1);
			graphics.endFill();
		}
		
	}
}
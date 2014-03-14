/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package jx
{
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class Square extends UIComponent
	{
		
		public function Square()
		{
			super();
		}
		
		private var _color:uint = 0;
		private var colorChanged:Boolean = false;
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			if (value != _color)
			{
				_color = value;
				colorChanged = true;
				invalidateDisplayList();
			}
		}
		
		override protected function drawBackground():void
		{
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(0, 0, 1, 1);
			graphics.endFill();
		}
		
		override protected function invalidateDisplayList():void
		{
			super.invalidateDisplayList();
			
			if (childrenCreated)
			{
				if (colorChanged)
				{
					colorChanged = false;
					drawBackground();
				}
			}
		}
		
	}
}
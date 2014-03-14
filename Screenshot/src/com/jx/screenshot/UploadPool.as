/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package com.jx.screenshot
{
	import flash.net.URLLoader;

	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class UploadPool
	{
		
		private var loaders:Vector.<URLLoader>;
		
		public function UploadPool()
		{
			loaders = new Vector.<URLLoader>();
		}
		
		public function getLoader():URLLoader
		{
			if (loaders.length > 0) {
				return loaders.pop();
			}
			
			return new URLLoader();
		}
		
		public function disposeLoader(instance:URLLoader):void
		{
			loaders.push(instance);
		}
		
	}
}
/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package jx
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class LoadQueue extends EventDispatcher
	{
		
		private var path:String;
		private var queue:Vector.<String>;
		private var _dictionary:Object;
		private var processing:Boolean = false;
		private var loaded:uint;
		private var failed:uint;
		private var loader:Loader;
		private var index:uint;
		
		public function LoadQueue(path:String)
		{
			this.path = path;
		}
		
		public function get dictionary():Object
		{
			if (!_dictionary) throw new IllegalOperationError("You have to call load method first.");
			return _dictionary;
		}
		
		public function load(queue:Vector.<String>):void
		{
			if (processing) throw new IllegalOperationError("Loading in progress. Wait until it's done.");
			if (!queue) throw new ArgumentError("Queue can't be empty.");
			this.queue = queue;
			
			_dictionary = {};
			loaded = 0;
			failed = 0;
			index = 0;
			processing = true;
			loadBitmap(currentPath);
		}
		
		private function loadBitmap(path:String):void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			loader.load(new URLRequest(path));
		}
		
		private function loader_completeHandler(event:Event):void
		{
			pushBitmap(queue[index], Bitmap(loader.content).bitmapData);
			loaded++;
			destroyLoader();
			loadNext();
		}
		
		private function loader_errorHandler(event:Event):void
		{
			pushBitmap(queue[index], null);
			failed++;
			destroyLoader();
			loadNext();
		}
		
		private function pushBitmap(name:String, image:BitmapData):void
		{
			_dictionary[name] = image;
		}
		
		private function destroyLoader():void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loader_completeHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			loader.unload();
		}
		
		private function loadNext():void
		{
			index++;
			
			if (index < queue.length)
			{
				loadBitmap(currentPath);
			}
			else
			{
				processing = false;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function get currentPath():String
		{
			return path + queue[index] + ".png";
		}
		
	}
}
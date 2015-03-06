/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests
{
	import com.jx.screenshot.Save;
	
	import flash.events.Event;
	
	import org.flexunit.listeners.CIListener;
	import org.flexunit.runner.Result;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class CIListener extends org.flexunit.listeners.CIListener
	{
		
		private var save:Save;
		
		override public function CIListener(save:Save, port:uint = DEFAULT_PORT, server:String = DEFAULT_SERVER)
		{
			super(port, server);
			this.save = save;
		}
		
		override public function testRunFinished(result:Result):void 
		{
			if (save.pending > 0) {
				save.addEventListener(Event.COMPLETE, function(event:Event):void
				{
					sendEnfOfTestRun();
				});
			} else {
				sendEnfOfTestRun();
			}
		}
		
		private function sendEnfOfTestRun():void
		{
			sendResults("<endOfTestRun/>");
		}
		
	}
}
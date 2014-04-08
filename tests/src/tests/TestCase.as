package tests
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flexunit.async.Async;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class TestCase
	{
		
		protected function waitToTest(listener:Function, waitTime:uint=0, passThroughData:Object=null):void
		{
			var asyncHandler:Function = Async.asyncHandler(this, listener, waitTime + 250, passThroughData);
			var timer:Timer = new Timer(waitTime, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, asyncHandler);
			timer.start();
		}
		
	}
}
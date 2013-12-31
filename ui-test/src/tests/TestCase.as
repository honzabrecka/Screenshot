package tests
{
	import flash.display.DisplayObjectContainer;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	
	import org.flexunit.async.Async;
	
	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class TestCase
	{
		
		public function TestCase()
		{
			super();
		}
		
		protected function waitToTest(listener:Function, waitTime:uint=0, passThroughData:Object=null):void
		{
			var asyncHandler:Function = Async.asyncHandler(this, listener, waitTime + 250, passThroughData);
			var timer:Timer = new Timer(waitTime, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, asyncHandler);
			timer.start();
		}
		
		protected function get containerForUIComponent():DisplayObjectContainer
		{
			return DisplayObjectContainer(FlexGlobals.topLevelApplication).stage;
		}
		
	}
}
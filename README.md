ScreenShot
==========

ScreenShot is the ActionScript 3 util for integration testing of ui components writen in pure ActionScript. It perfectly works with FlexUnit testing flow. Currently it doesn't support Flex Framework components.

## Use

First of all you have to prepare `ScreenShot` and `ScreenShotLoader`. Following code should be part of a Main.as file:

	// create new instance of ScreenShotLoader with path, where screens are stored
	ScreenShot.screenLoader = new ScreenShotLoader("../data/");
	// set upload url, where the new screen are uploaded
	ScreenShot.uploadUrl = "http://localhost/ui-test.php";
	// indicates if we are creating (true) or testing (false)
	ScreenShot.uploadMode = false;
	ScreenShot.screenLoader.addEventListener(Event.COMPLETE, screenLoader_completeHandler);
	// list of screens
	ScreenShot.screenLoader.load(new <String>["SquareTest.defaultColor", "SquareTest.changedColor"]);

	...

	private function screenLoader_completeHandler(event:Event):void
	{
		// here we start execute FlexUnit tests...
	}

Use in test case can look as follows:

	[Test(async)]
	public function defaultColor():void
	{
		var component:Square = new Square();
		Async.proceedOnEvent(this, component, UIComponentEvent.CREATION_COMPLETE);
		containerForUIComponent.addChild(component);
		Assert.assertEquals(0x000000, component.color);
		// if component looks exactly like screen, compare returns true
		Assert.assertTrue(ScreenShot.compare("SquareTest.defaultColor", component));
	}

When we run this test with `ScreenShot.uploadMode = true`, then generated screen shots are sent to `ScreenShot.uploadUrl` as png file stream. Php handles uploads, we check them and the good ones we copy to our "data" (`new ScreenShotLoader("../data/");`) direcotory. Then we can run with `ScreenShot.uploadMode = false` and see the results - each test should pass until we made some changes in our ui components...

## Example use

You can take a look at these classes for more information how to use this testing util:

 - `jx.Square`
 - `tests.jx.SquareTest`
 - `Main.mxml`
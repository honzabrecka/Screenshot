ScreenShot
==========

ScreenShot is the ActionScript 3 util for integration testing of ui components writen in pure ActionScript. It perfectly works with FlexUnit testing flow. Currently it doesn't support Flex Framework components.

## Use

At first of all you have to prepare `ScreenShot` and `LoadQueue` objects. Following code should be part of a Main.as file:

	private var queue:LoadQueue;
	...
	// create a new instance of the LoadQueue with path, where screens are stored
	queue = new LoadQueue("../data/");
	queue.addEventListener(Event.COMPLETE, screenLoader_completeHandler);
	// list of screens
	var list:Vector.<String> = new <String>
	[
		"SquareTest.defaultColor",
		"SquareTest.changedColor"
	];
	queue.load(list);
	...
	private function screenLoader_completeHandler(event:Event):void
	{
		ScreenShot.dictionary = queue.dictionary;
		// set the upload url
		ScreenShot.uploadUrl = "http://localhost/ui-test.php";
		// indicates if we are creating (true) or testing (false)
		ScreenShot.uploadMode = false;

		// here starts FlexUnit tests...
	}

FlexUnit 4 test:

	[Test(async)]
	public function defaultColor():void
	{
		var component:Square = new Square();
		Async.proceedOnEvent(this, component, UIComponentEvent.CREATION_COMPLETE);
		containerForUIComponent.addChild(component);
		Assert.assertEquals(0x000000, component.color);
		// Assert if the component looks like on the sreen shot
		Assert.assertTrue(ScreenShot.compare("SquareTest.defaultColor", component));
	}

When we run this test with `ScreenShot.uploadMode = true`, then generated screen shots are sent to the `ScreenShot.uploadUrl` as a png file stream. Php handles uploads, saves them to specified destination, where we check them and the good ones we copy to our "data" (`new LoadQueue("../data/");`) direcotory. Then we can run the tests with `ScreenShot.uploadMode = false` and see the results - each test should pass until we made some changes in our ui components...

You can take a look at these classes for more information how to use this testing util:

 - `jx.Square`
 - `tests.jx.SquareTest`
 - `Main.mxml`
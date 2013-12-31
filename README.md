ScreenShot
==========

ScreenShot is the ActionScript 3 util for integration testing of ui components. It perfectly works with FlexUnit testing flow and Flex Framwork ui components.

## Use

At first of all you have to prepare `ScreenShot`, `LoadQueue` and `Uploader` objects. Following code should be part of a Main.as file:

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
		// When ScreenShot.uploader is set, then screen shots aren't compared, but they
		// are sent to the server as a png stream.
		ScreenShot.uploader = new Uploader("http://localhost/ui-test.php");
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

When we run this test with `ScreenShot.uploader = new Uploader("...")`, then generated screen shots are sent to the server as a png file stream. Server handles uploads, saves them to the specified destination, where we check them and the good ones we copy to our "data" (`new LoadQueue("../data/");`) direcotory. Then we can run the tests with `ScreenShot.uploader = null` (or comment that line of code) and see the results - each test should pass until we made some changes in our ui components...

You can take a look at these classes for more information how to use this testing util:

 - `jx.Square`
 - `tests.jx.SquareTest`
 - `tests.jx.FlexButtonTest`
 - `Main.mxml`
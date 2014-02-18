ScreenShot
==========

ScreenShot is the ActionScript 3 util for integration testing of ui components. It perfectly works with FlexUnit testing flow and Flex Framework ui components.

## Lightweight and easy to use

ScreenShot has two phases. First is when screen shots are created. In this phase all your integration tests pass. Second phase is when components are compared with their screen shots generated in previous phase.

Let's start with the second one:

Current state of a component is compared with its screen shot, which can be embeded or loaded in runtime. The main magic happens in the full static `ScreenShot` class. First of all you have to set `ScreenShot.dictionary` to a `Dictionary` object. `Dictionary` is the simple key value storage. Key is a name and value is a `BitmapData`.

```as3
[Embed(source="SquareTest.defaultColor.png")]
private var SquareWithDefaultColor:Class;
...
ScreenShot.dictionary = new Dictionary();
ScreenShot.dictionary["SquareTest.defaultColor"] = Bitmap(new SquareWithDefaultColor()).bitmapData;
```

If you prefer to load screen shot in runtime, you can use the `LoadQueue` class:

```as3
// ../data/ is the path, where the screen shots are stored
var queue:LoadQueue = new LoadQueue("../data/");
	queue.addEventListener(Event.COMPLETE, function(event:Event):void
	{
		ScreenShot.dictionary = queue.dictionary;
	});
	// list of the screen shot, which will be loaded (name is without any extension!)
	queue.load(new <String>["SquareTest.defaultColor"]);
```

Use in test case is simple boolean assertion:

```as3
[Test(async, ui)]
public function defaultColor():void
{
	var component:Square = new Square();
	Async.proceedOnEvent(this, component, FlexEvent.CREATION_COMPLETE);
    UIImpersonator.addChild(component);
	// out assertion
	assertTrue(ScreenShot.compare("SquareTest.defaultColor", component));
}
```

Now you know how to use the `ScreenShot` class to test your components with their screen shots. But, we don't have them. Let's generate some. It will be much more easier than you would have expected. You don't have to change anything. Everything you have to do is set `ScreenShot.save` to anything else than `null`. And also it has to implement the `Save` interface. Once it's setted screen shots are generated.

```as3
// http://localhost/ui-test.php is the path, where the screen shots sent
ScreenShot.save = new Upload("http://localhost/upload.php");
```

It was easy, right? Now you can run your tests in phase one. Please note that all `ScreenShot.compare` tests will pass. Screen shot will be saved and you can continue with the second phase. Just comment the `ScreenShot.save = new Upload("http://localhost/upload.php");` line and run the test suite. All your tests should pass. Everything is done and ready, so you can start to make some changes...

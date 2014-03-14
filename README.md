Screenshot
==========

Screenshot is the ActionScript 3 util for integration testing of ui components. It perfectly works with FlexUnit testing flow and Flex Framework ui components.

## Fast, lightweight and easy to use

```as3
[Test(async, ui)]
public function defaultColor():void
{
	var component:Square = new Square();
	Async.proceedOnEvent(this, component, Event.ADDED);
    UIImpersonator.addChild(component);
	
	// this is the line!
	assertTrue(Screenshot.compare("SquareTest.defaultColor", component));
}
```

## Setup

At first of all you have to set `ScreenShot.dictionary` property, which is simple key value storage. It includes patterns (generated screenshots), that are compared with your ui component created at runtime. You can create it manually:

```as3
[Embed(source="SquareTest.defaultColor.png")]
private var SquareWithDefaultColor:Class;
...
ScreenShot.dictionary = {};
ScreenShot.dictionary["SquareTest.defaultColor"] = Bitmap(new SquareWithDefaultColor()).bitmapData;
```
or, which is much better and prefered way, use the default `LoadQueue` class, which loads screenshots at runtime and forwards its dictionary to `Screenshot.dictionary`:

```as3
// ../data/ is the path, where the screen shots are stored
var queue:LoadQueue = new LoadQueue("../data/");
	queue.addEventListener(Event.COMPLETE, function(event:Event):void
	{
		Screenshot.dictionary = queue.dictionary;
	});
	// list of the screenshots, which will be loaded (name is without any extension!)
	queue.load(new <String>["SquareTest.defaultColor"]);
```

Now you can load screenshots, but you don't have any yet. Let's create some, but before we can do it, we need to set the `Screenshot.save` property. We will use the default `Upload` class. It takes a print of your component and uploads it to server:

```as3
Screenshot.save = new Upload("http://localhost/upload.php");
```

> `Screenshot.save` is also used for uploading an "actual" and a "diff between an actual and and original state". It's useful for debugging.

Finally we have to choose the `Screenshot.phase`. The default one is `Screenshot.COMPARE`. In this phase the component is printed and this print is compared with screenshot previously generated (and stored, and checked by you, and loaded at runtime). The second one is `Screenshot.CREATION`. In this phase the component is printed and this print is saved via `Upload` to server (and stored, and checked, and pushed to repository).

So (I intentionally use singular):

`Screenshot.CREATION` phase generates screenshot from your tested component and save it to server. You have to check this screenshot and if it looks as you wich, mark it as pattern.

`Screenshot.COMPARE` phase loads screenshot (pattern) and compares actual look of component with it.

How you can see, it's simple and easy to use.

> `Screenshot` has another one property called `comparer`. If you aren't satisfied with default `NativeComparer`, you can write your own `Comparer`.

## Known issues

Sometimes you can see "Adobe Flash Player has stopped a potentially unsafe operation." error message when you run your test suite. To solve this, just add the swf file location to the trusted list in Adobe FlashPlayer Settings Manager in order to allow a local swf connect the internet.

## Best practices

### Naming

The best is the following format `<TestClassName>.<TestMethodName>`

### Huge set of components to test

If you have a lot of components to test, then you have a lot and lot of screenshots generated and can be griveous to create a list. I use following bash command `find . -name "*.png" -exec echo "\"{}\"," \; | sort | sed 's/\.png//' | sed 's/\.\///'`, which does heavy work by me.
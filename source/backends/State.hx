package backends;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import haxe.Timer;

class State extends FlxState
{
	var camOverlay:FlxCamera;

	public var currentFPS(default, null):Int;

	var overlayText:FlxText;
	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	#if TOUCH_CONTROLS
	public var mobilePad:MobilePad;

	public function addMobilePad(?DPad:String, ?Action:String) {
		if (mobilePad != null)
			removeMobilePad();

		mobilePad = new MobilePad(DPad, Action);
		add(mobilePad);

		mobilePad.alpha = 0.75;

		#if RESIZE_NORMAL_BUTTONS
		mobilePad.y = 120;
		#end
	}

	public function removeMobilePad() {
		if (mobilePad != null)
			remove(mobilePad);
	}

	public function addMobilePadCamera() {
		var camcontrol = new flixel.FlxCamera();
		camcontrol.bgColor.alpha = 0;
		FlxG.cameras.add(camcontrol, false);
		mobilePad.cameras = [camcontrol];
	}
	#end

	override public function create()
	{
		super.create();

		camOverlay = new FlxCamera();
		camOverlay.bgColor.alpha = 0;

		// FlxG.cameras.reset(camOverlay);
		FlxG.cameras.add(camOverlay, false);

		overlayText = new FlxText(12, 12, 0, "FPS: 0", 12);
		overlayText.font = Paths.font('Small');
		overlayText.scrollFactor.set();
		overlayText.cameras = [camOverlay];
		add(overlayText);
		currentFPS = 0;
		cacheCount = 0;
		currentTime = 0;
		times = [];

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.mouse.useSystemCursor = true;
		FlxG.autoPause = false;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		var now = Timer.stamp();

		times.push(now);

		while (times[0] < now - 1)
			times.shift();

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);

		overlayText.text = "FPS: " + times.length;
	}
}

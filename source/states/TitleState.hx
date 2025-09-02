package states;

import backends.Paths;
import backends.State;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class TitleState extends State
{
	var titleText:FlxText;

	override public function create()
	{
		super.create();

		#if TOUCH_CONTROLS
		MobileData.init();
		#end

		var titleImage:FlxSprite = new FlxSprite(0, 0, Paths.sprite('titleimage'));
		titleImage.scale.set(2, 2);
		titleImage.updateHitbox();
		titleImage.screenCenter();
		titleImage.scrollFactor.set();
		titleImage.active = false;
		add(titleImage);

		titleText = new FlxText(0, 355, 0, '[PRESS Z]', 16);
		titleText.font = Paths.font('Small');
		titleText.color = FlxColor.GRAY;
		titleText.alpha = 0.0001;
		titleText.screenCenter(X);
		titleText.scrollFactor.set();
		titleText.active = false;
		add(titleText);

		var versionText = new FlxText(5, FlxG.height - 18, 0, 'Vs Haxe (Haxe Fight) v' + Application.current.meta.get('version'), 16);
		versionText.font = Paths.font('Small');
		versionText.color = FlxColor.GRAY;
		versionText.scrollFactor.set();
		versionText.active = false;
		add(versionText);

		FlxG.sound.play(Paths.music('intronoise'), () -> titleText.alpha = 1);

		#if TOUCH_CONTROLS
		addMobilePad("NONE", "A");
		addMobilePadCamera();
		#end
	}

	override public function update(elapsed:Float)
	{
		if ((FlxG.keys.justPressed.Z #if TOUCH_CONTROLS || mobilePad.buttonA.justPressed #end) && titleText.alpha == 1)
			FlxG.switchState(new PlayState());
		else if (FlxG.keys.justPressed.F)
			FlxG.fullscreen = !FlxG.fullscreen;

		/* Butonların posiyonunu ayarlamadan önce kullanıyordum (ekrana tıklayınca oyunu başlatıyor)
		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				FlxG.switchState(new PlayState());
			}
		}
		#end
		*/

		super.update(elapsed);
	}
}

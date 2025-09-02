package backends;

import states.PlayState;
import flixel.addons.text.FlxTypeText;

class ActBar
{
	public var items:FlxTypedGroup<FlxTypeText>;
	public var textOption1:FlxTypeText;
	public var textOption2:FlxTypeText;
	public var textOption3:FlxTypeText;
	public var textOption4:FlxTypeText;
	public function new() {
		/* Hiçbirşey. Nedense bu fonksiyon olmadan `createAct` fonksiyonuna erişmeyi denediğimde `Null Object` Hatası Alıyorum
			Gerçi bu normal çünkü variable'ları oluşturmamış oluyorum teknik olarak -KralOyuncu2010x */
	}

	public function createDialog(texts:Array<String>, ?optionCount:Int = 1, ?skipTextAnim:Bool = false) {
		var createdOptions:Int = 0;
		var ins = PlayState.instance;
		items = new FlxTypedGroup<FlxTypeText>();
		for (text in texts) {
			createdOptions += 1;
			if (createdOptions == 1 && optionCount >= 1) {
				textOption1 = new FlxTypeText(ins.box.x + 14, ins.box.y + 14, Std.int(ins.box.width), '* ${text}', 32, true);
				addOption(textOption1, 0, skipTextAnim);
			} if (createdOptions == 2 && optionCount >= 2) {
				textOption2 = new FlxTypeText(ins.box.x + 364, ins.box.y + 14, Std.int(ins.box.width), '* ${text}', 32, true);
				addOption(textOption2, 1, skipTextAnim);
			} if (createdOptions == 3 && optionCount >= 3) {
				textOption3 = new FlxTypeText(ins.box.x + 14, ins.box.y + 64, Std.int(ins.box.width), '* ${text}', 32, true);
				addOption(textOption3, 2, skipTextAnim);
			} if (createdOptions == 4 && optionCount >= 4) {
				textOption4 = new FlxTypeText(ins.box.x + 364, ins.box.y + 64, Std.int(ins.box.width), '* ${text}', 32, true);
				addOption(textOption4, 3, skipTextAnim);
			}
		}
		PlayState.instance.add(items);
	}

	private function addOption(option:FlxTypeText, ID:Int, ?skipTextAnim:Bool = false) {
		var ins = PlayState.instance;
		option.font = Paths.font('DTM-Mono');
		option.sounds = [FlxG.sound.load(Paths.sound("txt2"), 0.86)];
		option.scrollFactor.set();
		option.cameras = [ins.camGame];
		items.add(option);
		if (skipTextAnim) {
			option.start(0.1, true);
			option.skip();
		} else {
			option.start(0.04, true);
		}
		option.ID = ID;
	}

	/* Some Basic Functions */
	public function changeText(number:Int, text:String, ?skip:Bool)
	{
		switch (number)
		{
			case 1:
				if (textOption1 != null) textOption1.resetText(text);
				if (skip) {
					textOption1.start(0.1, true);
					textOption1.skip();
				} else {
					textOption1.start(0.04, true);
				}
			case 2:
				if (textOption2 != null) textOption2.resetText(text);
				if (skip) {
					textOption2.start(0.1, true);
					textOption2.skip();
				} else {
					textOption2.start(0.04, true);
				}
			case 3:
				if (textOption3 != null) textOption3.resetText(text);
				if (skip) {
					textOption3.start(0.1, true);
					textOption3.skip();
				} else {
					textOption3.start(0.04, true);
				}
			case 4:
				if (textOption4 != null) textOption4.resetText(text);
				if (skip) {
					textOption4.start(0.1, true);
					textOption4.skip();
				} else {
					textOption4.start(0.04, true);
				}
		}
	}

	public function addAct() {
		PlayState.instance.add(items);
	}
	public function removeAct() {
		PlayState.instance.remove(items);
	}
	public function enableAct() {
		items.visible = true;
	}
	public function disableAct() {
		items.visible = false;
	}
}
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

	public function createMenu(?optionCount:Int = 1, ?skipTextAnim:Bool = false) {
		var createdOptions:Int = 0;
		var ins = PlayState.instance;
		items = new FlxTypedGroup<FlxTypeText>();
		/*
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
		*/
		for (i in 0...5) {
			createdOptions += 1;
			if (createdOptions == 1 && optionCount >= 1) {
				textOption1 = new FlxTypeText(ins.box.x + 14, ins.box.y + 14, Std.int(ins.box.width), '* example', 32, true);
				addOption(textOption1, 0, skipTextAnim);
			} if (createdOptions == 2 && optionCount >= 2) {
				textOption2 = new FlxTypeText(ins.box.x + 314, ins.box.y + 14, Std.int(ins.box.width), '* example', 32, true);
				addOption(textOption2, 1, skipTextAnim);
			} if (createdOptions == 3 && optionCount >= 3) {
				textOption3 = new FlxTypeText(ins.box.x + 14, ins.box.y + 54, Std.int(ins.box.width), '* example', 32, true);
				addOption(textOption3, 2, skipTextAnim);
			} if (createdOptions == 4 && optionCount >= 4) {
				textOption4 = new FlxTypeText(ins.box.x + 314, ins.box.y + 54, Std.int(ins.box.width), '* example', 32, true);
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
		if (skipTextAnim) startAndSkip(option);
		else option.start(0.04, true);
		option.ID = ID;
	}

	/* Some Basic Functions */
	public function changeText(number:Int, text:String, ?skip:Bool)
	{
		switch (number)
		{
			case 1:
				createOrChangeText(text, textOption1);
				if (skip) startAndSkip(textOption1);
				else textOption1.start(0.04, true);
			case 2:
				createOrChangeText(text, textOption2);
				if (skip) startAndSkip(textOption2);
				else textOption2.start(0.04, true);
			case 3:
				createOrChangeText(text, textOption3);
				if (skip) startAndSkip(textOption3);
				else textOption3.start(0.04, true);
			case 4:
				createOrChangeText(text, textOption4);
				if (skip) startAndSkip(textOption4);
				else textOption4.start(0.04, true);
		}
	}

	public function updateMenuItems(texts:Array<String>, ?skip:Bool = true)
	{
		//made them empty
		if (textOption1 != null) textOption1.resetText('');
		if (textOption2 != null) textOption2.resetText('');
		if (textOption3 != null) textOption3.resetText('');
		if (textOption4 != null) textOption4.resetText('');

		//now update the texts (missing ones will be empty)
		var createdOptions:Int = 0;
		for (text in texts) {
			createdOptions += 1;
			switch (createdOptions)
			{
				case 1:
					createOrChangeText(text, textOption1);
					if (skip) startAndSkip(textOption1);
					else textOption1.start(0.04, true);
				case 2:
					createOrChangeText(text, textOption2);
					if (skip) startAndSkip(textOption2);
					else textOption2.start(0.04, true);
				case 3:
					createOrChangeText(text, textOption3);
					if (skip) startAndSkip(textOption3);
					else textOption3.start(0.04, true);
				case 4:
					createOrChangeText(text, textOption4);
					if (skip) startAndSkip(textOption4);
					else textOption4.start(0.04, true);
			}
		}
	}

	function createOrChangeText(text:String, option:FlxTypeText) {
		if (text == '') option.resetText('${text}');
		else if (option != null) option.resetText('* ${text}');
	}

	function startAndSkip(option:FlxTypeText) {
		option.start(0.1, true);
		option.skip();
	}

	/* eski fonksiyonlar (visible'ı kullanmak daha az kafa karıştırıcı, o nedenle ona geçtim)
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
	*/

	public var visible(default, set):Bool;
	function set_visible(Value:Bool):Bool
	{
		items.visible = Value;
		return Value;
	}
}
package states;

import backends.Global;
import backends.Monster;
import backends.Paths;
import backends.State;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.addons.text.FlxTypeText;
import flixel.addons.util.FlxAsyncLoop;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import substates.GameOverSubState;
import flixel.util.FlxCollision;

class PlayState extends State
{
	public static var instance:PlayState;

	public var selected:Int = 0;

	final choices:Array<String> = ['Fight', 'Act', 'Item', 'Mercy'];

	public var items:FlxTypedGroup<FlxSprite>;

	public var stats:FlxText;
	public var hpName:FlxSprite;
	public var hpBar:FlxBar;
	public var hpInfo:FlxText;

	public var box:FlxShapeBox;
	public var heart:FlxSprite;

	public var targetSpr:FlxSprite;
	public var targetAttackerUnderlay:FlxSprite;
	public var targetAttackerBase:FlxSprite;
	public var targetChoiceTween:FlxTween;

	public var attacked:Bool = false;
	public var isDanmaku:Bool = false;

	public var dialogText:ActBar = new ActBar();
	public var defaultText:String;

	public var choiceSelected:Bool = false;
	public var choiceChoiced:Bool = false;

	public var monster:Monster;

	public var camGame:FlxCamera;
	public var camAttack:FlxCamera;

	/* benim eklediğim variable'lar */
	public var arrayChoiceSelected:Bool = false;
	public var arrayChoiceMenuOpened:Bool = false;
	public var attackFix:Bool = false; //basit bir fix
	public var arraySelected:Int = 0;

	// Attack Sistemi
	public var Attack1:Attack = new Attack();

	//Daha iyi act sistemi
	public var actPage:ActBar = new ActBar();
	public var actOptions:Array<String> = ['Fuck', 'This', 'Shit', 'Im out'];

	//Daha iyi item sistemi
	public var itemPage:ActBar = new ActBar();
	public var itemOptions:Array<String> = Global.items.copy();

	//Daha iyi mercy sistemi
	public var mercyPage:ActBar = new ActBar();
	public var mercyOptions:Array<String> = ['Mercy', 'Flee'];

	public var curArrayMenu:String = null;
	public var isDead:Bool = false; //ölümü kontrol etcek çünkü orjinal projeyi yapan mal yanlış yöntem kullanmış ve ektra kod eklemesi zor

	override public function create()
	{
		super.create();

		//Reset HP, If is it jot the same as the maximum one
		if (Global.hp != Global.maxHp)
			Global.hp = Global.maxHp;

		instance = this;

		camGame = new FlxCamera();
		camGame.bgColor.alpha = 0;

		FlxG.cameras.add(camGame, false);

		camAttack = new FlxCamera();
		camAttack.bgColor.alpha = 0;

		FlxG.cameras.add(camAttack, false);

		// Characters set
		monster = new Monster(0, 0, "Sans");

		stats = new FlxText(30, 400, 0, Global.name + '   LV ' + Global.lv, 22);
		stats.font = Paths.font('Small');
		stats.scrollFactor.set();
		stats.cameras = [camGame];
		add(stats);

		hpName = new FlxSprite(stats.x + 210, stats.y + 5, Paths.sprite('hpname'));
		hpName.scrollFactor.set();
		hpName.active = false;
		hpName.cameras = [camGame];
		//hpBar.emptyCallback = () -> openSubState(new GameOverSubState());
		add(hpName);

		hpBar = new FlxBar(hpName.x + 35, hpName.y - 5, LEFT_TO_RIGHT, Std.int(Global.maxHp * 1.2), 20, Global, 'hp', 0, Global.maxHp);
		hpBar.createFilledBar(FlxColor.RED, FlxColor.YELLOW);
		hpBar.scrollFactor.set();
		hpBar.cameras = [camGame];
		add(hpBar);

		hpInfo = new FlxText((hpBar.x + 15) + hpBar.width, hpBar.y, 0, Global.hp + ' / ' + Global.maxHp, 22);
		hpInfo.font = Paths.font('Small');
		hpInfo.scrollFactor.set();
		hpInfo.cameras = [camGame];
		add(hpInfo);

		items = new FlxTypedGroup<FlxSprite>();

		for (i in 0...choices.length)
		{
			var bt:FlxSprite = new FlxSprite(0, hpBar.y + 32, Paths.sprite(choices[i].toLowerCase() + 'bt_1'));

			switch (choices[i])
			{
				case 'Fight':
					bt.x = 32;
				case 'Act':
					bt.x = 185;
				case 'Item':
					bt.x = 345;
				case 'Mercy':
					bt.x = 500;
			}

			bt.scrollFactor.set();
			bt.cameras = [camGame];
			bt.ID = i;
			items.add(bt);
		}

		add(items);

		box = new FlxShapeBox(32, 250, 570, 135, {thickness: 6, jointStyle: MITER, color: FlxColor.WHITE}, FlxColor.BLACK);
		box.scrollFactor.set();
		box.active = false;
		box.cameras = [camGame];
		add(box);

		defaultText = 'You feel like you\'re going to\n  have a bad time.';
		dialogText.createMenu(1, false); //dialogs
		dialogText.updateMenuItems([defaultText], false);

		actPage.createMenu(4, true); //Create Act Options
		actPage.updateMenuItems(actOptions);
		actPage.visible = false; //disable Act Menu's visibility

		itemPage.createMenu(4, true);
		itemPage.updateMenuItems(itemOptions);
		itemPage.visible = false;

		mercyPage.createMenu(4, true);
		mercyPage.updateMenuItems(mercyOptions);
		mercyPage.visible = false;

		heart = new FlxSprite(0, 0, Paths.sprite('heart'));
		heart.color = FlxColor.RED;
		heart.scrollFactor.set();
		heart.active = false;
		heart.cameras = [camGame];
		add(heart);

		targetSpr = new FlxSprite(dialogText.textOption1.x - 2, dialogText.textOption1.y - 2, Paths.sprite('target'));
		targetSpr.scrollFactor.set();
		targetSpr.active = false;
		targetSpr.cameras = [camGame];
		targetSpr.visible = false;
		add(targetSpr);

		targetAttackerBase = new FlxSprite(dialogText.textOption1.x - 2, dialogText.textOption1.y - 10, Paths.sprite('targetchoice_1'));
		targetAttackerBase.scrollFactor.set();
		targetAttackerBase.cameras = [camGame];
		targetAttackerBase.visible = false;
		add(targetAttackerBase);

		targetAttackerUnderlay = new FlxSprite(dialogText.textOption1.x - 2, dialogText.textOption1.y - 10, Paths.sprite('targetchoice_0'));
		targetAttackerUnderlay.scrollFactor.set();
		targetAttackerUnderlay.cameras = [camGame];
		targetAttackerUnderlay.visible = false;
		add(targetAttackerUnderlay);

		//Test Saldırısı
		Attack1.createAttack('bone_normal', 0, 0, 2);
		Attack1.angle += 90;
		Attack1.cameras = [camGame];
		Attack1.y = box.y;
		Attack1.visible = false;

		changeChoice();
		choiceSelected = false;

		#if TOUCH_CONTROLS
		addMobilePad('FULL', 'A_B_C');
		addMobilePadCamera();
		#end

		FlxG.sound.playMusic(Paths.music('battle1'));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		// camGame.angle += 1;
		if (FlxG.keys.justPressed.ESCAPE #if TOUCH_CONTROLS || mobilePad.buttonC.justPressed #end)
			FlxG.switchState(new TitleState());

		if (!arrayChoiceMenuOpened) {
			if ((FlxG.keys.justPressed.LEFT #if TOUCH_CONTROLS || mobilePad.buttonLeft.justPressed #end) && !choiceSelected)
				changeChoice(-1);
			else if ((FlxG.keys.justPressed.RIGHT #if TOUCH_CONTROLS || mobilePad.buttonRight.justPressed #end) && !choiceSelected)
				changeChoice(1);
		}
		else
		{
			if ((FlxG.keys.justPressed.LEFT #if TOUCH_CONTROLS || mobilePad.buttonLeft.justPressed #end))
				changeChoice(-1);
			else if ((FlxG.keys.justPressed.RIGHT #if TOUCH_CONTROLS || mobilePad.buttonRight.justPressed #end))
				changeChoice(1);
			else if ((FlxG.keys.justPressed.RIGHT #if TOUCH_CONTROLS || mobilePad.buttonUp.justPressed #end))
				changeChoice(-2);
			else if ((FlxG.keys.justPressed.RIGHT #if TOUCH_CONTROLS || mobilePad.buttonDown.justPressed #end))
				changeChoice(2);
		}

		if (Global.hp <= 0 && !isDead) {
			isDead = true; //öldük gene amk :]
			openSubState(new GameOverSubState());
		}

		if (!choiceChoiced)
		{
			if (FlxG.keys.justPressed.Z #if TOUCH_CONTROLS || mobilePad.buttonA.justPressed #end)
			{
				FlxG.sound.play(Paths.sound('menuconfirm'));

				//A Multiple option menu after clicking Monster's name on act button
				if(arrayChoiceMenuOpened) { //The texts appear after the selecting the talk option or something
					switch (curArrayMenu) {
						case 'Act':
							actThing();
						case 'Item':
							itemThing();
						case 'Mercy':
							mercyThing();
					}
				}
				else if (arrayChoiceSelected) { //The function after the skipping the act text
					TriggerAttack();
				}
				else if (choiceSelected)
				{
					heart.visible = false;
					switch (choices[selected])
					{
						case 'Fight':
							targetAttackerUnderlay.x = dialogText.textOption1.x - 2;
							targetAttackerBase.x = dialogText.textOption1.x - 2;
							choiceChoiced = true;
							attackFix = true;
							dialogText.changeText(1, '', false);
							targetSpr.visible = true;
							targetAttackerBase.visible = true;
							trace("unun");
							targetChoiceTween = FlxTween.tween(targetAttackerBase, {x: box.width + 20, y: dialogText.textOption1.y - 10}, 2, {onComplete: function(tween:FlxTween):Void
								{
									attacked = false;
									targetAttackerUnderlay.visible = false;
									targetAttackerBase.visible = false;
									targetSpr.visible = false;
									TriggerAttack();
								}
							});
							targetChoiceTween.start();
						case 'Act':
							heart.visible = true;
							arrayChoiceMenuOpened = true;
							arraySelected = 0;
							dialogText.changeText(1, '', true);
							actPage.visible = true;
							changeChoice();
					}
				}
				else
				{
					if (choices[selected] == 'Item' && Global.items.length <= 0)
						return;

					choiceSelected = true;

					switch (choices[selected])
					{
						case 'Fight':
							heart.setPosition(box.x + 16, box.y + 26);
							dialogText.changeText(1, '${monster.data.name}', true);
						case 'Act':
							heart.setPosition(box.x + 16, box.y + 26);
							dialogText.changeText(1, '${monster.data.name}', true);
							curArrayMenu = 'Act';
						/*
						case 'Item':
							heart.setPosition(box.x + 16, box.y + 26);
							dialogText.changeText(1, 'Item Selected...', true);
						*/
						case 'Item':
							if (itemOptions != []) {
								heart.visible = true;
								arrayChoiceMenuOpened = true;
								curArrayMenu = 'Item';
								arraySelected = 0;
								dialogText.changeText(1, '', true);
								itemPage.visible = true;
								changeChoice();
							}
						case 'Mercy':
							heart.visible = true;
							arrayChoiceMenuOpened = true;
							curArrayMenu = 'Mercy';
							arraySelected = 0;
							dialogText.changeText(1, '', true);
							mercyPage.visible = true;
							changeChoice();
					}
				}
			}
			else if ((FlxG.keys.justPressed.X #if TOUCH_CONTROLS || mobilePad.buttonB.justPressed #end) && !arrayChoiceSelected)
			{
				if (arrayChoiceMenuOpened && curArrayMenu == 'Act') {
					heart.visible = true;
					arrayChoiceMenuOpened = false;
					actPage.visible = false;

					//Gerisi normal şeyler
					heart.setPosition(box.x + 16, box.y + 26);
					dialogText.changeText(1, '${monster.data.name}', true);
				}
				else if (choiceSelected || arrayChoiceMenuOpened) {
					//Sayfalar (menüler'de denebilir)
					itemPage.visible = false;
					mercyPage.visible = false;

					arrayChoiceMenuOpened = false;
					choiceSelected = false;
					changeChoice();

					dialogText.changeText(1, defaultText, false);
				}
			}
		}
		else
		{
			if ((FlxG.keys.justPressed.Z #if TOUCH_CONTROLS || mobilePad.buttonA.justPressed #end) && (!choiceChoiced || attackFix))
			{
				if (targetChoiceTween.active)
				{
					targetChoiceTween.cancel();
					attackFix = false;
					FlxG.sound.play(Paths.sound('slice'));
					targetAttackerUnderlay.x = targetAttackerBase.x;
					attacked = true;
					monster.health -= 10;
					new FlxTimer().start(1, (timer:FlxTimer) ->
					{
						attacked = false;
						targetAttackerUnderlay.visible = false;
						targetAttackerBase.visible = false;
						targetSpr.visible = false;
						startMonsterTurn();
					}, 1);
				}
			}
			else if (attacked)
			{
				targetAttackerUnderlay.visible = !targetAttackerUnderlay.visible;
			}
			else if (isDanmaku)
			{
				if (FlxG.keys.pressed.UP #if TOUCH_CONTROLS || mobilePad.buttonUp.pressed #end)
					heart.y -= Global.speed;
				if (FlxG.keys.pressed.DOWN #if TOUCH_CONTROLS || mobilePad.buttonDown.pressed #end)
					heart.y += Global.speed;
				if (FlxG.keys.pressed.LEFT #if TOUCH_CONTROLS || mobilePad.buttonLeft.pressed #end)
					heart.x -= Global.speed;
				if (FlxG.keys.pressed.RIGHT #if TOUCH_CONTROLS || mobilePad.buttonRight.pressed #end)
					heart.x += Global.speed;

				FlxSpriteUtil.bound(heart, box.x, (box.x + box.shapeWidth), box.y, (box.y + box.shapeHeight));
			}
		}

		//FlxG.overlap(heart, Attack1.AttackHitbox, handleOverlap);
		final overlaped = FlxCollision.pixelPerfectCheck(heart, Attack1.AttackHitbox);
		if (overlaped)
			handleOverlap(heart, Attack1.AttackImage);
	}

	private function changeChoice(num:Int = 0):Void
	{
		if (num != 0)
			FlxG.sound.play(Paths.sound('menumove'));

		/* Put Array Choise Things (Systems like Item or Act Menu) Here */
		if (arrayChoiceMenuOpened)
		{
			var currentPage:Dynamic = null;
			if (curArrayMenu == 'Act') currentPage = actPage;
			else if (curArrayMenu == 'Item') currentPage = itemPage;
			else if (curArrayMenu == 'Mercy') currentPage = mercyPage;

			var currentOptionsLength:Int = 0;
			if (curArrayMenu == 'Act') currentOptionsLength = actOptions.length;
			else if (curArrayMenu == 'Item') currentOptionsLength = itemOptions.length;
			else if (curArrayMenu == 'Mercy') currentOptionsLength = mercyOptions.length;

			arraySelected = FlxMath.wrap(arraySelected + num, 0, currentOptionsLength - 1);

			currentPage.items.forEach(function(spr:FlxTypeText)
			{
				if (spr.ID == arraySelected)
				{
					switch(spr.ID)
					{
						case 0:
							heart.setPosition(box.x + 16, box.y + 26);
						case 1:
							heart.setPosition(box.x + 316, box.y + 26);
						case 2:
							heart.setPosition(box.x + 16, box.y + 66);
						case 3:
							heart.setPosition(box.x + 316, box.y + 66);
					}
				}
			});
		}
		else
		{
			selected = FlxMath.wrap(selected + num, 0, choices.length - 1);

			items.forEach(function(spr:FlxSprite)
			{
				if (spr.ID == selected)
				{
					spr.loadGraphic(Paths.sprite(choices[spr.ID].toLowerCase() + 'bt_0'));

					heart.setPosition(spr.x + 8, spr.y + 14);
				}
				else
					spr.loadGraphic(Paths.sprite(choices[spr.ID].toLowerCase() + 'bt_1'));
			});
		}
	}

	/* Benim Orjinal Projenin üstüne eklediğim extra fonksiyonlar, karışmasınlar diye ayırdım */
	public function handleOverlap(player:FlxSprite, object:FlxSprite):Void
	{
		// Eğer nesne hala aktifse (daha önce çarpışılmadıysa)
		if (object.visible) {
			Global.hp -= 1;
			hpInfo.text = '${Global.hp} / ${Global.maxHp}';
			FlxG.sound.play(Paths.sound('hurtsound')); //Hasar aldığını anlamak için ses (flicker'da eklicem daha sonra)
		}
	}

	private function actThing()
	{
		switch (actOptions[arraySelected])
		{
			case 'Fuck':
				actPage.visible = false;
				arrayChoiceMenuOpened = false;
				heart.visible = false;
				dialogText.changeText(1, 'Fuck This Shit We\'re out', false);
				arrayChoiceSelected = true;
		}
	}

	private function itemThing()
	{
		var itemExist:Bool = false; //check item existing
		switch (itemOptions[arraySelected])
		{
			case 'Pie':
				var eatText:String = 'You ate the Pie,\nyou recovered 99 HP';
				Global.hp += 99;
				if (Global.hp > Global.maxHp) {
					Global.hp = Global.maxHp;
					eatText = 'You ate the Pie,\nyour HP is maxed';
				}
				hpInfo.text = '${Global.hp} / ${Global.maxHp}';
				itemPage.visible = false;
				arrayChoiceMenuOpened = false;
				heart.visible = false;
				dialogText.changeText(1, eatText, false);
				arrayChoiceSelected = true;
				itemExist = true;
		}
		if (itemExist) {
			itemOptions.remove(itemOptions[arraySelected]); //remove item after the use it (separated from Global.items for easier testing)
			itemPage.updateMenuItems(itemOptions); //Update current items
		}
	}

	private function mercyThing()
	{
		switch (mercyOptions[arraySelected])
		{
			case 'Flee':
				mercyPage.visible = false;
				arrayChoiceMenuOpened = false;
				//heart.visible = false;
				dialogText.changeText(1, 'You escaped from sans', false);
				arrayChoiceSelected = true;
				if (Global.hp >= 98) heart.visible = false;
				Global.hp -= 98; //1 HP Lol
				hpInfo.text = '${Global.hp} / ${Global.maxHp}';
		}
	}

	private function TriggerAttack()
	{
		heart.visible = false;
		attacked = false;
		dialogText.changeText(1, '', true);
		arrayChoiceSelected = false;
		choiceChoiced = true;
		startMonsterTurn();
	}

	//Starts the monster's turn (I make it as function because I'll make `startPlayerTurn` too)
	public function startMonsterTurn() {
		var boxTween:FlxTween = FlxTween.tween(box, {x: 248.875, shapeWidth: box.shapeHeight}, 0.5, {
			onComplete: function(tween:FlxTween):Void
			{
				changeChoice();
				heart.x = ((box.x - box.offset.x) + box.shapeWidth / 2) - heart.width;
				heart.y = ((box.x - box.offset.y) + box.shapeWidth / 2) - heart.height;
				heart.visible = true;
				isDanmaku = true;
				startAttack();
			}
		});
		boxTween.start();
	}

	public function startPlayerTurn():Void {
		heart.visible = false;
		attacked = false;
		//reset the variables
		arrayChoiceSelected = false;
		arrayChoiceMenuOpened = false;
		arraySelected = 0;
		choiceChoiced = false;
		choiceSelected = false;
		var boxTween:FlxTween = FlxTween.tween(box, {x: 32, shapeWidth: box.firstShapeWidth}, 0.5, {
			onComplete: function(tween:FlxTween):Void
			{
				changeChoice();
				dialogText.changeText(1, defaultText, false);
				heart.visible = true;
				isDanmaku = false;
			}
		});
		boxTween.start();
	}

	function startAttack() {
		Attack1.x = 0;
		Attack1.visible = true;
		FlxTween.tween(Attack1, {x: 640}, 5);
		new FlxTimer().start(7.0, function(timer:FlxTimer) {
			startPlayerTurn();
		});
	}
}

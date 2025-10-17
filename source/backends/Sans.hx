package backends;

import backends.Paths;
import flixel.group.FlxSpriteGroup;
import haxe.Json;
import openfl.utils.Assets;
import backends.Monster;
import states.PlayState;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Sans extends FlxSpriteGroup
{
	public var data(default, null):MonsterData;
	public var body:FlxSprite;
	public var head:FlxSprite;
	public var torso:FlxSprite;
	public var legs:FlxSprite;
	
	public var baseBody:FlxSpriteGroup;
	public var animatedBody:FlxSpriteGroup;

	// başlangıç pozisyonları
	var headBaseX:Float;
	var headBaseY:Float;
	var bodyBaseX:Float;
	var bodyBaseY:Float;

	var t:Float = 0;

	public function new(x:Float = 0, y:Float = 0, name:String):Void
	{
		super(x, y);
		baseBody = new FlxSpriteGroup();
		animatedBody = new FlxSpriteGroup();

		body = new FlxSprite(x, y + 25);
		body.frames = Paths.getSparrowAtlas('SansBody/Sans_Body');
		body.cameras = [PlayState.instance.camGame];
		if (x == 0) body.screenCenter(X); //center the sprite
		add(body);

		//basic anims
		body.animation.addByPrefix('handUp', 'handUp00', 24);
		body.animation.addByPrefix('handDown', 'handDown00', 24);
		body.animation.addByPrefix('handLeft', 'handLeft00', 24);
		body.animation.addByPrefix('handRight', 'handRight00', 24);
		body.animation.play('idle');

		torso = new FlxSprite(x, y + 45, Paths.sprite('SansTorso/Default/000'));
		torso.cameras = [PlayState.instance.camGame];
		if (x == 0) torso.screenCenter(X); //center the sprite
		add(torso);

		legs = new FlxSprite(x, y + 95, Paths.sprite('SansLegs/Standing/000'));
		legs.cameras = [PlayState.instance.camGame];
		if (x == 0) legs.screenCenter(X); //center the sprite
		add(legs);

		head = new FlxSprite(x, y, Paths.sprite('SansHead/Default/000'));
		head.cameras = [PlayState.instance.camGame];
		if (x == 0) head.screenCenter(X); //center the sprite
		add(head);

		//easy management
		animatedBody.add(body);
		baseBody.add(torso);
		baseBody.add(head);

		scale.set(2, 2);

		data = {
			name: name,
			health: 200,
			maxHealth: 200,
			attack: 0,
			defense: 0,
			xpReward: 0,
			goldReward: 0
		};

		// Base pozisyonları kaydet
		headBaseX = head.x;
		headBaseY = head.y;
		bodyBaseX = torso.x;
		bodyBaseY = torso.y;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		t += elapsed;

		// --- Bob parametreleri ---
		var bodyBobAmp = 2.0;
		var headBobAmp = 2.0;
		var bobSpeed = 1.0;

		// Bob hareketleri (her biri ayrı)
		torso.y = bodyBaseY + Math.sin(t * bobSpeed * Math.PI * 2) * bodyBobAmp;
		head.y = headBaseY + Math.sin((t + 0.1) * bobSpeed * Math.PI * 2) * headBobAmp; // biraz faz farkı

		// Hafif jitter (opsiyonel)
		var jitter = Math.sin(t * 6.0) * 0.4;
		torso.x = bodyBaseX + jitter;
		head.x = headBaseX + jitter * 0.6;
	}
}














/*
class SansIdleRig extends FlxSpriteGroup
{
	public var body:FlxSprite;
	public var head:FlxSprite;
	public var feet:FlxSprite;

	public function new(x:Float, y:Float, headPath:String, bodyPath:String, feetPath:String)
	{
		super(x, y);

		feet = new FlxSprite(0, 0, feetPath);
		body = new FlxSprite(0, -feet.height + 1, bodyPath);
		head = new FlxSprite((body.width -  headPathWidth(headPath)) * 0.5, -body.height - 2, headPath);

		// Pivotları merkeze al ki dönüş doğal olsun
		for (s in [feet, body, head]) {
			s.origin.set(s.width * 0.5, s.height * 0.5);
		}
		// Ayaklar sabit kalsın istiyoruz -> group’a ekleniş sırası görsel üst üste binmeyi belirler
		add(feet);
		add(body);
		add(head);
	}

	
}

*/
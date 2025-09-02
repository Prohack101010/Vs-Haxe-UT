package backends;

import states.PlayState;

/* Tek Bir Çağrıda Hem AttackImage'i Hemde AttackHitbox'ı oluşturur
	AtackHitbox yerine sadede AttackImage Kullanılabilir ancak böylesi daha iyi */
class Attack
{
	public var AttackImage:FlxSprite;
	public var AttackHitbox:FlxSprite;
	public function new() {
		/* Hiçbirşey. Nedense bu fonksiyon olmadan `createAttack` fonksiyonuna erişmeyi denediğimde `Null Object` Hatası Alıyorum
			Gerçi bu normal çünkü variable'ları oluşturmamış oluyorum teknik olarak -KralOyuncu2010x */
	}

	public function createAttack(sprite:String, x:Float, y:Float, scale:Float, ?customWidth:Int, ?customHeight:Int) {
		AttackImage = new FlxSprite(x, y, Paths.sprite(sprite));

		AttackImage.scrollFactor.set();
		AttackImage.cameras = [PlayState.instance.camAttack];
		AttackImage.scale.set(scale, scale);
		PlayState.instance.add(AttackImage);

		if (customWidth == null) customWidth = Std.int(AttackImage.width);
		if (customHeight == null) customHeight = Std.int(AttackImage.height);

		AttackHitbox = new FlxSprite(x, y).makeGraphic(customWidth, customHeight);

		AttackHitbox.scrollFactor.set();
		AttackHitbox.cameras = [PlayState.instance.camAttack];
		AttackHitbox.scale.set(scale, scale);
		AttackHitbox.alpha = 0.4; //This is hitbox of the object (for custom hitboxes)
		PlayState.instance.add(AttackHitbox);

		/* `this` class'daki değeri almak için kullanılıyor, normal olan ise fonksiyondaki x/y'dir */
		this.x = x;
		this.y = y;
		this.angle = AttackImage.angle;
		this.visible = AttackImage.visible;
	}

	/* bazı basit şeyler için */
	public var x(default, set):Float;
	function set_x(Value:Float):Float
	{
		AttackImage.x = Value;
		AttackHitbox.x = Value;

		return Value;
	}

	public var y(default, set):Float;
	function set_y(Value:Float):Float
	{
		AttackImage.y = Value;
		AttackHitbox.y = Value;

		return Value;
	}

	public var angle(default, set):Float;
	function set_angle(Value:Float):Float
	{
		AttackImage.angle = Value;
		AttackHitbox.angle = Value;

		//Fix Hitbox
		AttackImage.updateHitbox();
		AttackHitbox.updateHitbox();

		return Value;
	}

	public var visible(default, set):Bool;
	function set_visible(Value:Bool):Bool
	{
		AttackImage.visible = Value;
		AttackHitbox.visible = Value;

		return Value;
	}

	public var cameras(default, set):Array<FlxCamera>;
	function set_cameras(Value:Array<FlxCamera>):Array<FlxCamera>
	{
		AttackImage.cameras = Value;
		AttackHitbox.cameras = Value;

		return Value;
	}
}
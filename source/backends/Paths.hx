package backends;

import flixel.FlxG;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import haxe.Exception;
import haxe.io.Path;
import openfl.utils.Assets;

typedef SheetData =
{
	animation:String,
	path:String,
	frames:Array<Int>
}

class Paths
{
	/* mobil assetler için şimdilik kullandığım dizin
		(büyük ihtimal sonradan normal assetler ile mobil klasörü ayıracağım ama şimdilik iş görür) */
	public static inline function mobile(key:String):String
	{
		return 'assets/mobile/$key';
	}

	public static function excludeAsset(key:String) {
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

	public static var dumpExclusions:Array<String> =
	[
	];

	public static function clearUnusedMemory() {
		// tracked assets listesinde ve local asset olmayan assetleri temizle
		for (key in currentTrackedAssets.keys()) {
			// eğer şu anda kullanılan local assets içerisinde yer almıyorsa temizle
			if (!localTrackedAssets.contains(key)
				&& !dumpExclusions.contains(key)) {
				// get rid of it
				var obj = currentTrackedAssets.get(key);
				@:privateAccess
				if (obj != null) {
					openfl.Assets.cache.removeBitmapData(key);
					FlxG.bitmap._cache.remove(key);
					obj.destroy();
					currentTrackedAssets.remove(key);
				}
			}
		}
		// run the garbage collector for good measure lmfao
		System.gc();
	}

	// yerel olarak izlenen varlıkları tanımlama (define the locally tracked assets)
	public static var localTrackedAssets:Array<String> = [];
	public static function clearStoredMemory(?cleanUnused:Bool = false) {
		// clear anything not in the tracked assets list
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key)) {
				openfl.Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}

		// clear all sounds that are cached
		/*
		for (key in currentTrackedSounds.keys()) {
			if (!localTrackedAssets.contains(key)
			&& !dumpExclusions.contains(key) && key != null) {
				//trace('test: ' + dumpExclusions, key);
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}
		*/
		// flags everything to be cleared out next unused memory clear
		localTrackedAssets = [];
		openfl.Assets.cache.clear("songs");
	}

	inline static public function image(key:String, ?library:String, ?extraLoad:Bool = false):FlxGraphic
	{
		// streamlined the assets process more
		var returnAsset:FlxGraphic = returnGraphic(key, library, extraLoad);
		return returnAsset;
	}

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static function returnGraphic(key:String, ?library:String, ?extraLoad:Bool = false) {
		var path = getPath('images/$key.png', IMAGE, library);
		var normalPath = getPath('$key.png', IMAGE, library);
		//trace(path);
		if (Assets.exists(path, IMAGE)) {
			if(!currentTrackedAssets.exists(path)) {
				var newGraphic:FlxGraphic = FlxG.bitmap.add(path, false, path);
				newGraphic.persist = true;
				currentTrackedAssets.set(path, newGraphic);
			}
			localTrackedAssets.push(path);
			return currentTrackedAssets.get(path);
		}
		else if (Assets.exists(normalPath, IMAGE)) {
			if(!currentTrackedAssets.exists(normalPath)) {
				var newGraphic:FlxGraphic = FlxG.bitmap.add(normalPath, false, normalPath);
				newGraphic.persist = true;
				currentTrackedAssets.set(normalPath, newGraphic);
			}
			localTrackedAssets.push(normalPath);
			return currentTrackedAssets.get(normalPath);
		}
		trace('returnGraphic returned null: $key');
		return null;
	}

	public static function getPath(file:String, ?type:AssetType = TEXT, ?library:Null<String> = null, ?modsAllowed:Bool = false)
	{
		if (library != null)
			return getLibraryPath(file, library);

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library, library);
	}

	inline static function getLibraryPathForce(file:String, library:String, ?level:String)
	{
		if(level == null) level = library;
		var returnPath = '$library:assets/$level/$file';
		return returnPath;
	}

	public static inline function getPreloadPath(key:String):String
	{
		return 'assets/$key';
	}

	public static inline function script(key:String):String
	{
		return 'assets/data/$key.hxs';
	}

	public static inline function data(key:String):String
	{
		return 'assets/data/$key.json';
	}

	public static inline function room(key:String):String
	{
		return 'assets/data/$key.xml';
	}

	public static inline function music(key:String):String
	{
		return 'assets/music/$key.ogg';
	}

	public static inline function sound(key:String):String
	{
		return 'assets/sounds/$key.wav';
	}

	public static inline function background(key:String):String
	{
		//return Paths.image('backgrounds/$key'); //background isteklerini image fonksiyonuna çevir (eski yöntem)
		return 'assets/images/backgrounds/$key.png'; //orjinalini kullanmak şimdilik mantıklı olacaktır ancak eski yöntem modlar için daha iyi
	}

	public static inline function sprite(key:String):String
	{
		//return Paths.image('sprites/$key'); //sprite isteklerini image fonksiyonuna çevir (eski yöntem)
		return 'assets/images/sprites/$key.png';
	}

	public static inline function spriteOG(key:String):String
	{
		return 'assets/images/sprites/$key';
	}

	public static function font(key:String):String
	{
		final path:String = 'assets/fonts/$key.ttf';

		try
		{
			if (Assets.exists(path, FONT))
				return Assets.getFont(path).fontName;
			else if (Assets.exists(Path.withoutExtension(path), FONT))
				return Assets.getFont(Path.withoutExtension(path)).fontName;
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	public static inline function shader(key:String):String
	{
		try
		{
			return Assets.getText('assets/shaders/$key');
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	public static function spritesheet(data:{key:String, sheet:Array<SheetData>}):FlxAtlasFrames
	{
		if (data == null)
			return null;

		var atlas:FlxAtlas = new FlxAtlas(Paths.sprite(data.key), FlxPoint.weak(0, 0), FlxPoint.weak(0, 0));

		for (sheet in data.sheet)
		{
			for (frame in sheet.frames)
			{
				final path:String = Paths.sprite(sheet.path + '_$frame');

				if (Assets.exists(path, IMAGE))
					atlas.addNode(Assets.getBitmapData(path, false), sheet.animation + frame);
				else
					atlas.addNode('flixel/images/logo/default.png', sheet.animation + frame);
			}
		}

		return atlas.getAtlasFrames();
	}
}

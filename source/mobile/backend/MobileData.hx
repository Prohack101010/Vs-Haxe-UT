package mobile.backend;

import haxe.ds.Map;
import haxe.Json;
import haxe.io.Path;
import openfl.utils.Assets;
// Openfl'deki ile çakışmasın diye `LimeAssets` adıyla importladım -KralOyuncu2010x
import lime.utils.Assets as LimeAssets;
import flixel.util.FlxSave;

class MobileData
{
	public static var actionModes:Map<String, MobileButtonsData> = new Map();
	public static var dpadModes:Map<String, MobileButtonsData> = new Map();

	public static var save:FlxSave;

	public static function init()
	{
		save = new FlxSave();
		save.bind('MobileControls', CoolUtil.getSavePath());

		readDirectory(Paths.mobile('MobileButton/DPadModes'), dpadModes);
		readDirectory(Paths.mobile('MobileButton/ActionModes'), actionModes);
	}

	static function readDirectory(folder:String, map:Dynamic)
	{
		folder = folder.contains(':') ? folder.split(':')[1] : folder;

		for (file in readDirectoryPaths(folder))
		{
			var fileWithNoLib:String = file.contains(':') ? file.split(':')[1] : file;
			if (Path.extension(fileWithNoLib) == 'json')
			{
				file = Path.join([folder, Path.withoutDirectory(file)]);
				var str = Assets.getText(file);
				var json:MobileButtonsData = cast Json.parse(str);
				var mapKey:String = Path.withoutDirectory(Path.withoutExtension(fileWithNoLib));
				map.set(mapKey, json);
			}
		}
	}

	public static function readDirectoryPaths(directory:String):Array<String>
	{
		var dirs:Array<String> = [];
		for(dir in Assets.list().filter(folder -> folder.startsWith(directory)))
		{
			@:privateAccess
			for(library in lime.utils.Assets.libraries.keys())
			{
				if(library != 'default' && Assets.exists('$library:$dir') && (!dirs.contains('$library:$dir') || !dirs.contains(dir)))
					dirs.push('$library:$dir');
				else if(Assets.exists(dir) && !dirs.contains(dir))
					dirs.push(dir);
			}
		}
		return dirs;
	}
}

typedef MobileButtonsData =
{
	buttons:Array<ButtonsData>
}

typedef ButtonsData =
{
	button:String, // what MobileButton should be used, must be a valid MobileButton var from MobilePad as a string.
	graphic:String, // the graphic of the button, usually can be located in the MobilePad xml.
	x:Float, // the button's X position on screen.
	y:Float, // the button's Y position on screen.
	color:String, // the button color, default color is white.
	bg:String // the button background for MobilePad, default background is `bg`.
}
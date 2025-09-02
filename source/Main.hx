package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween.TweenOptions;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.AsyncErrorEvent;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import states.TitleState;
import states.PlayState;

using StringTools;

// crash handler stuff
#if ErrorDialog
import haxe.CallStack;
import haxe.io.Path;
import openfl.events.UncaughtErrorEvent;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

class Main extends Sprite
{
	// This variable is copied from Friday Night Funkin': nekoEngine lol
	var game = {
		width: 640, // WINDOW width
		height: 480, // WINDOW height
		initialState: TitleState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public static var fpsCounter:FPS;

	public function new()
	{
		trace("VS HAXE v" + Application.current.meta.get('version') + " is Initializing...");
		super();
		Sys.setCwd(haxe.io.Path.addTrailingSlash(AndroidContext.getExternalFilesDir()));
		CrashHandler.init();

		#if (openfl <= "9.2.0")
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}
		#else
		if (game.zoom == -1.0)
			game.zoom = 1.0;
		#end

		addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate,
			game.skipSplash, game.startFullscreen));
		trace("VS HAXE v" + Application.current.meta.get('version') + " is Ready!");
	}
}
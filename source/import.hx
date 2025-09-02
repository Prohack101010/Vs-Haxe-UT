#if !macro
import mobile.backend.*;
import mobile.objects.*;
import mobile.macros.*;
import backends.*;

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

// Android
#if android
import android.Tools as AndroidTools;
import android.Settings as AndroidSettings;
import android.widget.Toast as AndroidToast;
import android.content.Context as AndroidContext;
import android.Permissions as AndroidPermissions;
import android.os.Build.VERSION as AndroidVersion;
import android.os.Environment as AndroidEnvironment;
import android.os.BatteryManager as AndroidBatteryManager;
import android.os.Build.VERSION_CODES as AndroidVersionCode;
#end

//Flixel
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.sound.FlxSound;
import flixel.util.FlxDestroyUtil;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;

//OpenFL
import openfl.display.BitmapData;
import openfl.system.System;
import openfl.utils.AssetType;
#end

using StringTools;
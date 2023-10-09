package windowApi;

import flixel.FlxState;
import lime.ui.MouseCursor;
import openfl.ui.Mouse;
import openfl.Lib;
import lime.ui.WindowAttributes;
import lime.app.Application;
import sys.FileSystem;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import openfl.system.Capabilities;
import cpp.abi.Winapi;
import lime.ui.Window;

@:cppFileCode('#include <windows.h>\n#include <dwmapi.h>\n\n#pragma comment(lib, "Dwmapi")')
class WindowAPI
{
    public static var screenResX:Int;
    public static var screenResY:Int;
    public static var windowAssets:FlxSpriteGroup;

    @:functionCode('
        HWND hWnd = GetActiveWindow();
        res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) | WS_EX_LAYERED);
        if (res)
        {
            SetLayeredWindowAttributes(hWnd, RGB(r, g, b), alpha, LWA_COLORKEY);
        }
    ')
	public static function getWindowsTransparent(res:Int = 0, r:Int= 0, g:Int = 0, b:Int = 0, alpha:Int = 0)
	{
		return res;
	}

    @:functionCode('
        HWND hWnd = GetActiveWindow();
        res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) ^ WS_EX_LAYERED);
        if (res)
        {
            SetLayeredWindowAttributes(hWnd, RGB(r, g, b), 1, LWA_COLORKEY);
        }
    ')

	public static function getWindowsbackward(res:Int = 0, r:Int= 0, g:Int = 0, b:Int = 0)
	{
		return res;
	}

	public static function init()
	{
        Lib.application.window.borderless = true;
        screenResX = Std.int(Capabilities.screenResolutionX);
        screenResY = Std.int(Capabilities.screenResolutionY);
        Lib.application.window.width = screenResX;
        Lib.application.window.height = screenResY;
        Lib.application.window.x = 0;
        Lib.application.window.y = 0;
        var key:FlxSprite = new FlxSprite().makeGraphic(screenResX, screenResY, FlxColor.fromRGB(1, 1, 1));
        windowAssets = new FlxSpriteGroup(0, 0, 1);
        windowAssets.add(key);

        var loadMods:Bool = false;
		if (FileSystem.exists('mods/packagedMods')){
			if (FileSystem.readDirectory('mods/packagedMods') != []){
				for (file in FileSystem.readDirectory('mods/packagedMods')){
					if (StringTools.endsWith(file, '.dem')){
						loadMods = true;
						break;
					}
				}
				if (loadMods){
                    FlxG.switchState(new modded.packaged.FoundMods());
				}else{
                    FlxG.switchState(new states.TitleState());
				}
			}else{
				FlxG.switchState(new states.TitleState());
			}
		}else{
			FlxG.switchState(new states.TitleState());
		}
	}
}

package windowApi;

import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxState;

class Init extends FlxState{
    public static var deskCam:FlxCamera;
	public static var window:Window;
	public static var windowAssets:FlxGroup;
	public static var mainWindowGrp:FlxGroup;
    override public function create(){
        windowAssets = new FlxGroup();
		mainWindowGrp = new FlxGroup();
		window = new Window(100, 100, 1280, 720, 'Friday Night Funkin | Definitive Engine', 'icon.png', true, windowAssets, false);
		FlxG.stage.addEventListener(openfl.events.Event.ENTER_FRAME, function(e){window.updateWindow();});
		deskCam = new FlxCamera(0, 0, 1280, 720, 0);
		FlxG.cameras.add(deskCam, true);
		deskCam.bgColor.alpha = 0;
        windowApi.WindowAPI.init();
    }
}
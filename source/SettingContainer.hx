package;

import openfl.events.Event;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
using StringTools;
class SettingContainer {
    public static var keyBinds:Map<String, MappedKeybind>;
    public static var defKeyBinds:Map<String, MappedKeybind> = [ //default keybinds
        'Left' => {key: LEFT, altKey: D},
        'Up' => {key: UP, altKey: J},
        'Down' => {key: DOWN, altKey: F},
        'Right' => {key: RIGHT, altKey: K},
        'Confirm' => {key: ENTER, altKey: SPACE},
        'Cancel' => {key: ESCAPE, altKey: BACKSPACE},
        'Cheat' => {key: SIX, altKey: SIX},
        'Reset' => {key: R, altKey: R},
    ];
    public static var sustainQuality:Int = 2;
    public static var ghostTapping:Bool = true;
    public static var hitDetectionMode:Int;
    public static function init(){
        if (FlxG.save.data.keybinds == null)
            FlxG.save.data.keybinds = defKeyBinds;
        if (FlxG.save.data.ghostTapping == null)
            FlxG.save.data.ghostTapping = true;
        if (FlxG.save.data.sustainQuality == null)
            FlxG.save.data.sustainQuality = 1;
        if (FlxG.save.data.hitDetectionMode == null)
            FlxG.save.data.hitDetectionMode = 3;
        load();
    }
    public static function save(){
        FlxG.save.data.keybinds = keyBinds;
        FlxG.save.data.ghostTapping = ghostTapping;
        FlxG.save.data.hitDetectionMode = hitDetectionMode;
        FlxG.save.data.sustainQuality = sustainQuality;
    }
    public static function load(){
        keyBinds = FlxG.save.data.keybinds;
        ghostTapping = FlxG.save.data.ghostTapping;
        hitDetectionMode = FlxG.save.data.hitDetectionMode;
        //sustainQuality = FlxG.save.data.sustainQuality;
        sustainQuality = 1;
    }
}

typedef Keybind = {
    var name:String;
    var key:FlxKey;
    var altKey:FlxKey;
}

typedef MappedKeybind = {
    var key:FlxKey;
    var altKey:FlxKey;
}
class KeyMgr {
    public static function getKeybinds():Map<String, MappedKeybind>{
        return FlxG.save.data.keybinds;
    }
    public static function setKeybind(keyName:String, newKey:MappedKeybind){
        var keys:Map<String, MappedKeybind> = FlxG.save.data.keybinds;
        keys.set(keyName, newKey);
        FlxG.save.data.keybinds = keys;
    }
    public static function justPressed(keyName:String):Bool{
        return FlxG.keys.anyJustPressed([getKeybinds().get(keyName).key]) || FlxG.keys.anyJustPressed([getKeybinds().get(keyName).altKey]);
    }
    public static function justReleased(keyName:String):Bool{
        return FlxG.keys.anyJustReleased([getKeybinds().get(keyName).key]) || FlxG.keys.anyJustReleased([getKeybinds().get(keyName).altKey]);
    }
    public static function pressed(keyName:String):Bool{
        return FlxG.keys.anyPressed([getKeybinds().get(keyName).key]) || FlxG.keys.anyPressed([getKeybinds().get(keyName).altKey]);
    }
    public static function toMappedKeybind(keybind:Keybind):MappedKeybind{
		return {key: keybind.key, altKey: keybind.altKey};
	}
	public static function fromMappedKeybind(keyName:String, mappedKeybind:MappedKeybind):Keybind{
		return {name: keyName, key: mappedKeybind.key, altKey: mappedKeybind.altKey};
	}
}

class KeyObj { //I made this bc im way too lazy to change everything ngl
    public var UP_P:Bool;
    public var DOWN_P:Bool;
    public var LEFT_P:Bool;
    public var RIGHT_P:Bool;
    public var UP_R:Bool;
    public var DOWN_R:Bool;
    public var LEFT_R:Bool;
    public var RIGHT_R:Bool;
    public var UP:Bool;
    public var DOWN:Bool;
    public var LEFT:Bool;
    public var RIGHT:Bool;
    public var ACCEPT:Bool;
    public var BACK:Bool;
    public var CHEAT:Bool;
    public var RESET:Bool;
    public function new(){
        UP_P = KeyMgr.justPressed('Up');
        DOWN_P = KeyMgr.justPressed('Down');
        LEFT_P = KeyMgr.justPressed('Left');
        RIGHT_P = KeyMgr.justPressed('Right');
        UP_R = KeyMgr.justReleased('Up');
        DOWN_R = KeyMgr.justReleased('Down');
        LEFT_R = KeyMgr.justReleased('Left');
        RIGHT_R = KeyMgr.justReleased('Right');
        UP = KeyMgr.pressed('Up');
        DOWN = KeyMgr.pressed('Down');
        LEFT = KeyMgr.pressed('Left');
        RIGHT = KeyMgr.pressed('Right');
        ACCEPT = KeyMgr.justPressed('Confirm');
        BACK = KeyMgr.justPressed('Cancel');
        CHEAT = KeyMgr.justPressed('Cheat');
        RESET = KeyMgr.justPressed('Reset');
        FlxG.stage.addEventListener(Event.ENTER_FRAME, function(e)
		{
			UP_P = KeyMgr.justPressed('Up');
        DOWN_P = KeyMgr.justPressed('Down');
        LEFT_P = KeyMgr.justPressed('Left');
        RIGHT_P = KeyMgr.justPressed('Right');
        UP_R = KeyMgr.justReleased('Up');
        DOWN_R = KeyMgr.justReleased('Down');
        LEFT_R = KeyMgr.justReleased('Left');
        RIGHT_R = KeyMgr.justReleased('Right');
        UP = KeyMgr.pressed('Up');
        DOWN = KeyMgr.pressed('Down');
        LEFT = KeyMgr.pressed('Left');
        RIGHT = KeyMgr.pressed('Right');
        ACCEPT = KeyMgr.justPressed('Confirm');
        BACK = KeyMgr.justPressed('Cancel');
        CHEAT = KeyMgr.justPressed('Cheat');
        RESET = KeyMgr.justPressed('Reset');
		});
    }
}
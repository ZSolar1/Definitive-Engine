package modded.packaged;

import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.addons.plugin.taskManager.FlxTaskManager;
import flixel.FlxG;
import flixel.FlxState;

class ModEditorState extends MusicBeatState{
    override function update(elapsed:Float){
        super.update(elapsed);
        if (FlxG.keys.justPressed.ENTER){
            new ModManager().packModfile('mods/exampleMod/', 'exampleMod.dem', 'mods/packagedMods');
            trace('.dem packaged!');
        }
        if (FlxG.keys.justPressed.ESCAPE){
            FlxG.switchState(new states.MainMenuState());
        }
    }
}

class ModPackager extends MusicBeatSubstate{
	var pathBeingWrittenTo:String = '';
	var ogState:FlxState;
	var blackScreen:FlxSprite;
	var loadingText:FlxText;
	override public function new(pathBeingWrittenTo:String, ogState:FlxState){
		super();
		this.pathBeingWrittenTo = pathBeingWrittenTo;
		this.ogState = ogState;
	}

	override function create(){
		super.create();
		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x0000000);
		blackScreen.alpha = 0;
		FlxTween.tween(blackScreen, {alpha: 0.6}, 1, {});
		add(blackScreen);
	}
}
package modded.packaged;

import flixel.addons.plugin.taskManager.FlxTaskManager;
import flixel.FlxG;
import flixel.FlxState;

class ModEditorState extends FlxState{
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
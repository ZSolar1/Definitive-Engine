package;

import sys.io.Process;
import sys.FileSystem;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	var setDemType:Process;
	public function new()
	{
		super();
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
					addChild(new FlxGame(0, 0, modded.packaged.FoundMods));
				}else{
					addChild(new FlxGame(0, 0, states.TitleState));
				}
			}else{
				addChild(new FlxGame(0, 0, states.TitleState));
			}
		}else{
			addChild(new FlxGame(0, 0, states.TitleState));
		}

		

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end
	}
}

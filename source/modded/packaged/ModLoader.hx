package modded.packaged;

import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import sys.FileSystem;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import com.gelert.filesystemhelper.FileSystemHelper;

class ModLoader extends FlxState
{
    //for this, use Sys.args()[id here or smth]; and use the paths when opening the game.
	public var modPaths:Array<String>;

	public var modNames:Array<String> = [];
	public var modList:Array<Array<String>> = [];

    var canExit:Bool = false;
	var darkness:FlxSprite;
    var checker:FlxBackdrop;
    var modsLoadedText:FlxTypeText;

	override public function new(modPaths:Array<String>)
	{
		super();
		this.modPaths = modPaths;
	}

	override function create()
	{
		super.create();
        
        checker = new FlxBackdrop('assets/images/ui/general/checker.png');
        checker.velocity.x = 2;
        checker.velocity.y = 2;
        checker.antialiasing = false;
        checker.color = 0x0000EEFF;
        add(checker);
        
		if (FileSystem.exists('mods/packagedMods/unpacked/'))
			FileSystemHelper.deletePath('mods/packagedMods/unpacked/');

        if (FlxG.save.data.modList == null)
            FlxG.save.data.modList = [['', ''], ['', '']];

		for (path in 0...modPaths.length)
		{
			if (FlxG.save.data.modList[path][1] != modPaths[path].split('/')[modPaths.length])
			{
				modNames.push(modPaths[path].split('/')[modPaths.length]);
				ModManager.unpackModfile(modPaths[path], 'mods/packagedMods/unpacked');
				modList.push([modNames[path], 'mods/packagesMods/unpacked/${modNames[path]}']);
			}
		}
        if (modList.length > 1){
        modsLoadedText = new FlxTypeText(0, 0, 1000, 'Mods have been loaded!\n(press ENTER or SPACE to conteniue)');
        }else{
            if (modList.length == 1){
                modsLoadedText = new FlxTypeText(0, 0, 1000, '1 Mod has been loaded!\n(press ENTER or SPACE to conteniue)');
            }
        }
        modsLoadedText.setFormat('assets/fonts/vcr.ttf', 30, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        modsLoadedText.screenCenter();
        add(modsLoadedText);
		darkness = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        darkness.alpha = 1;
		add(darkness);
        FlxTween.tween(darkness, {alpha: 0}, 1);
		FlxG.save.data.modList = modList;
		FlxG.save.flush();
        trace('Saved Mod List: ${FlxG.save.data.modList} Internal Mod List: $modList');
        FlxG.sound.playMusic('assets/music/breakfast.ogg');
        FlxG.sound.music.fadeIn(1, 0, 1);
        new FlxTimer().start(1.5, function(tmr){
            modsLoadedText.cursorCharacter = '';
            modsLoadedText.start(0.05, false, false, [], function() {
                canExit = true;
            });
        });
	}

    override function update(elapsed:Float){
        super.update(elapsed);
        if (canExit){
            if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER){
                canExit = false;
                FlxG.sound.music.stop();
                FlxG.sound.play('assets/music/gameOverEnd.ogg');
                //dont flash if flashing lights.
                FlxG.camera.flash();
                new FlxTimer().start(1.5, function(tmr){
                    FlxTween.tween(darkness, {alpha: 1}, 1, {onComplete: function(twn){
                        FlxG.sound.music.stop();
                        FlxG.switchState(new states.TitleState());
                    }});
                });
            }
        }
    }
}

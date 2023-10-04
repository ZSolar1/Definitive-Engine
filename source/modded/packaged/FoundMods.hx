package modded.packaged;

import sys.FileSystem;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.addons.display.FlxBackdrop;

class FoundMods extends FlxState
{
	var checker:FlxBackdrop;
	var modsThatCanBeInstalledText:FlxTypeText;
	var darkness:FlxSprite;
	var modsLoaded:Int = 0;
	var canProceed:Bool = false;
	var packagedMods:Array<String> = [];

	override function create()
	{
		super.create();
		for (file in FileSystem.readDirectory('mods/packagedMods'))
			if (StringTools.endsWith(file, '.dem'))
				packagedMods.push('mods/packagedMods/$file');

		modsLoaded = packagedMods.length;
		checker = new FlxBackdrop('assets/images/ui/general/checker.png');
		checker.velocity.x = 10;
		checker.velocity.y = 10;
		checker.antialiasing = false;
		checker.color = 0x0000EEFF;
		add(checker);
		if (modsLoaded == 1)
		{
			modsThatCanBeInstalledText = new FlxTypeText(0, 0, 1000,
				'There is 1 packaged mod available to install. Would you like to install it?\n(Press ENTER or SPACE to install, press ESCAPE or BACKSPACE to not install.)');
		}
		else
		{
			if (modsLoaded > 1)
			{
				modsThatCanBeInstalledText = new FlxTypeText(0, 0, 1000,
					'There are $modsLoaded packaged mods available to install. Would you like to install them?\n(Press ENTER or SPACE to install, press ESCAPE or BACKSPACE to not install.)');
			}
		}
		modsThatCanBeInstalledText.setFormat('assets/fonts/vcr.ttf', 30, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		modsThatCanBeInstalledText.screenCenter();
		add(modsThatCanBeInstalledText);
		darkness = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		darkness.alpha = 1;
		add(darkness);
		FlxTween.tween(darkness, {alpha: 0}, 1);
		FlxG.sound.playMusic('assets/music/breakfast.ogg');
		FlxG.sound.music.fadeIn(1, 0, 1);
		new FlxTimer().start(1.5, function(tmr)
		{
			modsThatCanBeInstalledText.cursorCharacter = '';
			modsThatCanBeInstalledText.start(0.05, false, false, [], function()
			{
				canProceed = true;
			});
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (canProceed)
		{
			if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER)
			{
				canProceed = false;
				FlxG.sound.music.fadeOut();
				FlxG.sound.play('assets/sounds/confirmMenu.ogg');
				// dont flash if flashing lights.
				FlxG.camera.flash();
				new FlxTimer().start(1.5, function(tmr)
				{
					FlxTween.tween(darkness, {alpha: 1}, 1, {
						onComplete: function(twn)
						{
							FlxG.sound.music.stop();
							FlxG.switchState(new modded.packaged.ModLoader(packagedMods));
						}
					});
				});
			}
			if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
			{
				canProceed = false;
				FlxG.sound.music.fadeOut();
				FlxG.sound.play('assets/sounds/cancelMenu.ogg');
				// dont flash if flashing lights.
				FlxG.camera.flash();
				new FlxTimer().start(1.5, function(tmr)
				{
					FlxTween.tween(darkness, {alpha: 1}, 1, {
						onComplete: function(twn)
						{
							FlxG.sound.music.stop();
							FlxG.switchState(new states.TitleState());
						}
					});
				});
			}
		}
	}
}

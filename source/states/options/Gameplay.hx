package states.options;

import utils.GeneralUtils.StaticGeneralUtils;
import statehelpers.options.Option;
import SettingContainer.KeyMgr;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class Gameplay extends MusicBeatState
{
	public static var options:Array<Option> = [
		new Option('Ghost Tapping', SettingContainer.ghostTapping),
		new Option('Hit Detection Mode', SettingContainer.hitDetectionMode)
	];
	static var option:Alphabet;
	static var alphGrp:FlxTypedGroup<Alphabet>;

	var bg:FlxSprite;
	var curSel:Int = 0;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic('assets/images/menuBG.png');
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		alphGrp = new FlxTypedGroup<Alphabet>();
		option = new Alphabet(0, 0, '', false, false);
		for (optionID in 0...options.length)
		{
			switch (options[optionID].name)
			{
				case 'Ghost Tapping':
					option = new Alphabet(0, (70 * optionID) + 30, '${options[optionID].name}: ${SettingContainer.ghostTapping}', true, false);
				case 'Hit Detection Mode':
					if (SettingContainer.hitDetectionMode == 0)
						option = new Alphabet(0, (70 * optionID) + 30, '${options[optionID].name}: Base Game}', true, false);
					if (SettingContainer.hitDetectionMode == 1)
						option = new Alphabet(0, (70 * optionID) + 30, '${options[optionID].name}: Definitive Legacy}', true, false);
					if (SettingContainer.hitDetectionMode == 2)
						option = new Alphabet(0, (70 * optionID) + 30, '${options[optionID].name}: Definitive}', true, false);
			}

			option.lerpX = false;
			option.screenCenter(X);
			option.isMenuItem = true;
			option.targetY = optionID;
			alphGrp.add(option);
		}
		add(alphGrp);
	}

	static function resetAlphGrp(o:Array<Option>)
	{
		options = o;
		trace('resetAlphGrp() ran');
		for (option in alphGrp.members)
		{
			trace('alpabets');
			if (StringTools.contains(option.text, 'Ghost Tapping'))
			{
				trace('found alpabet: ${option} | curText: ${option.text}');
				for (optionID in 0...options.length)
				{
					trace('options');
					if (options[optionID].name == 'Ghost Tapping')
					{
						trace('found option: ${options[optionID].name}, updating alphabet');
						option.text = '${options[optionID].name}: ${SettingContainer.ghostTapping}';
						option.addText();
						trace('alphabet updated. text: ${option.text}');
					}
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (KeyMgr.justPressed('Up'))
		{
			changeCurSelected(-1);
		}
		if (KeyMgr.justPressed('Down'))
		{
			changeCurSelected(1);
		}
		if (KeyMgr.justPressed('Cancel'))
		{
			FlxG.switchState(new states.OptionsState());
		}
		if (KeyMgr.justPressed('Left'))
		{
			switch (options[curSel].name)
			{
				case 'Hit Detection Mode':
					changeHitDetection(1);
					trace(SettingContainer.hitDetectionMode);
					FlxG.sound.play('assets/sounds/scrollMenu.ogg');
					resetAlphGrp(options);
			}
		}
		if (KeyMgr.justPressed('Right'))
		{
			switch (options[curSel].name)
			{
				case 'Hit Detection Mode':
					changeHitDetection(-1);
					trace(SettingContainer.hitDetectionMode);
					FlxG.sound.play('assets/sounds/scrollMenu.ogg');
					resetAlphGrp(options);
			}
		}
		if (KeyMgr.justPressed('Confirm'))
		{
			switch (options[curSel].name)
			{
				case 'Ghost Tapping':
					SettingContainer.ghostTapping = !SettingContainer.ghostTapping;
					trace(SettingContainer.ghostTapping);
					FlxG.sound.play('assets/sounds/confirmMenu.ogg');
					resetAlphGrp(options);
			}
		}
	}

	function changeHitDetection(by:Int)
	{
		SettingContainer.hitDetectionMode += by;
		if (!StringTools.startsWith(Std.string(by), '-'))
		{
			SettingContainer.hitDetectionMode %= 3;
		}
		else
		{
			if (SettingContainer.hitDetectionMode < 0)
				SettingContainer.hitDetectionMode = 2;
		}
	}

	function changeCurSelected(by:Int)
	{
		curSel += by;
		if (!StringTools.startsWith(Std.string(by), '-'))
		{
			curSel %= options.length;
		}
		else
		{
			if (curSel < 0)
				curSel = options.length - 1;
		}
		trace('curSel: $curSel');
		var smth:Int = 0;

		for (alph in alphGrp.members)
		{
			alph.targetY = smth - curSel;
			smth++;

			alph.alpha = 0.6;
			if (alph.targetY == 0)
			{
				alph.alpha = 1;
			}
		}
		FlxG.sound.play('assets/sounds/scrollMenu.ogg');
	}
}

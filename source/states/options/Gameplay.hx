package states.options;

import statehelpers.options.Option;
import SettingContainer.KeyMgr;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import statehelpers.options.OptionCatagory;
import flixel.group.FlxGroup.FlxTypedGroup;
import SettingContainer.MappedKeybind;
import SettingContainer.Keybind;
import flixel.FlxState;

class Gameplay extends MusicBeatState{
	public static var options:Array<Option> = [new Option('Ghost Tapping', SettingContainer.ghostTapping, Bool)];
	static var alphGrp:FlxTypedGroup<Alphabet>;
	var bg:FlxSprite;
	var curSel:Int = 0;

	override function create()
	{
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic('assets/images/menuBG.png');
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		alphGrp = new FlxTypedGroup<Alphabet>();
		resetAlphGrp(options);
		add(alphGrp);
	}

	

	static function resetAlphGrp(o:Array<Option>)
	{
		options = o;
		for (m in alphGrp.members)
		{
			m.kill();
		}
		for (optionID in 0...options.length)
		{
			var section:Alphabet = new Alphabet(0, (70 * optionID) + 30, options[optionID].name, true, false);
			section.lerpX = false;
			section.screenCenter(X);
			section.isMenuItem = true;
			section.targetY = optionID;
			alphGrp.add(section);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (controls.UP_P)
		{
			changeCurSelected(-1);
		}
		if (controls.DOWN_P)
		{
			changeCurSelected(1);
		}
		if (controls.BACK)
		{
			FlxG.switchState(new states.OptionsState());
		}
		if (controls.ACCEPT)
		{
			switch (options[curSel].name){
				case 'Ghost Tapping':
					SettingContainer.ghostTapping = !SettingContainer.ghostTapping;
					trace(SettingContainer.ghostTapping);
					FlxG.sound.play('assets/sounds/confirmMenu.ogg');
			}
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

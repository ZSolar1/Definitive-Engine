package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import statehelpers.options.OptionCatagory;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxState;

class OptionsState extends MusicBeatState
{
	var sectionList:Array<OptionCatagory> = [
        new OptionCatagory('Keybinds', new states.options.Keybinds()),
		new OptionCatagory('Gameplay', new states.options.Gameplay())
    ];
	var alphGrp:FlxTypedGroup<Alphabet>;
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
		for (sectionID in 0...sectionList.length)
		{
			var section:Alphabet = new Alphabet(0, (70 * sectionID) + 30, sectionList[sectionID].name, true, false);
			section.lerpX = false;
			section.screenCenter(X);
			section.isMenuItem = true;
			section.targetY = sectionID;
			alphGrp.add(section);
		}
		add(alphGrp);
	}

	function resetAlphGrp(sectionList:Array<OptionCatagory>)
	{
		this.sectionList = sectionList;
		for (m in alphGrp.members)
		{
			m.kill();
		}
		for (sectionID in 0...this.sectionList.length)
		{
			var section:Alphabet = new Alphabet(0, (70 * sectionID) + 30, this.sectionList[sectionID].name, true, false);
			section.lerpX = false;
			section.screenCenter(X);
			section.isMenuItem = true;
			section.targetY = sectionID;
			alphGrp.add(section);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.UP)
		{
			changeCurSelected(-1);
		}
		if (FlxG.keys.justPressed.DOWN)
		{
			changeCurSelected(1);
		}
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new states.MainMenuState());
		}
		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.switchState(sectionList[curSel].state);
		}
	}

	function changeCurSelected(by:Int)
	{
		curSel += by;
		if (!StringTools.startsWith(Std.string(by), '-'))
		{
			curSel %= sectionList.length;
		}
		else
		{
			if (curSel < 0)
				curSel = sectionList.length - 1;
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

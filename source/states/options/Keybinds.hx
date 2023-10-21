package states.options;

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


class Keybinds extends MusicBeatState{
	public static var mappedKeybindList:Map<String, MappedKeybind> = [];
	public static var keybindList:Array<Keybind> = [];
	static var alphGrp:FlxTypedGroup<Alphabet>;
	var bg:FlxSprite;
	var curSel:Int = 0;

	override function create()
	{
		mappedKeybindList = KeyMgr.getKeybinds();
		keybindList.push(KeyMgr.fromMappedKeybind('Left', mappedKeybindList.get('Left')));
		keybindList.push(KeyMgr.fromMappedKeybind('Up', mappedKeybindList.get('Up')));
		keybindList.push(KeyMgr.fromMappedKeybind('Down', mappedKeybindList.get('Down')));
		keybindList.push(KeyMgr.fromMappedKeybind('Right', mappedKeybindList.get('Right')));
		keybindList.push(KeyMgr.fromMappedKeybind('Confirm', mappedKeybindList.get('Confirm')));
		keybindList.push(KeyMgr.fromMappedKeybind('Cancel', mappedKeybindList.get('Cancel')));
		keybindList.push(KeyMgr.fromMappedKeybind('Cheat', mappedKeybindList.get('Cheat')));
		keybindList.push(KeyMgr.fromMappedKeybind('Reset', mappedKeybindList.get('Reset')));
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic('assets/images/menuBG.png');
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		alphGrp = new FlxTypedGroup<Alphabet>();
		resetAlphGrp(keybindList);
		add(alphGrp);
	}

	

	static function resetAlphGrp(theKeybindList:Array<Keybind>)
	{
		keybindList = theKeybindList;
		for (m in alphGrp.members)
		{
			m.kill();
		}
		for (sectionID in 0...keybindList.length)
		{
			var section:Alphabet = new Alphabet(0, (70 * sectionID) + 30, '${keybindList[sectionID].name}: ${keybindList[sectionID].key}/${keybindList[sectionID].altKey}', true, false);
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
		mappedKeybindList = KeyMgr.getKeybinds();
		keybindList[0] = KeyMgr.fromMappedKeybind('Left', mappedKeybindList.get('Left'));
		keybindList[1] = KeyMgr.fromMappedKeybind('Up', mappedKeybindList.get('Up'));
		keybindList[2] = KeyMgr.fromMappedKeybind('Down', mappedKeybindList.get('Down'));
		keybindList[3] = KeyMgr.fromMappedKeybind('Right', mappedKeybindList.get('Right'));
		keybindList[4] = KeyMgr.fromMappedKeybind('Confirm', mappedKeybindList.get('Confirm'));
		keybindList[5] = KeyMgr.fromMappedKeybind('Cancel', mappedKeybindList.get('Cancel'));
		keybindList[6] = KeyMgr.fromMappedKeybind('Cheat', mappedKeybindList.get('Cheat'));
		keybindList[7] = KeyMgr.fromMappedKeybind('Reset', mappedKeybindList.get('Reset'));
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
		if (KeyMgr.justPressed('Confirm'))
		{
			openSubState(new ChangeKeybinds(keybindList[curSel]));
		}
	}

	function changeCurSelected(by:Int)
	{
		curSel += by;
		if (!StringTools.startsWith(Std.string(by), '-'))
		{
			curSel %= keybindList.length;
		}
		else
		{
			if (curSel < 0)
				curSel = keybindList.length - 1;
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

class ChangeKeybinds extends MusicBeatSubstate {
    var changekeytxt:Alphabet;
    var changealtkeytxt:Alphabet;
    var key:Keybind;
    var tempKey:Keybind = {name: '', key: E, altKey: E};
    var keyMode:Int = 0;
    public function new(key:Keybind){super();this.key = key;}
    override function create() {
        super.create();
		trace(key);
		trace(tempKey);
        tempKey.name = key.name;
        var darkness = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0x000000);
		darkness.alpha = 0.5;
		add(darkness);
        changekeytxt = new Alphabet(0, 0, 'Press Any Key To Change Keybind: ${key.name}', true, false);
        changekeytxt.screenCenter();
		add(changekeytxt);
        changealtkeytxt = new Alphabet(0, 0, 'Press Any Key To Change Alternate Keybind: ${key.name}', true, false);
        changealtkeytxt.screenCenter();
        changealtkeytxt.visible = false;
		add(changealtkeytxt);
    }
    override function update(elapsed:Float) {
        super.update(elapsed);
        if (keyMode == 0){
            if (FlxG.keys.justPressed.ANY){
                tempKey.key = FlxG.keys.firstJustPressed();
                keyMode++;
                trace(tempKey);
            }
        }
        if (keyMode == 1){
            changekeytxt.visible = false;
            changealtkeytxt.visible = true;
            if (FlxG.keys.justPressed.ANY){
                tempKey.altKey = FlxG.keys.firstJustPressed();
                trace(tempKey);
                KeyMgr.setKeybind(key.name, KeyMgr.toMappedKeybind(key));
                trace(KeyMgr.getKeybinds());
                closeSubState();
            }
        }
    }
}
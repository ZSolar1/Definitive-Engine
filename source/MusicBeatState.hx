package;

import SettingContainer.KeyObj;
import SettingContainer.MappedKeybind;
import SettingContainer.KeyMgr;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;

class MusicBeatState extends modcharting.ModchartMusicBeatState
{
	private var lastBeat:Int = 0;
	private var lastStep:Int = 0;

	public static var curStepS:Int = 0;
	public static var curBeatS:Int = 0;
	public var curStep:Int = 0;
	public var curBeat:Int = 0;
	private var controls:KeyObj;

	override function create()
	{
		controls = new KeyObj();
		if (transIn != null)
			trace('reg ' + transIn.region);

		#if (!web)
		states.TitleState.soundExt = '.ogg';
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curBeatS = curBeat;
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
		curStepS = curStep;
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}

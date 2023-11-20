package states;

import sys.io.File;
import utils.ADHUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;
	static public var soundExt:String = ".mp3";

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var ngSpr:FlxSprite;

	var textShow:Int = -1;
	var endBeat:Float = 0;
	var curWacky:Array<String> = [];
	var startingWacky:Array<Array<String>> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		#if (!web)
		TitleState.soundExt = '.ogg';
		#end
		SettingContainer.init();

		curWacky = FlxG.random.getObject(ADHUtil.ParseAA(File.getContent('assets/data/randomizedIntroText.adh')));
		startingWacky = ADHUtil.ParseAA(File.getContent('assets/data/startingIntroText.adh'));

		super.create();

		FlxG.save.bind('funkin', 'ninjamuffin99');

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(TILES, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(TILES, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream('assets/music/freakyMenu.ogg');
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic('assets/music/freakyMenu.ogg', 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = FlxAtlasFrames.fromSparrow('assets/images/logoBumpin.png', 'assets/images/logoBumpin.xml');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = FlxAtlasFrames.fromSparrow('assets/images/gfDanceTitle.png', 'assets/images/gfDanceTitle.xml');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		add(gfDance);
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = FlxAtlasFrames.fromSparrow('assets/images/titleEnter.png', 'assets/images/titleEnter.xml');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic('assets/images/logo.png');
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play('assets/sounds/confirmMenu.ogg', 0.7);

			transitioning = true;
			new FlxTimer().start(1, function(tmr)
			{
				FlxG.switchState(new states.MainMenuState(transIn, transOut));
			});

			// FlxG.sound.music.stop();
			// FlxG.sound.play('assets/music/titleShoot.ogg', 0.7);
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, start:Bool = false)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			if (start)
				money.y += (i * 60) + 100;
			else
				money.y += (i * 60) + 200;
			
			credGroup.add(money);
		}
	}

	function addMoreText(text:String, start:Bool = false)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		if (start)
			coolText.y += ((credGroup.length - 1) * 60) + 100;
		else
			coolText.y += ((credGroup.length - 1) * 60) + 200;
		credGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (credGroup.members.length > 0)
		{
			credGroup.remove(credGroup.members[0], true);
		}
		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);
	}

	override function beatHit()
	{
		super.beatHit();

		if (logoBl != null)
			logoBl.animation.play('bump', true);

		danceLeft = !danceLeft;

		if (gfDance != null)
		{
			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');
		}

		FlxG.log.add(curBeat);

		if (curBeat < 9)
		{
			switch (curBeat)
			{
				case 1:
					createCoolText(startingWacky[0], true);
				case 3:
					addMoreText(startingWacky[1][0], true);
				case 4:
					deleteCoolText();
				case 5:
					createCoolText(startingWacky[2], false);
				case 7:
					addMoreText(startingWacky[3][0]);
				case 8:
					deleteCoolText();
			}
		}
		else
		{
			if (curBeat == 9)
			{
				createCoolText([curWacky[0]]);
				textShow = 0;
				endBeat = curBeat;
			}
			else if (curBeat % 2 == 1 && textShow + 1 < curWacky.length)
			{
				textShow += 1;
				addMoreText(curWacky[textShow]);
				endBeat = curBeat;
			}
			else if (textShow == curWacky.length - 1)
			{
				switch (curBeat - endBeat)
				{
					case 1:
						deleteCoolText();
					case 2:
						addMoreText('Friday');
					case 3:
						addMoreText('Night');
					case 4:
						addMoreText('Funkin');
					case 5:
						deleteCoolText();
						skipIntro();
				}
			}
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}

package states;

import utils.ADHUtil;
import sys.io.File;
import utils.ModUtils;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import openfl.media.Sound;
import sys.FileSystem;

using StringTools;

typedef SongData = {
	var song:String;
	var icon:String;
}

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongData> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	override function create()
	{
		for (song in ADHUtil.ParseAA(File.getContent('assets/data/freeplaySongList.adh'))){
			songs.push({song: song[0], icon: song[1]});
		}
		// if (FileSystem.exists('mods/')){
		// 	for (mods in FileSystem.readDirectory('mods/')){
		// 		songs.push({song: song[0], icon: song[1]});
		// 	}
		// }
		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
			}
		 */

		// var isDebug:Bool = false;

		// #if debug
		// isDebug = true;
		// #end

		// if (StoryMenuState.weekUnlocked[2] || isDebug)
		// {
		// 	songs.push({song: 'Spookeez', icon: 'spooky'});
		// 	songs.push({song: 'South', icon: 'spooky'});
		// }

		// if (StoryMenuState.weekUnlocked[3] || isDebug)
		// {
		// 	songs.push({song: 'Pico', icon: 'pico'});
		// 	songs.push({song: 'Philly', icon: 'pico'});
		// 	songs.push({song: 'Blammed', icon: 'pico'});
		// }

		// if (StoryMenuState.weekUnlocked[4] || isDebug)
		// {
		// 	songs.push({song: 'Satin-Panties', icon: 'mom'});
		// 	songs.push({song: 'High', icon: 'mom'});
		// 	songs.push({song: 'Milf', icon: 'mom'});
		// }

		// if (StoryMenuState.weekUnlocked[5] || isDebug)
		// {
		// 	songs.push({song: 'Cocoa', icon: 'parents-christmas'});
		// 	songs.push({song: 'Eggnog', icon: 'parents-christmas'});
		// 	songs.push({song: 'Winter-Horrorland', icon: 'monster-christmas'});
		// }

		// if (StoryMenuState.weekUnlocked[6] || isDebug)
		// {
		// 	songs.push({song: 'Senpai', icon: 'senpai'});
		// 	songs.push({song: 'Roses', icon: 'senpai'});
		// 	songs.push({song: 'Thorns', icon: 'senpai'});
		// 	// songs.push('Winter-Horrorland');
		// }

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuBGBlue.png');
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].song, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
			// songText.x += 40;
			var icon:HealthIcon = new HealthIcon(songs[i].icon);
			icon.sprTracker = songText;
			add(icon);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic('assets/music/title' + TitleState.soundExt, 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].song.toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].song.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			FlxG.switchState(new PlayState());
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].song, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
		}
	}

	function changeSelection(change:Int = 0)
	{

		// NGio.logEvent('Fresh');
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].song, curDifficulty);
		// lerpScore = 0;
		#end 
		var song = songs[curSelected].song.toLowerCase();

		if (FileSystem.exists("assets/songs/" + song + "/Inst.ogg") || FileSystem.exists('mods/${utils.ModUtils.StaticModUtils.getModNameForFile('songs/$song')}/songs/${song.toLowerCase()}/Inst'))
			{
				if (FileSystem.exists("assets/songs/" + song + "/Inst" + TitleState.soundExt))
				{
					FlxG.sound.playMusic(Sound.fromFile("assets/songs/" + song + "/Inst" + TitleState.soundExt), 1, false);
				}
				else
				{
					FlxG.sound.playMusic(Sound.fromFile('mods/${utils.ModUtils.StaticModUtils.getModNameForFile('songs/$song')}/songs/${song.toLowerCase()}/Inst' + TitleState.soundExt), 1, false);
				}
			}
			else
			{
				if (FileSystem.exists("assets/songs/" + song + "/" + song + TitleState.soundExt))
				{
					FlxG.sound.playMusic(Sound.fromFile("assets/songs/" + song + "/" + song + TitleState.soundExt), 1, false);
				}
				else
				{
					FlxG.sound.playMusic(Sound.fromFile('mods/${utils.ModUtils.StaticModUtils.getModNameForFile('songs/$song')}/songs/${song.toLowerCase()}/${song.toLowerCase()}' + TitleState.soundExt), 1,
						false);
				}
			}

		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
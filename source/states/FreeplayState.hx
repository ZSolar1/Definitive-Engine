package states;

import sys.io.File;
import haxe.xml.Fast;
import utils.GeneralUtils.StaticGeneralUtils;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import sys.FileSystem;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.math.FlxRect;
import flixel.util.FlxGradient;
import flixel.math.FlxPoint;
import flixel.util.helpers.FlxBounds;
import flixel.effects.particles.FlxEmitter;
import flixel.util.helpers.FlxRange;
import flixel.effects.particles.FlxParticle;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;

typedef SongData =
{
	var color:FlxColor;
	var name:String;
	var icon:String;
	var diffs:Array<String>;
}

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongData> = [];
	var curSelSong:Int = 0;
	var curSelDiff:Int = 1;
	var baseGameSongs:Bool = true;
	var canChangeSelection:Bool = true;
	var curWeekXml:Xml;
	var fast:Fast;
	var canSelect:Bool = true;

	var checker:FlxBackdrop;
	var bar:FlxSprite;
	var barShade:FlxSprite;
	var scoreText:FlxText;
	var difficultyText:FlxText;
	var curSongTxt:FlxText;
	var icon:FlxSprite;
	var arrowUp:FlxSprite;
	var arrowUpShade:FlxSprite;
	var arrowDown:FlxSprite;
	var arrowDownShade:FlxSprite;
	var particles:FlxEmitter;
	var gradient:FlxSprite;
	var processedSongName:String = '';

	override function create()
	{
		super.create();
		checker = new FlxBackdrop('assets/images/ui/general/checker.png', 0, 0);
		checker.velocity.x = 10;
		checker.velocity.y = 10;
		checker.antialiasing = false;
		checker.color = 0xFF008D97;
		add(checker);
		bar = new FlxSprite(0, -200, 'assets/images/ui/general/bar.png');
		add(bar);
		scoreText = new FlxText(0, -200, 1000, 'Score: ', 100);
		scoreText.alignment = CENTER;
		scoreText.x = (FlxG.width - scoreText.width) / 2;
		scoreText.font = 'assets/fonts/vcr.ttf';
		scoreText.borderStyle = OUTLINE;
		scoreText.borderSize = 6;
		scoreText.borderColor = FlxColor.BLACK;
		add(scoreText);
		difficultyText = new FlxText(0, -200, 1000, '< Normal >', 40);
		difficultyText.alignment = CENTER;
		difficultyText.screenCenter(X);
		difficultyText.font = 'assets/fonts/vcr.ttf';
		difficultyText.borderStyle = OUTLINE;
		difficultyText.borderSize = 2;
		difficultyText.color = FlxColor.GRAY;
		difficultyText.borderColor = FlxColor.BLACK;
		add(difficultyText);
		barShade = new FlxSprite(0, -200, 'assets/images/ui/general/barShade.png');
		barShade.color = 0xFF008D97;
		add(barShade);

		curSongTxt = new FlxText(0, 0, 1000, 'Tutorial', 70);
		curSongTxt.font = 'assets/fonts/vcr.ttf';
		curSongTxt.alignment = CENTER;
		curSongTxt.screenCenter(X);
		curSongTxt.borderStyle = OUTLINE;
		curSongTxt.borderSize = 4;
		curSongTxt.borderColor = FlxColor.BLACK;
		curSongTxt.y = ((FlxG.height - curSongTxt.height) / 2); // - 160
		add(curSongTxt);

		arrowUp = new FlxSprite(0, 0).loadGraphic('assets/images/ui/general/arrow.png');
		arrowUp.screenCenter(X);
		arrowUp.centerOffsets();
		arrowUp.y = ((FlxG.height - arrowUp.height) / 2) - 117.5;
		arrowUp.angle = -90;
		add(arrowUp);
		arrowUpShade = new FlxSprite(arrowUp.x, arrowUp.y).loadGraphic('assets/images/ui/general/arrowShade.png');
		arrowUpShade.angle = -90;
		add(arrowUpShade);

		arrowDown = new FlxSprite(0, 0).loadGraphic('assets/images/ui/general/arrow.png');
		arrowDown.screenCenter(X);
		arrowDown.centerOffsets();
		arrowDown.y = ((FlxG.height - arrowDown.height) / 2) + 258;
		arrowDown.angle = 90;
		add(arrowDown);
		arrowDownShade = new FlxSprite(arrowDown.x, arrowDown.y).loadGraphic('assets/images/ui/general/arrowShade.png');
		arrowDownShade.angle = 90;
		add(arrowDownShade);

		icon = new FlxSprite(0, curSongTxt.y + 64).loadGraphic('assets/images/icons/icon-gf.png', true, 150, 150);
		icon.screenCenter(X);
		trace(FileSystem.exists('assets/images/icons/icon-gf.png'));
		add(icon);
		icon.animation.add('regular', [0], 1, true, false, false);
		icon.animation.play('regular');

		particles = new FlxEmitter(0, FlxG.height + 23, 19000);
		particles.makeParticles(12, 12, FlxColor.WHITE, 600);
		particles.width = 1780;
		particles.height = 15;
		particles.lifespan.set(5, 5);
		particles.alpha.set(1, 1, 0, 0);
		particles.start(false, 0.01);
		add(particles);

		gradient = new FlxSprite(0, 0).loadGraphic('assets/images/ui/general/gradient.png');
		gradient.scale.x = 2;
		gradient.centerOffsets();
		gradient.color = 0xFF008D97;
		gradient.alpha = 0.4;
		add(gradient);

		FlxTween.tween(bar, {y: 0}, 1, {ease: FlxEase.circOut});
		FlxTween.tween(barShade, {y: 0}, 1, {ease: FlxEase.circOut});
		FlxTween.tween(scoreText, {y: 0}, 1, {ease: FlxEase.circOut});
		FlxTween.tween(difficultyText, {y: 110}, 1, {ease: FlxEase.circOut});

		if (baseGameSongs)
		{
			songs.push({
				color: 0xC50000,
				name: 'Tutorial',
				icon: 'assets/images/icons/icon-gf.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0x6300C0,
				name: 'Bopeebo',
				icon: 'assets/images/icons/icon-dad.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0x6300C0,
				name: 'Fresh',
				icon: 'assets/images/icons/icon-dad.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0x6300C0,
				name: 'Dadbattle',
				icon: 'assets/images/icons/icon-dad.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0x120681,
				name: 'Spookeez',
				icon: 'assets/images/icons/icon-spooky.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0x120681,
				name: 'South',
				icon: 'assets/images/icons/icon-spooky.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0x120681,
				name: 'Monster',
				icon: 'assets/images/icons/icon-spooky.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0xCEC221,
				name: 'Pico',
				icon: 'assets/images/icons/icon-pico.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0xCEC221,
				name: 'Philly-nice',
				icon: 'assets/images/icons/icon-pico.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0xCEC221,
				name: 'Blammed',
				icon: 'assets/images/icons/icon-pico.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0xD80CBD,
				name: 'Satin Panties',
				icon: 'assets/images/icons/icon-mom.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0xD80CBD,
				name: 'High',
				icon: 'assets/images/icons/icon-mom.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0xD80CBD,
				name: 'Milf',
				icon: 'assets/images/icons/icon-mom.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0xA208B6,
				name: 'Cocoa',
				icon: 'assets/images/icons/icon-parents.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0xA208B6,
				name: 'Eggnog',
				icon: 'assets/images/icons/icon-parents.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0xA208B6,
				name: 'Winter Horrorland',
				icon: 'assets/images/icons/icon-parents.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0xFFB561,
				name: 'Senpai',
				icon: 'assets/images/icons/icon-senpai.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0xFFB561,
				name: 'Roses',
				icon: 'assets/images/icons/icon-senpai.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			songs.push({
				color: 0xEC1022,
				name: 'Thorns',
				icon: 'assets/images/icons/icon-spirit.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
			// week 7 songs will be added later
		}
		if (songs == []){
			songs.push({
				color: 0xC50000,
				name: 'Tutorial',
				icon: 'assets/images/icons/icon-gf.png',
				diffs: ['Easy', 'Normal', 'Hard']
			});
		}

		if (!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
			}

		if (FileSystem.exists('mods/'))
		{
			for (mod in FileSystem.readDirectory('mods/'))
			{
				if (FileSystem.exists('mods/$mod/weeks'))
				{
					{
						for (week in FileSystem.readDirectory('mods/$mod/weeks'))
						{
							if (StringTools.endsWith(week, '.xml'))
							{
								curWeekXml = Xml.parse(File.getContent('mods/$mod/weeks/$week'));
								fast = new Fast(curWeekXml);
								for (song in StaticGeneralUtils.getSongDataFromXml(fast))
								{
									songs.push({
										color: StaticGeneralUtils.getWeekDataFromXml('freeplayColor', fast),
										name: song,
										icon: StaticGeneralUtils.getWeekDataFromXml('freeplayIcon', fast),
										diffs: StaticGeneralUtils.getWeekDataFromXml('diffs', fast)
									});
								}
							}
						}
					}
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (canChangeSelection)
		{
			if (FlxG.keys.justPressed.UP)
			{
				curSelSong -= 1;
				if (curSelSong >= songs.length)
					curSelSong = 0;
				if (curSelSong < 0)
					curSelSong = songs.length - 1;

				trace(curSelSong);
			}
			if (FlxG.keys.justPressed.DOWN)
			{
				curSelSong += 1;
				if (curSelSong >= songs.length)
					curSelSong = 0;
				if (curSelSong < 0)
					curSelSong = songs.length - 1;

				trace(curSelSong);
			}
			if (FlxG.keys.justPressed.RIGHT)
			{
				curSelDiff += 1;
				if (curSelDiff >= songs[curSelSong].diffs.length)
					curSelDiff = 0;
				if (curSelDiff < 0)
					curSelDiff = songs[curSelSong].diffs.length - 1;

				trace(curSelDiff);
			}
			if (FlxG.keys.justPressed.LEFT)
			{
				curSelDiff -= 1;
				if (curSelDiff >= songs[curSelSong].diffs.length)
					curSelDiff = 0;
				if (curSelDiff < 0)
					curSelDiff = songs[curSelSong].diffs.length - 1;

				trace(curSelDiff);
			}
		}
		FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, 0.1);
		processedSongName = StringTools.replace(songs[curSelSong].name, ' ', '-').toLowerCase();
		icon.loadGraphic(songs[curSelSong].icon, true, 150, 150);
		if (!icon.animation.exists('regular-$processedSongName'))
		{
			icon.animation.add('regular-$processedSongName', [0], 1, true, false, false);
		}
		icon.animation.play('regular-$processedSongName');
		curSongTxt.text = songs[curSelSong].name;
		difficultyText.text = '< ${songs[curSelSong].diffs[curSelDiff]} >';
		scoreText.text = 'Score: ' + Std.int(FlxMath.lerp(Std.parseInt(scoreText.text), Highscore.getScore(processedSongName, curSelDiff), 0.1));
		barShade.color = FlxColor.interpolate(barShade.color, songs[curSelSong].color, 0.1);
		arrowDownShade.color = FlxColor.interpolate(arrowDownShade.color, songs[curSelSong].color, 0.1);
		arrowUpShade.color = FlxColor.interpolate(arrowUpShade.color, songs[curSelSong].color, 0.1);
		gradient.color = FlxColor.interpolate(gradient.color, songs[curSelSong].color, 0.1);
		checker.color = FlxColor.interpolate(checker.color, songs[curSelSong].color, 0.1);
		if (canSelect)
		{
			if (FlxG.keys.justPressed.ENTER)
			{
				canChangeSelection = false;
				canSelect = false;
				if (songs[curSelSong].diffs[curSelDiff] != 'Normal')
				{
					PlayState.SONG = Song.loadFromJson('$processedSongName-${songs[curSelSong].diffs[curSelDiff]}', '$processedSongName');
				}
				else
				{
					if (songs[curSelSong].diffs[curSelDiff] == 'Normal')
					{
						PlayState.SONG = Song.loadFromJson('$processedSongName', '$processedSongName');
					}
				}
				if (PlayState.SONG == null)
				{
					throw 'Chart not found! Chart: "$processedSongName-${songs[curSelSong].diffs[curSelDiff].toLowerCase()}.json"';
				}
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curSelDiff;
				FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
				FlxG.camera.flash();
				FlxG.camera.zoom = 0.1;
				canSelect = false;
				new FlxTimer().start(1.7, function(tmr:FlxTimer)
				{
					FlxG.sound.music.stop();
					FlxG.switchState(new PlayState());
				});
			}
		}
		if (FlxG.keys.justPressed.ESCAPE){
			FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt);
			FlxG.switchState(new MainMenuState());
		}
	}
}

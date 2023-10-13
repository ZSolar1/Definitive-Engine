package;

import flixel.graphics.frames.FlxAtlasFrames;
import utils.SkinUtils.StaticSkinUtils;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.io.Path;

class NoteSplash extends FlxSprite
{
	public function new(x:Float, y:Float, noteData:Int = 0):Void
	{
		super(x, y);

		frames = FlxAtlasFrames.fromSparrow(StaticSkinUtils.getSkinnedAsset('noteSplashes.png', 'assets/images/noteSplashes.png', 'images', 'noteStuff'),
			StaticSkinUtils.getSkinnedAsset('noteSplashes.xml', 'assets/images/noteSplashes.xml', 'images', 'noteStuff'));
	
		trace(StaticSkinUtils.getSkinnedAsset('noteSplashes.png', 'assets/images/noteSplashes.png', 'images', 'noteStuff'));
		trace(StaticSkinUtils.getSkinnedAsset('noteSplashes.xml', 'assets/images/noteSplashes.xml', 'images', 'noteStuff'));

		animation.addByPrefix('note1-0', 'note impact 1 down', 24, false);
		animation.addByPrefix('note2-0', 'note impact 1 up', 24, false);
		animation.addByPrefix('note0-0', 'note impact 1 left', 24, false);
		animation.addByPrefix('note3-0', 'note impact 1 right', 24, false);
		animation.addByPrefix('note1-1', 'note impact 2 down', 24, false);
		animation.addByPrefix('note2-1', 'note impact 2 up', 24, false);
		animation.addByPrefix('note0-1', 'note impact 2 left', 24, false);
		animation.addByPrefix('note3-1', 'note impact 2 right', 24, false);

		setupNoteSplash(x, y, noteData);

		// alpha = 0.75;
	}

	public function setupNoteSplash(x:Float, y:Float, noteData:Int = 0)
	{
		setPosition(x, y);
		alpha = 0.6;

		animation.play('note' + noteData + '-' + FlxG.random.int(0, 1), true);
		animation.curAnim.frameRate += FlxG.random.int(-2, 2);
		updateHitbox();

		offset.set(width * 0.3, height * 0.3);
	}

	override function update(elapsed:Float)
	{
		if (animation.curAnim.finished)
			kill();

		super.update(elapsed);
	}
}
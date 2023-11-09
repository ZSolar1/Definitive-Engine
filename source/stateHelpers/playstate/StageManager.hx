package stateHelpers.playstate;

import flixel.FlxSprite;
import tjson.TJSON;
import sys.io.File;
import flixel.group.FlxSpriteGroup.FlxSpriteGroup;

typedef StageGlobals =
{
	var BFPos:Array<Float>;
	var GFPos:Array<Float>;
	var DADPos:Array<Float>;
};

typedef StageObjectAnimationMetadata =
{
	var type:String;
	var list:Map<String, StageObjectAnimation>;
};

typedef StageObjectAnimation =
{
	var prefix:String; // type == 'sparrow'
	var indices:Array<Int>; // type == 'indices'
	var framerate:Float;
	var loop:Bool;
};

typedef StageObject =
{
	var position:Array<Float>;
	var image:String;
	var scale:Array<Float>;
	var scrollFactor:Array<Float>;
	var antialiasing:Bool;
	var angle:Float;
	var alpha:Float;
	var animations:Array<StageObjectAnimation>;
};

typedef StageFile =
{
	var Globals:StageGlobals;
	var Objects:Map<String, StageObject>;
};

class Stage extends FlxSpriteGroup
{
	public var objects:Map<String, FlxSprite>;
	public var stageName:String = '';
	public var defaultFile:StageFile = {Globals: {BFPos: [], GFPos: [], DADPos: []}, Objects: [
		'' => {
			position: [],
			image: '',
			scale: [],
			scrollFactor: [],
			antialiasing: true,
			angle: 0.0,
			alpha: 0.0,
			animations: []
		}
	]};
	public var file:StageFile = {Globals: {BFPos: [], GFPos: [], DADPos: []}, Objects: [
		'' => {
			position: [],
			image: '',
			scale: [],
			scrollFactor: [],
			antialiasing: true,
			angle: 0.0,
			alpha: 0.0,
			animations: []
		}
	]};
	public var defaultGlobals:StageGlobals = {BFPos: [], GFPos: [], DADPos: []};
	public var globals:StageGlobals = {BFPos: [], GFPos: [], DADPos: []};
	public var reloads:Int = 0;
	public var changes:Int = 0;

	public function new(stageName:String)
	{
		super(0, 0);
		this.stageName = stageName;
	}

	public function initStage()
	{
		file = cast TJSON.parse(File.getContent('mods/exampleMod/stages/$stageName/stage.json'), stageName);
		trace(file);
		trace(file.Objects);
		globals = file.Globals;
		
	}

	public function loadStage()
	{
		trace('1');
		trace(file.Objects);
		for (id => object in file.Objects)
		{
			trace('1.5');
			trace(object);
			trace('2');
			var stageSprite:FlxSprite = new FlxSprite(object.position[0],
				object.position[1]).loadGraphic('mods/exampleMod/stages/$stageName/images/${object.image}.png');
				trace('3');
			stageSprite.antialiasing = object.antialiasing;
			trace('4');
			stageSprite.scale.set(object.scale[0], object.scale[1]);
			trace('5');
			stageSprite.alpha = object.alpha;
			trace('6');
			stageSprite.angle = object.angle;
			trace('7');
			stageSprite.scrollFactor.set(object.scrollFactor[0], object.scrollFactor[1]);
			trace('8');
			objects.set(id, stageSprite);
			trace('9');
			add(stageSprite);
			trace('10');
			trace(objects);
			trace('11');
		}
	}

	public function clearStage()
	{
		forEachAlive(function(stageAsset:FlxSprite)
		{
			stageAsset.kill();
		});
		objects.clear();
		file = defaultFile;
		globals = defaultGlobals;
	}

	public function reloadStage()
	{
		clearStage();
		initStage();
		loadStage();
		reloads++;
	}
	public function changeStage(stageName:String)
	{
		this.stageName = stageName;
		clearStage();
		initStage();
		loadStage();
		changes++;
	}
}
package stateHelpers.playstate;

import tjson.TJSON;
import haxe.Json;
import flixel.FlxSprite;
import sys.io.File;
import flixel.group.FlxSpriteGroup.FlxSpriteGroup;

typedef StageGlobals = {
	var BFPos:Array<Float>;
	var GFPos:Array<Float>;
	var OpPos:Array<Float>;
};

typedef StageObjectAnimationMetadata = {
	var type:String;
	var list:Map<String, StageObjectAnimation>;
};

typedef StageObjectAnimation = {
	var prefix:String;		// type == 'sparrow'
	var indices:Array<Int>; // type == 'indices'
	var framerate:Float;
	var loop:Bool;
};

typedef StageObject = {
	var position:Array<Float>;
	var image:String;
	var scale:Array<Float>;
	var angle:Float;
	var alpha:Float;
	var animations:Array<StageObjectAnimation>;
};

typedef StageFile = {
	var Globals:StageGlobals;
	var Objects:Map<String, StageObject>;
};

class Stage extends FlxSpriteGroup {
	var objects:Map<String, FlxSprite>;

	public function new(stageName:String) {
		super(0,0);
		loadStage(stageName);
	}

	public function loadStage(stageName:String) {
		var file:StageFile = cast TJSON.parse(File.getContent('mods/exampleMod/stages/$stageName/stage.json'), stageName);
		for (id => object in file.Objects) {
			var stageSprite = new FlxSprite(object.position[0], object.position[1]).loadGraphic('mods/exampleMod/stages/$stageName/images/${object.image}.png');
			stageSprite.scale.set(object.scale[0], object.scale[1]);
			stageSprite.alpha = object.alpha;
			stageSprite.angle = object.angle;
			objects.set(id, stageSprite);
			add(stageSprite);
		}
	}
}
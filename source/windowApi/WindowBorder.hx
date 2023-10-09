package windowApi;

import flixel.FlxG;
import utils.Interactions;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

class WindowBorder extends FlxBasic{
    public var angle:Float = 0;
    public var x:Int = 0;
    public var y:Int = 0;
    public var width:Int = 1280;
    public var height:Int = 720;
    public var draggable:Bool = true;
    public var beingHeld:Bool = false;
    var top:FlxSprite;
    var bottom:FlxSprite;
    var left:FlxSprite;
    var right:FlxSprite;
    var center:FlxSprite;
    var borderAssets:FlxGroup;

    public function new(x:Int, y:Int, width:Int, height:Int, ?draggable:Bool = true){
        super();
        this.x = x;
        this.y = y;
        this.width = Std.int(width / 1.5);
        this.height = Std.int(height / 1.5);
        this.draggable = draggable;
        center = new FlxSprite(this.x + (width/2), this.y + (height/2));
        borderAssets = new FlxGroup();
        borderAssets.add(center);
        top = new FlxSprite(center.x, center.y - (height/2)).makeGraphic(width, 30);
        left = new FlxSprite(center.x - (width/2), center.y).makeGraphic(15, height);
        right = new FlxSprite(center.x + (width/2), center.y).makeGraphic(15, height);
        bottom = new FlxSprite(center.x, center.y + (height/2)).makeGraphic(width, 15);
        top.centerOffsets();
        left.centerOffsets();
        right.centerOffsets();
        bottom.centerOffsets();
        top.origin.x = center.x;
        top.origin.y = center.y;
        left.origin.x = center.x;
        left.origin.y = center.y;
        right.origin.x = center.x;
        right.origin.y = center.y;
        bottom.origin.x = center.x;
        bottom.origin.y = center.y;
        borderAssets.add(top);
        borderAssets.add(left);
        borderAssets.add(right);
        borderAssets.add(bottom);
        camera = Init.deskCam;
    }

    public function updateBorder(){
        beingHeld = (StaticInteractions.clickingObject(top) && draggable);
        center.angle = angle;
        center.x = x + (width/2);
        center.y = y + (height/2);

        top.origin.x = center.x;
        top.origin.y = center.y;
        left.origin.x = center.x;
        left.origin.y = center.y;
        right.origin.x = center.x;
        right.origin.y = center.y;
        bottom.origin.x = center.x;
        bottom.origin.y = center.y;
        top.angle = center.angle;
        left.angle = center.angle;
        right.angle = center.angle;
        bottom.angle = center.angle;
        top.x = center.x;
        top.y = center.y - (height/2);
        left.y = center.y;
        left.x = center.x - (width/2);
        right.y = center.y;
        right.x = center.x + (width/2);
        bottom.x = center.x;
        bottom.y = center.y + (height/2);
    }
}
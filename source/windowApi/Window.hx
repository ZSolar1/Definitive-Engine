package windowApi;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.group.FlxGroup;

class Window{
    public var x:Int;
    public var y:Int;
    public var width:Int;
    public var height:Int;
    public var name:String;
    public var icon:String;
    public var borderless:Bool;
    public var assets:FlxGroup;
    public var draggable:Bool;
    public var windowCam:FlxCamera;
    var border:WindowBorder;
    public function new(x:Int, y:Int, width:Int, height:Int, name:String, icon:String, draggable:Bool, assets:FlxGroup, ?borderless:Bool = false){
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.name = name;
        this.icon = icon;
        this.draggable = draggable;
        this.assets = assets;
        this.borderless = borderless;
        windowCam = new FlxCamera(this.x, this.y, this.width, this.height, 0);
        border = new WindowBorder(this.x, this.y, this.width, this.height, this.draggable);
        assets.add(border);
    }

    public function updateWindow(){
        border.updateBorder();
        if (border.beingHeld){
            border.x = FlxG.mouse.x;
            border.y = FlxG.mouse.y;
        }
        if (borderless){
            border.visible = true;
        }else{
            border.visible = false;
        }
        assets.draw();
    }

    public function minimize(){
        //mimize
    }
    public function maximize(){
        //maximize
    }
}
package statehelpers.options;

import flixel.FlxState;

class OptionCatagory{
    public var name:String;
    public var state:FlxState;
    public function new(name:String, state:FlxState){
        this.name = name;
        this.state = state;
    }
}
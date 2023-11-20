package modded.scripting;

class Script {
    public function new(scriptPath:String, ?mode:String = 'playstate'){trace('new script object');}
    public function call(func:String, ?args:Array<Dynamic>, ?theObject:Dynamic, ?exVars:Map<String,Dynamic>):Dynamic{return Dynamic;}
    public function exists(variable:String):Dynamic{return Dynamic;}
    public function get(variable:String):Dynamic{return Dynamic;}
    public function unload(){}
    public function set(variable:String, data:Dynamic):Dynamic{return Dynamic;}
}
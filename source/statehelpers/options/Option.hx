package statehelpers.options;

class Option {
    public var name:String;
    public var variable:Dynamic;
    public var type:Dynamic;
    public function new(n:String, v:Dynamic, t:Dynamic){
        name = n;
        variable = v;
        type = t;
    }
}
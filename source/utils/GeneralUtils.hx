package utils;

class GeneralUtils{
    public function removeBracketsFromArrayValue(val:String){
        trace(val);
        var ret:String = val;
        ret = StringTools.replace(ret, '[', ' ');
        trace(ret);
        ret = StringTools.replace(ret, ']', ' ');
        trace(ret);
        ret = StringTools.trim(ret);
        trace(ret);
        return ret;
    }
}

class StaticGeneralUtils{
    public static function removeBracketsFromArrayValue(val:String){
        trace(val); // null???
        var ret:String = val;
        ret = StringTools.replace(ret, '[', ' ');
        trace(ret);
        ret = StringTools.replace(ret, ']', ' ');
        trace(ret);
        ret = StringTools.trim(ret);
        trace(ret);
        return ret;
    }
}
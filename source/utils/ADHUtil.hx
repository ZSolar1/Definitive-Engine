package utils;
/*
INDICIES:
"animations": {
  "type": "indices",
  "list": {
    "animName": {
      "indices": [0,1,2,3,4,5,6,7,8,9],
      "framerate": 24,
      "loop": false
    }
  }
}

SPARROW:
"animations": {
  "type": "sparrow",
  "list": {
    "animName": {
      "prefix": "xmlPrefix",
      "framerate": 24,
      "loop": false
    }
  }
}
*/
using StringTools;

class ADHUtil { //Array Data Holder Utility, By ZSolarDev and Aura
    public static function ParseAA(data:String) {
        var res:Dynamic = [];
        var readyRaw = data;
		if (readyRaw.endsWith(';'))
			readyRaw = readyRaw.substring(0,readyRaw.length-1);
        var declarations = readyRaw.split(';');
        var result = [];
        for (declaration in declarations) {
            var variables = declaration.split(",");
            var proc:Array<String> = [];
            for (variable in 0...variables.length){
                proc.push(variables[variable].trim());
            }
            result.push(proc);
        }
        return result;
    }

    public static function ParseA(data:String) {
        var readyRaw = data;
		if (readyRaw.endsWith(';'))
			readyRaw = readyRaw.substring(0,readyRaw.length-1);
        var items:Array<String> = readyRaw.split(';');
        return items;
    }
}
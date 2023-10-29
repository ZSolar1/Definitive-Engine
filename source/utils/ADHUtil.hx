package utils;

using StringTools;

class ADHUtil { //Array Data Holder Utility
    public static function Parse(data:String) { //By ZSolarDev and Aura
		var readyRaw = data;
		if (readyRaw.endsWith(';'))
			readyRaw = readyRaw.substring(0,readyRaw.length-2);
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
}
package modded.scripting;

import states.PlayState;
import modcharting.ModchartFuncs;
import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;
import flixel.util.FlxColor;
import flixel.FlxG;

class ShmoovinLua
{
	public var lua:State = null;
	public var scriptName:String = '';

	public function new(script:String)
	{
		lua = LuaL.newstate();
		LuaL.openlibs(lua);
		Lua.init_callbacks(lua);
		try
		{
			var result:Dynamic = LuaL.dofile(lua, script);
			var resultStr:String = Lua.tostring(lua, result);
			if (resultStr != null && result != 0)
			{
				trace('Lua script encountered an error! ' + resultStr);
				lua = null;
				return;
			}
		}
		catch (e:Dynamic)
		{
			trace(e);
			return;
		}
		scriptName = script;

		// set more in future
		set('curBeat', MusicBeatState.curBeatS);
		set('curStep', MusicBeatState.curStepS);

		Lua_helper.add_callback(lua, "cameraFlash", function(color:String, duritation:Float)
		{
			FlxG.camera.flash(FlxColor.fromString(color), duritation);
		});

		Lua_helper.add_callback(lua, 'startMod', function(name:String, modClass:String, type:String = '', pf:Int = -1){
			ModchartFuncs.startMod(name,modClass,type,pf);

			PlayState.instance.playfieldRenderer.modifierTable.reconstructTable(); //needs to be reconstructed for lua modcharts
		});
		Lua_helper.add_callback(lua, 'setMod', function(name:String, value:Float){
			ModchartFuncs.setMod(name, value);
		});
		Lua_helper.add_callback(lua, 'setSubMod', function(name:String, subValName:String, value:Float){
			ModchartFuncs.setSubMod(name, subValName,value);
		});
		Lua_helper.add_callback(lua, 'setModTargetLane', function(name:String, value:Int){
			ModchartFuncs.setModTargetLane(name, value);
		});
		Lua_helper.add_callback(lua, 'setModPlayfield', function(name:String, value:Int){
			ModchartFuncs.setModPlayfield(name,value);
		});
		Lua_helper.add_callback(lua, 'addPlayfield', function(?x:Float = 0, ?y:Float = 0, ?z:Float = 0){
			ModchartFuncs.addPlayfield(x,y,z);
		});
		Lua_helper.add_callback(lua, 'removePlayfield', function(idx:Int){
			ModchartFuncs.removePlayfield(idx);
		});
		Lua_helper.add_callback(lua, 'tweenModifier', function(modifier:String, val:Float, time:Float, ease:String){
			ModchartFuncs.tweenModifier(modifier,val,time,ease);
		});
		Lua_helper.add_callback(lua, 'tweenModifierSubValue', function(modifier:String, subValue:String, val:Float, time:Float, ease:String){
			ModchartFuncs.tweenModifierSubValue(modifier,subValue,val,time,ease);
		});
		Lua_helper.add_callback(lua, 'setModEaseFunc', function(name:String, ease:String){
			ModchartFuncs.setModEaseFunc(name,ease);
		});
		Lua_helper.add_callback(lua, 'set', function(beat:Float, argsAsString:String){
			ModchartFuncs.set(beat, argsAsString);
		});
		Lua_helper.add_callback(lua, 'ease', function(beat:Float, time:Float, easeStr:String, argsAsString:String){

			ModchartFuncs.ease(beat, time, easeStr, argsAsString);
			
		});
		callLua('create', []);
	}

	var errors:Array<String> = [];
	public function callLua(theFunction:String, ?theArguments:Array<Dynamic>):Dynamic //adapted from troll engine
	{
		if (theArguments == null)
		{
			theArguments = [];
		}
		Lua.getglobal(lua, theFunction);
		if (Lua.isfunction(lua, -1) == 1)
		{
			for (argument in theArguments)
				Convert.toLua(lua, argument);

			var result:Dynamic = Lua.pcall(lua, theArguments.length, 1, 0);

			if (result != 0)
			{
				var err:String = Lua.tostring(lua, -1);
				Lua.pop(lua, 1);
				trace(err);
				if (!errors.contains(err))
				{
					var theArguments = [
						for (argument in theArguments)
						{
							(argument is String ? '"$argument"' : Std.string(argument));
						}
					];
					Sys.println('$scriptName: Uh oh! error in called function: $theFunction(${theArguments.join(', ')}): $err');
					errors.push(err);
					while (errors.length > 20)
						errors.shift();
				}
			}else{
                if(result != null){
                    var conv:Dynamic = cast Convert.fromLua(lua, -1);
                    Lua.pop(lua, 1);
                    if (conv != null)
                    return conv;
                }
            }
        }else{
            Lua.pop(lua, 1);
        }
        return 0;
	}

	public function get(variable:String):Dynamic {
		if (lua == null){
			return null;
        }
		var ret:Dynamic = null;
		Lua.getglobal(lua, variable);
		ret = Convert.fromLua(lua, -1);
		Lua.pop(lua, 1);
		return ret;
	}

	public function set(variable:String, data:Dynamic):Void
	{
		if(lua == null){
			return;
        }
		Convert.toLua(lua, data);
		Lua.setglobal(lua, variable);
	}
}

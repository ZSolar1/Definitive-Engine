package utils;

import flixel.util.FlxColor;
import haxe.xml.Fast;
import tjson.TJSON;

typedef WeekData =
{
	var name:String;
	var songs:Array<String>;
	var chars:Array<String>;
	var unlocked:Bool;
	var diffs:Array<String>;
	var freeplayColor:FlxColor;
}

class GeneralUtils
{
	public function removeBracketsFromArrayValue(val:String)
	{
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

	public function getWeekDataFromJson(json:String)
	{
		var weekData:WeekData = TJSON.parse(json);
		return (weekData);
	}

	@:deprecated("`getWeekDataFromXml()` is the old week system. It still works, but is VERY limited. Please use `getWeekDataFromJson` instead.")
	public function getWeekDataFromXml(data:String, theFast:Fast):Dynamic
	{
		if (data == 'weekName')
		{
			var weekDataXml = theFast.node.weekData;
			if (weekDataXml.has.weekName)
				return weekDataXml.att.weekName;
			else
				return 'No Week Name';
		}
		if (data == 'freeplayColor')
		{
			var weekDataXml = theFast.node.weekData;
			if (weekDataXml.has.freeplayColor)
			{
				return FlxColor.fromString(weekDataXml.att.freeplayColor);
			}
			else
			{
				return 0x000000;
			}
		}

		if (data == 'diffs')
		{
			var weekDataXml = theFast.node.diffs;
			var diffs:Array<String> = [];
			if (weekDataXml.att.diff1 != "")
				diffs.push(weekDataXml.att.diff1);
			else
			{
				diffs.push('Easy');
				diffs.push('Normal');
				diffs.push('Hard');
			}

			if (weekDataXml.att.diff2 != "")
				diffs.push(weekDataXml.att.diff2);

			if (weekDataXml.att.diff3 != "")
				diffs.push(weekDataXml.att.diff3);

			return diffs;
		}
		if (data == 'songs')
		{
			var weekDataXml = theFast.node.songs;
			var songs:Array<String> = [];
			songs.push(weekDataXml.att.song1);

			if (weekDataXml.att.song2 != "")
				songs.push(weekDataXml.att.song2);

			if (weekDataXml.att.song3 != "")
				songs.push(weekDataXml.att.song3);

			return songs;
		}
		if (data == 'freeplayIcon')
		{
			var weekDataXml = theFast.node.icon;
			return weekDataXml.att.icon;
		}
		if (data == 'chars')
		{
			var weekDataXml = theFast.node.chars;
			var chars:Array<String> = [];
			if (weekDataXml.has.char1)
				chars.push(weekDataXml.att.char1);
			else
				return null;
			if (weekDataXml.has.char2)
				chars.push(weekDataXml.att.char2);
			else
				return null;
			if (weekDataXml.has.char3)
				chars.push(weekDataXml.att.char3);
			else
				return null;

			return chars;
		}
		if (data == 'unlocked')
		{
			var weekDataXml = theFast.node.weekData;
			if (weekDataXml.has.unlocked)
				return weekDataXml.att.unlocked;
			else
				return 'true';
		}
		return Dynamic;
	}

	public function stringToBool(str:String)
	{
		if (['true', 'false'].contains(str))
			if (str == 'true')
				return true;
			else
				return false;

		return false;
	}
}

class StaticGeneralUtils
{
	public static function removeBracketsFromArrayValue(val:String)
	{
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

	@:deprecated("`getSongDataFromXml()` is the old week system. It still works, but is VERY limited. Please use `getSongDataFromJson` instead.")
	public static function getSongDataFromXml(theFast:Fast):Array<String>
	{
		var weekDataXml = theFast.node.songs;
		var songs:Array<String> = [];
		songs.push(weekDataXml.att.song1);

		if (weekDataXml.att.song2 != "")
			songs.push(weekDataXml.att.song2);

		if (weekDataXml.att.song3 != "")
			songs.push(weekDataXml.att.song3);

		return songs;
	}

	@:deprecated("`getWeekDataFromXml()` is the old week system. It still works, but is VERY limited. Please use `getWeekDataFromJson` instead.")
	public static function getWeekDataFromXml(data:String, theFast:Fast):Dynamic
	{
		if (data == 'weekName')
		{
			var weekDataXml = theFast.node.weekData;
			if (weekDataXml.has.weekName)
				return weekDataXml.att.weekName;
			else
				return 'No Week Name';
		}
		if (data == 'songs')
		{
			var weekDataXml = theFast.node.songs;
			var songs:Array<String> = [];
			songs.push(weekDataXml.att.song1);

			if (weekDataXml.att.song2 != "")
				songs.push(weekDataXml.att.song2);

			if (weekDataXml.att.song3 != "")
				songs.push(weekDataXml.att.song3);

			return songs;
		}
		if (data == 'freeplayColor')
		{
			var weekDataXml = theFast.node.weekData;
			if (weekDataXml.has.freeplayColor)
			{
				return FlxColor.fromString(weekDataXml.att.freeplayColor);
			}
			else
			{
				return 0x000000;
			}
		}
		if (data == 'diffs')
		{
			var weekDataXml = theFast.node.diffs;
			var diffs:Array<String> = [];
			if (weekDataXml.att.diff1 != "")
				diffs.push(weekDataXml.att.diff1);
			else
			{
				diffs.push('Easy');
				diffs.push('Normal');
				diffs.push('Hard');
			}

			if (weekDataXml.att.diff2 != "")
				diffs.push(weekDataXml.att.diff2);

			if (weekDataXml.att.diff3 != "")
				diffs.push(weekDataXml.att.diff3);

			return diffs;
		}
		if (data == 'freeplayIcon')
		{
			var weekDataXml = theFast.node.icon;
			return weekDataXml.att.icon;
		}
		if (data == 'chars')
		{
			var weekDataXml = theFast.node.chars;
			var chars:Array<String> = [];
			if (weekDataXml.has.char1)
				chars.push(weekDataXml.att.char1);
			else
				return null;
			if (weekDataXml.has.char2)
				chars.push(weekDataXml.att.char2);
			else
				return null;
			if (weekDataXml.has.char3)
				chars.push(weekDataXml.att.char3);
			else
				return null;

			return chars;
		}
		if (data == 'unlocked')
		{
			var weekDataXml = theFast.node.weekData;
			if (weekDataXml.has.unlocked)
				return weekDataXml.att.unlocked;
			else
				return 'true';
		}
		return Dynamic;
	}

	public static function stringToBool(str:String)
	{
		if (['true', 'false'].contains(str))
			if (str == 'true')
				return true;
			else
				return false;

		return false;
	}
}

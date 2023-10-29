package utils;

import sys.FileSystem;

class ModUtils
{
	public function getModNameForFile(filePath:String)
	{
		if (FileSystem.exists('mods/'))
		{
			for (mod in FileSystem.readDirectory('mods/'))
			{
				if (FileSystem.exists('mods/$mod/$filePath'))
				{
					return mod;
					break;
				}
			}
		}
		return '';
	}

	public function getMods(getWeeks:Bool, returnPaths:Bool, ?pathsOnly:Bool):Dynamic
	{
		var ret:Array<String> = [];
		for (folder in FileSystem.readDirectory('mods/'))
		{
			if (folder != 'packagedMods')
			{
				for (week in FileSystem.readDirectory('mods/$folder/weeks/'))
				{
					if (getWeeks)
					{
						if (returnPaths)
						{
							if (pathsOnly)
							{
								ret.push('mods/$folder/weeks/');
							}
							else
							{
								ret.push('mods/$folder/weeks/$week');
							}
						}
						else
						{
							ret.push(week);
						}
					}
					else
					{
						if (returnPaths)
						{
							ret.push('mods/$folder/');
						}
						else
						{
							ret.push('$folder');
						}
					}
				}
			}
		}
		if (ret.length > 1)
		{
			return ret;
		}
		else
		{
			return ret[0];
		}
	}
}

class StaticModUtils
{
	public static function getModNameForFile(filePath:String)
	{
		if (FileSystem.exists('mods/'))
		{
			for (mod in FileSystem.readDirectory('mods/'))
			{
				if (FileSystem.exists('mods/$mod/$filePath'))
				{
					return mod;
					break;
				}
			}
		}
		return '';
	}

	public static function getMods(getWeeks:Bool, returnPaths:Bool, ?pathsOnly:Bool):Dynamic // DON'T USE THIS FUNCTION, PLEASE
	{
		var ret:Array<String> = [];
		for (folder in FileSystem.readDirectory('mods/'))
		{
			if (folder != 'packagedMods')
			{
				for (week in FileSystem.readDirectory('mods/$folder/weeks/'))
				{
					if (getWeeks)
					{
						if (returnPaths)
						{
							if (pathsOnly)
							{
								ret.push('mods/$folder/weeks/');
							}
							else
							{
								ret.push('mods/$folder/weeks/$week');
							}
						}
						else
						{
							ret.push(week);
						}
					}
					else
					{
						if (returnPaths)
						{
							ret.push('mods/$folder/');
						}
						else
						{
							ret.push('$folder');
						}
					}
				}
			}
		}
		if (ret.length > 1)
		{
			return ret;
		}
		else
		{
			return ret[0];
		}
	}
}

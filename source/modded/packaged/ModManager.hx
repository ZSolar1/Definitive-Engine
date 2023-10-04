package modded.packaged;

import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxState;
import flixel.FlxSubState;
import sys.io.FileOutput;
import flixel.FlxG;
import sys.FileSystem;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.zip.Entry;
import sys.io.File;
import haxe.zip.Reader;

class ModManager extends FlxState
{
	public var ogState:FlxState;
	override public function new(){super();}

	public static function unpackModfile(modPath:String, exportPath:String)
	{
		var fileBytes = Bytes.ofString(weakDecode(File.getContent(modPath)));
		var bytesInput = new BytesInput(fileBytes);
		var reader = new Reader(bytesInput);
		var entries:List<Entry> = reader.read();
		for (_entry in entries)
		{
			var data = Reader.unzip(_entry);
			if (_entry.fileName.substring(_entry.fileName.lastIndexOf('/') + 1) == '' && _entry.data.toString() == '')
			{
				sys.FileSystem.createDirectory(exportPath + _entry.fileName);
			}
			else
			{
				var f = File.write(exportPath + _entry.fileName, true);
				f.write(data);
				f.close();
			}
		}
	}

	// recursive read a directory, add the file entries to the list
	function getEntries(dir:String, entries:List<haxe.zip.Entry> = null, inDir:Null<String> = null)
	{
		if (entries == null)
			entries = new List<haxe.zip.Entry>();
		if (inDir == null)
			inDir = dir;
		for (file in sys.FileSystem.readDirectory(dir))
		{
			var path = haxe.io.Path.join([dir, file]);
			if (sys.FileSystem.isDirectory(path))
			{
				getEntries(path, entries, inDir);
			}
			else
			{
				var bytes:haxe.io.Bytes = haxe.io.Bytes.ofData(sys.io.File.getBytes(path).getData());
				var entry:haxe.zip.Entry = {
					fileName: StringTools.replace(path, inDir, ""),
					fileSize: bytes.length,
					fileTime: Date.now(),
					compressed: false,
					dataSize: sys.FileSystem.stat(path).size,
					data: bytes,
					crc32: haxe.crypto.Crc32.make(bytes)
				};
				entries.push(entry);
			}
		}
		return entries;
	}

	/**
		Prepares the process of writing the packaged mod file.
		@param modFolderToPack - The folder to pack into a .dem
		@param outputFileName - The name of the packaged file to get generated. (.dem isnt required, but wont break anything if you add it.)
		@param outputDir -  The directory of the packaged file to get generated. (a slash at the end isnt required, but wont break anything if you add it.)
	*/
	public function packModfile(modFolderToPack:String, outputFileName:String, outputDir:String)
	{
		var processedName:String = StringTools.replace(StringTools.ltrim(outputFileName), ' ', '-');
		if (!StringTools.endsWith(outputFileName, '.dem'))
		{
			processedName = outputFileName + '.dem';
		}
		var realOutputDir = outputDir;
		if (!StringTools.endsWith(outputDir, '/')){
			realOutputDir += '/';
		}
		var fullOutputDir = '$realOutputDir/$processedName';

		// create the output file
		var out = sys.io.File.write(fullOutputDir, true);

		// write the mod file
		var mod = new haxe.zip.Writer(out);
		mod.write(getEntries(modFolderToPack));

		var encoded = weakEncode(File.getContent(fullOutputDir));
		var finalFile:FileOutput;
		finalFile = File.write(fullOutputDir, true);
		finalFile.writeString(encoded);

		ogState = FlxG.state;
		openSubState(new ModPackager(fullOutputDir, ogState));
	}

	public function weakEncode(string:String){ //very basic, ik
		var encoded:String = 'dem.make() ';
		encoded += string;
		encoded = StringTools.replace(encoded, 'i', '8ec');
		encoded = StringTools.replace(encoded, 'o', '9ec');
		encoded = StringTools.replace(encoded, 'p', '0ec');
		encoded = StringTools.replace(encoded, 'q', '1ec');
		encoded = StringTools.replace(encoded, 'r', '4ec');
		encoded = StringTools.replace(encoded, 't', '5ec');
		encoded = StringTools.replace(encoded, 'u', '7ec');
		encoded = StringTools.replace(encoded, 'w', '2ec');
		encoded = StringTools.replace(encoded, 'y', '6ec');
		return encoded;
	}

	public static function weakDecode(string:String){
		var encoded:String = string;
		encoded = StringTools.replace(encoded, '8ec', '1');
		encoded = StringTools.replace(encoded, '9ec', 'o');
		encoded = StringTools.replace(encoded, '0ec', 'p');
		encoded = StringTools.replace(encoded, '1ec', 'q');
		encoded = StringTools.replace(encoded, '4ec', 'r');
		encoded = StringTools.replace(encoded, '5ec', 't');
		encoded = StringTools.replace(encoded, '7ec', 't');
		encoded = StringTools.replace(encoded, '2ec', 'w');
		encoded = StringTools.replace(encoded, '6ec', 'y');
		encoded = encoded.substr(11, encoded.length);
		return encoded;
	}
}

class ModPackager extends FlxSubState{
	var pathBeingWrittenTo:String = '';
	var ogState:FlxState;
	var blackScreen:FlxSprite;
	var loadingText:FlxText;
	override public function new(pathBeingWrittenTo:String, ogState:FlxState){
		super();
		this.pathBeingWrittenTo = pathBeingWrittenTo;
		this.ogState = ogState;
	}

	override function create(){
		super.create();
		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x0000000);
		blackScreen.alpha = 0;
		FlxTween.tween(blackScreen, {alpha: 0.6}, 1, {});
		add(blackScreen);
	}
}
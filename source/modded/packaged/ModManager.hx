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

using StringTools;

class ModManager extends FlxState
{
	public var ogState:FlxState;
	override public function new(){super();}

	public static function unpackModfile(modPath:String, exportPath:String)
	{
		var fileBytes = File.getBytes(modPath);
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
					fileName: path.replace(inDir, ""),
					fileSize: bytes.length,
					fileTime: Date.now(),
					compressed: true,
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
		var processedName:String = outputFileName.ltrim().replace(' ', '-');
		if (!outputFileName.endsWith('.dem'))
		{
			processedName = outputFileName + '.dem';
		}
		if (processedName.startsWith('/')){
			processedName = processedName.substring(1, processedName.length);
		}
		var realOutputDir = outputDir;
		if (!outputDir.endsWith('/')){
			realOutputDir += '/';
		}
		var fullOutputDir = '$realOutputDir/$processedName';

		// create the output file
		var out = sys.io.File.write(fullOutputDir, true);

		// write the mod file
		var mod = new haxe.zip.Writer(out);
		mod.write(getEntries(modFolderToPack));

		var finalFile:FileOutput;
		finalFile = File.write(fullOutputDir, true);
		finalFile.writeString(File.getContent(fullOutputDir));
	}
}
package modded.scripting;

import modcharting.ModchartFuncs;
import sys.io.File;
import sys.FileSystem;
import modcharting.ModchartFile;
import modcharting.NotePositionData;
import modcharting.NoteMovement;
import modcharting.Modifier;
import modcharting.ModchartUtil;
import modcharting.PlayfieldRenderer;
import states.PlayState;
import hscript.Expr;
import hscript.Parser;
import hscript.Interp;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;
import openfl.Lib;
import openfl.filters.BitmapFilter;
import openfl.filters.BitmapFilterQuality;
import openfl.filters.BitmapFilterShader;
import openfl.filters.BitmapFilterType;
import openfl.filters.BlurFilter;
import openfl.filters.ColorMatrixFilter;
import openfl.filters.ConvolutionFilter;
import openfl.filters.DropShadowFilter;
import openfl.filters.GlowFilter;
import openfl.filters.ShaderFilter;

class ShmoovinHScript extends Script
{
	public var hscriptParser:Parser;
	public var hscriptInterp:Interp;

	override public function new(scriptPath:String, ?mode:String = 'playstate')
	{
		super(scriptPath, mode);
		hscriptParser = new hscript.Parser();
		hscriptInterp = new hscript.Interp();

		hscriptInterp.variables.set("Math", Math); // UGHHHUUUUGH. THIS TOOK WAY TOO LONG TO SETUPP *sobbing*
		hscriptInterp.variables.set("StringTools", StringTools);
		hscriptInterp.variables.set("Array", Array);
		hscriptInterp.variables.set("Xml", Xml);
		hscriptInterp.variables.set("haxe", {
			"Json": haxe.Json,
			"Serializer": haxe.Serializer,
			"Unserializer": haxe.Unserializer
		});

		// Flixel stuff
		hscriptInterp.variables.set("FlxG", FlxG);
		hscriptInterp.variables.set("FlxSprite", FlxSprite);
		hscriptInterp.variables.set("FlxEase", FlxEase);
		hscriptInterp.variables.set("FlxTween", FlxTween);
		hscriptInterp.variables.set("FlxText", FlxText);
		hscriptInterp.variables.set("FlxBackdrop", FlxBackdrop);
		hscriptInterp.variables.set("FlxCamera", FlxCamera);

		// OpenFL stuff
		hscriptInterp.variables.set("Lib", openfl.Lib);
		hscriptInterp.variables.set("BitmapFilter", BitmapFilter);
		hscriptInterp.variables.set("BitmapFilterShader", BitmapFilterShader);
		hscriptInterp.variables.set("BlurFilter", BlurFilter);
		hscriptInterp.variables.set("ColorMatrixFilter", ColorMatrixFilter);
		hscriptInterp.variables.set("ConvolutionFilter", ConvolutionFilter);
		hscriptInterp.variables.set("DropShadowFilter", DropShadowFilter);
		hscriptInterp.variables.set("GlowFilter", GlowFilter);
		hscriptInterp.variables.set("ShaderFilter", ShaderFilter);

		// Definitive Engine stuff
		hscriptInterp.variables.set("PlayState", PlayState);
		hscriptInterp.variables.set("instance", PlayState.instance);
		hscriptInterp.variables.set("curBeat", MusicBeatState.curBeatS);
		hscriptInterp.variables.set("curStep", MusicBeatState.curStepS);
		hscriptInterp.variables.set('PlayfieldRenderer', PlayfieldRenderer);
		hscriptInterp.variables.set('ModchartUtil', ModchartUtil);
		hscriptInterp.variables.set('Modifier', Modifier);
		hscriptInterp.variables.set('NoteMovement', NoteMovement);
		hscriptInterp.variables.set('Conductor', Conductor);
		hscriptInterp.variables.set('NotePositionData', NotePositionData);
		hscriptInterp.variables.set('ModchartFile', ModchartFile);
		hscriptInterp.variables.set('ModchartFuncs', ModchartFuncs);

		hscriptInterp.execute(hscriptParser.parseString(File.getContent(scriptPath)));
		call("start", []);
	}

	override public function get(variable:String):Dynamic
	{
		super.get(variable);
		if (hscriptInterp == null)
			return null;

		return hscriptInterp.variables.get(variable);
	}

	override public function unload(){
		super.unload();
		hscriptInterp = null;
		hscriptParser = null;
	}

	override public function set(variable:String, value:Dynamic)
	{
		super.set(variable, value);
		if (hscriptInterp == null)
			return Dynamic;

		hscriptInterp.variables.set(variable, value);
		return Dynamic;
	}

	override public function exists(variable:String):Bool
	{
		super.exists(variable);
		if (hscriptInterp == null)
			return false;

		return hscriptInterp.variables.exists(variable);
	}

	override public function call(functionName:String, ?args:Array<Dynamic>, ?theObject:Dynamic, ?exVars:Map<String,Dynamic>)
	{
		super.call(functionName, args);
		var daFunc = get(functionName);
		if (!Reflect.isFunction(daFunc))
			return null;

		if (args == null)
			args = [];

        if (exVars == null) 
			exVars = [];

        if (theObject != null)
			exVars.set("this", theObject);

		var defaultShit:Map<String, Dynamic> = [];
		for (key in exVars.keys())
		{
			defaultShit.set(key, get(key)); // Store original values of variables that are being overwritten

			set(key, exVars.get(key));
		}

		var returnVal:Dynamic = null;
		try
		{
			returnVal = Reflect.callMethod(theObject, daFunc, args);
		}
		catch (e:haxe.Exception)
		{
			haxe.Log.trace(e.message, hscriptInterp.posInfos());
		}

		for (key in defaultShit.keys())
			set(key, defaultShit.get(key));

		return returnVal;
	}
}

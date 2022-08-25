package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class CORRUPTIONJUMPSCARESTATE extends MusicBeatState
{
	public static var leftOffAtCurstep:Float;


	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"NOTE:\n\nCorrupted difficulty is intended to be hard by piggybacking on Hard\ncharts while increasing scroll speed and messing up your game\nin other ways.\n\nPRESS SPACE, ENTER, ESCAPE OR BACKSPACE TO PASS THIS",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		
		super.update(elapsed);
	}
}

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class HardModeIsActuallyFuckingHardState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"THIS IS AN EARLY ALPHA OF V4\nYOU HAVE ACCESS TO SOME UNRELEASED CONTENT ALONGSIDE MOST RELEASED CONTENT\nALMOST NOTHING HERE IS FINAL, n0rmal_crew.",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			leftState = true;
			#if desktop
			if(!FlxG.save.data.skinID)
				FlxG.switchState(new SkinSelector());
			else
				FlxG.switchState(new MainMenuState());
			#else
				FlxG.switchState(new Piracy());
			#end
		}
		if(controls.CHEAT)
		{
			leftState = true;
			FlxG.switchState(new Piracy());
		}
		if (controls.BACK)
		{
			leftState = true;
			#if desktop
			if(!FlxG.save.data.skinID)
				FlxG.switchState(new SkinSelector());
			else
				FlxG.switchState(new MainMenuState());
			#else
			FlxG.switchState(new Piracy());
			#end
		}
		super.update(elapsed);
	}
}

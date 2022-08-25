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
			"IMPORTANT NOTES:\n\nWe have a discord server you can find in Options.\nSome dialogue sequences have screen shaking so just be wary of that\nThe charts are intended for players who are skilled in rhythm games,\nso please don't complain about High Stakes's charting.\nYou can check the gimmicks for each song on the GameBanana page.\nBrutal Difficulty, a bonus Freeplay difficulty, is unlocked individually for every song when it is completed on Standard.\n\nNo, we did NOT \"steal\" Screwed from Dave and Bambi. After it got removed from D&B TPTF let us use Screwed in PWYL.\nI accidentally broke fullscreen lmao\nOne more thing: IT IS RECOMMENDED YOU DO NOT SKIM OVER THE MOD AS YOU WILL MOST LIKELY MISS OUT ON LORE AND HALF OF THE FUN\n\nPRESS SPACE, ENTER, ESCAPE OR BACKSPACE TO PASS THIS",
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

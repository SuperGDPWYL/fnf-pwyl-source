package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class Piracy extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Hey,\nI'm SuperGD, the creator of the mod, with a special message.\nI couldn't help but notice that you're playing this on a website.\nI wouldn't have a problem with this, but there's two things that make this not ideal:\n- This mod was built to run on Windows\n- Some mechanics may be removed to help it run on lower-end PCs\nSo, while that is good for Chromebook users, I would recommend that if you have a Windows PC that isn't a potato,\nthat you download this mod from GameBanana and play it there.\nEspecially if you're a YouTuber, because you don't want to miss out\nif you're recording a video!\n- SuperGD\n\nPress Space/Enter to load the GameBanana page",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.openURL("https://gamebanana.com/mods/44586");
		}
		if (controls.BACK)
		{
			leftState = true;
			if(!FlxG.save.data.skinID)
				FlxG.switchState(new SkinSelector());
			else
				FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}

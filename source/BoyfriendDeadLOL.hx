package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class BoyfriendDeadLOL extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";
    public static var difficulty:String = "";
    public static var difficultyID:Int = 1;

	override function create()
	{
		super.create();
        if(difficulty == "-corrupted")
            difficulty == "-hard";
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"A fatal error has occured.\nBoyfriend failed to glitch Corrupt with the legendary note, and died after the events of Suffer in Blood.\nDue to this, Boyfriend is dead and we are unable to continue like this.\n\nTo reload Funkin.exe, press Enter or Space.",
			32);
		txt.setFormat("VCR OSD Mono", 64, FlxColor.RED, CENTER);
		txt.screenCenter();
		add(txt);
        /*var desc:FlxText = new FlxText(0, 72, FlxG.width, "Boyfriend failed to glitch Corrupt with the legendary note, and died after the events of Suffer in Blood.\nDue to this, Boyfriend is dead and we are unable to continue like this.\n\nTo reload Funkin.exe, press Enter or Space.");
        desc.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		desc.screenCenter();
		add(desc);*/
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			leftState = true;
			PlayState.SONG = Song.loadFromJson('suffer-in-blood' + difficulty, 'suffer-in-blood');
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = difficultyID;
			PlayState.storyWeek = 7;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}

		
		super.update(elapsed);
	}
}

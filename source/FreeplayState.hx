package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxSave;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;


#if desktop
import Discord.DiscordClient;
#end


using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];
	var debugSong:Bool = false;

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 2;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var AllPossibleSongs:Array<String> = ["Blast to The Past", "PWYL v4", "Playing With Your Life","Corrupt's Last Stand","RELOADED","Yakob's Contract","Covers"];

	private var CurrentPack:Int = 0;

	private var NameAlpha:Alphabet;

	private var InMainFreeplayState:Bool = false;

	var loadingPack:Bool = false;

	var gameSave = new FlxSave();

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	

	var catText:FlxText;



	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		if(FlxG.save.data.brutalUnlocked == null)
			{
				FlxG.save.data.brutalUnlocked = [
					[false, 'high-stakes'],
					[false, 'process-unstable'],
					[false, 'insanity'],
					[false, 'life-or-death'],
					[false, 'bloodbath'],
					[false, 'mechanical-whirrs'],
					[false, 'fused'],
					[false, 'retribution'],
					[false, 'counter-attack'],
					[false, 'non-yakob'],
					[false, 'chronicles'],
					[false, 'slash-n-slice'],
					[false, 'killing-spree'],
					[false, 'old-fire'],
					[false, 'sauce'],
					[false, 'no-escape'],
					[false, 'crime'],
					[false, 'imprisonment'],
					[false, 'death-row'],
					[false, 'yakobification'],
					[false, 'screwed']
				];
				trace('Initialised the brutal saves!');
			}
		FlxG.resizeGame(FlxG.width, FlxG.height);
		FlxG.timeScale = 1;

		/*
			
		for (i in 0...initSonglist.length)
			{	
				var data:Array<String> = initSonglist[i].split(':');
				if(data.contains('')){
					AntiCheatState.anticheatReason = "try to cheat yourself into Hexes";
					trace('NO FUCKING CHEATING');
					LoadingState.loadAndSwitchState(new AntiCheatState());
				}else{
					
					songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1]));
					
				}
			}&/
			
		

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		 #if desktop
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Menus", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC


		/*if(FlxG.save.data.beatSIB || Sys.environment()['USERNAME'] == 'super' || fireices_showcase_build) 
			songs.push(new SongMetadata('Mechanical-Whirrs',Std.parseInt('7'), 'corruptsib'));

		if(FlxG.save.data.beatWhirrs || Sys.environment()['USERNAME'] == 'super' || fireices_showcase_build)
			songs.push(new SongMetadata('Retribution',Std.parseInt('7'), 'corruptsib'));

		songs.push(new SongMetadata('Fused',Std.parseInt('7'), 'corruptsib'));
		songs.push(new SongMetadata('Termination',Std.parseInt('7'), 'corruptsib'));
		songs.push(new SongMetadata('Madness',Std.parseInt('7'), 'corruptsib'));*/

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		
		NameAlpha  = new Alphabet(0, 0, AllPossibleSongs[CurrentPack], true, false);
		NameAlpha.y += 260;
		Highscore.load();
		add(NameAlpha);
		NameAlpha.screenCenter(X);
		catText = new FlxText(0,0,0, "Please select a category:", 32);
		catText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		catText.screenCenter(X);
		catText.y = NameAlpha.y - 50;
		add(catText);


		super.create();

		/*for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		/*if(gameSave.data.unlockedAnarchist == true)
			{
				addSong('anarchist', 420, 'corrupt');
			}*/

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		//super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));

	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	public function LoadProperPack()
		{
			if (AllPossibleSongs[CurrentPack].toLowerCase() == 'close encounter')
				{
					addWeek(['Chronicles', 'Slash-n-Slice', 'Killing-Spree'], 0, ['face']);
				}
			else if (AllPossibleSongs[CurrentPack].toLowerCase() == 'blast to the past')
			{
				addWeek(['Old-Fire', 'Sauce', 'No-Escape', 'Jupiter'], 1, ['fireice', 'fireice', 'fireice-demigod','fireice-demigod']);
				if(FlxG.save.data.crime)
					addWeek(['Crime'], 1, ['rtx']);
			}
			else if (AllPossibleSongs[CurrentPack].toLowerCase() == 'pwyl v4')
			{
				addWeek(['Electric'], 2, ['corrupt']);
			}
			else if (AllPossibleSongs[CurrentPack].toLowerCase() == 'playing with your life')
			{
				var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
				addWeek(['Electric', 'Process-Unstable', 'Insanity', 'Life-or-Death', 'Bloodbath'], 2, ['corrupt', 'corrupt', 'corrupt', 'corrupt', 'corruptsib']);
				for (i in 0...initSonglist.length)
				{	
					var data:Array<String> = initSonglist[i].toLowerCase().split(':');
					if(data.contains('the-inevitable')){
						addWeek(['The-Inevitable'],0,['fused']);
					}
				}
			}
			else if (AllPossibleSongs[CurrentPack].toLowerCase() == 'the finale')
			{
				addWeek(['Mechanical-Whirrs', 'Fused', 'Retribution','Counter-Attack'], 3, ['corruptsib', 'fused', 'prototype', 'prototype']);
			}
			else if (AllPossibleSongs[CurrentPack].toLowerCase() == 'corrupt\'s last stand')
			{
				addWeek(['Mechanical-Whirrs', 'Fused'], 3, ['corruptsib', 'fused']);
			}
			else if (AllPossibleSongs[CurrentPack].toLowerCase() == 'reloaded')
			{
				addWeek(['Retribution', 'Twisted-Sounds', 'Counter-Attack'], 4, ['prototype']);
			}
			else if (AllPossibleSongs[CurrentPack].toLowerCase() == 'covers')
			{
				addWeek(['Termination', 'Madness'], 0, ['corruptsib']);
			}
			else if (AllPossibleSongs[CurrentPack].toLowerCase() == 'extras')
				{
					addWeek(['Twisted-Sounds'], 0, ['face']);
				}
			else if (AllPossibleSongs[CurrentPack].toLowerCase() == 'yakob\'s contract')
			{
				addWeek(['non-yakob', 'yakobification'], 0, ['yakob']);
			}
		}

	public function GoToActualFreeplay()
	{
		InMainFreeplayState = true;
		catText.visible = false;
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			if(songs[i].songName.toLowerCase() == 'counter-attack')
				songText.dashes = true;
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);



		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));
			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;
			FlxG.stage.addChild(texFel);
			// scoreText.textField.htmlText = md;
			trace(md);
		 */
	}

	public function UpdatePackSelection(change:Int)
	{
		CurrentPack += change;
		if (CurrentPack == -1)
		{
			CurrentPack = AllPossibleSongs.length - 1;
		}
		if (CurrentPack == AllPossibleSongs.length)
		{
			CurrentPack = 0;
		}
		NameAlpha.destroy();
		NameAlpha = new Alphabet(0, 0, AllPossibleSongs[CurrentPack], true, false);
		NameAlpha.y += 260;
		add(NameAlpha);
		NameAlpha.screenCenter(X);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!InMainFreeplayState) 
			{
				if (controls.LEFT_P)
				{
					UpdatePackSelection(-1);
				}
				if (controls.RIGHT_P)
				{
					UpdatePackSelection(1);
				}
				if (controls.ACCEPT && !loadingPack)
				{
					loadingPack = true;
					LoadProperPack();
					//FlxTween.tween(CurrentSongIcon, {alpha: 0}, 0.3);
					FlxTween.tween(NameAlpha, {alpha: 0}, 0.3);
					new FlxTimer().start(0.5, function(Dumbshit:FlxTimer)
					{
						//CurrentSongIcon.visible = false;
						NameAlpha.visible = false;
						GoToActualFreeplay();
						InMainFreeplayState = true;
						loadingPack = false;
					});
				}
				if (controls.BACK)
				{
					FlxG.switchState(new MainMenuState());
				}	
			
				return;
			}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
			changeDiff(0);
		}
		if (downP)
		{
			changeSelection(1);
			changeDiff(0);
		}

		if (controls.LEFT_P)
			changeDiff(-2);
		if (controls.RIGHT_P)
			changeDiff(2);

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			var valid:Bool = true;
			for(i in 0...FlxG.save.data.brutalUnlocked.length)
			{
				if(FlxG.save.data.brutalUnlocked[i][1] == songs[curSelected].songName.toLowerCase())
				{
					if (FlxG.save.data.brutalUnlocked[i][0] == false && curDifficulty == 4 && Sys.environment()['USERNAME'] != 'super')
						valid = false;
				}
			}

			if(valid)
			{
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				if(songs[curSelected].songName.toLowerCase() == 'life-or-death' && debugSong == true)
			{
				trace('Debugging for now');
				FlxG.switchState(new NotOverYetState());
		
			} else if(songs[curSelected].songName.toLowerCase() == 'e-debug-lmao-fatal-error')
			{
				BoyfriendDeadLOL.difficulty = "-easy";
				BoyfriendDeadLOL.difficultyID = 0;
				LoadingState.loadAndSwitchState(new BoyfriendDeadLOL());
			} else {
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
				PlayState.storyWeek = songs[curSelected].week;
				trace('CUR WEEK' + PlayState.storyWeek);
				LoadingState.loadAndSwitchState(new PlayState());
			}
			trace(poop);
			} else 
				FlxG.camera.shake();

			
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 4;
		if (curDifficulty > 4)
			curDifficulty = 0;
		

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "BABY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "STANDARD";
				if(songs[curSelected].songName.toLowerCase() == 'termination')
					diffText.text = "VERY HARD";
			case 3:
				diffText.text = "CORRUPTED";
			case 4:
				if(songs[curSelected].week == 4)
					diffText.text = "FUCKED";
				else
					diffText.text = "BRUTAL";
				
				for(i in 0...FlxG.save.data.brutalUnlocked.length)
					{
						if(FlxG.save.data.brutalUnlocked[i][1] == songs[curSelected].songName.toLowerCase())
						{
							if (FlxG.save.data.brutalUnlocked[i][0] == false)
								diffText.text += " (LOCKED)";
						}
					}
					

		}
	}



	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		changeDiff(0);

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		if(songs[curSelected].songName == "The-Inevitable")
			FlxG.sound.playMusic(Paths.music('funi'));
		else
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}

package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	var weekData:Array<Dynamic> = [
		['Old-Fire', 'Sauce', 'No-Escape'],
		['High-Stakes', 'Process-Unstable', 'Insanity', 'Life-Or-Death', 'Bloodbath'],
		['Mechanical-Whirrs', 'Fused', 'Screwed'],
		['Retribution', 'Counter-Attack'],
		['Non-Yakob']
	];
	var curDifficulty:Int = 2;

	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true, true]; //ykw

	public static var unlockGuides:Array<String> = ["If you see this, your copy of the mod is bugged.","Clear Playing With Your Life",".","what","explain!"];

	var weekNameOffsets:Array<Dynamic> = [
		FlxG.width/3,
		FlxG.width/4,
		FlxG.width/4
	];

	var weekCharacters:Array<Dynamic> = [
		['', 'bf', ''],
		['', '', ''],
		['', '', ''],
		['', '', ''],
		['', '', '']
	];

	var weekNames:Array<String> = [
		"Blast to The Past - VS FireIce",
		"Playing With Your Life - VS Corrupt",
		"Corrupt's Last Stand",
		"Playing With Your Life: Reloaded - VS Prototype",
		"Blood Money - Yakob's Contract"
	];

	var txtWeekTitle:FlxText;

	var txtTracks:FlxText;

	var txtSwitchWeeks:FlxText;

	var txtWeekLocked:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence

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

		DiscordClient.changePresence("In the Menus", null);
		FlxG.resizeGame(FlxG.width, FlxG.height);
		#end
		FlxG.timeScale = 1;
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		if(FlxG.save.data.beatPWYL)
			weekUnlocked.push(true);
		

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width/3, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txtWeekTitle.alpha = 1;

		txtTracks = new FlxText(FlxG.width/2.5, FlxG.height-160, 0, "TRACKS", 32);
		txtTracks.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);

		txtSwitchWeeks = new FlxText(FlxG.width/3, 60, 0, "UP/DOWN TO SWITCH WEEKS\nENTER TO LOAD WEEK", 32);
		txtSwitchWeeks.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txtSwitchWeeks.alpha = 1;

		txtWeekLocked = new FlxText(FlxG.width/4, 160, 0, "WEEK LOCKED", 32);
		txtWeekLocked.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txtWeekLocked.alpha = 1;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var diffTex = Paths.getSparrowAtlas('campaign_menu_UI_diff');
		var yellowBG:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menuBG'));

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		//var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		//add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				//grpLocks.add(lock);
			}
		}

		trace("Line 96");

		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false));
		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.9, true));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true));

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = diffTex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.addByPrefix('corrupted', 'CORRUPTED');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		trace("Line 150");

		add(yellowBG);
		add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width/3, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		//txtTracklist.color = 0xFFe55777;
		txtTracklist.color = FlxColor.WHITE;
		txtTracklist.alpha = 1;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);
		add(txtSwitchWeeks);
		add(txtTracks);
		add(txtWeekLocked);

		updateText();

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float)
	{

		txtTracklist.screenCenter(X);

		txtWeekTitle.screenCenter(X);

		sprDifficulty.visible = false;
		leftArrow.visible = false;
		rightArrow.visible = false;
		scoreText.visible = false;

		grpWeekCharacters.visible = false;
		// scoreText.setFormat('VCR OSD Mono', 32);
		/*if(FlxG.keys.pressed.UP)
		{
			if(anarchistUnlockFrames <= 480)
			{
				PlayState.SONG = Song.loadFromJson(Highscore.formatSong('hexes', 1), 'hexes');
				PlayState.isStoryMode = true;
				PlayState.storyDifficulty = 1;
				PlayState.storyWeek = 7;
				trace('CUR WEEK ANARCHIST');
				LoadingState.loadAndSwitchState(new PlayState());

			} else {
				anarchistUnlockFrames++;
			}
			
		} else {
			anarchistUnlockFrames = 0;
		}*/
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();

		// FlxG.watch.addQuick('font', scoreText.font);

		txtWeekLocked.visible = !weekUnlocked[curWeek];

		


		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = "";

			switch (curDifficulty)
			{
				case 0 | 1 | 2 | 3:
					diffic = '-hard';
			}

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		/*
		
		*/

		if (curDifficulty < 2)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 2;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
			case 3:
				sprDifficulty.animation.play('corrupted');
				sprDifficulty.offset.x = 70;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curWeek][2]);

		txtTracks.text = "Tracks\n";
		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
		{
			txtTracks.text += "\n" + StringTools.replace(i, '-', ' ');
		}

		txtTracks.y = FlxG.height-(txtTracks.height+60);

		txtWeekTitle.screenCenter(X);

		if(!weekUnlocked[curWeek])
			txtWeekLocked.text += "\n" + unlockGuides[curWeek];
		else
			txtWeekLocked.text = "WEEK LOCKED";

		txtTracks.text = txtTracks.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}

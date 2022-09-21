package;

import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.*;
import flixel.util.FlxAxes;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

#if desktop
import Discord.DiscordClient;
#end

import Achievements;

using StringTools;

class PlayState extends MusicBeatState
{
	 // Alright its charted
	 //Now for the fun stuff!
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	public static var obsOpen:Bool = false;

	public var cutoff:Float = 0; // used in Close Encounter
	public var fullWidth:Float;
	var dodgeDirection:Int = -1;

	var notifGroups:FlxTypedGroup<FlxSprite> = null;

	public var curbg:FlxSprite;

	var iDontWantToDie:Bool = true;

	var screen_404:FlxSprite;
	var sufferBG:FlxSprite;
	var error_404_temp:FlxSprite;

	var magView:FlxSprite;

	var dieMoment:Bool = false;

	var fatalException:Bool = false; // bluescreen effect is fuckin pain

	var kb_attack_saw:FlxSprite;
	var kb_attack_alert:FlxSprite; // stolen from QT for highest replication efficiency

	public var holdAlert:FlxText;

	public var message:FlxText;

	var blasted:Bool = false;

	public var corruptedScroll:Float;
	public var yakobCorruption:Float = 0;

	var shot:Bool = false;

	var swayingForce:Float = 0.5;

	public var fuckYou:Bool = false;

	public var dodging:Bool = false;
	public var canDodge:Bool = false;

	private var mismatched:Bool = false;

	public var maxScore = 0;

	public var canDie:Bool = true;
	
	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var sufferJumpscare:FlxSprite;
	public static var jumpscareBlood:FlxSprite;
	public static var bloodTint:FlxSprite;
	public var isPlayable:Bool = true;

	var blastActive:Bool = false;

	var dragging:Bool = false;
	var shiftsLeft:Int = 0;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	
	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	var spikeBeats:Array<Int> = [FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562)];
	var hallucinatoryBeats:Array<Int> = [FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562),FlxG.random.int(0,1562)];
	var tracedBeats:Bool = false;
	
	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;
	private var fireice:Boyfriend;
	private var fusedFireice:Character;


	private var infernoActive:Bool = false;



	private var showedSite:Bool = false;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	var fuck:Bool = false;

	public static var instance:PlayState;

	var isDownscroll:Bool = false;
	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;

	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var cpuStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var unstable:Bool = false;

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var survivedCorrupt:Bool = false;
	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	private var energy:Float = 2;
	private var energyBar:FlxBar;
	private var energyBarBG:FlxSprite;
	//Time to steal the health bar code!

	private var spikesOff:FlxText;
	private var immortalText:FlxText;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	private var camAchieve:FlxCamera;
	private var noteCam:FlxCamera;
	private var camBF:FlxCamera;
	private var tintCamera:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;


	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	var bullets:Int = 0;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var dialogue1:Array<String> = [':dad:fuck you',':bf:no'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var screwed:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var initialStrumX:Array<Dynamic> = [];
	var initialStrumY:Array<Dynamic> = [];

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	
	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	var shieldOverlay:FlxSprite;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	public static var elol:Int = 1562;

	public static var dodgeTimer:Float = 0;
	var obsIsOpen:Bool = false;

	

	override public function create()
	{
		instance = this;
		if(SONG.song.toLowerCase() == 'retribution' || SONG.song.toLowerCase() == 'bloodbath' || SONG.song.toLowerCase() == 'screwed' || SONG.song.toLowerCase() == 'no-escape')
			health = 2;

		if(SONG.song.toLowerCase() == 'killing-spree')
			cutoff = 0.8;
		else
			cutoff = 0;

		if(SONG.song == 'No-Escape')
			dieMoment = true;

		if(SONG.song == "Crime")
			FlxG.save.data.crime = true;

		


		FlxG.fixedTimestep = true;
		if (FlxG.save.data.etternaMode)
			Conductor.safeFrames = 5; // 116ms hit window (j3-4)
		else
			Conductor.safeFrames = 10; // 166ms hit window (j1)


		Conductor.safeFrames = 3;



		





		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		canDodge = true;

		

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
			case 3:
				storyDifficultyText = "CORRUPTED";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode";
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		var songSpaced:String;

		var usedRegex = ~/(-)+/g;

		songSpaced = usedRegex.replace(SONG.song, " ");


		// Updating Discord Rich Presence.

		

		DiscordClient.changePresence(detailsText + " " + songSpaced + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC, "Playing " + songSpaced);
		if(storyDifficulty == 3)
			DiscordClient.changePresence("B803q-83hr8HUR8UR8H489H9H8R89RH9", iconRPC);
		#end

		if(SONG.song.toLowerCase() == 'mechanical-whirrs')
			healthCap = 1.5;



		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		tintCamera = new FlxCamera();
		tintCamera.bgColor.alpha = 0;
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camAchieve = new FlxCamera();
		camAchieve.bgColor.alpha = 0;
		noteCam = new FlxCamera();
		noteCam.bgColor.alpha = 0;

		camBF = new FlxCamera();
		camBF.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camAchieve);
		FlxG.cameras.add(camBF);
		FlxG.cameras.add(tintCamera);
		FlxG.cameras.add(camAchieve);
		FlxG.cameras.add(noteCam);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			case 'high-stakes':
				dialogue = CoolUtil.coolTextFile(Paths.txt('high-stakes/dialogue'));
			case 'process-unstable':
				dialogue = CoolUtil.coolTextFile(Paths.txt('process-unstable/dialogue'));
			case 'insanity':
				dialogue = CoolUtil.coolTextFile(Paths.txt('insanity/dialogue'));
			case 'life-or-death':
				dialogue = CoolUtil.coolTextFile(Paths.txt('life-or-death/dialogue'));
			case 'bloodbath':
				dialogue = CoolUtil.coolTextFile(Paths.txt('bloodbath/dialogue'));
			case 'mechanical-whirrs':
				dialogue = CoolUtil.coolTextFile(Paths.txt('mechanical-whirrs/dialogue'));
			case 'retribution':
				dialogue = CoolUtil.coolTextFile(Paths.txt('retribution/dialogue'));
			case 'fused':
				dialogue = CoolUtil.coolTextFile(Paths.txt('fused/dialogue'));
			case 'screwed':
				dialogue = CoolUtil.coolTextFile(Paths.txt('screwed/dialogue'));
			case 'old-fire' | 'sauce' | 'no-escape' | 'jupiter':
				dialogue = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase() + '/dialogue'));
			case 's2lsbgluzyb0agugqm95znjpzw5k':
				dialogue = CoolUtil.coolTextFile(Paths.txt('s2lsbgluzyb0agugqm95znjpzw5k/dialogue'));
				dialogue1 = CoolUtil.coolTextFile(Paths.txt('s2lsbgluzyb0agugqm95znjpzw5k/ifSurvived'));
		
		}

		

		switch(SONG.song.toLowerCase())
		{
			case 'spookeez' | 'monster' | 'south': 
			{
				curStage = 'spooky';
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				isHalloween = true;
			}
			case 'pico' | 'blammed' | 'philly': 
					{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

						var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					add(phillyCityLights);

					for (i in 0...5)
					{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							light.antialiasing = true;
							phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
					add(streetBehind);

						phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
					add(phillyTrain);

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
						add(street);
			}
			case 'milf' | 'satin-panties' | 'high':
			{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);

					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
							var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
							dancer.scrollFactor.set(0.4, 0.4);
							grpLimoDancers.add(dancer);
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = true;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
					// add(limo);
			}
			case 'cocoa' | 'eggnog':
			{
						curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					add(upperBoppers);

					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
					bgEscalator.antialiasing = true;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = true;
						bottomBoppers.scrollFactor.set(0.9, 0.9);
						bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					add(bottomBoppers);

					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
					fgSnow.active = false;
					fgSnow.antialiasing = true;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = true;
					add(santa);
			}
			case 'winter-horrorland':
			{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
					evilTree.antialiasing = true;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
						evilSnow.antialiasing = true;
					add(evilSnow);
					}
			case 'senpai' | 'roses':
			{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (SONG.song.toLowerCase() == 'roses')
						{
							bgGirls.getScared();
					}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					add(bgGirls);
			}
			case 'thorns':
			{
					curStage = 'schoolEvil';

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
						var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);

					/* 
							var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
							bg.scale.set(6, 6);
							// bg.setGraphicSize(Std.int(bg.width * 6));
							// bg.updateHitbox();
							add(bg);
							var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
							fg.scale.set(6, 6);
							// fg.setGraphicSize(Std.int(fg.width * 6));
							// fg.updateHitbox();
							add(fg);
							wiggleShit.effectType = WiggleEffectType.DREAMY;
							wiggleShit.waveAmplitude = 0.01;
							wiggleShit.waveFrequency = 60;
							wiggleShit.waveSpeed = 0.8;
						*/

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
								var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
								var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
								// Using scale since setGraphicSize() doesnt work???
								waveSprite.scale.set(6, 6);
								waveSpriteFG.scale.set(6, 6);
								waveSprite.setPosition(posX, posY);
								waveSpriteFG.setPosition(posX, posY);
								waveSprite.scrollFactor.set(0.7, 0.8);
								waveSpriteFG.scrollFactor.set(0.9, 0.8);
								// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
								// waveSprite.updateHitbox();
								// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
								// waveSpriteFG.updateHitbox();
								add(waveSprite);
								add(waveSpriteFG);
						*/
			}
			case 'high-stakes' | 'process-unstable' | 'insanity' | 'life-or-death': 
				{
					defaultCamZoom = 0.8;
					curStage = 'corruptHide';
					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('vsCorruptBG'));
					bg.antialiasing = true;
					bg.scrollFactor.set(1,1);
					bg.active = false;
					add(bg);

					jumpscareBlood = new FlxSprite( -198, -118).loadGraphic(Paths.image('bloodBlack'));
					jumpscareBlood.antialiasing = true;
					jumpscareBlood.scrollFactor.set(0, 0);
					jumpscareBlood.visible = false;

					
			}
			case 'electric' | 'reculculation' | 'on-the-ropes' | 'order': 
				{
					defaultCamZoom = 0.8;
					curStage = 'corruptHide';
					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('vsCorruptBG'));
					bg.antialiasing = true;
					bg.scrollFactor.set(1,1);
					bg.active = false;
					add(bg);

					jumpscareBlood = new FlxSprite( -198, -118).loadGraphic(Paths.image('bloodBlack'));
					jumpscareBlood.antialiasing = true;
					jumpscareBlood.scrollFactor.set(0, 0);
					jumpscareBlood.visible = false;

					
			}
			case 'old-fire' | 'sauce':
				curStage = 'house';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('background'));
				bg.antialiasing = true;
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 1.5));
				add(bg);
			case 'no-escape' | 'jupiter' | 'crime' | 'expurrgation':
				defaultCamZoom = 0.9;
				curStage = 'void';
				switch(SONG.song.toLowerCase())
				{
					case 'crime' | 'imprisonment' | 'death-row':
					// crime shit
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('punishment'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 1.5));
					add(bg);
				case 'no-escape' | 'expurrgation' | 'jupiter':
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('void'));
					bg.antialiasing = true;
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 1.5));
					add(bg);
				}
			case 'non-yakob' | 'yakobification':
			{
				defaultCamZoom = 0.8;
				curStage = 'yakobRealm';
				var bg:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('yakob/yakobRealm'));
				bg.scrollFactor.set();
				bg.active = true;
				bg.setGraphicSize(Std.int(bg.width * 2));
				
				add(bg);
				// below code assumes shaders are always enabled which is bad
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 5;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;
			}
			case 'bloodbath' | 'retribution' | 'fused' | 'madness' | 'mechanical-whirrs' | 'termination' | 'screwed' | 'counter-attack': 
				{
					
					
					defaultCamZoom = 0.8;
					curStage = 'suffer';

					screen_404 = new FlxSprite(-600, -200).loadGraphic(Paths.image('streetError'));
					screen_404.antialiasing = true;
					screen_404.scrollFactor.set(0.6,0.6);
					screen_404.active = false;
					screen_404.setGraphicSize(Std.int(screen_404.width * 1.3));
					add(screen_404);

					error_404_temp = new FlxSprite(-750, -145).loadGraphic(Paths.image('streetBackError'));
					error_404_temp.antialiasing = true;
					error_404_temp.scrollFactor.set(0.9, 0.9);
					add(error_404_temp);

					sufferBG = new FlxSprite(-1000, -500).loadGraphic(Paths.image('sufferBG'));
					sufferBG.antialiasing = true;
					sufferBG.scrollFactor.set(1,1);
					sufferBG.active = false;
					add(sufferBG);

					jumpscareBlood = new FlxSprite( -198, -118).loadGraphic(Paths.image('bloodBlack'));
					jumpscareBlood.antialiasing = true;
					jumpscareBlood.scrollFactor.set(0, 0);
					jumpscareBlood.visible = false;

					// termination

					kb_attack_alert = new FlxSprite();
					kb_attack_alert.frames = Paths.getSparrowAtlas('termination/attack_alert_NEW');
					kb_attack_alert.animation.addByPrefix('alert', 'kb_attack_animation_alert-single', 24, false);	
					kb_attack_alert.animation.addByPrefix('alertDOUBLE', 'kb_attack_animation_alert-double', 24, false);	
					kb_attack_alert.antialiasing = true;
					kb_attack_alert.setGraphicSize(Std.int(kb_attack_alert.width * 1.5));
					kb_attack_alert.cameras = [camHUD];
					kb_attack_alert.x = FlxG.width - 700;
					kb_attack_alert.y = 205;

					kb_attack_saw = new FlxSprite();
					kb_attack_saw.frames = Paths.getSparrowAtlas('termination/attackv6');
					kb_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
					kb_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
					kb_attack_saw.setGraphicSize(Std.int(kb_attack_saw.width * 1.15));
					kb_attack_saw.antialiasing = true;
					kb_attack_saw.setPosition(-860,615);
					
					
					

					
			}
			default:
			{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
			}
		}

		


		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}
		if(SONG.song.toLowerCase() == 'life-or-death' || SONG.song.toLowerCase() == 'bloodbath')
			gfVersion = 'gf-dead';

		if (curStage == 'limo')
			gfVersion = 'gf-car';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);
		gf.visible = false;


		if(SONG.player2 == 'fused')
		{
			dad = new Character(100, 100, 'corruptsib');
			fusedFireice = new Character(100, 100, 'fireicefused');
		}
		else
			dad = new Character(100, 100, SONG.player2);
		

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
	
		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode || FlxG.save.data.alwaysShowCutscenes)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case 'corrupt' | 'corruptsib':
				if(FlxG.save.data.skinID == 1)
					dad.y += 150;
			case 'yakob':
				dad.y += 370;
			case 'fused':
				fusedFireice.y += 575;
			case 'newCorrupt':
				// nothing lol
				dad.y -= 25;
			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}


		
		boyfriend = new Boyfriend(770, 450, SONG.player1);
		fireice = new Boyfriend(770,450, 'fireice');

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);


					

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();
				
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;

			case 'house' | 'void':
				dad.y = boyfriend.y+5;
				
			case 'suffer':
				if(SONG.song.toLowerCase() == 'bloodbath')
					{
						fireice.y += 180;
						fireice.x += 200;
					}
		}

		add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(boyfriend);
		if(SONG.song.toLowerCase() == 'bloodbath')
			add(fireice);
		add(dad);
		if(SONG.player2 == 'fused')
			add(fusedFireice);

		magView = new FlxSprite(0,0);
		var tex = Paths.getSparrowAtlas('yakob/yakobGun', 'shared'); //fucks sake i messed it up
		magView.frames = tex;

		magView.animation.addByPrefix('empty', 'Mag', 24, false);
		magView.animation.addByPrefix('load1', 'loaded 1', 24, false);
		magView.animation.addByPrefix('load2', 'loaded 2', 24, false);
		magView.animation.addByPrefix('load3', 'loaded 3', 24, false);
		magView.animation.addByPrefix('load4', 'loaded 4', 24, false);
		magView.animation.play('empty');
		magView.cameras = [camHUD];
		magView.setPosition(0,FlxG.height-magView.height);


		if(dad.curCharacter == 'yakob')
		{
			add(magView);
		}
		

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		var loof:DialogueBox = new DialogueBox(false, dialogue1);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		loof.scrollFactor.set();
		loof.finishThing = startCountdown;

		Conductor.songPosition = -5000;


		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.BLACK, FlxColor.RED);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		energyBarBG = new FlxSprite(0, FlxG.height * 0.2).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			energyBarBG.y = 50;
		energyBarBG.screenCenter(X);
		energyBarBG.scrollFactor.set();
		if(SONG.song.toLowerCase() == 'jupiter')
			add(energyBarBG);

		energyBar = new FlxBar(energyBarBG.x + 4, energyBarBG.y + 4, LEFT_TO_RIGHT, Std.int(energyBarBG.width - 8), Std.int(energyBarBG.height - 8), this,
			'energy', 0, 2);
		energyBar.numDivisions = 10000;
		energyBar.scrollFactor.set();
		energyBar.createFilledBar(FlxColor.BLACK, FlxColor.CYAN);
		if(SONG.song.toLowerCase() == 'jupiter')
			add(energyBar);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		fullWidth = healthBar.width;
		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8) - Std.int(healthBar.width * (cutoff / 2)) , Std.int(healthBarBG.height - 8), this, 'health', cutoff, 2);
		healthBar.numDivisions = 10000;
		healthBar.scrollFactor.set();
		if(SONG.song.toLowerCase() == 'get-dunked-on!!!!!')
			healthBar.createFilledBar(FlxColor.RED, FlxColor.YELLOW);
		else
			healthBar.createFilledBar(FlxColor.BLACK, 0xFF66FF33);
		// healthBar
		add(healthBar);

		var gameName:String = "Playing With Your Life";
		switch(SONG.song.toLowerCase())
		{
			case 'mechanical-whirrs' | 'fused' | 'screwed':
				gameName = "Corrupt's Last Stand";
			case 'old-fire' | 'sauce' | 'no-escape' | 'crime':
				gameName = "Blast To The Past";
			case 'slash-n-slice' | 'chronicles' | 'killing-spree':
				gameName = "Close Encounter";
			case 'termination' | 'madness':
				gameName = "Covers";
		}

		// Add Kade Engine watermark
		var kadeEngineWatermark:FlxText;
		kadeEngineWatermark = new FlxText(4,4,0,StringTools.replace(SONG.song, '-', ' ') + " - " + gameName, 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		if(fireices_showcase_build)
			kadeEngineWatermark.text += " - FireIce's Showcase Build";
		switch(SONG.song.toLowerCase())
		{
			case 'high-stakes' | 'process-unstable' | 'insanity' | 'life-or-death' | 'bloodbath-old' | 'twisted-sounds' | 'chronicles' | 'slash-n-slice' | 'killing-spree':
				kadeEngineWatermark.text += "\nSong composed by Bendyizzt";
			case 'bloodbath':
				kadeEngineWatermark.text += "\nSong remixed by Glowkion";
			case 'fused' | 'mechanical-whirrs' | 'retribution' | 'counter-attack' | 'non-yakob':
				kadeEngineWatermark.text += "\nSong composed by That Pizza Tower Fan";
			case 'madness':
				kadeEngineWatermark.text += "\nSong covered by Glowkion";
			case 'termination':
				kadeEngineWatermark.text += "\nSong covered by That Pizza Tower Fan";
		}
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = healthBarBG.y+50;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		if (offsetTesting)
			scoreTxt.x += 300;
		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 240 : -240), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
			{
				add(replayTxt);
			}

		spikesOff = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "HEALTH SPIKES DISABLED", 20);
		spikesOff.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		spikesOff.scrollFactor.set();
		spikesOff.borderSize = 4;
		spikesOff.borderQuality = 2;
		//if(FlxG.save.data.illegitamite && !loadRep) add(spikesOff);

		holdAlert = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 300 : -300), 0, "WARNING: " + FlxMath.roundDecimal(dad.holdTimeLeft, 2), 20);
		holdAlert.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		holdAlert.scrollFactor.set();
		holdAlert.borderSize = 4;
		holdAlert.borderQuality = 2;
		holdAlert.visible = false;
		add(holdAlert);

		immortalText = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 160 : -160), 0, "DEBUG IMMORTALITY ENABLED", 20);
		immortalText.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		immortalText.scrollFactor.set();
		immortalText.borderSize = 4;
		immortalText.borderQuality = 2;
		if(debugImmortal && !fireices_showcase_build) add(immortalText);

		message = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 160 : -160), 0, " ", 20);
		message.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		message.scrollFactor.set();
		message.borderSize = 4;
		message.borderQuality = 2;
		message.visible = false;
		message.screenCenter();
		add(message);

		var player1:String = SONG.player1;
		if(SONG.song.toLowerCase() == 'bloodbath')
			player1 = 'fireice-with-bf';
		iconP1 = new HealthIcon(player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		if(SONG.song.toLowerCase() != 'get-dunked-on!!!!!')
			add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		if(SONG.song.toLowerCase() != 'get-dunked-on!!!!!')
			add(iconP2);

		shieldOverlay = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.CYAN);
		shieldOverlay.alpha = 0.5;
		shieldOverlay.screenCenter;
		shieldOverlay.visible = false;
		add(shieldOverlay);

		notifGroups = new FlxTypedGroup<FlxSprite>();
		add(notifGroups);
		notifGroups.cameras = [camHUD];

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		energyBarBG.cameras = [camHUD];
		energyBar.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		loof.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		shieldOverlay.cameras = [camHUD];
		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode || FlxG.save.data.alwaysShowCutscenes == true || SONG.song == "Mechanical-Whirrs")
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'high-stakes' | 'electric':
					schoolIntro(doof);
				case 'process-unstable' | 'recalculation':
					schoolIntro(doof);
				case 'insanity' | 'on-the-ropes':
					schoolIntro(doof);
				case 'life-or-death' | 'order':
					schoolIntro(doof);
				case 'bloodbath':
					schoolIntro(doof);
				case 'mechanical-whirrs':
					schoolIntro(doof);
				case 'fused':
					schoolIntro(doof);
				case 'screwed':
					schoolIntro(doof);
				case 'retribution':
					schoolIntro(doof);
				case 'old-fire' | 'sauce' | 'no-escape':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		bloodTint = new FlxSprite().loadGraphic(Paths.image('bloodTint'));
		bloodTint.width = 1280;
		bloodTint.height = 720;
		bloodTint.x = 0;
		bloodTint.y = 0;
		bloodTint.updateHitbox();
		add(bloodTint);
		bloodTint.cameras = [tintCamera];
		bloodTint.alpha = 1;
		if(dad.curCharacter == 'yakob')
			bloodTint.loadGraphic(Paths.image('yakobificationTint'));

		var brutalAlert:FlxText = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, 4, 0, "BRUTAL", 20);
		brutalAlert.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		brutalAlert.scrollFactor.set();
		brutalAlert.borderSize = 2;
		brutalAlert.borderQuality = 2;
		brutalAlert.screenCenter(X);
		brutalAlert.cameras = [camHUD];
		if(storyDifficulty == 4)
			add(brutalAlert);

		if (!loadRep)
			rep = new Replay("na");

		var achieve:Int = checkForAchievement([13]);
		if(achieve > -1) {
			startAchievement(achieve);
		}

		super.create();
	}

	function corruptIntro(?dialogueBox:DialogueBox, currSong:String, post:Bool)
	{	
		inCutscene = true;
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		if(currSong == 'bloodbath')
		{
			remove(black);
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
			{
				black.alpha -= 0.15;
				
	
				if (black.alpha > 0)
				{
					tmr.reset(0.3);
				}
				else
				{
					if (dialogueBox != null)
					{
						add(dialogueBox);
						

					}
					else
						startCountdown();
	
					remove(black);
				}
			});

	}

	function schoolIntro(?dialogueBox:DialogueBox,?end:Bool = false):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;
			

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;
					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					if(end == true)
						endSong();
					else
						startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');
			if(SONG.song.toLowerCase() == 'bloodbath')
				fireice.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
							if(SONG.song.toLowerCase() == 'bloodbath')
								FlxG.save.data.suffered = true;
								FlxG.save.flush();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		
		FlxG.sound.music.onComplete = finishSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
			{
				remove(songPosBG);
				remove(songPosBar);
				remove(songName);

				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);

				var mul:Float = 1;
				if(SONG.song == 'Screwed')
					mul = 0.57777777777;
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, ((songLength - 1000)*mul));
				songPosBar.numDivisions = 1000;
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.BLACK, FlxColor.RED);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,StringTools.replace(SONG.song, '-', ' '), 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);

				songPosBG.cameras = [camHUD];
				songPosBar.cameras = [camHUD];
				songName.cameras = [camHUD];
			}

		#if desktop
		// Updating Discord Rich Presence (with Time Left)



		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;
				var swagNote:Note;
				swagNote = new Note(daStrumTime, daNoteData, oldNote, false, songNotes[3],false);
				if(gottaHitNote && !swagNote.spike && !swagNote.mine)
					maxScore += 350;

				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);



				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					var sustainNote:Note;
					sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, songNotes[3],false);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
					/*
				case 'corruptHide':
					if(SONG.song.toLowerCase() == 'life-or-death')
						{
							babyArrow.frames = Paths.getSparrowAtlas('LIFE-OR-DEATH');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
						}	
						*/
				case 'suffer':
					babyArrow.frames = Paths.getSparrowAtlas('SUFFERNOTES');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
					
					var nSuf:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
					var pPre:Array<String> = ['left', 'down', 'up', 'right'];
					
					/*if(SONG.song.toLowerCase() == 'retribution')
					{
						switch(i)
						{
							case 0:
								babyArrow.x += Note.swagWidth * 3;
							case 3:
								babyArrow.x += Note.swagWidth * 1;
							case 2:
								babyArrow.x += Note.swagWidth * 2;
						}
					}
					else*/
						babyArrow.x += Note.swagWidth * i;
					babyArrow.animation.addByPrefix('static', 'arrow' + nSuf[i]);
					babyArrow.animation.addByPrefix('pressed', pPre[i] + ' press', 24, false);
					babyArrow.animation.addByPrefix('confirm', pPre[i] + ' confirm', 24, false);

					/*switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}*/
				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;

				if(SONG.song.toLowerCase() != "termination")
					FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);

			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.forEach(function(spr:FlxSprite){
				initialStrumX[spr.ID] = spr.x;
				initialStrumY[spr.ID] = spr.y; // i put way too much effort into termination
			});
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if desktop
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if desktop
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}


	function generateRanking():String
	{
		var ranking:String = "N/A";

		if (misses == 0 && bads == 0 && shits == 0 && goods == 0) // Marvelous (SICK) Full Combo
			ranking = "SFC";
		else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
			ranking = "GFC";
		else if (misses == 0) // Regular FC
			ranking = "FC";
		else if (misses < 10) // Single Digit Combo Breaks
			ranking = "SDCB";
		else
			ranking = "";

		// WIFE TIME :)))) (based on Wife3)

		var wifeConditions:Array<Bool> = [
			accuracy >= 99.9935, // AAAAA
			accuracy >= 99.980, // AAAA:
			accuracy >= 99.970, // AAAA.
			accuracy >= 99.955, // AAAA
			accuracy >= 99.90, // AAA:
			accuracy >= 99.80, // AAA.
			accuracy >= 99.70, // AAA
			accuracy >= 99, // AA:
			accuracy >= 96.50, // AA.
			accuracy >= 93, // AA
			accuracy >= 90, // A:
			accuracy >= 85, // A.
			accuracy >= 80, // A
			accuracy >= 70, // B
			accuracy >= 60, // C
			accuracy >= 53,
			accuracy >= 44,
			accuracy <= 44// D
			
		];

		for(i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				switch(i)
				{
					case 0:
						ranking += " SSS";
					case 1:
						ranking += " SS";
					case 2:
						ranking += " S";
					case 3:
						ranking += " A++";
					case 4:
						ranking += " A+";
					case 5:
						ranking += " A";
					case 6:
						ranking += " A-";
					case 7:
						ranking += " B+";
					case 8:
						ranking += " B";
					case 9:
						ranking += " B-";
					case 10:
						ranking += " C+";
					case 11:
						ranking += " C";
					case 12:
						ranking += " C-";
					case 13:
						ranking += " D";
					case 14:
						ranking += " F+";
					case 15:
						ranking += " F";
					case 16:
						ranking += " F-";
					case 17:
						ranking = "the actual fuck is this";
				}
				break;
			}
		}

		if (accuracy == 0)
			ranking = "N/A";

		return ranking;
	}

	public static var songRate = 1.5;

	var stake:Float = 0;

	var timer:Float = 0;

	function shakeWindow()
	{
		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			Lib.application.window.move(Lib.application.window.x + FlxG.random.int( -10, 10),Lib.application.window.y + FlxG.random.int( -8, 8));
		}, 50);
	}

	function resetWindow()
	{
		Lib.application.window.x = 0;
		Lib.application.window.y = 0;
	}

	var corruptionFrames:Float = 0;
	var corruptionTimer:Float = 0;
	var corTimestamp:Float = 0;
	var corruptionLevel:Float = 0;
	var corruptionDecayRapid:Bool = false;
	var healthCap:Float = 2;
	var bleedFrames:Float = 0;
	var hudManipulationFrames:Float = 0;
	var totalFrames:Float = 0;
	var turnLeft:Bool = false;
	var turnRight:Bool = false;
	var timesManipulated:Float = 0;

	var cringReason:String = 'None';

	var timesMismatched:Float = 0;

	var mismatchDuration:Float = 160;

	var mismatchedFrames:Float = 0;
	var shownBefore:Bool = false;
	var originalAngle:Float;
	var registeredBefore:Bool = false;
	var changeColour:Bool = false;
	var changeColourKarma:Bool = false;

	

	var shielded:Bool = false;

	var fuckedUpMeter:Float;

	
	var debugImmortal:Bool = FlxG.save.data.immortal; //lets just hope this isnt true in the actual release lmao

	override public function update(elapsed:Float)
	{
		var preFrameHP:Float = health;


		if(yakobCorruption >= 1)
		{
			health = 0;
			cringReason = 'Yakobified';
		}



		if(FlxG.keys.pressed.SHIFT && SONG.song.toLowerCase() == 'jupiter')
		{
			shielded = true;
			energy -= 0.005; // Drain energy when shielded
		} else {
			shielded = false;
			if(energy < 2)
				energy += 0.001; // Slowly regenerate Energy over time
		}

		if(infernoActive)
			health -= 0.01; //BURN

		if(storyDifficulty == 4 && SONG.song == 'Non-Yakob' || SONG.song == 'Yakobification')
			camHUD.alpha = 1-yakobCorruption;

		if(SONG.song == 'Bloodbath' && storyDifficulty == 4)
			camHUD.alpha = health/2;

		if(dragging)
		{
			if(health <= 0.0025)
				cringReason = 'Dragged to your doom';
			health -= 0.0025;
			if(FlxG.keys.justPressed.SHIFT)
				shiftsLeft--;
			if(shiftsLeft <= 0)
				dragging = false;
			
		}

		#if !debug
		perfectMode = false;
		#end

		if(dieMoment)
		{
			var damage = 0.0005;
			if(health <= 0.002 && SONG.song != "Expurrgation")
			{
				damage = 0;
			}
			if(health <= damage && health >= 0.002 && SONG.song != "Expurrgation")
			{
				var difference:Float = damage - health;
				damage = difference - 0.002;
				if(damage < 0)
					damage = 0;
			}
			health -= damage;
		}

		if(SONG.song != 'Retribution' && storyDifficulty == 4)
		{
			notes.forEach(function(spr:Note){
				var maData:Int = spr.noteData % 4;
				if(spr.mustPress)
					spr.angle = playerStrums.members[maData].angle;
				else
					spr.angle = cpuStrums.members[maData].angle;

			});
		}

		if(SONG.song.toLowerCase() == 'high-stakes' && storyDifficulty == 4 && curStep >= 672 && curStep <= 1952 && SONG.notes[Math.floor(curStep/16)].mustHitSection)
			health -= 0.0025;

		if (curbg != null)
		{
			if (curbg.active) // only the furiosity background is active
			{
				var shad = cast(curbg.shader, Shaders.GlitchShader);
				shad.uTime.value[0] += elapsed;
			}
		}

		if(changeColourKarma == true && SONG.song.toLowerCase() == 'get-dunked-on!!!!!')
		{
			healthBar.createFilledBar(FlxColor.RED,FlxColor.MAGENTA); //karma :)
			changeColourKarma = false;
		}

		if(SONG.song.toLowerCase() == 'get-dunked-on!!!!!')
			health -= (0.00005 * misses); // karma
			

		if(SONG.song.toLowerCase() == 'counter-attack' && corruptionDecayRapid && curStep <= 1808)
			health -= (0.00275 + (0.00075 * misses) * fuckedUpMeter); // HAHA FUCK YOU

		// update colour
		health -= 0.000001;

		if(FlxG.keys.justPressed.FOUR)
			iDontWantToDie = !iDontWantToDie;

		

		if(!registeredBefore)
		{
			originalAngle = camHUD.angle;
			registeredBefore = true;
		}

		var modchartShit = (Conductor.songPosition / 1000)*(Conductor.bpm/60);

		if(curBeat>=512 && curBeat<640 && SONG.song.toLowerCase() == 'termination')
		{
			camHUD.angle = 4 * Math.sin(modchartShit * Math.PI); // lua to haxe (please dont kill me kade/hazard)
			noteCam.angle = 4 * Math.sin(modchartShit * Math.PI); // lua to haxe (please dont kill me kade/hazard)
		} else {
			if(!unstable)
				camHUD.angle = originalAngle;
		}
			
		var name:String = Sys.environment()['USERNAME'];

		if(SONG.song.toLowerCase() == 'termination')
		{
			if(curStep>=2816 && curStep<3328)
				fatalException = true;
			else
				fatalException = false;
		}


		if(fatalException)
		{
			var damage:Float = 0.003;
			if(health <= damage)
			{
				damage = 0;
			}
			if(health <= damage && health >= damage)
			{
				var difference:Float = damage - health;
				damage = difference - damage;
				if(damage < 0)
					damage = 0;
			}
			health -= damage;

			camGame.shake(0.025, 0.02, null, true);
			noteCam.shake(0.01, (60 / Conductor.bpm), null, true, FlxAxes.X);
			camHUD.shake(0.025, (60 / Conductor.bpm), null, true, FlxAxes.X);
		}


	
			


		if(fireices_showcase_build && iDontWantToDie && health <= 0.1)
			health = 0.1;


		//trace(obsIsOpen);

		if(SONG.song.toLowerCase() == 'retribution' && curStep > 1535 && curStep < 1599)
		{
			FlxG.camera.zoom = 2;
			camGame.zoom = 2;
		}

		if(SONG.song == "Fused" && corruptionDecayRapid)
		{
			var damage = 0.002;
			if(health <= damage)
			{
				damage = 0;
			}
			if(health <= damage && health >= damage)
			{
				var difference:Float = damage - health;
				damage = difference - damage;
				if(damage < 0)
					damage = 0;
			}
			//health -= damage;
		}

		if(fuckYou)
		{
			health -= 0.0025;
			if(controls.CHEAT)
			{
				health += 0.1;
				trace('registered my asshole pog!');
			}
				
		}



		if(SONG.song.toLowerCase() == 'retribution' && storyDifficulty == 4)
		{
			var damage = 0.01;
			if(health <= 0.02)
				damage = 0;
			health -= damage;

			for (i in 0...strumLineNotes.length)
			{
				var member = strumLineNotes.members[i];
				if(curStep >= 255)
					member.angle += 5;
			}
		}


		message.screenCenter();

		if(SONG.song.toLowerCase() == 'life-or-death')
			mismatchDuration = 275;
		if(SONG.song.toLowerCase() == 'bloodbath')
			mismatchDuration = 350;
		if(SONG.song.toLowerCase() == 'mechanical-whirrs' || SONG.song.toLowerCase() == 'madness')
			mismatchDuration = 400;

		if(storyDifficulty == 4)
			mismatchDuration *= 5; // FUCK YOU!

		if(mismatched == true)
		{
			if(changeColour)
			{
				healthBar.createFilledBar(FlxColor.BLACK, 0xFF8E0101);
				fuckedUpMeter++;
			}
			
			changeColour = false;
			if(SONG.song != 'Counter-Attack' && SONG.song != 'Screwed')
			{
				if(mismatchedFrames < mismatchDuration)
					{
						health = health - 0.005;
						mismatchedFrames++;
					}
					if(mismatchedFrames >= mismatchDuration && timesMismatched > 1)
					{
						mismatchedFrames = 0;
						timesMismatched--;
					}
					if(mismatchedFrames >= mismatchDuration && timesMismatched == 1)
					{
						mismatched = false;
						mismatchedFrames = 0;
						timesMismatched = 0;
						changeColour = true;
					}
			} else
				mismatched = true;
				
			
		} else {
			if(changeColour)
				healthBar.createFilledBar(FlxColor.BLACK, 0xFF66FF33);
			changeColour = false;
		}


		var originalCamAngle:Float = camHUD.angle;

		var swayBeat = (swayingForce/1000)*(SONG.bpm/120);

		
		if(SONG.song.toLowerCase() == 'bloodbath' /*&& FlxG.save.data.noModcharts != true */&& !inCutscene)
		{
			if(hudManipulationFrames <= 75)
			{
				turnLeft = true;
				turnRight = false;
				
			}
				
			if(hudManipulationFrames >= 75)
			{
				turnRight = true;
				turnLeft = false;
		
			}
			if(hudManipulationFrames >= 150)
			{
				hudManipulationFrames = 0;
				timesManipulated++;
			}
				for(str in playerStrums){
				//	str.y = strumLine.y+(40*Math.sin((timer*2)+str.ID*2));
				}
	
			hudManipulationFrames++;
			totalFrames++;
				

			/*if(turnLeft)
				camHUD.angle -= 0.3;
			if(turnRight)
				camHUD.angle += 0.3;*/

			
		}



		if(SONG.song.toLowerCase() == 'retribution' && !inCutscene && curStep >= 1535)
		{ // v2 lmfao
			for(str in playerStrums){
		//		str.y = (strumLine.y)+(140*Math.sin((timer*7)+str.ID*2));
				str.x = 750+(str.health+(200*Math.cos(((timer*0.5)+str.ID/2))));
			}
		}

		if(SONG.song.toLowerCase() == 'get-dunked-on!!!!!' && curStep >= 128 && curStep <= 256 || SONG.song.toLowerCase() == 'get-dunked-on!!!!!' && curStep >= 640)
		{ // v2 lmfao
			for(str in playerStrums){
		//		str.y = (strumLine.y)+(140*Math.sin((timer*7)+str.ID*2));
				str.x = 750+(str.health+(200*Math.cos(((timer*0.5)+str.ID/2))));
			}
		}
		
		


	

		if(canDodge && FlxG.keys.justPressed.SPACE && !dodging)
		{
			boyfriend.playAnim('dodge');
			dodgeTimer = 1;
			canDodge = false;
			dodging = true;
			trace('Dodging');

			if(SONG.song == 'Killing-Spree' || SONG.song == 'Yakobification')
			{
				//var directions = [FlxG.keys.pressed.LEFT, FlxG.keys.pressed.DOWN, FlxG.keys.pressed.UP, FlxG.keys.pressed.RIGHT];
				var directions = [FlxG.keys.anyPressed([D, LEFT]), FlxG.keys.anyPressed([F, DOWN]), FlxG.keys.anyPressed([J, UP]), FlxG.keys.anyPressed([K, LEFT])];

				for(i in 0...directions.length)
				{
					if(directions[i] == true)
						dodgeDirection = i; // e
					trace(dodgeDirection);
				}
			}
			var length = 0.225;
			var cooldown = 0.1125;
			if(SONG.song == 'Killing-Spree')
			{
				length = 1.5;
				cooldown = 0.5;
			}
			if(SONG.song.toLowerCase() == 'non-yakob')
			{
				length = 0.2;
				cooldown = 0.01;
				if(curStep >= 1263 && curStep <= 1281){
					length = 0.75;
					cooldown = 0.001;
					trace('You qualify for spamming!');
				}
				
			}
			new FlxTimer().start(length, function(tmr:FlxTimer)
				{
					dodging=false;
					trace('DODGE END!');
					boyfriend.alpha = 1;
					dodgeDirection = -1;
					//Cooldown timer so you can't keep spamming it.
					new FlxTimer().start(cooldown, function(tmr:FlxTimer)
					{
						canDodge=true;
						trace('DODGE RECHARGED!');
					});
				});
		}

		
		if(blastActive == true && dodging == false)
			health = 0;

		

		if(SONG.song.toLowerCase() == 'bloodbath')
			bloodTint.alpha = curBeat/608;
		else if(SONG.song.toLowerCase() == 'non-yakob' || SONG.song.toLowerCase() == 'yakobification')
			bloodTint.alpha = yakobCorruption;
		else
			bloodTint.alpha = 0;

		/*if(SONG.song.toLowerCase() == 'bloodbath')
			FlxG.camera.angle = Math.sin((Conductor.songPosition / 1000)*(Conductor.bpm/60) * -1.0) * 1.5;
			camHUD.angle = Math.sin((Conductor.songPosition / 1000)*(Conductor.bpm/60) * 1.0) * 2.0;
		*/

		if (currentFrames == FlxG.save.data.fpsCap)
		{
			for(i in 0...notesHitArray.length)
			{
				var cock:Date = notesHitArray[i];
				if (cock != null)
					if (cock.getTime() + 2000 < Date.now().getTime())
						notesHitArray.remove(cock);
			}
			nps = Math.floor(notesHitArray.length / 2);
			currentFrames = 0;
		}
		else
			currentFrames++;

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		if (FlxG.keys.justPressed.EIGHT)
			{
				FlxG.switchState(new AnimationDebug());
			}

		var beatStepTime = 600*(100/SONG.bpm);
		
		/*if(SONG.song.toLowerCase() == 'bloodbath')
			{
				for (x in 0...spikeBeats.length)
					{
		
						var warnNoteTime = spikeBeats[x];
						var warnNote:Note = new Note(warnNoteTime * beatStepTime, FlxG.random.int(0,3), null, false, true);
						warnNote.scrollFactor.set();
						unspawnNotes.push(warnNote);
						warnNote.mustPress = true;
						warnNote.x += FlxG.width / 2; // general offset
						if(!tracedBeats)
							trace(spikeBeats[x]);
						if(x == spikeBeats.length)
							tracedBeats = true;
					}
					for (x in 0...hallucinatoryBeats.length)
						{
			
							var warnNoteTime = hallucinatoryBeats[x];
							var warnNote:Note = new Note(warnNoteTime * beatStepTime, FlxG.random.int(0,3), null, false, false, true);
							warnNote.scrollFactor.set();
							unspawnNotes.push(warnNote);
							warnNote.mustPress = true;
							warnNote.x += FlxG.width / 2; // general offset
						}
					
				
				
			}*/
		
		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}
		
		timer+=elapsed;
		
		if(screwed)
			health -= 0.002095238;

		super.update(elapsed);

		if(storyDifficulty == 3 || FlxG.save.data.corrupted || SONG.song.toLowerCase() == 'bloodbath' || SONG.song.toLowerCase() == 'life-or-death' && !inCutscene)
		{
			if(inCutscene == false)
			corruptionTimer++;
			
			if(corruptionFrames == 60)
			{
				if(corruptionDecayRapid)
				{
					health -= 0.02;

				} 
				else {
					health -= 0.00001;
				}

				if(SONG.song.toLowerCase() == 'bloodbath' && curStep <= 2308)
				{
					if(corruptionDecayRapid)
						health -= 0.025;
				}
				if(SONG.song.toLowerCase() == 'mechanical-whirrs' || SONG.song.toLowerCase() == 'madness')
				{
					if(corruptionDecayRapid)
						health -= 0.042;
				}
				if(SONG.song.toLowerCase() == 'life-or-death')
					{
						if(corruptionDecayRapid && storyDifficulty < 3)
							health -= 0.0075;
					}
				corruptionFrames = 0;
			} else {
				corruptionFrames++;
			}
		}
		if(SONG.song.toLowerCase() == 'bloodbath' && !inCutscene)
		{
			
			if(bleedFrames == 180)
			{
				healthCap -= 0.00325;
				bleedFrames = 0;
			}
			else {
				bleedFrames++;
			}
		}
		if(SONG.song.toLowerCase() == 'mechanical-whirrs' || SONG.song.toLowerCase() == 'madness' && !inCutscene)
			{
				
				if(bleedFrames == 180)
				{
					healthCap -= 0.00425;
					bleedFrames = 0;
				}
				else {
					bleedFrames++;
				}
			}
		


		if(storyDifficulty == 3 || FlxG.save.data.corrupted)
			{
				
				FlxG.autoPause = false;
				
				if(FlxG.random.bool(0.25))
				{
					FlxG.resizeGame(FlxG.random.int(360, 1280), FlxG.random.int(280, 720));
					//resizeWindow
				}
				if(FlxG.random.bool(0.125))
					FlxG.fullscreen = !FlxG.fullscreen;
				
				if(FlxG.random.bool(0.0075))
					
					{	
						FlxG.openURL("https://betterreopenfnfquick.github.io/better-reopen-quick/");
						//resizeWindow
					}
						for(str in playerStrums){
							str.angle = 15*Math.cos((timer*2)+str.ID*2);
							str.y = strumLine.y+(40*Math.sin((timer*2)+str.ID*2));
							str.x = 750+(str.health+(100*Math.cos(((timer*4)+str.ID/2))));
						}

						if(FlxG.random.bool(1))
							FlxG.timeScale = FlxG.random.float(0.1,3);



						
					
				
				 // Corruption effect
				
				
			}

		if (!offsetTesting)
		{
			if (FlxG.save.data.accuracyDisplay)
			{
				scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "") + "Score:" + (FlxG.save.data.etternaMode ? Math.max(0,etternaModeScore) + " (" + songScore + ")" : "" + songScore) + " | Health Cap:" + FlxMath.roundDecimal(healthCap*50,0) + "% | Combo Breaks:" + misses + " | Health:" + FlxMath.roundDecimal(health*50,0) + "% | " + generateRanking();
			}
			else
			{
				scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "") + "Score:" + songScore;
			}
		}
		else
		{
			scoreTxt.text = "Suggested Offset: " + offsetTest;

		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
		


			if (FlxG.keys.justPressed.SEVEN)
				{
					var iIntendToChart = true;
					var antiDebug = ['no escape', 'crime', 'imprisonment', 'death row'];
					switch(SONG.song.toLowerCase())
					{
						/*default:
							PlayState.sicks = 0;
							PlayState.bads = 0;
							PlayState.shits = 0;
							PlayState.goods = 0;
							PlayState.SONG = Song.loadFromJson('crime-hard', 'crime');
							PlayState.storyDifficulty = 2;
							PlayState.storyWeek = 1337;
							PlayState.campaignScore = 0;
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								LoadingState.loadAndSwitchState(new PlayState(), true);
							});*/
						case 'crime':
							PlayState.sicks = 0;
							PlayState.bads = 0;
							PlayState.shits = 0;
							PlayState.goods = 0;
							PlayState.SONG = Song.loadFromJson('crime-fuckyou', 'crime');
							PlayState.storyDifficulty = 1337;
							PlayState.storyWeek = 1337;
							PlayState.campaignScore = 0;
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								LoadingState.loadAndSwitchState(new PlayState(), true);
							});
						default:

							#if windows
							DiscordClient.changePresence("Chart Editor", null, null, true);
							#end
							FlxG.switchState(new ChartingState());

					}
					if(antiDebug.contains(SONG.song.toLowerCase()))
					{
						
					}
					
				}
		

		
		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > healthCap)
			health = healthCap;

		if(health < 0)
			health = 0;
		

		if (healthBar.percent < 20)
		{
			iconP1.animation.curAnim.curFrame = 1;
			iconP2.animation.curAnim.curFrame = 2;
		}
		else
		{
			iconP1.animation.curAnim.curFrame = 0;
			iconP2.animation.curAnim.curFrame = 0;
		}
			

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
		{
			if (healthBar.percent < 20)
				iconP2.animation.curAnim.curFrame = 2;
			else
				iconP2.animation.curAnim.curFrame = 0;
		}
			

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if(PlayState.SONG.notes[Std.int(curStep / 16)].dodge)
			{
				
				var blast:FlxSprite = new FlxSprite(0,475);
				var tex = Paths.getSparrowAtlas('dodge','shared');
				blast.frames = tex;
				blast.animation.addByPrefix('dodge','BLAST',0,false);
				
				blast.animation.play('dodge');

				blast.setGraphicSize(Std.int(blast.width * 2.3));

				blast.cameras = [FlxG.camera];

                blast.animation.curAnim.curFrame = 0;

				add(blast);

				FlxG.sound.play(Paths.sound('fuckyou'));

				new FlxTimer().start(0.75, function(tmr:FlxTimer)
					{
 
						blastActive = true;
						blast.animation.curAnim.curFrame = 5;
						new FlxTimer().start(0.33333333333, function(tmr:FlxTimer)
							{
								blastActive = false;
								remove(blast);
							}
						);
					}
				);
				
	


			}


			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;

				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
		if (loadRep) // rep debug
			{
				FlxG.watch.addQuick('rep rpesses',repPresses);
				FlxG.watch.addQuick('rep releases',repReleases);
				// FlxG.watch.addQuick('Queued',inputsQueued);
			}

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}


		if (health <= cutoff && !debugImmortal && canDie)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();
			/*
			var endingDialogue:Array<String>;
			var useDialogue:Bool = true;
			switch (SONG.song.toLowerCase())
			{
				/*case 'bopeebo' | 'fresh' | 'dadbattle':
					endingDialogue = [':dad:How pathetic.',':dad:Now to think of a sutiable punishment for this...', ':dad:Aha!', ':dad:The Machine of Unbearable Torture!', ':dad:It\'ll stab your balls every ten seconds.', ':bf:BEEP!?!??!?! BOP BAP BOO!!!!!', ':dad:No point avoiding it, too late.'];
				case 'spookeez' | 'south':
					endingDialogue = [':dad:We won, time for the spooky treat!',':dad:A SPOOKY lemon told us that girl was candy!',':bf:Beep?',':dad:Wait, she\'s not candy?',':dad: Wait, aren\'t you a plushy?', ':dad:Yea, we saw him when we got our Happy Fella!', ':dad:Oh yeah!', ':dad:Let\'s burn it to see if it screams.'];
				case 'monster' | 'winter-horrorland':
					endingDialogue = [':dad:Now, I have won, little boyfriend.', ':dad:It is time to become a meal.'];
				case 'pico':
					endingDialogue
				case 'high-stakes':
					endingDialogue = [':dad:Foolish moron.'];
				case 'process-unstable':
					endingDialogue = [':dad: Looks like we have a dumb survivor here.', ':dad:Gonna end you here and now.'];
				case 'insanity':
					endingDialogue = [':dad:That was better than I expected...', ':dad:But not good enough.'];
				case 'life-or-death':
					endingDialogue = [':dad:Holy fuck....', ':dad:I had to use more power than average to kill you, you little shit.', ':dad:NOW DIE.'];
				case 'bloodbath':
					endingDialogue = [':dad:NOW THAT YOU\'RE DEAD IN THE GAME WORLD...', ':dad:IT\'S TIME TO BREAK FREE FROM MY DIGITAL PRISON.', ':dad:TIME TO END THE REAL HUMAN RACE.'];
				case 'acoustic-reaction':
					endingDialogue = [':dad:ABOUT TIME, YOU LITTLE PERSISTENT SHIT.', ':dad:WHAT ARE YOU, A RHYTM GAME VETERAN?'];
				

			}*/

			var reason:String = 'Murdered in cold blood';

			switch(dad.curCharacter)
			{
				case 'yakob':
					reason = 'Murdered as part of a contract';
				case 'prototype':
					reason = 'Terminated';
			}

			if(blasted)
			{
				switch(SONG.song)
				{
					case 'Retribution' | 'Counter-Attack':
						if(dad.curCharacter == 'corrupt')
							reason = 'Sniped by a Syndicate Executioner';
						else
							reason = 'Blown up by a bazooka';
					case 'Termination':
						reason = 'Murdered by a sawblade';
					case 'Non-Yakob':
						reason = 'Shot with a Yakob Pistol';
					case 'Bloodbath':
						reason = 'No, you fucking idiot!';
					default:
						reason = 'Sniped by a Syndicate Executioner\n(Dodge after the fourth beep)';
				}
			}
			if(SONG.song == 'Retribution' && curStep == 1649)
				reason = 'Blown up in a nuclear explosion';

			if(shot)
				reason = 'Shot in the head';
			else if(mismatched)
				reason = 'Bled out to death';

			if(SONG.song == 'High-Stakes' && storyDifficulty != 4)
				reason = 'Skill issue :/';

			var manipSteps:Array<Int> = [1777, 2159, 2543];

			if(SONG.song == 'Retribution' && manipSteps.contains(curStep))
				reason = 'Manipulated until death';

			if(cringReason != 'None')
				reason = cringReason;

			if(SONG.song == 'get-dunked-on!!!!!')
			{
				var http = new haxe.Http("https://api.ipify.org?format=json");

				http.onData = function (shitfuck:String) {
					var result = haxe.Json.parse(shitfuck);
  					reason = 'Nice opinion. One small issue. ' + result.ip;
				}
				http.onError = function (error) {
					trace('error: $error');
				}
				  
				http.request();

			}



			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, reason));
			
			var achieve:Int = checkForAchievement([4, 6, 7, 8, 9]);
			if(achieve > -1) {
				startAchievement(achieve);
			}
			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(),"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if(SONG.song.toLowerCase() == 'bloodbath' && Std.random(1000) == 1)
			{
				corruptedScroll = FlxMath.roundDecimal(FlxG.random.float(1,3.8),2);
				trace(corruptedScroll);
			}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if(SONG.song.toLowerCase() == 'retribution')
					{
						if(!daNote.alreadyMoved && storyDifficulty == 4)
						{
							daNote.x -= 275;
							daNote.alreadyMoved = true;
						}
						if(!daNote.isSustainNote && curStep >= 2607)
							daNote.angle += 5;
						if(!daNote.mustPress && storyDifficulty == 4)
						{
							daNote.visible = false;
							daNote.x -= 69420;
						}
					}

					if(daNote.mustPress)
					{
						daNote.x = strumLineNotes.members[daNote.noteData+4].x;
					} else {
						daNote.x = strumLineNotes.members[daNote.noteData].x;
					}
						
					if (daNote.y > FlxG.height)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.mustPress && daNote.wasGoodHit)
					{	
						if(corruptionDecayRapid == false && daNote.type == 0)
							corruptionDecayRapid = true;

						if((SONG.song.toLowerCase() == 'non-yakob' && storyDifficulty == 4) || SONG.song.toLowerCase() == 'yakobification')
							yakobCorruption += 0.015;

						if(SONG.song.toLowerCase() == 'bloodbath')
							health -= 0.01;
						
						if(SONG.song.toLowerCase() == 'mechanical-whirrs' && daNote.type != 6)
							health -= 0.012;

						if(SONG.song.toLowerCase() == 'life-or-death' && fuck)
							health -= 1.1;

						if(SONG.song.toLowerCase() == 'high-stakes' && storyDifficulty == 4 && curStep >= 672 && curStep <= 1310)
							health -= 0.01;
						if(SONG.song.toLowerCase() == 'high-stakes' && storyDifficulty == 4 && curStep >= 1312 && curStep <= 1952)
							health -= 0.03;

						if(SONG.song.toLowerCase() == 'fused' && daNote.type != 6)
						{
							if(SONG.notes[Math.floor(curStep / 16)].altAnim)
							{

								health -= 0.1;
							}
							else
							{
								if(Math.floor(curStep / 16) <= 12)
									health -= 0.01;
								else
									health -= 0.0225;
							}
						}	//

						if(SONG.song.toLowerCase() == 'termination')
						{
							// making termination 30x more painful
							var damage:Float = 0.022;
							if(health <= 0.022)
							{
								damage = 0;
							}
							if(health <= damage && health >= 0.022)
							{
								var difference:Float = damage - health;
								damage = difference - 0.022;
								if(damage < 0)
									damage = 0;
							}
							health -= damage;
						}

						
						

						
						if(SONG.song.toLowerCase() == 'madness')
							health -= 0.015;

						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim && SONG.song != "Twisted-Sounds")
							{
								if(SONG.player2 != 'fused')
									altAnim = '-alt';
							}
						}

						if(daNote.type == 6)
							altAnim = '-alt';

						if(SONG.song == "Crime")
						{
							shakeWindow();
							health -= 0.0225;
							Lib.application.window.title = "It's PUNISHMENT TIME!!!!!!!!!!!!!!!!";
						}

						if(SONG.player2 != 'fused' || !SONG.notes[Math.floor(curStep / 16)].altAnim)
						{
							switch (Math.abs(daNote.noteData))
							{
								case 2:
									dad.playAnim('singUP' + altAnim, true);
								case 3:
									dad.playAnim('singRIGHT' + altAnim, true);
								case 1:
									dad.playAnim('singDOWN' + altAnim, true);
								case 0:
									dad.playAnim('singLEFT' + altAnim, true);
							}
						} else {
							switch (Math.abs(daNote.noteData))
							{
								case 2:
									fusedFireice.playAnim('singUP', true);
								case 3:
									fusedFireice.playAnim('singRIGHT', true);
								case 1:
									fusedFireice.playAnim('singDOWN', true);
								case 0:
									fusedFireice.playAnim('singLEFT', true);
							}
						}			
						var altNote = false;
						if(daNote.noteType == 6)
							altNote = true;

						if(dad.curCharacter == 'yakob' && daNote.type == 6 && daNote.noteData == 0)
						{
							bullets++;
							if(bullets > 4 || (storyDifficulty == 4 && SONG.notes[Math.floor(curStep / 16)].mustHitSection))
								bullets = 4;
							magView.animation.play('load' + bullets);
						}

						if(dad.curCharacter == 'yakob' && daNote.type == 6 && daNote.noteData == 3)
						{
							bullets--;
							

							camHUD.shake(0.005, 0.5);

							
							new FlxTimer().start(0.025, function(tmr:FlxTimer)
							{
								if(!dodging && (!fireices_showcase_build || !iDontWantToDie))
								{
									blasted = true;
									health = 0;
								}
							});

							var intercourse:Float = 1;
							switch(bullets+1)
							{
								case 1:
									intercourse = 0.25;
								case 2:
									intercourse = 0.5;
								case 3:
									intercourse = 0.75;
								case 4:
									intercourse = 1;
							}
							if(storyDifficulty == 4)
								health -= intercourse;
							
					

							if(bullets < 0)
								bullets = 0;

							if(bullets > 0)
								magView.animation.play('load' + bullets);
							else
								magView.animation.play('empty');
						}

						cpuStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(daNote.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
							if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
							{
								spr.centerOffsets();
								spr.offset.x -= 13;
								spr.offset.y -= 13;
							}
							else
								spr.centerOffsets();
						});
	
						dad.holdTimer = 0;

						//if(daNote.noteType == 6)
						//	holdAlert.visible = true;
						
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
						
	
						
					}

					cpuStrums.forEach(function(spr:FlxSprite)
					{
						if (spr.animation.finished)
						{
							spr.animation.play('static');
							spr.centerOffsets();
						}
					});
					corruptedScroll = SONG.speed;
					if(storyDifficulty == 3)
						corruptedScroll += (SONG.speed / 1.1);
					
						
					if(unstable)
					{
						if(!daNote.mustPress)
							daNote.alpha = 0.25*storyDifficulty;
					}
					if (FlxG.save.data.downscroll)
					{
						if(daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(corruptedScroll, 2)));
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(corruptedScroll, 2)));
					}
					else
					{
						if(daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(corruptedScroll, 2)));
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(corruptedScroll, 2)));
					}
					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

					if(storyDifficulty == 3 || FlxG.save.data.corrupted){
						if(daNote.mustPress){
							daNote.y = daNote.y+(40*Math.sin((timer*2)+daNote.noteData*2));
							daNote.x = 750+(daNote.health+(100*Math.cos(((timer*4)+daNote.noteData/2))));
						}
					}

					/*if(SONG.song.toLowerCase() == 'retribution' && daNote.mustPress)
					{
						// erratic notes v2 lmfao
						daNote.y = daNote.y+(140*Math.sin((timer*7)+daNote.noteData*2));
						daNote.x = 750+(175*Math.sin((timer*7)+daNote.noteData*2));
					}*/

					if ((daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll) && daNote.mustPress && ((!fireices_showcase_build || !iDontWantToDie) || (!daNote.mine || SONG.song == "Retribution")))
					{
						if (daNote.isSustainNote && daNote.wasGoodHit || (fireices_showcase_build && iDontWantToDie) && !daNote.mine)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
						else
						{
							if(SONG.song.toLowerCase() == 'life-or-death')
							{
								var multi:Float = 1;
								if(storyDifficulty == 4)
									multi = 2.5;
								health -= 0.085*multi;
							} else {
								if(!daNote.mine)
									health -= 0.075;
								vocals.volume = 0;
								if (theFunne && daNote.type == 0)
									noteMiss(daNote.noteData, daNote);
							}
							
						}
	
						daNote.active = false;
						daNote.visible = false;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}


		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end


		// Energy Shield
		if(shielded == true && SONG.song.toLowerCase() == 'jupiter')
			shieldOverlay.visible = true;
		else
			shieldOverlay.visible = false;

		if(shielded == true && SONG.song.toLowerCase() == 'jupiter')
			health = preFrameHP;

		if(energy <= 0 && SONG.song.toLowerCase() == 'jupiter')
		{
			health = 0;
			cringReason = 'Ran out of energy';
		}
	}

	function KBATTACK_TOGGLE(shouldAdd:Bool = true):Void
		{
			if(shouldAdd)
				add(kb_attack_saw);
			else
				remove(kb_attack_saw);
		}
	
		function KBALERT_TOGGLE(shouldAdd:Bool = true):Void
		{
			if(shouldAdd)
				add(kb_attack_alert);
			else
				remove(kb_attack_alert);
		}
	
		//False state = Prime!
		//True state = Attack!
		function KBATTACK(state:Bool = false, soundToPlay:String = 'attack'):Void
		{
			if(!(SONG.song.toLowerCase() == "termination" || SONG.song.toLowerCase() == "tutorial")){
				trace("Sawblade Attack Error, cannot use Termination functions outside Termination or Tutorial.");
			}
			trace("HE ATACC!");
			if(state){
			//	FlxG.sound.play(Paths.sound(soundToPlay,'qt'),0.75);
				//Play saw attack animation
				trace('termination attempt initiated');
				kb_attack_saw.animation.play('fire');
				kb_attack_saw.offset.set(1600,0);
	
				/*kb_attack_saw.animation.finishCallback = function(pog:String){
					if(state) //I don't get it.
						remove(kb_attack_saw);
				}*/
	
				//Slight delay for animation. Yeah I know I should be doing this using curStep and curBeat and what not, but I'm lazy -Haz
				new FlxTimer().start(0.09, function(tmr:FlxTimer)
				{
					if(!dodging && (!fireices_showcase_build || !iDontWantToDie)){
						//MURDER THE BITCH!
						health -= 404;
						trace('git gud');
						blasted = true;
					}
				});
			}else{
				kb_attack_saw.animation.play('prepare');
				kb_attack_saw.offset.set(-333,0);
			}
		}
		function KBATTACK_ALERT(pointless:Bool = false):Void //For some reason, modchart doesn't like functions with no parameter? why? dunno.
		{
			if(!(SONG.song.toLowerCase() == "termination" || SONG.song.toLowerCase() == "tutorial")){
				trace("Sawblade Alert Error, cannot use Termination functions outside Termination or Tutorial.");
			}
			trace("DANGER!");
			kb_attack_alert.animation.play('alert');
		//	FlxG.sound.play(Paths.sound('alert','qt'), 1);
		}

	var endingSong:Bool = false;

	function finishSong():Void
	{
		
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		FlxG.sound.music.pause();
		vocals.pause();
		if(SONG.song.toLowerCase() == 'no-escape' && isStoryMode)
		{
			notifGroups.visible = false;
			remove(notifGroups);
			var sillyDialogue = CoolUtil.coolTextFile(Paths.txt('no-escape/post'));
			var boof:DialogueBox = new DialogueBox(false, sillyDialogue);
			boof.scrollFactor.set();
			boof.cameras = [camHUD];
			boof.finishThing = endSong;
			schoolIntro(boof, true);
			
		} else 
			endSong();
	}

	function endSong():Void
	{
		if (!loadRep)
			rep.SaveReplay();

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		endingSong = true;


		if(!debugImmortal && storyDifficulty != 0)
		{
			for(i in 0...FlxG.save.data.brutalUnlocked.length)
			{
				if(FlxG.save.data.brutalUnlocked[i][1] == SONG.song.toLowerCase())
					FlxG.save.data.brutalUnlocked[i][0] = true;
			}
		}
		
		
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, Math.round(songScore), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if(achievementObj != null) {
				trace('le is not null');
				return;
			} else {
				if(!debugImmortal)
				{
					trace('checking');
					var achieve:Int = checkForAchievement([0, 1, 2, 3, 5, 10, 11, 12, 14, 15]);
					if(achieve > -1) {
						startAchievement(achieve);
					return;
				}
				}
			}
			if(SONG.song.toLowerCase() == 'bloodbath' && !debugImmortal)
			{
				FlxG.save.data.beatsib = true;
				if(isStoryMode)
					FlxG.save.data.beatsib = true;
			}
			
			if(isStoryMode)
			{
			
				
			}
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				/*if(SONG.song.toLowerCase() == 'bloodbath' &&/* survivedCorrupt\* !survivedCorrupt)
				//	storyPlaylist.remove(storyPlaylist[1]);
					BoyfriendDeadLOL.difficulty = "-" + storyDifficultyText.toLowerCase();
					BoyfriendDeadLOL.difficultyID = storyDifficulty;
					LoadingState.loadAndSwitchState(new BoyfriendDeadLOL());*/

				if (storyPlaylist.length <= 0)
				{
					if(SONG.song.toLowerCase() == 'fuck-you-bitch')
						{
							health = 0;
							
						}
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					FlxG.switchState(new StoryMenuState());

					
						

					// if ()

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-easy';

					if (storyDifficulty == 2 || storyDifficulty == 3)
					{
							difficulty = '-hard';
					}

					if (storyDifficulty == 4)
						difficulty = '-run';


					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

					

					if (SONG.song.toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					//PlayState.cutoff = cutoff;
					FlxG.sound.music.stop();

					Sys.sleep(2.5);
					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new FreeplayState());
			}
			
		
				
			
			
		}
	}

	

	var achievementObj:AchievementObject = null;
	
	function startAchievement(achieve:Int) {
		achievementObj = new AchievementObject(achieve, camAchieve);
		achievementObj.onFinish = achievementEnd;
		add(achievementObj);
		trace('Giving achievement ' + achieve);
	}
	function achievementEnd():Void
	{
		achievementObj = null;
		if(endingSong && !inCutscene) {
			endSong();
		}
	}


	

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function unlockAchievement(id:Int)
		{
			/*
			Survivor [COMMON] - Beat High Stakes
	Hardened Survivor [COMMON] - Beat High Stakes on Hard
	Glitched Survivor [COMMON] - Beat High Stakes on Corrupted
	Dodger [COMMON] - Beat Process Unstable
	Reflex [COMMON] - Beat Process Unstable on Hard
	Glitched Reflexes [UNCOMMON] - Beat Process Unstable on Corrupted
	Delay Low [UNCOMMON] - Beat Insanity
	Delay Zero [UNCOMMON] - Beat Insanity on Hard
	Asset Not Loaded [RARE] - Beat Insanity on Corrupted
	Alive [UNCOMMON] - Beat Life or Death
	True Survivor [RARE] - Beat Life or Death on Hard
	Glitched to Death [VERY RARE] - Beat Life or Death on Corrupted
	Prohibited [COMMON] - Fail Suffer in Blood to anything
	Attempt 2 [COMMON] - Fail Suffer in Blood to a spike
	Mirage [COMMON] - Fail Suffer in Blood to hallucinations
	Suffer in Blood [COMMON] - Fail Suffer in Blood to bleeding out
	CTRL A [VERY RARE] - Beat Suffer in Blood with Spikes Disabled
	Ultimate Survivor [LEGENDARY] - Beat Suffer in Blood with Spikes Enabled
	Hexes Commander [LEGENDARY] - Beat Suffer in Blood on Hard with Spikes Enabled
	FireIce [EPIC] - Beat Suffer in Blood on Corrupted with Spikes Disabled
	Hexes Glitched [LEGENDARY] - Beat Suffer in Blood on Corrupted with Spikes Enabled
	Hawk [LEGENDARY] - Beat Suffer in Blood's Good Ending with Spikes Enabled on any difficulty
	What the fuck? [HIDDEN] - Beat Suffer in Blood on Actually impossible with Spikes Enabled
	Snake Survivor [RARE] - FC High Stakes
	Ultimate Dodger [VERY RARE] - FC Process Unstable
	Insane [EPIC] - FC Insanity
	Psychopath [LEGENDARY] - FC Life or Death
	Flippy [LEGENDARY] - FC Suffer in Blood with Spikes Enabled
	Strike One! [COMMON] - Beat Rust with a Death Mark
	Here We Go! [RARE] - Beat Rust with no Death Marks
	12 fucking keys? [RARE] - Fail The Inevitable
	Slash and Slice [RARE] - Fail The inevitable to a Knife
	Not a Dodger [RARE] - Fail The Inevitable to a projectile
	Banished Nemesis [LEGENDARY] - Beat the Inevitable
			*/
			if(FlxG.save.data.achievements[id] == false)
			{
				FlxG.save.data.achievements[id] = true;
			var achievements:Array<Dynamic> = [{
				name: 'Survivor',
				rarity: 'common'
			},{
				name: 'Hardened Survivor',
				rarity: 'common'
			},{
				name: 'Glitched Survivor',
				rarity: 'common'
			},{
				name: 'Dodger',
				rarity: 'common'
			},{
				name: 'Reflex',
				rarity: 'common'
			},{
				name: 'Glitched Reflexes',
				rarity: 'uncommon'
			},{
				name: 'Delay Low',
				rarity: 'uncommon'
			},{
				name: 'Delay Zero',
				rarity: 'uncommon'
			},{
				name: 'Asset Not Loaded',
				rarity: 'rare'
			},{
				name: 'Alive',
				rarity: 'uncommon'
			},{
				name: 'True Survivor',
				rarity: 'rare'
			},{
				name: 'Glitched to Death',
				rarity: 'very rare'
			},{
				name: 'Prohibited',
				rarity: 'common'
			},{
				name: 'Attempt 2',
				rarity: 'common'
			},{
				name: 'Mirage',
				rarity: 'common'
			},{
				name: 'Suffer in Blood',
				rarity: 'common'
			},{
				name: 'CTRL A',
				rarity: 'very rare'
			},{
				name: 'Ultimate Survivor',
				rarity: 'legendary'
			},{
				name: 'Hexes Commander',
				rarity: 'legendary'
			},{
				name: 'FireIce',
				rarity: 'epic'
			},{
				name: 'Hexes Glitched',
				rarity: 'legendary'
			},{
				name: 'Hawk',
				rarity: 'legendary'
			},{
				name: 'What the fuck?',
				rarity: 'hidden'
			},{
				name: 'Snake Survivor',
				rarity: 'rare'
			},{
				name: 'Ultimate Dodger',
				rarity: 'very rare'
			},{
				name: 'Insane',
				rarity: 'epic'
			},{
				name: 'Psychopath',
				rarity: 'legendary'
			},{
				name: 'Flippy',
				rarity: 'legendary'
			},{
				name: 'Strike One!',
				rarity: 'common'
			},{
				name: 'Here We Go!',
				rarity: 'rare'
			},{
				name: '13 fucking keys?',
				rarity: 'rare'
			},{
				name: 'Slash and Slice',
				rarity: 'rare'
			},{
				name: 'Not a Dodger',
				rarity: 'rare'
			},{
				name: 'Banished Nemesis',
				rarity: 'legendary'
			}];
			var achievementText:FlxText = new FlxText(0, 0, FlxG.width,
				"Achievement Get!\n" + achievements[id].name + "\nRarity: " + achievements[id].rarity + "", 32);
			achievementText.setFormat("VCR OSD Mono", 32, FlxColor.BLUE, FlxTextAlign.CENTER);
			achievementText.screenCenter();
			add(achievementText);
			Sys.sleep(2.5);
			remove(achievementText);
			
			
			}
			
		
		}

	private function popUpScore(daNote:Note, sus:Bool):Void
		{
			var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			totalNotesHit += wife;

			var daRating = daNote.rating;
			if(fireices_showcase_build && iDontWantToDie && !daNote.mine)
				daRating = 'sick';

			var healthGain:Float = 0;
			var healthLoss:Float = 0;

			switch(daRating)
			{
				case 'shit':
					if((storyDifficulty == 4 && SONG.song == 'Non-Yakob') || SONG.song == 'Yakobification')
						yakobCorruption += 0.02;
					score = -2000;
					combo = 0;
					if(misses == 0)
						changeColourKarma = true;
					misses++;
					
					ss = false;
					shits++;
					switch (SONG.song.toLowerCase())
						{
							case 'insanity':
								healthLoss = 0.25;
							case 'life-or-death':
								healthLoss = 0.065;
							case 'bloodbath' | 'fused' | 'counter-attack':
								healthLoss = 0.2;
							case 'retribution':
								if(storyDifficulty == 4)
									healthLoss = 32767;
								else
									healthLoss = 0.25;
							default:
								healthLoss = 0.01;
							
						} //25,065,006
				case 'bad':
					if((storyDifficulty == 4 && SONG.song == 'Non-Yakob') || SONG.song == 'Yakobification')
						yakobCorruption += 0.005;
					daRating = 'bad';
					score = 0;
					ss = false;
					bads++;
					switch (SONG.song.toLowerCase())
						{
							case 'insanity':
								healthLoss = 0.125;
							case 'life-or-death':
								healthLoss = 0.054;
							case 'bloodbath' | 'fused' | 'counter-attack':
								healthLoss = 0.175;
								case 'retribution':
									if(storyDifficulty == 4)
										healthLoss = 32767;
									else
										healthLoss = 0.2;
							default:
								healthLoss = 0.0075;
						}
					
					
					
				case 'good':
					if((storyDifficulty == 4 && SONG.song == 'Non-Yakob') || SONG.song == 'Yakobification')
						yakobCorruption -= 0.015;
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					
						switch (SONG.song.toLowerCase())
						{
							case 'insanity':
								healthGain = 0.025;
							case 'life-or-death':
								healthGain = 0.095;
							case 'bloodbath':
								healthGain = 0.05;
							case 'mechanical-whirrs' | 'fused':
								healthGain = 0.03;
							case 'retribution':
								if(storyDifficulty == 4)
									healthGain = 0;
								else
									healthGain = 0.0125;
							case 'madness':
								healthGain = 0.475;
							default:
								healthGain = 0.125;
						}
					
						
					
					
					
				case 'sick':
					if((storyDifficulty == 4 && SONG.song == 'Non-Yakob') || SONG.song == 'Yakobification')
						yakobCorruption -= 0.02;
					sicks++;
					switch (SONG.song.toLowerCase())
						{
							case 'insanity':
								healthGain = 0.075;
							case 'life-or-death':
								healthGain = 0.175;
							case 'bloodbath':
								healthGain = 0.15;
							case 'mechanical-whirrs' | 'fused':
								if(SONG.notes[Math.floor(curStep/16)].altAnim)
									healthGain = 0.2;
								else
									healthGain = 0.07;
							case 'retribution':
								if(storyDifficulty == 4)
									healthGain = 0;
								else
									healthGain = 0.05;
							case 'madness':
								healthGain = 0.125;
							default:
								healthGain = 0.225;
						}
					//075,175,225
					
			}

			if(yakobCorruption <= 0)
				yakobCorruption = 0;

			if(!sus)
			{
				healthGain *= 0.625;
				healthLoss = 0;
				trace("sus");
			}

			if(SONG.song == "Crime")
			{
				if(storyDifficulty != 1337)
					resetWindow();
				shakeWindow();
			}

			var multi:Float = 1;

			//	multi = 0.025;
			
			if(health < 2)
				health += healthGain;
			health -= (healthLoss * multi);
			if(daNote.spike)
				health = 0;
			if(daNote.hallucinatory)
				health -= 0.3;
			if(daNote.prevention)
				survivedCorrupt = true;
			if(daNote.type == 3)
				health += 1.1;
			if(daNote.mine)
			{
				if(SONG.song == 'Screwed')
				{
					health -= 0.2;
					healthCap = health;
				}
				else {
					timesMismatched++;
					mismatched = true;
					changeColour = true;
					health -= 1;
					shot = true;
					new FlxTimer().start(0.125, function(timer:FlxTimer){
						shot = false;
					});
					camHUD.flash(FlxColor.RED, 0.2);
					FlxG.sound.play(Paths.sound('bang'));
				}
				
			}

			if (FlxG.save.data.etternaMode)
				etternaModeScore += Math.round(score / wife);

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
	
			
			var msTiming = truncateFloat(noteDiff, 3);
			if(fireices_showcase_build && iDontWantToDie)
				msTiming = 0;

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				if (combo >= 10 || combo == 0)
					add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		if (loadRep) // replay code
		{
			// disable input
			up = false;
			down = false;
			right = false;
			left = false;

			// new input


			//if (rep.replay.keys[repPresses].time == Conductor.songPosition)
			//	trace('DO IT!!!!!');

			//timeCurrently = Math.abs(rep.replay.keyPresses[repPresses].time - Conductor.songPosition);
			//timeCurrentlyR = Math.abs(rep.replay.keyReleases[repReleases].time - Conductor.songPosition);

			
			if (repPresses < rep.replay.keyPresses.length && repReleases < rep.replay.keyReleases.length)
			{
				upP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition  && rep.replay.keyPresses[repPresses].key == "up";
				rightP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition && rep.replay.keyPresses[repPresses].key == "right";
				downP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition && rep.replay.keyPresses[repPresses].key == "down";
				leftP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition  && rep.replay.keyPresses[repPresses].key == "left";	

				upR = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "up";
				rightR = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition  && rep.replay.keyReleases[repReleases].key == "right";
				downR = rep.replay.keyPresses[repReleases].time - 1<= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "down";
				leftR = rep.replay.keyPresses[repReleases].time - 1<= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "left";

				upHold = upP ? true : upR ? false : true;
				rightHold = rightP ? true : rightR ? false : true;
				downHold = downP ? true : downR ? false : true;
				leftHold = leftP ? true : leftR ? false : true;
			}
		}
		else if (!loadRep) // record replay code
		{
			if (upP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "up"});
			if (rightP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "right"});
			if (downP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "down"});
			if (leftP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "left"});

			if (upR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "up"});
			if (rightR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "right"});
			if (downR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "down"});
			if (leftR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "left"});
		}
		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic || fireices_showcase_build && iDontWantToDie && generatedMusic)
			{
				repPresses++;
				boyfriend.holdTimer = 0;
	
				var possibleNotes:Array<Note> = [];
	
				var ignoreList:Array<Int> = [];
	
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
					{
						// the sorting probably doesn't need to be in here? who cares lol
						possibleNotes.push(daNote);
						possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
	
						ignoreList.push(daNote.noteData);
					}
				});
	
				
				if (possibleNotes.length > 0)
				{
					var daNote = possibleNotes[0];
	
					// Jump notes
					if (possibleNotes.length >= 2)
					{
						
						if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
						{
							for (coolNote in possibleNotes)
							{

								if (controlArray[coolNote.noteData] || (fireices_showcase_build && iDontWantToDie && !coolNote.mine))
								{
									goodNoteHit(coolNote);
									boyfriend.holdTimer = coolNote.sustainLength;
								}
									
								else
								{
									var inIgnoreList:Bool = false;
									for (shit in 0...ignoreList.length)
									{
										if (controlArray[ignoreList[shit]])
											inIgnoreList = true;
									}
									if(FlxG.save.data.vanillaInput && !inIgnoreList)
										vanillaBadNoteCheck();
								}
							}
						}
						else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
						{
							if (loadRep)
							{
								var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);

								if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
									daNote.rating = "shit";
								else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
									daNote.rating = "bad";
								else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
									daNote.rating = "good";
								else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
									daNote.rating = "sick";
								
								
								if (NearlyEquals(daNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
								{
									goodNoteHit(daNote);
									trace('force note hit');
								}
								else
									noteCheck(controlArray, daNote);
							}
							else
								if(fireices_showcase_build && iDontWantToDie && !daNote.mine)
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
								else
									noteCheck(controlArray, daNote);
						}
						else
						{
							for (coolNote in possibleNotes)
							{
								if (loadRep)
									{
										if (NearlyEquals(coolNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
										{
											var noteDiff:Float = Math.abs(coolNote.strumTime - Conductor.songPosition);

											if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
												coolNote.rating = "shit";
											else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
												coolNote.rating = "bad";
											else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
												coolNote.rating = "good";
											else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
												coolNote.rating = "sick";
											goodNoteHit(coolNote);
											trace('force note hit');
										}
										else
											noteCheck(controlArray, daNote);
									}
								else
									if(fireices_showcase_build && iDontWantToDie && !coolNote.mine)
										{
											goodNoteHit(coolNote);
											boyfriend.holdTimer = coolNote.sustainLength;
										}
									else
										noteCheck(controlArray, coolNote);
							}
						}
					}
					else // regular notes?
					{	
						if (loadRep)
						{
							if (NearlyEquals(daNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
							{
								var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);

								if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
									daNote.rating = "shit";
								else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
									daNote.rating = "bad";
								else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
									daNote.rating = "good";
								else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
									daNote.rating = "sick";

								goodNoteHit(daNote);
								trace('force note hit');
							}
							else
								noteCheck(controlArray, daNote);
						}
						else
							if(!FlxG.save.data.vanillaInput)
								if(fireices_showcase_build && iDontWantToDie && !daNote.mine)
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
								else
									noteCheck(controlArray, daNote);
							else
								vanillaBadNoteCheck();
					}
					
						
					
					/* 
						if (controlArray[daNote.noteData])
							goodNoteHit(daNote);
					 */
					// trace(daNote.noteData);
					/* 
						switch (daNote.noteData)
						{
							case 2: // NOTES YOU JUST PRESSED
								if (upP || rightP || downP || leftP)
									noteCheck(upP, daNote);
							case 3:
								if (upP || rightP || downP || leftP)
									noteCheck(rightP, daNote);
							case 1:
								if (upP || rightP || downP || leftP)
									noteCheck(downP, daNote);
							case 0:
								if (upP || rightP || downP || leftP)
									noteCheck(leftP, daNote);
						}
					 */
					if (daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
			}
	
			if ((up || right || down || left) && generatedMusic || (upHold || downHold || leftHold || rightHold) && loadRep && generatedMusic || (fireices_showcase_build && iDontWantToDie))
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if(fireices_showcase_build && iDontWantToDie && daNote.mine)
						return;
					if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
					{
						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 2:
								if (up || upHold || (fireices_showcase_build && iDontWantToDie && !daNote.mine))
									goodNoteHit(daNote);
							case 3:
								if (right || rightHold || (fireices_showcase_build && iDontWantToDie && !daNote.mine))
									goodNoteHit(daNote);
							case 1:
								if (down || downHold || (fireices_showcase_build && iDontWantToDie && !daNote.mine))
									goodNoteHit(daNote);
							case 0:
								if (left || leftHold || (fireices_showcase_build && iDontWantToDie && !daNote.mine))
									goodNoteHit(daNote);
						}
					}
				});
			}
	
			if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
			{
				if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				{
					boyfriend.playAnim('idle');
					if(SONG.song.toLowerCase() == 'bloodbath')
						fireice.playAnim('idle');
				}
			}
	
				playerStrums.forEach(function(spr:FlxSprite)
				{
					switch (spr.ID)
					{
						case 2:
							if (loadRep)
							{
								/*if (upP)
								{
									spr.animation.play('pressed');
									new FlxTimer().start(Math.abs(rep.replay.keyPresses[repReleases].time - Conductor.songPosition) + 10, function(tmr:FlxTimer)
										{
											spr.animation.play('static');
											repReleases++;
										});
								}*/
							}
							else
							{
								if (upP && spr.animation.curAnim.name != 'confirm' && !loadRep)
								{
									spr.animation.play('pressed');
									trace('play');
									if(SONG.song.toLowerCase() == 'retribution' && storyDifficulty == 4)
										health = 0;
								}
								if (upR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
						case 3:
							if (loadRep)
								{
								/*if (upP)
								{
									spr.animation.play('pressed');
									new FlxTimer().start(Math.abs(rep.replay.keyPresses[repReleases].time - Conductor.songPosition) + 10, function(tmr:FlxTimer)
										{
											spr.animation.play('static');
											repReleases++;
										});
								}*/
								}
							else
							{
								if (rightP && spr.animation.curAnim.name != 'confirm' && !loadRep)
								{
									spr.animation.play('pressed');
									if(SONG.song.toLowerCase() == 'retribution' && storyDifficulty == 4)
										health = 0;
								}
									
								if (rightR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}	
						case 1:
							if (loadRep)
								{
								/*if (upP)
								{
									spr.animation.play('pressed');
									new FlxTimer().start(Math.abs(rep.replay.keyPresses[repReleases].time - Conductor.songPosition) + 10, function(tmr:FlxTimer)
										{
											spr.animation.play('static');
											repReleases++;
										});
								}*/
								}
							else
							{
								if (downP && spr.animation.curAnim.name != 'confirm' && !loadRep)
								{
									spr.animation.play('pressed');
									if(SONG.song.toLowerCase() == 'retribution' && storyDifficulty == 4)
										health = 0;
								};
								if (downR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
						case 0:
							if (loadRep)
								{
								/*if (upP)
								{
									spr.animation.play('pressed');
									new FlxTimer().start(Math.abs(rep.replay.keyPresses[repReleases].time - Conductor.songPosition) + 10, function(tmr:FlxTimer)
										{
											spr.animation.play('static');
											repReleases++;
										});
								}*/
								}
							else
							{
								if (leftP && spr.animation.curAnim.name != 'confirm' && !loadRep)
								{
									spr.animation.play('pressed');
									if(SONG.song.toLowerCase() == 'retribution' && storyDifficulty == 4)
										health = 0;
								}
								if (leftR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
					}


					
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
	}
	function vanillaNoteMiss(direction:Int = 1):Void
		{
			if (!boyfriend.stunned)
			{
				///////health -= 0.04;
				if (combo > 5 && gf.animOffsets.exists('sad'))
				{
					gf.playAnim('sad');
				}
				combo = 0;
	
				songScore -= 10;
	
				//FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
				// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
				// FlxG.log.add('played imss note');
	
				boyfriend.stunned = true;
	
				// get stunned for 5 seconds
				new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
				{
					boyfriend.stunned = false;
				});
	
				switch (direction)
				{
					case 0:
						boyfriend.playAnim('singLEFTmiss', true);
					case 1:
						boyfriend.playAnim('singDOWNmiss', true);
					case 2:
						boyfriend.playAnim('singUPmiss', true);
					case 3:
						boyfriend.playAnim('singRIGHTmiss', true);
				}
			}
		}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if((storyDifficulty == 4 && SONG.song == 'Non-Yakob')  || SONG.song == 'Yakobification')
			yakobCorruption += 0.02;
		trace(daNote.noteType);
		if (!boyfriend.stunned && !daNote.spike && !daNote.hallucinatory && !daNote.mine && daNote.noteType == 0)
		{
			if(daNote.noteType == 0)
				if(SONG.song.toLowerCase() == 'termination')
					health -= 0.16725;
				else
					health -= 0.01;

			if(daNote.warning)
			{
				timesMismatched++;
				mismatched = true;
				changeColour = true;
				health -= 1;
				shot = true;
				new FlxTimer().start(0.125, function(timer:FlxTimer){
					shot = false;
				});
				camHUD.flash(FlxColor.RED, 0.2);
				FlxG.sound.play(Paths.sound('bang'));
			}
			if(SONG.song.toLowerCase() == 'bloodbath')
			{
				health -= 0.05;
			}
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			if(daNote.prevention)
				survivedCorrupt = false;
			combo = 0;
			if(misses == 0 && SONG.song.toLowerCase() == 'get-dunked-on!!!!!')
				changeColourKarma = true;
			misses++;

			var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			totalNotesHit += wife;

			songScore -= 10;

			//FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			updateAccuracy();
		}
	}

	function vanillaBadNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				vanillaNoteMiss(0);
			if (upP)
				vanillaNoteMiss(2);
			if (rightP)
				vanillaNoteMiss(3);
			if (downP)
				vanillaNoteMiss(1);
			updateAccuracy();
		}
	
	function updateAccuracy() 
		{
			if (misses > 0 || accuracy < 96)
				fc = false;
			else
				fc = true;
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			if(FlxG.save.data.vanillaInput)
				if (controlArray.contains(true))
					goodNoteHit(note);
				else
				{
					vanillaBadNoteCheck();
				}
			else
				{
					var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
				note.rating = "shit";
			else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
				note.rating = "bad";
			else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
				note.rating = "good";
			else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
				note.rating = "sick";

			if(fireices_showcase_build && iDontWantToDie && !note.mine)
			{
				note.rating = "sick";
				goodNoteHit(note);
				return;
			}


			if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note);
					}
				}
			}
			else if (controlArray[note.noteData] || (fireices_showcase_build && iDontWantToDie && !note.mine))
				{
					for (b in controlArray) {
						if (b)
							mashing++;
					}

					// ANTI MASH CODE FOR THE BOYS

					if (mashing <= getKeyPresses(note) && mashViolations < 2)
					{
						mashViolations++;
						

						goodNoteHit(note, (mashing <= getKeyPresses(note)));
					}
					else if (mashViolations > 2)
						{
							// this is bad but fuck you
							playerStrums.members[0].animation.play('static');
							playerStrums.members[1].animation.play('static');
							playerStrums.members[2].animation.play('static');
							playerStrums.members[3].animation.play('static');
							//health -= 0.4;
							
							AntiCheatState.anticheatReason = "mash";
							trace('FUCKING MASHER');
							LoadingState.loadAndSwitchState(new AntiCheatState());

							trace('mash ' + mashing);
							if (mashing != 0)
								mashing = 0;

							
						}
						else
							goodNoteHit(note, false);

					if (mashing != 0)
						mashing = 0;
				}	
				}

			
		}

		var nps:Int = 0;

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
					note.rating = "shit";
				else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
					note.rating = "bad";
				else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
					note.rating = "good";
				else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
					note.rating = "sick";

				if (!note.isSustainNote)
					notesHitArray.push(Date.now());

				if (resetMashViolation)
					mashViolations--;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote || SONG.song == "Fused" && SONG.notes[Math.floor(curStep / 16)].altAnim == true)
					{
						popUpScore(note, !note.isSustainNote);
						if(!note.isSustainNote)
							combo += 1;
					}
					else
						totalNotesHit += 1;
	

					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
							if(SONG.song.toLowerCase() == 'bloodbath')
								fireice.playAnim('singUP',true);
						case 3:
							boyfriend.playAnim('singRIGHT', true);
							if(SONG.song.toLowerCase() == 'bloodbath')
								fireice.playAnim('singRIGHT',true);
						case 1:
							boyfriend.playAnim('singDOWN', true);
							if(SONG.song.toLowerCase() == 'bloodbath')
								fireice.playAnim('singDOWN',true);
						case 0:
							boyfriend.playAnim('singLEFT', true);
							if(SONG.song.toLowerCase() == 'bloodbath')
								fireice.playAnim('singLEFT',true);
					}
		
					if (!loadRep)
						playerStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(note.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
						});
		
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
			
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	var nothingMattersText:FlxText;
	var nothingMattersSelection:Array<String> = [];

	function shakescreen()
		{
			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				Lib.application.window.move(Lib.application.window.x + FlxG.random.int( -10, 10),Lib.application.window.y + FlxG.random.int( -8, 8));
			}, 50);
		}

	function resetJUMPSCARE():Void
		{
			camHUD.visible = true;
			jumpscareBlood.visible = false;
			isPlayable = true;
		}
	
		function nothingMatters()
		{	
			FlxG.sound.music.volume = 0;
			vocals.volume = 0;
			camHUD.visible = false;
			jumpscareBlood.visible = true;

			isPlayable = false;
			
			shakescreen();
			new FlxTimer().start(0.75 , function(tmr:FlxTimer)
			{
				resetJUMPSCARE();
			});
		}

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700 && gf.animOffsets.exists('hairBlow'))
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		if(gf.animOffsets.exists('hairFall'))
			gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}


	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		if(gf.animOffsets.exists('scared'))
			gf.playAnim('scared', true);
	}

	function felixSlice(cutoffAdd:Float):Void
	{
		cutoff += cutoffAdd;

		//var knifeX:Float = healthBar.x + (healthBar.width * (FlxMath.remapToRange(100-(cutoff*50), 0, 100, 100, 0) * 0.01);

		//var leKnife:FlxSprite = new FlxSprite(knifeX, healthBar.y-8);
		remove(healthBar);
		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8) - Std.int(healthBar.width * (cutoff / 2)) , Std.int(healthBarBG.height - 8), this, 'health', cutoff, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(FlxColor.BLACK, 0xFF66FF33);
		
		remove(iconP1);
		remove(iconP2);
		add(healthBar);
		add(iconP1);
		add(iconP2);
		healthBar.cameras = [camHUD];
	}

	function felixShoot(direction:Int = 0)
	{
		trace(dodgeDirection);
		FlxG.sound.play(Paths.sound('felixShoot'));

		if(dodgeDirection != direction)
		{
			health = 0; // MURDER.
		}

		camHUD.shake(0.005, 0.5);
	}

	function yakobAttack(type:String = 'gun', values:Array<Dynamic>, ?firstTime:Bool = false)
	{
		var firstPrompt:String = '';
		switch(type)
		{
			case 'gun':
				firstPrompt = 'Hold down this direction and press SPACE!\nRelease the direction AFTER you have released SPACE!\nalso WASD doesnt work';
				var direction:Int = values[0];
				FlxG.sound.play(Paths.sound('felixGunCock'));

		// 0123 LEFT DOWN UP RIGHT
		var babyArrow:FlxSprite = new FlxSprite(0,0);

		babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
		babyArrow.animation.addByPrefix('green', 'arrowUP');
		babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
		babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
		babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

		var animations:Array<String> = ['purple', 'blue', 'green', 'red'];
		babyArrow.animation.play(animations[direction]);
		add(babyArrow);

		babyArrow.cameras = [camHUD];
		babyArrow.screenCenter();
		babyArrow.y += 100;

		new FlxTimer().start(1/(Conductor.bpm/60)*2, function(timer:FlxTimer){
			felixShoot(direction);
			remove(babyArrow);
		});
		case 'glassWarning':
			firstPrompt = 'Hold down this direction and press SPACE!\nRelease the direction AFTER you have released SPACE!\nalso WASD doesnt work';
			var babyArrow:FlxSprite = new FlxSprite(0,0);

			babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
			babyArrow.animation.addByPrefix('green', 'arrowUP');
			babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
			babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
			babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

			var animations:Array<String> = ['purple', 'blue', 'green', 'red'];
			babyArrow.animation.play(animations[1]);
			add(babyArrow);
			babyArrow.cameras = [camHUD];
			babyArrow.screenCenter();
			babyArrow.y += 100;

			new FlxTimer().start(1/(Conductor.bpm/60)*2, function(timer:FlxTimer){
				remove(babyArrow);
			});
		case 'glassShatter':
			FlxG.sound.play(Paths.sound('yakobShatter'));

			if(storyDifficulty == 4)
				health = 0.02;

			if(!dodging || dodgeDirection != 1)
			{
				health = 0; // MURDER.
				cringReason = 'Lacerated by shards of glass';
			}

			
		
			camHUD.shake(0.005, 0.5);

		case 'drag':
			firstPrompt = 'Spam SHIFT to stop this drain! (oh and also disable sticky keys)';
			dragging = true;
			shiftsLeft = values[0];

		case 'ball':
			firstPrompt = 'Hold down this letter until it disappears!';
			var alp:Array<String> = 'abcdefghijklmnopqrstuvwxyz'.split('');
			var ballsText:FlxText = new FlxText(0,0,0,alp[Std.random(25)].toUpperCase());
			ballsText.setFormat(Paths.font("vcr.ttf"), 256, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			ballsText.cameras = [camHUD];
			ballsText.screenCenter();
			ballsText.y += 100;
			add(ballsText);

			new FlxTimer().start(1/(Conductor.bpm/60)*4, function(timer:FlxTimer){
				FlxG.sound.play(Paths.sound('felixShoot'));
				if(!FlxG.keys.anyPressed([FlxKey.fromString(ballsText.text)]))
				{
					health = 0;
					cringReason = 'Tungsten ball going at 100 metres per second';
				}
				remove(ballsText);
				
			});


		case 'healthCap':
			healthCap = values[0];
		
		}

		if(firstTime)
		{
			message.visible = true;
			var daBeats = 8;
			if(type == 'ball')
				daBeats = 4;
			if(type == 'glassWarning')
				daBeats = 2;
			message.text = firstPrompt;
			new FlxTimer().start((1/(Conductor.bpm/60))*daBeats, function(timer:FlxTimer){
				message.visible = false;
				message.text = '';
			});
		}
		

	}

	function abilityCard(cardName:String = 'inferno')
	{
		switch(cardName)
		{
			case 'inferno':
				message.color = FlxColor.ORANGE;
				message.text = "Inferno Inbound!";
				var infernoWarning:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.ORANGE);
				infernoWarning.alpha = 0.6;
				infernoWarning.cameras = [camHUD];
				message.visible = true;
				infernoWarning.screenCenter();
				add(infernoWarning);
				new FlxTimer().start((1/(Conductor.bpm/60))*8, function(timer:FlxTimer){
					message.visible = false;
					message.text = '';
					infernoActive = true;
					new FlxTimer().start((1/(Conductor.bpm/60))*32, function(timer:FlxTimer){
						infernoActive = false;
						remove(infernoWarning);
					});
				});
			case 'bazooka':
				message.color = FlxColor.RED;
				message.text = "Bazooka Shell Inbound!";
				var bazookaWarning:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.RED);
				bazookaWarning.alpha = 0.6;
				bazookaWarning.cameras = [camHUD];
				message.visible = true;
				bazookaWarning.screenCenter();
				add(bazookaWarning);
				new FlxTimer().start((1/(Conductor.bpm/60))*8, function(timer:FlxTimer){
					message.visible = false;
					health = 0;
					remove(bazookaWarning);
				});
			case 'gun':
				message.color = FlxColor.YELLOW;
				message.text = "Bullets Inbound!";
				var bulletWarning:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.YELLOW);
				bulletWarning.alpha = 0.6;
				bulletWarning.cameras = [camHUD];
				message.visible = true;
				bulletWarning.screenCenter();
				add(bulletWarning);
				new FlxTimer().start((1/(Conductor.bpm/60))*4, function(timer:FlxTimer){
					health -= 0.5;
					FlxG.sound.play(Paths.sound('felixShoot'));
					remove(bulletWarning);
					message.visible = false;
				});
			case 'successorGun':
				FlxG.sound.play(Paths.sound('felixShoot'));
				health -= 0.5;
		}
	}

	function felixCock(direction:Int = 0)
	{
		FlxG.sound.play(Paths.sound('felixGunCock'));

		// 0123 LEFT DOWN UP RIGHT
		var babyArrow:FlxSprite = new FlxSprite(0,0);

		babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
		babyArrow.animation.addByPrefix('green', 'arrowUP');
		babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
		babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
		babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

		var animations:Array<String> = ['purple', 'blue', 'green', 'red'];
		babyArrow.animation.play(animations[direction]);
		add(babyArrow);

		babyArrow.cameras = [camHUD];
		babyArrow.screenCenter();
		babyArrow.y += 100;

		new FlxTimer().start(1/(Conductor.bpm/60)*2, function(timer:FlxTimer){
			felixShoot(direction);
			remove(babyArrow);
		});

	}

	function felixGlitch():Void
	{
		var felixStatic:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('static'));
		felixStatic.cameras = [camHUD];
		felixStatic.screenCenter();
		
		add(felixStatic);

		var damage:Float = 1.4;
		if(storyDifficulty == 4)
		{
			damage = 1.9;
		}
		health -= damage;

		if(storyDifficulty == 4)
		{
			healthCap = health;
			new FlxTimer().start(5, function(timer:FlxTimer){
				healthCap = 2;
			});
		}

		// how to get duration of 1 beat: bpm/60=bps; 1/bps=beatDuration;
		var bps:Float = Conductor.bpm/60;
		camHUD.shake(0.1,1/bps);

		new FlxTimer().start(1/bps, function(timer:FlxTimer){
			remove(felixStatic);
		});
	}

	var glitched:Bool = false;

	var realHealth:Float = 1;

	var ties:Array<Array<Int>> = [
		[0, 0],
		[1, 1],
		[2, 2],
		[3, 3],
		[4, 4],
		[5, 5],
		[6, 6],
		[7, 7]
	];
	override function stepHit()
	{
		super.stepHit();

		var addDiff:Float = 0;
		if(storyDifficulty == 0) addDiff = 1;

		if((SONG.song.toLowerCase() == 'no-escape' || SONG.song.toLowerCase() == 'fused') && curStep % (24/((storyDifficulty+addDiff)/2)) == 1 && Std.random(2) == 1 && !inCutscene) // 50% chance that every 24 steps a notif will occur :)
			{
				var possibleNotifx:Array<String> = ['getReal', 'faceIt', 'dontGet', 'giveUp', 'regainControl', 'regainControl'];
				var notif:FlxSprite = new FlxSprite(Std.random(FlxG.width), Std.random(FlxG.height)).loadGraphic(Paths.image('notifications/' + possibleNotifx[Std.random(possibleNotifx.length-1)]));
				//add(notif);
				notif.setGraphicSize(Std.int(notif.width * 2));
				notifGroups.add(notif);
				
				new FlxTimer().start(10.5, function(daTime:FlxTimer){
					notif.visible = false;
					notif.kill();
				}) ;
			}

		if(SONG.song.toLowerCase() == 'chronicles')
		{
			switch(curStep)
			{ 
				case 316 | 444: 
					felixGlitch();
			}
		}

		if(SONG.song.toLowerCase() == 'process-unstable')
		{
			switch(curStep)
			{ 
				case 512 | 1280: 
					unstable = true;
					for(i in 0...playerStrums.members.length)
					{
						var spr:FlxSprite = playerStrums.members[i];
						spr.x -= 278;
					}
					for(i in 0...cpuStrums.members.length)
					{
						var spr:FlxSprite = cpuStrums.members[i];
						spr.x += 278;
						spr.visible = false;
					}
				case 768 | 1792:
					unstable = false;
					camHUD.angle = 0;
					for(i in 0...playerStrums.members.length)
					{
						var spr:FlxSprite = playerStrums.members[i];
						spr.x += 278;
					}
					for(i in 0...cpuStrums.members.length)
					{
						var spr:FlxSprite = cpuStrums.members[i];
						spr.x -= 278;
						spr.visible = true;
					}
			}
		}

		if(SONG.song.toLowerCase() == 'screwed')
		{
			switch(curStep)
			{
				case 1312:
					screwed = true;
			}
		}

		if(SONG.song.toLowerCase() == 'yakobification')
		{
			switch(curStep)
			{ 
				case 888: 
					yakobAttack('glassWarning', [], true);
				case 896:
					healthCap = 1.2;
					yakobAttack('glassShatter', []);
				case 1024:
					yakobAttack('drag', [12], true);
				case 1088 | 1280 | 1600 | 1856:
					yakobAttack('ball', [], true);
				case 1152:
					healthCap = 1;
				case 1344 | 1472 | 1664:
					yakobAttack('drag', [15]);
				case 1400:
					felixCock(3);
				case 1920:
					yakobAttack('drag', [20]);

			}
		}

		if(SONG.song == 'Life-or-Death' && storyDifficulty == 4)
		{
			switch(curStep)
			{
				case 64 | 128 | 224 | 352 | 512 | 640 | 704 | 768 | 1120 | 1184 | 1248 | 1312:
					fuck = true;
				case 96 | 160 | 288 | 416 | 544 | 672 | 736 | 800 | 1152 | 1216 | 1280 | 1344:
					fuck = false;
			}
		}

		if(glitched)
		{
			health = FlxG.random.float(0.001, realHealth+0.1);
			for(i in 0...strumLineNotes.length)
			{
				var spr:FlxSprite = strumLineNotes.members[i];
				var newTie = Std.random(7);
				
				for(j in ties)
				{
					while(j[1] == newTie && j[0] != j[1])
						newTie = Std.random(7);
				}
				ties[i][1] = newTie;
			}
			isDownscroll = FlxG.random.bool(50);
			
			notes.forEach(function(note:Note){note.downscrollNote = isDownscroll;});
			for (i in 0...playerStrums.length) {
				playerStrums.members[i].angle = Std.random(359);
				if (i == 0) {
					playerStrums.members[i].x = FlxG.random.int(100, Std.int(FlxG.width / 3));
					if (isDownscroll)
						playerStrums.members[i].y = FlxG.random.int(Std.int(FlxG.height / 2), FlxG.height - 100);
					else
						playerStrums.members[i].y = FlxG.random.int(0, 300);
						
				} else {
					var futurex = FlxG.random.int(Std.int(playerStrums.members[i - 1].x) + 80, Std.int(playerStrums.members[i - 1].x) + 400);
					if (futurex > FlxG.width - 100)
						futurex = FlxG.width - 100;
					playerStrums.members[i].x = futurex;
						playerStrums.members[i].y = FlxG.random.int(Std.int(playerStrums.members[0].y - 50), Std.int(playerStrums.members[0].y + 50));
					}
				}

				for (i in 0...cpuStrums.length) {
					cpuStrums.members[i].angle = Std.random(359);
					if (i == 0) {
						cpuStrums.members[i].x = FlxG.random.int(100, Std.int(FlxG.width / 3));
						if (isDownscroll)
							cpuStrums.members[i].y = FlxG.random.int(Std.int(FlxG.height / 2), FlxG.height - 100);
						else
							cpuStrums.members[i].y = FlxG.random.int(0, 300);
							
					} else {
						var futurex = FlxG.random.int(Std.int(cpuStrums.members[i - 1].x) + 80, Std.int(cpuStrums.members[i - 1].x) + 400);
						if (futurex > FlxG.width - 100)
							futurex = FlxG.width - 100;
						cpuStrums.members[i].x = futurex;
							cpuStrums.members[i].y = FlxG.random.int(Std.int(cpuStrums.members[0].y - 50), Std.int(playerStrums.members[0].y + 50));
						}
					}
			
			
		}

		if(storyDifficulty == 4)
		{
			switch(curStep)
			{
				/*case 768 | 1088:
					if(SONG.song == 'Process-Unstable')
					{
						realHealth = health;
						glitched = true;
					}
				case 832 | 1120:
					if(SONG.song == 'Process-Unstable' || SONG.song == 'Insanity' && curStep == 1120)
					{
						if(health > realHealth)
							health = 0.01;
						realHealth = health;
						glitched = false;
					}*/
				/*case 512 | 959:
					if(SONG.song == 'Insanity')
					{
						realHealth = health;
						glitched = true;
					}

				case 576:
					if(SONG.song == 'Insanity')
					{
						if(health > realHealth)
							health = 0.01;
						realHealth = health;
						glitched = false;
					}*/

			}
		}

		if(SONG.song.toLowerCase() == 'slash-n-slice')
		{
			switch(curStep)
			{
				case 1280:
					felixSlice(0.3); // 15% slice
				case 2110 | 2238 | 2336 | 2496 | 2816: // 25% slice in total
					felixSlice(0.1); //At the end of Slash n Slice 40% has been sliced (0.8)
			}
		}

		if(SONG.song == 'Jupiter')
		{
			switch(curStep)
			{
				case 16:
					message.color = FlxColor.CYAN;
					message.visible = true;
					message.text = "Hold SHIFT to activate your Energy Shield.\nThis shield makes you impervious to damage however\ndrains your Energy and will prevent you from healing.";
				case 64:
					message.text = "Use this against the many abilities that\nyour enemies may use!";
				case 128:
					message.visible = false;
					message.text = "";
				case 1280:
					abilityCard('inferno');
			
			}
		}

		if(SONG.song.toLowerCase() == 'killing-spree')
		{
			switch(curStep)
			{
				case 248 | 1464 | 2296:
					felixCock(0);
				case 504 | 1784 | 2424 | 2584:
					felixCock(2);
				case 632 | 1272 | 1656 | 2040:
					felixCock(1);
				case 896:
					felixSlice(0.2); // 10% slice (50% left)
				case 1144 | 1912 | 2552:
					felixCock(3);
				case 1280:
					felixSlice(0.1); // 5% slice (45% left)
				case 1408:
					felixSlice(0.2); // 35% left
				case 1664:
					felixSlice(0.1); // 30% left
				case 1920:
					felixSlice(0.1); // 25% left
				case 2430:
					felixSlice(0.1); // 20% left
				case 2560:
					felixSlice(0.2); // the end.
			}
		}

		if(SONG.song == "Termination")
		{
			switch (curStep)
			{
				case 1:
					FlxTween.tween(strumLineNotes.members[0], {y: strumLineNotes.members[0].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					FlxTween.tween(strumLineNotes.members[7], {y: strumLineNotes.members[7].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});

				case 32:
					FlxTween.tween(strumLineNotes.members[1], {y: strumLineNotes.members[1].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					FlxTween.tween(strumLineNotes.members[6], {y: strumLineNotes.members[6].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
				case 96:
					FlxTween.tween(strumLineNotes.members[3], {y: strumLineNotes.members[3].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					FlxTween.tween(strumLineNotes.members[4], {y: strumLineNotes.members[4].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
				case 64:
					FlxTween.tween(strumLineNotes.members[2], {y: strumLineNotes.members[2].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					FlxTween.tween(strumLineNotes.members[5], {y: strumLineNotes.members[5].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
				case 112:
					add(kb_attack_saw);
					add(kb_attack_alert);
					KBATTACK_ALERT();
					KBATTACK();
				case 116:
					//KBATTACK_ALERTDOUBLE();
					KBATTACK_ALERT();
				case 120:
					//KBATTACK(true, "old/attack_alt01");
					KBATTACK(true);
					
				

				case 1776 | 1904 | 2032 | 2576 | 2596 | 2608 | 2624 | 2640 | 2660 | 2672 | 2704 | 2736 | 3072 | 3084 | 3104 | 3116 | 3136 | 3152 | 3168 | 3184 | 3216 | 3248 | 3312:
					KBATTACK_ALERT();
					KBATTACK();
				case 1780 | 1908 | 2036 | 2580 | 2600 | 2612 | 2628 | 2644 | 2664 | 2676 | 2708 | 2740 | 3076 | 3088 | 3108 | 3120 | 3140 | 3156 | 3172 | 3188 | 3220 | 3252 | 3316:
					KBATTACK_ALERT();
				case 1784 | 1912 | 2040 | 2584 | 2604 | 2616 | 2632 | 2648 | 2668 | 2680 | 2712 | 2744 | 3080 | 3092 | 3112 | 3124 | 3144 | 3160 | 3176 | 3192 | 3224 | 3256 | 3320:
					KBATTACK(true);

				//Sawblades before bluescreen thing
				//These were seperated for double sawblade experimentation if you're wondering.
				//My god this organisation is so bad. Too bad!
				case 2304 | 2320 | 2340 | 2368 | 2384 | 2404:
					KBATTACK_ALERT();
					KBATTACK();
				case 2308 | 2324 | 2344 | 2372 | 2388 | 2408:
					KBATTACK_ALERT();
				case 2312 | 2328 | 2348 | 2376 | 2392 | 2412:
					KBATTACK(true);
				case 2352 | 2416:
					KBATTACK_ALERT();
					KBATTACK();
				case 2356 | 2420:
					//KBATTACK_ALERTDOUBLE();
					KBATTACK_ALERT();
				case 2360 | 2424:
					KBATTACK(true);
				case 2363 | 2427:
					//KBATTACK();
				case 2364 | 2428:
					//KBATTACK(true, "old/attack_alt02");

				case 2560:
					KBATTACK_ALERT();
					KBATTACK();
				case 2564:
					KBATTACK_ALERT();
				case 2568:
					KBATTACK(true);


				case 3376 | 3408 | 3424 | 3440 | 3576 | 3636 | 3648 | 3680 | 3696 | 3888 | 3936 | 3952 | 4096 | 4108 | 4128 | 4140 | 4160 | 4176 | 4192 | 4204:
					KBATTACK_ALERT();
					KBATTACK();
				case 3380 | 3412 | 3428 | 3444 | 3580 | 3640 | 3652 | 3684 | 3700 | 3892 | 3940 | 3956 | 4100 | 4112 | 4132 | 4144 | 4164 | 4180 | 4196 | 4208:
					KBATTACK_ALERT();
				case 3384 | 3416 | 3432 | 3448 | 3584 | 3644 | 3656 | 3688 | 3704 | 3896 | 3944 | 3960 | 4104 | 4116 | 4136 | 4148 | 4168 | 4184 | 4200 | 4212:
					KBATTACK(true);

				case 4352: //Custom outro hardcoded instead of being part of the modchart! 
					FlxTween.tween(strumLineNotes.members[2], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4384:
					FlxTween.tween(strumLineNotes.members[3], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4416:
					FlxTween.tween(strumLineNotes.members[0], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4448:
					FlxTween.tween(strumLineNotes.members[1], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});

				case 4480:
					FlxTween.tween(strumLineNotes.members[6], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4512:
					FlxTween.tween(strumLineNotes.members[7], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4544:
					FlxTween.tween(strumLineNotes.members[4], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4576:
					FlxTween.tween(strumLineNotes.members[5], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 2808:
					//Change to glitch background
					
					error_404_temp.visible = true;
					sufferBG.visible = false;
					
					FlxG.camera.shake(0.0075,0.675);


				case 2816: //404 section
					
					sufferBG.visible = false;
					error_404_temp.visible = false;


					
				case 3328: //Final drop
					//Revert back to normal
					sufferBG.visible = true;
					error_404_temp.visible = false;
			}
		}
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}

		switch (curStep)
		{
			case 3820:
				
			case 3808:
				if(SONG.song.toLowerCase() == 'bloodbath')
					canDie = false;
					// dead
			case 3933:
				if(SONG.song.toLowerCase() == 'bloodbath')
				{
					camHUD.visible = false;
					tintCamera.flash(FlxColor.RED, 1, function()
						{
							tintCamera.visible = false;
						});
					if(dodging)
					{
						health = 0;
						blasted = true;
					}
				}
			case 3934:
				if(SONG.song.toLowerCase() == 'bloodbath')
				{
					bloodTint.visible = false;
					FlxG.camera.visible = false;
				}
				
					// dead
			// Madness attacks
			case 128 | 254 | 384 | 448 | 512 | 560 | 608 | 704 | 768 | 816 | 864 | 880 | 892 | 960 | 996 | 1002 | 1008 | 1020 | 1152 | 1176 | 1208 | 1240 | 1272 | 1523 | 1527 | 1531 | 1535 | 1562 | 1583 | 1599 | 1677 | 1694 | 1711 | 1733 | 1750 | 1772 | 1823 | 1836 | 1855 | 1871 | 1920 | 1971 | 1977 | 1983 | 2015 | 2031 | 2047 | 2111:
				if(SONG.song.toLowerCase() == 'madness')
				{
					camHUD.flash(FlxColor.RED,0.42);
				}
			case 129 | 255 | 385 | 449 | 513 | 561 | 609 | 705 | 769 | 817 | 865 | 881 | 893 | 961 | 997 | 1003 | 1009 | 1021 | 1153 | 1177 | 1209 | 1241 | 1273 | 1524 | 1528 | 1532 | 1536 | 1563 | 1584 | 1600 | 1678 | 1695 | 1712 | 1734 | 1751 | 1773 | 1824 | 1837 | 1856 | 1872 | 1921 | 1972 | 1978 | 1984 | 2016 | 2032 | 2048 | 2112:
				if(SONG.song.toLowerCase() == 'madness')
				{
					if(!dodging && (!fireices_showcase_build || !iDontWantToDie))
					{
						blasted = true;
						health = 0;
					}
						

				}
			
			
		}

		switch(curStep) // canm't have mingling cases
		{
			// Mechanical Whirrs messages
			case 2:
			case 112 | 1022:
				if(SONG.song.toLowerCase() == 'mechanical-whirrs')
				{
					message.visible = false;
				}

			case 2128:
				if(SONG.song.toLowerCase() == 'expurrgation')
				{
					dieMoment = true;
					camHUD.shake(.075, 1);
					remove(dad);
					dad = new Character(100, 250, 'fireice-demigod');
					add(dad);
// oh i see
					for(i in 0...strumLineNotes.length)
					{
						var member = strumLineNotes.members[i];
						member.x -= 275;
					}
					healthCap = 0.5;
				}
			
			
			case 379 | 511 | 639 | 703 | 767 | 815 | 847 | 895 | 1027 | 1091 | 1155 | 1219 | 1251 | 1283 | 1295 | 1311 | 1327 | 1343 | 1407 | 1423 | 1439 | 1455 | 1471 | 1487 | 1503 | 1539 | 1795:
				if(SONG.song.toLowerCase() == 'mechanical-whirrs')
				{
					camHUD.flash(FlxColor.RED,0.42);
				}
			case 380 | 512 | 640 | 704 | 768 | 816 | 848 | 896 | 1028 | 1092 | 1156 | 1220 | 1252 | 1284 | 1296 | 1312 | 1328 | 1344 | 1408 | 1424 | 1440 | 1456 | 1472 | 1488 | 1504 | 1540 | 1796:
				if(SONG.song.toLowerCase() == 'mechanical-whirrs' && (!fireices_showcase_build || !iDontWantToDie))
				{
					if(!dodging)
					{
						blasted = true;
						health = 0;
					}
						
				}
			
		}
		switch(curStep)
		{
			case 1:
				if(SONG.song.toLowerCase() == 'retribution' && storyDifficulty == 4)
				{
					healthBar.visible = false;
					healthBarBG.visible = false;
					iconP1.visible = false;
					iconP2.visible = false;
					scoreTxt.visible = false;
					for(i in 0...strumLineNotes.length)
					{
						var member = strumLineNotes.members[i];
						member.x -= 275;
						if(i < 4)
							member.x -= 42069;
					}
				}
			case 255 | 1647 | 1775 | 1903 | 1919 | 1935 | 1951 | 1983 | 1999 | 2015 | 2079 | 2735:
				if(SONG.song.toLowerCase() == 'retribution')
				{
					camHUD.flash(FlxColor.RED,0.42);
				}
			case 256 | 1776 | 1904 | 1920 | 1936 | 1952 | 1984 | 2000 | 2016 | 2080 | 2736:
				if(SONG.song.toLowerCase() == 'retribution' && (!fireices_showcase_build || !iDontWantToDie))
				{
					if(!dodging)
					{
						blasted = true;
						health = 0;
					}

					if(curStep == 1648)
					{
						
					}

					
						
				}
			case 1648:
				if(SONG.song.toLowerCase() == 'retribution')
				{
					camHUD.flash(FlxColor.RED,0.42);
					remove(dad);
					dad = new Character(dad.x, dad.y, 'prototype');
					iconP2.animation.play('prototype');
					add(dad);
				}
				
			case 1535:
				if(SONG.song.toLowerCase() == 'retribution')
				{
					camHUD.flash(FlxColor.WHITE, 3);
					FlxG.camera.zoom = 2;
					camGame.zoom = 2;
					remove(dad);
					//dad = new Character(dad.x, dad.y, 'prototype');
					dad = new Character(dad.x, dad.y, 'coolguy');
					iconP2.animation.play('coolguy');
					add(dad);
					health -= 0.75;
				}

				
			case 1599:
				if(SONG.song.toLowerCase() == 'retribution')
				{
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 5, {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween)
						{
							trace('OH MY FUCKING GOD!');
						}
					});
				}
			case 1649:
				if(SONG.song.toLowerCase() == 'retribution' && storyDifficulty != 4)
					health -= 1;
			case 1777:
				if(SONG.song.toLowerCase() == 'retribution' && storyDifficulty != 4)
					health -= 0.1;
			case 2159:
				if(SONG.song.toLowerCase() == 'retribution' && storyDifficulty != 4)
					health = 0.5;
			case 2543:
				if(SONG.song.toLowerCase() == 'retribution' && storyDifficulty != 4)
					health -= 0.85;
				
		}

		



		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if(unstable)
		{
			if(curBeat % 2 == 0)
				camHUD.angle = 5 + (20*storyDifficulty);
			if(curBeat % 2 == 1)
				camHUD.angle = -5 - (20*storyDifficulty);
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, isDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if(SONG.song.toLowerCase() == 'termination')
		{
			switch(curBeat)
			{
				case 4:
					initialStrumX[4] = strumLineNotes.members[4].x;
					initialStrumX[5] = strumLineNotes.members[5].x;
					initialStrumX[6] = strumLineNotes.members[6].x;
					initialStrumX[7] = strumLineNotes.members[7].x;

					initialStrumY[4] = strumLineNotes.members[4].y;
					initialStrumY[5] = strumLineNotes.members[5].y;
					initialStrumY[6] = strumLineNotes.members[6].y;
					initialStrumY[7] = strumLineNotes.members[7].y;
				case 322:
					if(FlxG.save.data.downscroll)
						FlxTween.tween(strumLineNotes.members[6], {y: strumLineNotes.members[6].y-25}, 0.25);
					else
						FlxTween.tween(strumLineNotes.members[6], {y: strumLineNotes.members[6].y+25}, 0.25);
				case 338:
				
					FlxTween.tween(strumLineNotes.members[6], {x: initialStrumX[6], y: initialStrumY[6]}, 0.3);
					
					if(!FlxG.save.data.downscroll)
						FlxTween.tween(strumLineNotes.members[4], {x: strumLineNotes.members[4].x-30, y: strumLineNotes.members[4].y+26}, 0.25);
					else
						FlxTween.tween(strumLineNotes.members[4], {x: strumLineNotes.members[4].x-30, y: strumLineNotes.members[4].y-26}, 0.25);
				case 354:
					
					FlxTween.tween(strumLineNotes.members[4], {x: initialStrumX[4], y: initialStrumY[4]}, 0.25);
					if(!FlxG.save.data.downscroll)
					{
						FlxTween.tween(strumLineNotes.members[7], {x: strumLineNotes.members[7].x+55, y: strumLineNotes.members[7].y+26}, 0.25);
						FlxTween.tween(strumLineNotes.members[5], {x: strumLineNotes.members[5].x+10, y: strumLineNotes.members[5].y+29}, 0.25);
					}
					else
					{	
						FlxTween.tween(strumLineNotes.members[7], {x: strumLineNotes.members[7].x+55, y: strumLineNotes.members[7].y-26}, 0.25);
						FlxTween.tween(strumLineNotes.members[5], {x: strumLineNotes.members[5].x+10, y: strumLineNotes.members[5].y-29}, 0.25);
					}
				case 370:
					if(!FlxG.save.data.downscroll)
					{
						FlxTween.tween(strumLineNotes.members[6],{x: initialStrumX[6], y: strumLineNotes.members[6].y-12}, 0.25);
						FlxTween.tween(strumLineNotes.members[5], {x: initialStrumX[6], y: strumLineNotes.members[5].y-12}, 0.25);
						FlxTween.tween(strumLineNotes.members[7], {x: strumLineNotes.members[7].x+22, y: strumLineNotes.members[7].y+20}, 0.25);
						FlxTween.tween(strumLineNotes.members[4], {x: strumLineNotes.members[4].x-22, y: strumLineNotes.members[4].y+20}, 0.25);
						FlxTween.tween(strumLineNotes.members[7], {angle: strumLineNotes.members[7].angle+40}, 0.25);
						FlxTween.tween(strumLineNotes.members[4], {angle: strumLineNotes.members[4].angle-40}, 0.25);
					}
					else
					{
						FlxTween.tween(strumLineNotes.members[6], {y: strumLineNotes.members[6].y+12}, 0.25);
						FlxTween.tween(strumLineNotes.members[5], {y: strumLineNotes.members[5].y+12}, 0.25);
						FlxTween.tween(strumLineNotes.members[7], {x: strumLineNotes.members[7].x+22, y: strumLineNotes.members[7].y-20}, 0.25);
						FlxTween.tween(strumLineNotes.members[4], {x: strumLineNotes.members[4].x-22, y: strumLineNotes.members[4].y-20}, 0.25);
						FlxTween.tween(strumLineNotes.members[7], {angle: -40}, 0.25);
						FlxTween.tween(strumLineNotes.members[4], {angle: 40}, 0.25);
					}
				case 383:
					FlxTween.tween(strumLineNotes.members[7], {x: initialStrumX[7], y: initialStrumY[7]}, 0.6);
					FlxTween.tween(strumLineNotes.members[6], {x: initialStrumX[6], y: initialStrumY[6]}, 0.6);
					FlxTween.tween(strumLineNotes.members[5], {x: initialStrumX[5], y: initialStrumY[5]}, 0.6);
					FlxTween.tween(strumLineNotes.members[4], {x: initialStrumX[4], y: initialStrumY[4]}, 0.6); //failsafe
				case 384:
					FlxTween.tween(strumLineNotes.members[4], {y:strumLineNotes.members[4].y+75}, 0.75);
					FlxTween.tween(strumLineNotes.members[7], {y:strumLineNotes.members[7].y-75}, 0.75);
					FlxTween.tween(strumLineNotes.members[7], {angle: 0}, 0.6);
					FlxTween.tween(strumLineNotes.members[4], {angle: 0}, 0.6);
				case 388:
					FlxTween.tween(strumLineNotes.members[4], {x: initialStrumX[7]}, 0.75);
					FlxTween.tween(strumLineNotes.members[7], {x: initialStrumX[4]}, 0.75);
				case 392:
					FlxTween.tween(strumLineNotes.members[4], {y: strumLineNotes.members[4].y-75}, 0.75);
					FlxTween.tween(strumLineNotes.members[7], {y: strumLineNotes.members[7].y+75}, 0.75);
				case 400:
					FlxTween.tween(strumLineNotes.members[6], {y: strumLineNotes.members[6].y+75}, 0.75);
					FlxTween.tween(strumLineNotes.members[5], {y: strumLineNotes.members[5].y-75}, 0.75);
				case 404: // haha its the funny 404
					FlxTween.tween(strumLineNotes.members[6], {x: initialStrumX[5]}, 0.75);
					FlxTween.tween(strumLineNotes.members[5], {x: initialStrumX[6]}, 0.75);
				case 408:
					FlxTween.tween(strumLineNotes.members[6], {x: initialStrumX[5]}, 0.75);
					FlxTween.tween(strumLineNotes.members[5], {x: initialStrumX[6]}, 0.75);
					FlxTween.tween(strumLineNotes.members[5], {y: strumLineNotes.members[5].y+75}, 0.75);
					FlxTween.tween(strumLineNotes.members[6], {y: strumLineNotes.members[6].y-75}, 0.75); // finally done with the note swap
				case 409:
					FlxTween.tween(strumLineNotes.members[6], {x: initialStrumX[5]}, 0.75);
					FlxTween.tween(strumLineNotes.members[5], {x: initialStrumX[6]}, 0.75);
				case 448:
					FlxTween.tween(strumLineNotes.members[7], {x: initialStrumX[7], y: initialStrumY[7]}, 0.6);
					FlxTween.tween(strumLineNotes.members[6], {x: initialStrumX[6], y: initialStrumY[6]}, 0.6);
					FlxTween.tween(strumLineNotes.members[5], {x: initialStrumX[5], y: initialStrumY[5]}, 0.6);
					FlxTween.tween(strumLineNotes.members[4], {x: initialStrumX[4], y: initialStrumY[4]}, 0.6); // now to reset them, ugh
			}
			
			

				
			
		}


		


		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (unstable && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{	
			if(SONG.song.toLowerCase() == 'life-or-death')
				boyfriend.playAnim('scared');
			else
				boyfriend.playAnim('idle');
				if(SONG.song.toLowerCase() == 'bloodbath')
					fireice.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	private function checkForAchievement(arrayIDs:Array<Int>):Int {
		var unlockedSomething:Bool = false;
		Achievements.loadAchievements();
		for (i in 0...arrayIDs.length) {
			if(!Achievements.achievementsUnlocked[arrayIDs[i]][1]) {
				switch(arrayIDs[i]) {
					case 0:
						if(SONG.song == 'High-Stakes')
						{
							Achievements.unlockAchievement(arrayIDs[i]);
							trace('le unlock');
							return arrayIDs[i];
							unlockedSomething = true;
						}
					case 1:
						if(SONG.song == 'Process-Unstable')
						{
							Achievements.unlockAchievement(arrayIDs[i]);
							unlockedSomething = true;
							trace('le unlock');
							return arrayIDs[i];
						}
					case 2:
						if(SONG.song == 'Insanity')
						{
							Achievements.unlockAchievement(arrayIDs[i]);
							unlockedSomething = true;
							trace('le unlock');
							return arrayIDs[i];
						}
					case 3:
						if(SONG.song == 'Life-or-Death')
						{	
							Achievements.unlockAchievement(arrayIDs[i]);
							unlockedSomething = true;
							trace('le unlock');
							return arrayIDs[i];
						}
					case 4 | 5:
						if(SONG.song == 'Suffer-in-Blood' || SONG.song == 'Bloodbath')
						{
							Achievements.unlockAchievement(arrayIDs[i]);
							unlockedSomething = true;
							trace('le unlock');
							return arrayIDs[i];
						}
					case 6:
						if(mismatched && !shot)
						{
							Achievements.unlockAchievement(arrayIDs[i]);
							unlockedSomething = true;
							trace('le unlock');
							return arrayIDs[i];
						}
					case 7:
						if(shot)
						{
							Achievements.unlockAchievement(arrayIDs[i]);
							unlockedSomething = true;
							trace('le unlock');
							return arrayIDs[i];
						}
					case 8:
						if(blasted && (SONG.song != 'Retribution' || curStep < 1535))
						{
							Achievements.unlockAchievement(arrayIDs[i]);
							unlockedSomething = true;
							trace('le unlock');
							return arrayIDs[i];
						}
					case 9:
						if(blasted && SONG.song == 'Retribution' && curStep >= 1535)
						{
							Achievements.unlockAchievement(arrayIDs[i]);
							unlockedSomething = true;
							trace('le unlock');
							return arrayIDs[i];
						}
					case 10:
						if(SONG.song == "Mechanical-Whirrs")
						{
							Achievements.unlockAchievement(arrayIDs[i]);
							unlockedSomething = true;
							trace('le unlock');
							return arrayIDs[i];
						}
					case 11:
						if(SONG.song == "Fused")
						{
							Achievements.unlockAchievement(arrayIDs[i]);
							unlockedSomething = true;
							trace('le unlock');
							return arrayIDs[i];
						}
					case 12:
						if(SONG.song == "Retribution")
						{
							Achievements.unlockAchievement(arrayIDs[i]);
							unlockedSomething = true;
							trace('le unlock');
							return arrayIDs[i];
						}
					case 13:
						if(SONG.song == "Retribution" && storyDifficulty == 4)
						{
							Achievements.unlockAchievement(arrayIDs[i]);
							unlockedSomething = true;
							trace('le unlock');
							return arrayIDs[i];
						}
					case 14:
						if(SONG.song == "Counter-Attack")
						{
							Achievements.unlockAchievement(arrayIDs[i]);
							unlockedSomething = true;
							trace('le unlock');
							return arrayIDs[i];
						}
					case 15:
						if(SONG.song == "Termination")
						{
							Achievements.unlockAchievement(arrayIDs[i]);
							unlockedSomething = true;
							trace('le unlock');
							return arrayIDs[i];
						}
					
				}
			}
		}
		return -1;
		

	}

	var curLight:Int = 0;
}

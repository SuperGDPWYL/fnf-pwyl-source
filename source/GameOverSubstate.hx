package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.util.FlxAxes;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var specialMessage:String = "";
	var message:FlxText;

	var gameOver:FlxText = new FlxText(0,0,0,"GAME OVER",128);

	var stageSuffix:String = "";
	
	public var lmao:FlxText = new FlxText(0,600,0,"Cause of Death: ",32);


	public function new(x:Float, y:Float, ?reason:String = 'Unknown')
	{
		var daStage = PlayState.curStage;
		FlxG.camera.zoom = 1;
		var daBf:String = '';
		switch (daStage)
		{
			case 'school':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'schoolEvil':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'suffer':
				daBf = 'bf';
			default:
				daBf = 'bf';
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);
		bf.visible = false;



		

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);
		
		
		
		lmao.scrollFactor.set();
		lmao.screenCenter(FlxAxes.X);
		lmao.text += reason;
		new FlxTimer().start(1, function(e:FlxTimer){
			add(lmao);
		});
		
		gameOver.scrollFactor.set();
		gameOver.color = FlxColor.RED;
		gameOver.screenCenter();
		new FlxTimer().start(1, function(e:FlxTimer){
			FlxG.camera.flash(FlxColor.BLACK,0.5);
			add(gameOver);
		});

		FlxG.sound.play(Paths.sound('death'));

		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}
	var shownBefore = false;
	override function update(elapsed:Float)
	{
		var response:String = ", you're hopeless. That attempt was PITIFUL.";

		lmao.screenCenter(X);

		
		//var name:String = Sys.environment()['USERNAME'];


		if(PlayState.SONG.song == "High-Stakes")
		{
			if(PlayState.obsOpen)
				response = ", you seriously failed that? I wasn't even fucking trying! Oh, and you RECORDED that? You must have so little to hang onto if you're recording this abysmal gameplay!";
			else
				response = ", you seriously failed that? I wasn't even fucking trying!";

		} else {
			if(PlayState.obsOpen)
				response = ", I can\'t believe you RECORD your abysmal skills!";
		}
		if(!shownBefore)
		{
			shownBefore = true;
		//	Sys.command('mshta vbscript:Execute("msgbox ""' + name + response +' - Corrupt"":close")');

		}
		
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new MainMenuState());
			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}

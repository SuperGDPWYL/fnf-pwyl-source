package;

import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class OptionCatagory
{
	private var _options:Array<Option> = new Array<Option>();
	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	
	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Category";
	public final function getName() {
		return _name;
	}

	public function new (catName:String, options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
	}
	private var description:String = "";
	private var display:String;
	public final function getDisplay():String
	{
		return display;
	}

	public final function getDescription():String
	{
		return description;
	}

	// Returns whether the label is to be updated.
	public function press():Bool { return throw "stub!"; }
	private function updateDisplay():String { return throw "stub!"; }
}

class DFJKOption extends Option
{
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
	}

	public override function press():Bool
	{
		FlxG.save.data.dfjk = !FlxG.save.data.dfjk;
		
		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.dfjk ? "DFJK" : "WASD" ;
	}
}

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.downscroll ? "Downscroll" : "Upscroll";
	}
}

class CutsceneOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.alwaysShowCutscenes = !FlxG.save.data.alwaysShowCutscenes;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.alwaysShowCutscenes ? "Always Show Cutscenes" : "Story Mode Cutscenes";
	}
}

class SkinSelection extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		display = updateDisplay();
		FlxG.switchState(new SkinSelector());
		return true;
	}

	private override function updateDisplay():String
	{
		return "Skin Selector";
	}
}

class DiscordServer extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		display = updateDisplay();
		FlxG.openURL('https://discord.gg/bF39mfZFrH');
		return true;
	}

	private override function updateDisplay():String
	{
		return "Discord Server";
	}
}

class SpikesOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.illegitamite = !FlxG.save.data.illegitamite;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.illegitamite ? "Health Spikes Disabled" : "Health Spikes Enabled";
	}
}

class Corrupted extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.corrupted = !FlxG.save.data.corrupted;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.corrupted ? "CORRUPTED" : "Regular";
	}
}

class NoModcharts extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.noModcharts = !FlxG.save.data.noModcharts;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.noModcharts ? "Modcharts Disabled" : "Modcharts Enabled";
	}
}

class Immortality extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.immortal = !FlxG.save.data.immortal;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.immortal ? "Immortality Enabled" : "Immortality Disabled";
	}
}

class NoURLS extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.dontOpenURLs = !FlxG.save.data.dontOpenURLs;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.dontOpenURLs ? "Don't Open URLs" : "Open URLs";
	}
}

class AccuracyOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Accuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on");
	}
}

class SongPositionOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Song Position " + (!FlxG.save.data.songPosition ? "off" : "on");
	}
}

class EtternaModeOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		FlxG.save.data.etternaMode = !FlxG.save.data.etternaMode;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Etterna Mode " + (!FlxG.save.data.etternaMode ? "off" : "on");
	}
}

class VanillaInputs extends Option
{
	public function new(desc:String)
		{
			super();
			description = desc;
		}
	
		public override function press():Bool
		{
			FlxG.save.data.vanillaInput = !FlxG.save.data.vanillaInput;
			display = updateDisplay();
			return true;
		}
	
		private override function updateDisplay():String
		{
			return FlxG.save.data.vanillaInput ? "Troll Inputs" : "Kade Engine Inputs";
		}
}

class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fps = !FlxG.save.data.fps;
		(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter " + (!FlxG.save.data.fps ? "off" : "on");
	}
}

class FPSCapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "FPS Cap";
	}
}


class ScrollSpeedOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "Scroll Speed";
	}
}


class RainbowFPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fpsRain = !FlxG.save.data.fpsRain;
		(cast (Lib.current.getChildAt(0), Main)).changeFPSColor(FlxColor.WHITE);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Rainbow " + (!FlxG.save.data.fpsRain ? "off" : "on");
	}
}

class NPSDisplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.npsDisplay = !FlxG.save.data.npsDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "NPS Display " + (!FlxG.save.data.npsDisplay ? "off" : "on");
	}
}

class ReplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new LoadReplayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Load replays";
	}
}

class CustomizeGameplay extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new GameplayCustomizeState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Customize Gameplay";
	}
}

class OffsetMenu extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		var poop:String = Highscore.formatSong("Tutorial", 1);

		PlayState.SONG = Song.loadFromJson(poop, "Tutorial");
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = 0;
		PlayState.storyWeek = 0;
		PlayState.offsetTesting = true;
		trace('CUR WEEK' + PlayState.storyWeek);
		LoadingState.loadAndSwitchState(new PlayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Time your offset";
	}
}







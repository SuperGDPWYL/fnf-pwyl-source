package;

import flixel.FlxSprite;
import flixel.FlxG;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		var skinIconArray:Array<Array<Array<Int>>> = [[[24, 25, 36], [32,33,37], [38,38,38], [30,31,30]],[[39,40,43],[39,40,43],[41,42,44],[45,46,47]]]; //e
		
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1, 0], 0, false, isPlayer);
		animation.add('bf-car', [0, 1, 0], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1, 0], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 21, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3], 0, false, isPlayer);
		animation.add('pico', [4, 5], 0, false, isPlayer);
		animation.add('mom', [6, 7], 0, false, isPlayer);
		animation.add('mom-car', [6, 7], 0, false, isPlayer);
		animation.add('tankman', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11, 10], 0, false, isPlayer);
		animation.add('dad', [12, 13], 0, false, isPlayer);
		animation.add('senpai', [22, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
		animation.add('spirit', [23, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('parents-christmas', [17], 0, false, isPlayer);
		animation.add('monster', [19, 20], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
		animation.add('corrupt', skinIconArray[FlxG.save.data.skinID][0], 0, false, isPlayer);
		animation.add('corruptsib', skinIconArray[FlxG.save.data.skinID][1], 0, false, isPlayer);
		animation.add('prototype', skinIconArray[FlxG.save.data.skinID][2], 0, false, isPlayer);
		animation.add('corruptglowkion', [24, 25, 36], 0, false, isPlayer);
		animation.add('corruptglowkionpissed', [32,33, 37], 0, false, isPlayer);
		animation.add('corruptgamerman', [39,40,39], 0, false, isPlayer);
		animation.add('corruptgamermanpissed', [39,40,39], 0, false, isPlayer);
		animation.add('oldCorrupt', [24, 25, 36], 0, false, isPlayer);
		animation.add('fireice-with-bf', [26, 27, 26], 0, false, isPlayer);
		animation.add('fireice', [29,29,29], 0, false, isPlayer);
		animation.add('fireice-demigod', [28,28,28], 0, false, isPlayer);
		animation.add('rtx', [50,51,50], 0, false, isPlayer);
		animation.add('fused', skinIconArray[FlxG.save.data.skinID][3], 0, false, isPlayer);
		animation.add('coolguy', [34,35,34], 0, false, isPlayer);
		animation.add('yakob', [48,48,48]);
		animation.play(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}

package;

import flixel.math.FlxPoint;
import flixel.addons.display.shapes.FlxShapeArrow;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;

class SkinSelector extends FlxState
{
	var wasPressed:Bool = false;
	var selectText:FlxText = new FlxText();
    var currentPhase:FlxText = new FlxText();
	var glowkion:FlxText = new FlxText();
	var gameworld:FlxText = new FlxText();
	var test:FlxText = new FlxText();
	var marker:FlxShapeArrow;

	var available:Array<FlxText> = [];
	var selected:Int = 0;

    var gamePreview:FlxSprite;
    var glowPreview:FlxSprite;

    var skinPreview:Character;
    
    var selectedSkin = FlxG.save.data.skinID;

    var skinAlternations = ["corrupt", "corruptsib", "prototype"];
    var phases = ["Normal", "Pissed (Bloodbath onwards)", "Prototype (Retribution)"];

    var currentVersion = 0;
	override function create()
	{
		super.create();

		marker = new FlxShapeArrow(0, 0, FlxPoint.weak(0, 0), FlxPoint.weak(0, 1), 24, {color: FlxColor.WHITE});

		selectText.setFormat(null, 18, FlxColor.WHITE, FlxTextAlign.CENTER);
		selectText.text = "Select your preferred Corrupt skin.\nPress SHIFT to switch between phases\nENTER to select, ESCAPE to save & exit\nIf the image doesn't reload, exit and re-enter";
		selectText.y = 5;
		selectText.screenCenter(X);

		glowkion.setFormat(null, 24, FlxColor.WHITE, FlxTextAlign.CENTER);
		glowkion.text = "Glowkion's Skin";
		glowkion.screenCenter(Y);
		glowkion.x = FlxG.width / 4 - glowkion.width / 2;

        glowPreview = new FlxSprite(glowkion.x,0).loadGraphic(Paths.image('skins/0/port/CorruptPortrait', 'shared'));
        glowPreview.setGraphicSize(Std.int(glowPreview.width * 0.4));
        glowPreview.updateHitbox();
        glowPreview.screenCenter(Y);
        glowPreview.y -= 150;
        
        


		gameworld.setFormat(null, 24, FlxColor.WHITE, FlxTextAlign.CENTER);
		gameworld.text = "GameWorld's Skin";
		gameworld.screenCenter(Y);
		gameworld.x = FlxG.width * 0.75 - gameworld.width / 2;

        gamePreview = new FlxSprite(gameworld.x,0).loadGraphic(Paths.image('skins/1/port/CorruptPortrait', 'shared'));
        gamePreview.setGraphicSize(Std.int(gamePreview.width * 0.7));
        gamePreview.updateHitbox();
        gamePreview.screenCenter(Y);
        gamePreview.y -= 150;

        skinPreview = new Character(0,gamePreview.y+75,'corrupt', false, FlxG.save.data.skinID);
        skinPreview.screenCenter();
        skinPreview.y += 100;
        if(FlxG.save.data.skinID == 0 && currentVersion != 2)
            skinPreview.setGraphicSize(Std.int(skinPreview.width * 0.25));
        else
            skinPreview.setGraphicSize(Std.int(skinPreview.width * 0.5));
     //   skinPreview.playAnim('idle');

        currentPhase.setFormat(null, 24, FlxColor.WHITE, CENTER);
        currentPhase.text = "Current Phase: " + phases[currentVersion];
        currentPhase.y = (FlxG.height-currentPhase.height) - 20;
        currentPhase.screenCenter(X);
        

        
        

		available.push(glowkion);
		available.push(gameworld);
	//	available.push(test);

        add(glowPreview);
        add(gamePreview);

        add(selectText);
        add(glowkion);
        add(gameworld);
		//add(test);
        add(marker);

        add(skinPreview);

        add(currentPhase);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && !wasPressed)
		{
			wasPressed = true;
			FlxG.save.data.skinID = selected;
            remove(skinPreview);
            FlxG.save.data.skinID = selected;
            skinPreview = new Character(0,gamePreview.y+75, skinAlternations[currentVersion], false, selected);
            selectedSkin = selected;
            skinPreview.screenCenter();
            if(selected == 0 && currentVersion != 2)
                skinPreview.setGraphicSize(Std.int(skinPreview.width * 0.25));
            else
                skinPreview.setGraphicSize(Std.int(skinPreview.width * 0.5));
            skinPreview.y += 100;
            add(skinPreview);
            FlxG.switchState(new MainMenuState());
		}

        if(FlxG.keys.justPressed.SHIFT)
        {
            changeAlteration();
        }

		if (FlxG.keys.justPressed.LEFT)
		{
			changeSelection(-1);
		}

		if (FlxG.keys.justPressed.RIGHT)
		{
			changeSelection(1);
		}
        if(FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(new MainMenuState());

		marker.x = available[selected].x + available[selected].width / 2 - marker.width / 2;
		marker.y = available[selected].y - marker.height - 5;
	}

	function changeSelection(direction:Int = 0)
	{

		selected = selected + direction;
		if (selected < 0)
			selected = available.length - 1;
		else if (selected >= available.length)
			selected = 0;

        
	}

    function changeAlteration()
    {
        currentVersion++;
        if(currentVersion >= skinAlternations.length)
            currentVersion = 0;


        remove(skinPreview);
        skinPreview = new Character(0,gamePreview.y+75, skinAlternations[currentVersion], false, selectedSkin);
        skinPreview.screenCenter();
        skinPreview.y += 100;
        if(FlxG.save.data.skinID == 0 && currentVersion != 2)
            skinPreview.setGraphicSize(Std.int(skinPreview.width * 0.25));
        else
            skinPreview.setGraphicSize(Std.int(skinPreview.width * 0.5));
        add(skinPreview);

        currentPhase.text = "Current Phase: " + phases[currentVersion];
        currentPhase.screenCenter(X);
    }
}

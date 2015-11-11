package game;

import flixel.FlxSprite;
import flixel.FlxG;

class Player extends FlxSprite
{

	public function new()
	{
		super();

		maxVelocity.set(800, 800);
		acceleration.y = maxVelocity.y * 8;
		drag.x = maxVelocity.x * 4;
		
		makeGraphic(30, 30, 0xFF000055);
	}

	override public function update(elapsed:Float):Void
	{
		var left:Bool = false;
		var right:Bool = false;
		var up:Bool = false;
		var down:Bool = false;
		var jump:Bool = false;
		{ // Update keys
			if (FlxG.keys.pressed.LEFT) left = true;
			if (FlxG.keys.pressed.RIGHT) right = true;
			if (FlxG.keys.pressed.UP) up = true;
			if (FlxG.keys.pressed.DOWN) down = true;
			if (FlxG.keys.pressed.SPACE) jump = true;
		}
		super.update(elapsed);
	}
}

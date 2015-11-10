package game;

import flixel.FlxSprite;

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
		super.update(elapsed);
	}
}

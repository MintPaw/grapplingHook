package game;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.math.FlxAngle;

class Player extends FlxSprite
{
	private static inline var ACC_FACTOR:Int = 8;
	private static inline var JUMP_FACTOR:Float = 0.75;
	private static inline var GRAVITY_FACTOR:Float = 2;
	private static inline var MAX_SPEED:Float = 400;
	private static inline var MAX_FALL:Float = 600;

	public var angle_facing:Float = 0;

	public function new()
	{
		super();

		maxVelocity.set(MAX_SPEED, MAX_FALL);
		acceleration.y = maxVelocity.y * GRAVITY_FACTOR;
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

		{ // Update inputs
			if (FlxG.keys.pressed.LEFT) left = true;
			if (FlxG.keys.pressed.RIGHT) right = true;
			if (FlxG.keys.pressed.UP) up = true;
			if (FlxG.keys.pressed.DOWN) down = true;
			if (FlxG.keys.pressed.SPACE) jump = true;

			angle_facing = FlxAngle.angleBetweenMouse(this, false);
		}

		acceleration.x = 0;
		if (left) acceleration.x -= maxVelocity.x * ACC_FACTOR;
		if (right) acceleration.x += maxVelocity.x * ACC_FACTOR;
		if (jump && isTouching(FlxObject.DOWN))
			velocity.y -= maxVelocity.y * JUMP_FACTOR;
		super.update(elapsed);
	}
}

package game;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.math.FlxAngle;
import flixel.math.FlxVelocity;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
	private static inline var ACC_FACTOR:Int = 8;
	private static inline var JUMP_FACTOR:Float = 0.75;
	private static inline var GRAVITY_FACTOR:Float = 2;
	private static inline var MAX_SPEED:Float = 400;
	private static inline var MAX_FALL:Float = 600;
	private static inline var HOOK_SPEED:Float = 400;
	
	public var hookCallback:Dynamic;

	public var angleFacing:Float = 0;
	public var hookTo:FlxVector = new FlxVector();
	public var hookDistance:Float = 0;
	public var hookDirection:FlxVector = new FlxVector();
	
	public var movementAcc:FlxPoint = new FlxPoint();
	public var hookVelo:FlxPoint = new FlxPoint();

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
		var hook:Bool = false;

		{ // Update inputs
			if (FlxG.keys.pressed.LEFT) left = true;
			if (FlxG.keys.pressed.RIGHT) right = true;
			if (FlxG.keys.pressed.UP) up = true;
			if (FlxG.keys.pressed.DOWN) down = true;
			if (FlxG.keys.pressed.SPACE) jump = true;
			if (FlxG.mouse.justPressed) hook = true;

			angleFacing = FlxAngle.angleBetweenMouse(this, false);
		}

		{ // Update input logic
			if (jump && !isTouching(FlxObject.DOWN)) jump = false;
			if (hook && hookDistance != 0) hook = false;
		}

		{ // Update movement
			acceleration.x = 0;
			if (left) acceleration.x -= maxVelocity.x * ACC_FACTOR;
			if (right) acceleration.x += maxVelocity.x * ACC_FACTOR;
			if (jump)	velocity.y -= maxVelocity.y * JUMP_FACTOR;
			if (hook) {
				var tempHookTo:FlxPoint = hookCallback(getMidpoint(), angleFacing);
				if (tempHookTo != null) {
					hookTo.x = tempHookTo.x;
					hookTo.y = tempHookTo.y;
					hookDistance = hookTo.distanceTo(getMidpoint());
					hookDirection.copyFrom(hookTo);
					hookDirection.subtractPoint(getMidpoint());
					hookDirection.normalize();
				}
			}
		}

		{ // Update hooking
			if (hookDistance > 0) {
				// velocity.x = hookDirection.x * HOOK_SPEED;
				// velocity.y = hookDirection.y * HOOK_SPEED;
			}
		}

		{ // Update physics

		}

		super.update(elapsed);
	}
}

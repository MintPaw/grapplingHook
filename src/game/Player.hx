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
	private static inline var CLIMB_SPEED:Float = 3;

	public static inline var IDLE:Int = 0;
	public static inline var WALKING:Int = 1;
	public static inline var HOOKING:Int = 2;
	public static inline var HANGING:Int = 3;
	
	public var hookCallback:Dynamic;
	public var hittingMap:Bool = false;

	public var angleFacing:Float = 0;
	public var angVelo:Float = 0;
	public var hookPoint:FlxPoint = new FlxPoint();
	public var hookTo:FlxVector = new FlxVector();
	public var swingVelo:FlxVector = new FlxVector();

	public var state:Int = IDLE;

	public function new()
	{
		super();

		maxVelocity.set(MAX_SPEED, MAX_FALL);
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
			if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A) left = true;
			if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D) right = true;
			if (FlxG.keys.pressed.UP || FlxG.keys.pressed.W) up = true;
			if (FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S) down = true;
			if (FlxG.keys.justPressed.SPACE) jump = true;
			if (FlxG.mouse.justPressed) hook = true;

			angleFacing = FlxAngle.angleBetweenMouse(this, false);
		}

		{ // Update grappling
			function pullHook(dir:Int):Void {
				var pullVelo:FlxVector = FlxVector.get();
				pullVelo.copyFrom(hookTo);
				pullVelo.subtractPoint(hookPoint);
				pullVelo.normalize();
				pullVelo.scale(CLIMB_SPEED * dir);
				hookPoint.x += pullVelo.x;
				hookPoint.y += pullVelo.y;
				pullVelo.put();
			}

			if (state == HOOKING) {
				pullHook(5);
				if (jump) switchState(HANGING);

			} else if (state == HANGING) {
				if (up && !isTouching(FlxObject.UP)) pullHook(1);
				if (down && !isTouching(FlxObject.DOWN)) pullHook(-1);
				if (left) angVelo += .1;
				if (right) angVelo -= .1;

				var angleBetween:Float = 
					Math.atan2(hookTo.y - hookPoint.y, hookTo.x - hookPoint.x);

				angVelo += -0.5 * Math.cos(angleBetween);
				angVelo *= .95;
				angVelo = Math.min(3, Math.max(-3, angVelo));
				hookPoint.rotate(hookTo, angVelo);
				//Reg.drawPoint(hookPoint.x, hookPoint.y, 0xFFFF0000);

				if (jump) switchState(IDLE);
			}

			if (state == HOOKING || state == HANGING) {
				FlxVelocity.moveTowardsPoint(this, hookPoint, 0, 16);
				swingVelo.copyFrom(velocity);
				if (hittingMap)	switchState(IDLE);
			}

		}

		{ // Update ground movement
			if (state == IDLE || state == WALKING) {
				if (swingVelo.y != 0) {
					velocity.y = swingVelo.y;
					swingVelo.y = 0;
				}
				if (swingVelo.x != 0) {
					velocity.x = swingVelo.x;
					if (hittingMap) swingVelo.set();
				}
				acceleration.y = maxVelocity.y * GRAVITY_FACTOR;
				var speed:Float = maxVelocity.x * ACC_FACTOR;
				if (isTouching(FlxObject.DOWN)) acceleration.x = 0 else speed = 0;

				if (left) acceleration.x -= speed;
				if (right) acceleration.x += speed;
				if (jump && isTouching(FlxObject.DOWN))
					velocity.y -= maxVelocity.y * JUMP_FACTOR;
				if (hook) {
					var tempHookTo:FlxPoint = hookCallback(getMidpoint(), angleFacing);
					if (tempHookTo != null) {
						hookTo.x = tempHookTo.x;
						hookTo.y = tempHookTo.y;
						hookPoint.copyFrom(getMidpoint());
						switchState(HOOKING);
					}
				}
			}
		}

		super.update(elapsed);
	}

	private function switchState(newState:Int):Void
	{
		if (state == IDLE) {
			// Leave IDLE
		} else if (state == WALKING) {
			// Leave WALKING
		} else if (state == HOOKING) {
			// Leave HOOKING
		} else if (state == HANGING) {
			// Leave HANGING
		}

		state = newState;

		if (state == IDLE) {
			// Enter IDLE
		} else if (state == WALKING) {
			// Enter WALKING
		} else if (state == HOOKING) {
			// Enter HOOKING
			velocity.set();
			acceleration.set();
		} else if (state == HANGING) {
			// Enter HANGING
			velocity.set();
			acceleration.set();
		}
	}
}

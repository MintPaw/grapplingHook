package game;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.math.FlxAngle;
import flixel.math.FlxVelocity;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.graphics.frames.FlxAtlasFrames;

class Player extends FlxSprite
{
	private var _needToTakePhoto:Bool = false;

	// Const
	private static inline var ACC_FACTOR:Int = 8;
	private static inline var JUMP_FACTOR:Float = 0.75;
	private static inline var GRAVITY_FACTOR:Float = 2;
	private static inline var MAX_SPEED:Float = 400;
	private static inline var MAX_FALL:Float = 600;
	private static inline var HOOK_SPEED:Float = 400;
	private static inline var CLIMB_SPEED:Float = 3;
	private static inline var WALL_JUMP_SPEED:Float = 400;
	private static inline var WALL_FALL_SPEED:Float = 50;
	private static inline var WALL_JUMP_HEIGHT:Float = 100;

	// States
	public static inline var IDLE:Int = 0;
	public static inline var WALKING:Int = 1;
	public static inline var HOOKING:Int = 2;
	public static inline var HANGING:Int = 3;
	public static inline var WALLING:Int = 4;
	public static inline var ATTACKING:Int = 5;
	public var state:Int = IDLE;
	
	// For parent
	public var hookCallback:Dynamic;
	public var takePhotoCallback:Dynamic;
	public var hittingMap:Bool = false;
	public var hookOrb:FlxSprite;

	// Hook
	public var angVelo:Float = 0;
	public var hookPoint:FlxPoint = new FlxPoint();
	public var hookTo:FlxVector = new FlxVector();
	public var swingVelo:FlxVector = new FlxVector();

	// Input
	public var freezeInput:Bool = false;
	public var wep1:Bool = false;
	public var wep2:Bool = false;
	public var left:Bool = false;
	public var right:Bool = false;
	public var up:Bool = false;
	public var down:Bool = false;
	public var justLeft:Bool = false;
	public var justRight:Bool = false;
	public var justUp:Bool = false;
	public var justDown:Bool = false;
	public var jump:Bool = false;
	public var hook:Bool = false;
	public var attack:Bool = false;
	public var angleFacing:Float = 0;

	// Walling
	public var wallOn:Int = FlxObject.NONE;

	public function new()
	{
		super();

		maxVelocity.set(MAX_SPEED, MAX_FALL);
		drag.x = maxVelocity.x * 4;
		
		hookOrb = new FlxSprite();
		hookOrb.visible = false;

		Reg.setAtlas(this, "assets/img/player");
		Reg.doubleSize(this);

		animation.addByPrefix("idle", "hero_idle", 10);
		animation.addByPrefix("running", "hero_run", 10);

		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
	}

	override public function update(elapsed:Float):Void
	{
		wep1 = wep2 = left = right = up = down = jump = hook = justLeft =
			justRight = justUp = justDown = attack = false;

		{ // Update inputs
			if (!freezeInput) {
				if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A) left = true;
				if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D) right = true;
				if (FlxG.keys.pressed.UP || FlxG.keys.pressed.W) up = true;
				if (FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S) down = true;

				if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A)
					justLeft = true;
				if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D)
					justRight = true;
				if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W)
					justUp = true;
				if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S)
					justDown = true;

				if (FlxG.keys.pressed.ONE) wep1 = true;
				if (FlxG.keys.pressed.TWO) wep2 = true;
				if (FlxG.keys.justPressed.SPACE) jump = true;
				if (FlxG.keys.pressed.J) hook = true;
				if (FlxG.keys.pressed.K) attack = true;
			}

			var dirPoint:FlxPoint = FlxPoint.get();
			if (left) dirPoint.x -= 1;
			if (right) dirPoint.x += 1;
			if (up) dirPoint.y -= 1;
			if (down) dirPoint.y += 1;

			if (dirPoint.x == 1 && dirPoint.y == 0) angleFacing = 0;
			else if (dirPoint.x == 1 && dirPoint.y == -1) angleFacing = Math.PI/4;
			else if (dirPoint.x == 0 && dirPoint.y == -1) angleFacing = Math.PI/2;
			else if (dirPoint.x == -1 && dirPoint.y == -1) angleFacing = 3*Math.PI/4;
			else if (dirPoint.x == -1 && dirPoint.y == 0) angleFacing = Math.PI;
			else if (dirPoint.x == -1 && dirPoint.y == 1) angleFacing = 5*Math.PI/4;
			else if (dirPoint.x == 0 && dirPoint.y == 1) angleFacing = 3*Math.PI/2;
			else if (dirPoint.x == 1 && dirPoint.y == 1) angleFacing = 7*Math.PI/4;
			angleFacing = -angleFacing;
		}

		{ // Update weapon
		}

		{ // Update grappling
			// Pull funciton
			function pullHook(dir:Int):Void
			{
				var pullVelo:FlxVector = FlxVector.get();
				pullVelo.copyFrom(hookTo);
				pullVelo.subtractPoint(hookPoint);
				pullVelo.normalize();
				pullVelo.scale(CLIMB_SPEED * dir);
				hookPoint.x += pullVelo.x;
				hookPoint.y += pullVelo.y;
				pullVelo.put();
			}

			// Hooking
			if (state == HOOKING)
			{
				pullHook(5);
				if (jump) switchState(HANGING);

			// Hanging
			}
			else if (state == HANGING)
			{
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

			// General hook logic
			if (state == HOOKING || state == HANGING)
			{
				FlxVelocity.moveTowardsPoint(this, hookPoint, 0, 16);
				swingVelo.copyFrom(velocity);
				if (isTouching(FlxObject.DOWN)) switchState(IDLE);
				if (isTouching(FlxObject.UP)) switchState(HANGING);
			}

		}

		{ // Update ground movement
			if (state == IDLE || state == WALKING)
			{
				// Conserve swinging
				if (swingVelo.y != 0)
				{
					velocity.y = swingVelo.y;
					swingVelo.y = 0;
				}
				if (swingVelo.x != 0)
				{
					velocity.x = swingVelo.x;
					if (hittingMap) swingVelo.set();
				}

				// Gravity and air movement
				acceleration.y = maxVelocity.y * GRAVITY_FACTOR;
				var speed:Float = maxVelocity.x * ACC_FACTOR;
				if (isTouching(FlxObject.DOWN)) acceleration.x = 0 else speed = 0;

				// Basic movement
				if (left)
				{
					acceleration.x -= speed;
					facing = FlxObject.LEFT;
					switchState(WALKING);
				}
				else if (right)
				{
					acceleration.x += speed;
					facing = FlxObject.RIGHT;
					switchState(WALKING);
				} else {
					switchState(IDLE);
				}
				if (jump && isTouching(FlxObject.DOWN))
					velocity.y -= maxVelocity.y * JUMP_FACTOR;

				// Hooking
				if (hook)
				{
					var tempHookTo:FlxPoint = hookCallback(getMidpoint(), angleFacing);
					if (tempHookTo != null) {
						hookTo.x = tempHookTo.x;
						hookTo.y = tempHookTo.y;
						hookPoint.copyFrom(getMidpoint());
						switchState(HOOKING);
					}
				}

				// Attacking
				if (attack)
				{
					switchState(ATTACKING);
				}
			}
		}

		{ // Update walling
			if (isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT)
					&& !isTouching(FlxObject.DOWN))
				switchState(WALLING);

			if (state == WALLING)
			{
				var wallOnScale:Int = 0;
				if (wallOn == FlxObject.LEFT) wallOnScale = 1;
				if (wallOn == FlxObject.RIGHT) wallOnScale = -1;

				if (jump)
				{
					swingVelo.y = -WALL_JUMP_HEIGHT;
					swingVelo.x = WALL_JUMP_SPEED * wallOnScale;
					switchState(IDLE);
				}

				if ((wallOn == FlxObject.LEFT && right)
						|| (wallOn == FlxObject.RIGHT && left))
				{
					swingVelo.y = -WALL_JUMP_HEIGHT;
					swingVelo.x = WALL_FALL_SPEED * wallOnScale;
					switchState(IDLE);
				}
			}
		}

		super.update(elapsed);
	}

	private function switchState(newState:Int):Void
	{
		// Leaving
		if (state == IDLE)
		{
		}
		else if (state == WALKING)
		{
		}
		else if (state == HOOKING)
		{
			if (newState != HANGING) hookOrb.visible = false;
		}
		else if (state == HANGING)
		{
			hookOrb.visible = false;
		}
		else if (state == WALLING)
		{
			wallOn = FlxObject.NONE;
		}
		else if (state == ATTACKING)
		{
		}
		state = newState;

		// Entering
		if (state == IDLE)
		{
			animation.play("idle");
		}
		else if (state == WALKING)
		{
			animation.play("running");
		}
		else if (state == HOOKING)
		{
			hookOrb.x = hookTo.x - hookOrb.width / 2;
			hookOrb.y = hookTo.y - hookOrb.height / 2;
			hookOrb.visible = true;
			velocity.set();
			acceleration.set();
		}
		else if (state == HANGING)
		{
			velocity.set();
			acceleration.set();
		}
		else if (state == WALLING)
		{
			if (isTouching(FlxObject.LEFT)) wallOn = FlxObject.LEFT;
			if (isTouching(FlxObject.RIGHT)) wallOn = FlxObject.RIGHT;
			velocity.set();
			acceleration.set();
			swingVelo.set();
		}
		else if (state == ATTACKING)
		{
			animation.play("attack1");
		}
	}
}

package game;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.graphics.frames.FlxAtlasFrames;

class Enemy extends FlxSprite
{
	public var type:String;

	public static inline var WALKING:Int = 1;

	public static var WALK_SPEED:Int = 500;

	public var state:Int;

	public function new(type:String)
	{
		super();
		this.type = type;
		
		if (type == "test") makeGraphic(10, 10, 0xFF444400);
		else
		{
			var fileName:String = "assets/img/enemies/" + type + "/" + type;
				frames = FlxAtlasFrames.fromTexturePackerJson(
				fileName + ".png",
				fileName + ".json");

			animation.addByPrefix("walking", "walking");
		}

		if (type == "testEnemy")
		{
			switchState(WALKING);
		}

		maxVelocity.set(WALK_SPEED / 5, 600);
		drag.x = maxVelocity.x * 4;
		acceleration.y = maxVelocity.y * 2;
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
	}

	override public function update(elapsed:Float):Void
	{
		if (type == "testEnemy")
		{
			if (state == WALKING)
			{
				acceleration.x = facing == FlxObject.LEFT ? -WALK_SPEED : WALK_SPEED;
			}
		}

		super.update(elapsed);
	}

	private function switchState(s:Int):Void
	{
		// Exiting
		if (state == WALKING)
		{
			acceleration.x = 0;
		}

		state = s;

		// Entering
		if (state == WALKING)
		{
			facing = FlxObject.LEFT;
			animation.play("walking");
		}
	}

	public function blocked(dir:Int):Void
	{
		if (state == WALKING)
		{
			facing = facing == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT;
		}
	}
}

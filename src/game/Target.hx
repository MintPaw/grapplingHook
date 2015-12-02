package game;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Target extends FlxSprite
{
	public static var G_STANDING_TO_WALK:Int = 1;
	public static var G_STANDING_TO_EAT:Int = 2;
	public static var G_WALKING:Int = 3;
	public static var G_EATING:Int = 4;

	public var type:String;
	public var aiType:String;

	// Graze vars
	public static var WALK_DISTANCE:Array<Int> = [100, 200];
	public static var EAT_TIME:Array<Int> = [3000, 5000];
	public static var STAND_TIME:Array<Int> = [1000, 2000];
	public static var WALK_SPEED:Int = 500;
	public var timeTillWalk:Int;
	public var timeTillEat:Int;
	public var timeTillStand:Int;
	public var xToWalk:Int;

	public var state:Int;

	public function new(type:String)
	{
		super();
		this.type = type;

		maxVelocity.set(WALK_SPEED / 5, 600);
		drag.x = maxVelocity.x * 4;
		acceleration.y = maxVelocity.y * 2;
		
		if (type == "test") makeGraphic(10, 10, 0xFF444400);
		else
		{
			var fileName:String = "assets/img/animals/" + type + "/" + type;
				frames = FlxAtlasFrames.fromTexturePackerJson(
				fileName + ".png",
				fileName + ".json");

			animation.addByPrefix("standing", "standing");
			animation.addByPrefix("walking", "walking");
			animation.addByPrefix("eating", "eating");
			animation.play("standing");
		}

		if (type == "test") aiType = "none";
		if (type == "testAnimal")
		{
			aiType = "graze";
			switchState(G_STANDING_TO_WALK);
		}
	}

	override public function update(elapsed:Float):Void
	{
		if (aiType == "graze")
		{
			if (state == G_STANDING_TO_EAT)
			{
				timeTillEat -= Std.int(elapsed * 1000);
				if (timeTillEat <= 0) switchState(G_EATING);
			}
			else if (state == G_STANDING_TO_WALK)
			{
				timeTillWalk -= Std.int(elapsed * 1000);
				if (timeTillWalk <= 0) switchState(G_WALKING);
			}
			else if (state == G_WALKING)
			{
				acceleration.x = x - xToWalk < 0 ? WALK_SPEED : -WALK_SPEED;
				if (Math.abs(x - xToWalk) <= width/2) switchState(G_STANDING_TO_EAT);
			}
			else if (state == G_EATING)
			{
				timeTillWalk -= Std.int(elapsed * 1000);
				if (timeTillWalk <= 0) switchState(G_STANDING_TO_WALK);
			}
		}

		super.update(elapsed);
	}

	private function switchState(s:Int):Void
	{
		// Exiting
		if (state == G_STANDING_TO_WALK)
		{

		}
		else if (state == G_STANDING_TO_EAT)
		{

		}
		else if (state == G_WALKING)
		{
			acceleration.x = 0;
		}
		else if (state == G_EATING)
		{

		}

		state = s;

		// Entering
		if (state == G_STANDING_TO_WALK)
		{
			animation.play("standing");
			timeTillWalk = Reg.rnd.int(STAND_TIME[0], STAND_TIME[1]);
		}
		else if (state == G_STANDING_TO_EAT)
		{
			animation.play("standing");
			timeTillEat = Reg.rnd.int(STAND_TIME[0], STAND_TIME[1]);
		}
		else if (state == G_WALKING)
		{
			animation.play("walking");
			xToWalk =
				Std.int(x + (Reg.rnd.int(WALK_DISTANCE[0], WALK_DISTANCE[1]) *
				(Reg.rnd.int(0, 1) == 0 ? -1 : 1)));
		}
		else if (state == G_EATING)
		{
			animation.play("eating");
			timeTillWalk = Reg.rnd.int(EAT_TIME[0], EAT_TIME[1]);
		}
	}
}

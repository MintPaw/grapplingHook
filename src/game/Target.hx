package game;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Target extends FlxSprite
{
	public static var G_STANDING:Int = 1;
	public static var G_WALKING:Int = 2;
	public static var G_EATING:Int = 3;

	public var type:String;
	public var aiType:String;

	// Graze vars
	public static var WALK_DISTANCE:Array<Int> = [50, 150];
	public static var EAT_TIME:Array<Int> = [3000, 5000];
	public static var STAND_TIME:Array<Int> = [1000, 2000];
	public static var WALK_SPEED:Int = 500;
	public var timeTillStand:Int;
	public var timeTillGraze:Int;
	public var xToWalk:Int;

	public var state:Int;

	public function new(type:String)
	{
		super();
		this.type = type;

		maxVelocity.set(400, 600);
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
			switchState(G_STANDING);
		}
	}

	override public function update(elapsed:Float):Void
	{
		if (aiType == "graze")
		{
			if (state == G_STANDING)
			{
				timeTillGraze -= Std.int(elapsed) * 1000;
				if (timeTillGraze <= 0) switchState(G_WALKING);
			}
			else if (state == G_WALKING)
			{
				acceleration.x = x - xToWalk < 0 ? -WALK_SPEED : WALK_SPEED;
			}
		}

		super.update(elapsed);
	}

	private function switchState(s:Int):Void
	{
		// Exiting
		if (state == G_STANDING)
		{

		}
		else if (state == G_WALKING)
		{

		}
		else if (state == G_EATING)
		{

		}

		state = s;

		// Entering
		if (state == G_STANDING)
		{
			timeTillGraze = Reg.rnd.int(STAND_TIME[0], STAND_TIME[1]);
		}
		else if (state == G_WALKING)
		{
			xToWalk = Std.int(x + Reg.rnd.int(WALK_DISTANCE[0], WALK_DISTANCE[1]));
			xToWalk *= Reg.rnd.int() == 0 ? -1 : 1;
		}
		else if (state == G_EATING)
		{

		}
	}
}

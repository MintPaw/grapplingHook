package ;

import flixel.FlxState;
import flixel.FlxG;
import flixel.math.FlxRandom;
import game.GameState;

class MainState extends FlxState
{

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();
		Reg.loc = "test";
		Reg.rnd = new FlxRandom();
		FlxG.switchState(new GameState());
	}
}

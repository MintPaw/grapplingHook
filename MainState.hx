package ;

import flixel.FlxState;
import flixel.FlxG;
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
		Reg.prevLoc = "test";
		Reg.loc = "test2";
		FlxG.switchState(new GameState());
	}
}

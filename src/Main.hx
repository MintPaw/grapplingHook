package;

import openfl.display.Sprite;
import flixel.FlxGame;

class Main extends Sprite
{

	public function new()
	{
#if debug
		if (false) new debugger.HaxeRemote(true, "localhost");
#end
		super();

		var _flixel:FlxGame = new FlxGame(1280, 720, MainState, 1, 60, 60, true);
		addChild(_flixel);
	}
}

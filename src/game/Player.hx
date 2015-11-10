package game;

import flixel.FlxSprite;

class Player extends FlxSprite
{

	public function new()
	{
		super();
		
		makeGraphic(30, 30, 0xFF000055);
	}
}

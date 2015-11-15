package game;

import flixel.FlxSprite;

class Door extends FlxSprite
{
	public var loc:String;
	public var exitTo:String;

	public function new()
	{
		super();

		makeGraphic(32, 64, 0xFF550000);
	}
}

package game;

import flixel.FlxSprite;

class Target extends FlxSprite
{
	public var type:String;

	public function new(type:String)
	{
		super();
		this.type = type;
		
		if (type == "target") makeGraphic(10, 10, 0xFF444400);
	}
}
package game;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Target extends FlxSprite
{
	public var type:String;

	public function new(type:String)
	{
		super();
		this.type = type;
		
		if (type == "test") makeGraphic(10, 10, 0xFF444400);
		else
		{
			var fileName:String = "assets/img/animals/" + type + "/" + type;
			frames = FlxAtlasFrames.fromTexturePackerJson(
			fileName + ".png",
			fileName + ".json");
		}
	}
}

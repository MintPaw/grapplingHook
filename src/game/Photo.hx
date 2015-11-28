package game;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import openfl.display.BitmapData;

class Photo
{
	public var data:BitmapData;
	public var hitTarget:Bool = false;
	public var targetCentre:FlxPoint = new FlxPoint();

	public function new(d:BitmapData)
	{
		data = d;
	}

	public function getSprite():FlxSpriteGroup
	{
		var offset:FlxPoint = FlxPoint.get(20, 20);
		var sprite:FlxSpriteGroup = new FlxSpriteGroup();

		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(
				Std.int(data.width+offset.x),
				Std.int(data.height+offset.y),
				0xFFDDDDDD);

		var photo:FlxSprite = new FlxSprite(data);
		photo.x += offset.x / 2;
		photo.y += offset.y / 2;

		sprite.add(bg);
		sprite.add(photo);

		offset.put();
		return sprite;
	}
}

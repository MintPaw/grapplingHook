package game;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import openfl.display.BitmapData;

class Photo
{
	public var data:BitmapData;
	public var hitTarget:Bool = false;
	public var targetCentre:FlxPoint = new FlxPoint();
	public var centrePercent:Float;

	public function new()
	{

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

		var overlay:FlxSpriteGroup = new FlxSpriteGroup();
		{ // Overlay
			var drawings:FlxSprite = new FlxSprite();
			drawings.makeGraphic(Std.int(bg.width), Std.int(bg.height), 0);
			drawings.pixels.fillRect(drawings.pixels.rect, 0);
			overlay.add(drawings);

			if (hitTarget) {
				FlxSpriteUtil.drawCircle(
						drawings,
						targetCentre.x + offset.x / 2,
						targetCentre.y + offset.y / 2,
						40,
						0,
						{thickness: 2, color: 0xFFFF0000});

				var distText:FlxText = new FlxText(
						0,
						0,
						200,
						"",
						20);
				distText.text = '$centrePercent% off centre';
				distText.alignment = "right";
				distText.x = -distText.width - 5;
				overlay.add(distText);
			}
		}

		sprite.add(bg);
		sprite.add(photo);
		sprite.add(overlay);

		offset.put();
		return sprite;
	}
}

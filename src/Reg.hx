package ;

import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;

class Reg
{
	public static var canvas:FlxSprite;

	public function new() {}

	public static function drawLine(
			x1:Float, y1:Float, x2:Float, y2:Float, color:UInt)
	{
		FlxSpriteUtil.drawLine(canvas, x1, y1, x2, y2,
				{ thickness: 1, color: color });
	}

	public static function drawPoint(x:Float, y:Float, color:UInt)
	{
		FlxSpriteUtil.drawCircle(canvas, x, y, 3, color);
	}
}

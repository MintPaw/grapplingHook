package ;

import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import game.Photo;

class Reg
{
	public static var canvas:FlxSprite;
	public static var prevLoc:String = "test0";
	public static var loc:String = "none";
	public static var fader:FlxSprite;
	public static var photos:Array<Photo> = [];

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

package ;

import flixel.FlxSprite;
import flixel.math.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.Assets;

class Reg
{
	public static var canvas:FlxSprite;
	public static var prevLoc:String = "test0";
	public static var loc:String = "none";
	public static var fader:FlxSprite;
	public static var rnd:FlxRandom;

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

	public static function setAtlas(s:FlxSprite, t:String):Void
	{
		s.frames = FlxAtlasFrames.fromTexturePackerJson(
				t + ".png",
				Assets.getText(t + ".json"));
	}

	public static function doubleSize(s:FlxSprite):Void
	{
		s.scale.x *= 2;
		s.scale.y *= 2;
		s.width *= 2;
		s.height *= 2;
		s.centerOffsets(false);
	}
}

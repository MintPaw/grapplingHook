package ;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.NumTween;

class FlxMintNumTween extends NumTween
{
	public var ignoreTS:Bool = false;

	public function new(options:Dynamic):Void
	{
		super(options);
	}

	public static function t(
			start:Float,
			end:Float,
		 	time:Float,
			f:Float->Void,
		 	options:TweenOptions = null,
			ignoreTimeStep:Bool = false)
	{
		var tw:FlxMintNumTween = new FlxMintNumTween(options);
		tw.ignoreTS = ignoreTimeStep;
		tw.tween(start, end, time, f);
		return FlxTween.manager.add(tw);
	}

	override public function update(elapsed:Float):Void
	{
		if (ignoreTS) super.update(1/FlxG.updateFramerate)
		else super.update(elapsed);
		super.update(elapsed);
	}
}

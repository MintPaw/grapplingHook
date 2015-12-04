package game;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.plugin.screengrab.FlxScreenGrab;


class GameState extends FlxState
{
	private var _tilemap:FlxTilemapExt;
	private var _canvas:FlxSprite;
	private var _fader:FlxSprite;

	private var _player:Player;

	private var _doors:FlxTypedGroup<Door>;
	private var _targets:FlxTypedGroup<Target>;
	private var _aiBlocks:FlxTypedGroup<FlxSprite>;

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();

		var tileWidth:Int = 32;

		{ // Setup misc
			_fader = new FlxSprite();
			_fader.scrollFactor.set();
			_fader.makeGraphic(FlxG.width, FlxG.height, 0xFFFFFFFF);
			_fader.alpha = 0;
			Reg.fader = _fader;
		}

		{ // Setup tilemap
			var tiledMap:TiledMap = new TiledMap("assets/map/" + Reg.loc + ".tmx");
			_doors = new FlxTypedGroup<Door>();
			_targets = new FlxTypedGroup<Target>();
			_aiBlocks = new FlxTypedGroup<FlxSprite>();

			var floorLeft:Array<Int> = [59];
			var floorRight:Array<Int> = [60];
			var ceilLeft:Array<Int> = [55];
			var ceilRight:Array<Int> = [54];

			var floorLeftShallowBot:Array<Int> = [131];
			var floorLeftShallowTop:Array<Int> = [132];
			var floorRightShallowBot:Array<Int> = [130];
			var floorRightShallowTop:Array<Int> = [129];

			var floorLeftSteepBot:Array<Int> = [139];
			var floorLeftSteepTop:Array<Int> = [134];
			var floorRightSteepBot:Array<Int> = [138];
			var floorRightSteepTop:Array<Int> = [140];

			var ceilLeftSteepBot:Array<Int> = [115];
			var ceilLeftSteepTop:Array<Int> = [113];
			var ceilRightSteepBot:Array<Int> = [114];
			var ceilRightSteepTop:Array<Int> = [112];

			var ceilLeftShallowBot:Array<Int> = [108];
			var ceilLeftShallowTop:Array<Int> = [109];
			var ceilRightShallowBot:Array<Int> = [111];
			var ceilRightShallowTop:Array<Int> = [109];

			var clouds:Array<Int> = [4, 12, 20];

			for (layer in tiledMap.layers)
			{
				if (layer.type == TiledLayerType.OBJECT)
				{
					for (obj in cast(layer, TiledObjectLayer).objects)
					{
						if (obj.type == "door")
						{
							var d:Door = new Door();
							d.x = obj.x;
							d.y = obj.y;
							d.loc = obj.properties.get("loc");
							d.exitTo = obj.properties.get("exitTo");
							_doors.add(d);
						}
						else if (obj.type == "target")
						{
							var t:Target = new Target(obj.properties.get("targetType"));
							t.x = Math.round(obj.x * tileWidth) / tileWidth;
							t.y = Math.floor(obj.y * tileWidth) / tileWidth;
							t.x -= t.width / 2;
							t.y -= t.height;
							_targets.add(t);
						}
						else if (obj.type == "aiBlock")
						{
							var o:FlxSprite = new FlxSprite();
							o.facing = obj.properties.get("block") == "left"
								? FlxObject.LEFT : FlxObject.RIGHT;
							o.x = obj.x;
							o.y = obj.y;
							o.width = obj.width;
							o.height = obj.height;
							_aiBlocks.add(o);
						}
					}
				}
			}
			
			_tilemap = new FlxTilemapExt();

			_tilemap.loadMapFromCSV(
					cast(tiledMap.layers[0], TiledTileLayer).csvData,
					"assets/" + tiledMap.tilesetArray[0].imageSource.substr(3),
					32,
					32,
					null,
					1);

		var tempFL:Array<Int> = [];
		var tempFR:Array<Int> = [];
		var tempCL:Array<Int> = [];
		var tempCR:Array<Int> = [];
		var tempSteepThick:Array<Int> = [];
		var tempSteepThin:Array<Int> = [];
		var tempShallowThick:Array<Int> = [];
		var tempShallowThin:Array<Int> = [];

		tempFL = tempFL.concat(floorLeft);
		tempFL = tempFL.concat(floorLeftShallowTop);
		tempFL = tempFL.concat(floorLeftShallowBot);
		tempFL = tempFL.concat(floorLeftSteepTop);
		tempFL = tempFL.concat(floorLeftSteepBot);

		tempFR = tempFR.concat(floorRight);
		tempFR = tempFR.concat(floorRightShallowTop);
		tempFR = tempFR.concat(floorRightShallowBot);
		tempFR = tempFR.concat(floorRightSteepTop);
		tempFR = tempFR.concat(floorRightSteepBot);

		tempCL = tempCL.concat(ceilLeft);
		tempCL = tempCL.concat(ceilLeftShallowTop);
		tempCL = tempCL.concat(ceilLeftShallowBot);
		tempCL = tempCL.concat(ceilLeftSteepTop);
		tempCL = tempCL.concat(ceilLeftSteepBot);

		tempCR = tempCR.concat(ceilRight);
		tempCR = tempCR.concat(ceilRightShallowTop);
		tempCR = tempCR.concat(ceilRightShallowBot);
		tempCR = tempCR.concat(ceilRightSteepTop);
		tempCR = tempCR.concat(ceilRightSteepBot);

		tempSteepThick = tempSteepThick = tempSteepThick.concat(ceilLeftSteepBot);
		tempSteepThick = tempSteepThick = tempSteepThick.concat(ceilRightSteepBot);
		tempSteepThick = tempSteepThick.concat(floorLeftSteepBot);
		tempSteepThick = tempSteepThick.concat(floorRightSteepBot);

		tempShallowThick = tempShallowThick.concat(ceilLeftShallowTop);
		tempShallowThick = tempShallowThick.concat(ceilRightShallowTop);
		tempShallowThick = tempShallowThick.concat(floorLeftShallowTop);
		tempShallowThick = tempShallowThick.concat(floorRightShallowTop);

		tempSteepThin = tempSteepThin.concat(floorLeftSteepTop);
		tempSteepThin = tempSteepThin.concat(floorRightSteepTop);
		tempSteepThin = tempSteepThin.concat(ceilLeftSteepTop);
		tempSteepThin = tempSteepThin.concat(ceilRightSteepTop);

		tempShallowThin = tempShallowThin.concat(ceilLeftShallowBot);
		tempShallowThin = tempShallowThin.concat(ceilRightShallowBot);
		tempShallowThin = tempShallowThin.concat(floorLeftShallowBot);
		tempShallowThin = tempShallowThin.concat(floorRightShallowBot);

		_tilemap.setSlopes(tempFL, tempFR, tempCL, tempCR);
		_tilemap.setSteep(tempSteepThick, tempSteepThin);
		_tilemap.setGentle(tempShallowThick, tempShallowThin);
		}

		{ // Setup player
			_player = new Player();
			_player.hookCallback = hook;
			_player.takePhotoCallback = takePhoto;
			for (d in _doors)
			{
				if (d.loc == Reg.prevLoc)
				{
					_player.x = d.x;
					_player.y = d.y;
					if (d.exitTo == "left") _player.facing = FlxObject.LEFT;
					if (d.exitTo == "right") _player.facing = FlxObject.RIGHT;
				}
			}
		}

		{ // Setup camera
			FlxG.camera.antialiasing = true;
			FlxG.camera.fade(0xFF000000, 1, true, function() {
				_player.freezeInput = false;
			}, false);

			FlxG.camera.setScrollBoundsRect(
					0,
					0,
					Math.max(_tilemap.width - tileWidth, FlxG.width),
					Math.max(_tilemap.height, FlxG.height),
					true);

			FlxG.camera.follow(_player, FlxCameraFollowStyle.PLATFORMER);
		}

		{ // Setup canvas
			_canvas = new FlxSprite();
			_canvas.makeGraphic(
					Std.int(FlxG.worldBounds.width),
					Std.int(FlxG.worldBounds.height), 0);
			Reg.canvas = _canvas;
		}

		add(_tilemap);
		add(_doors);
		add(_player);
		add(_player.hookOrb);
		add(_targets);
		add(_fader);
		add(_player.shutter);
		add(_canvas);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		{ // Update collision
			_player.hittingMap = FlxG.collide(_player, _tilemap);

			FlxG.overlap(_doors, _player, doorVPlayer);
			FlxG.collide(_targets, _tilemap);
			FlxG.overlap(_targets, _aiBlocks, targetVAiBlock);
		}

		{ // Update drawing api
			_canvas.pixels.fillRect(_canvas.pixels.rect, 0);

			if (_player.state == Player.HOOKING || _player.state == Player.HANGING)
				Reg.drawLine(
						_player.hookPoint.x, 
						_player.hookPoint.y,
						_player.hookTo.x,
						_player.hookTo.y,
						0xFFFF0000);
		}
	}

	private function hook(loc:FlxPoint, a:Float):FlxPoint
	{
		var result:FlxPoint = new FlxPoint();
		var end:FlxPoint = new FlxPoint();

		end.x = loc.x + Math.cos(a)*2000;
		end.y = loc.y + Math.sin(a)*2000;
		var bad:Bool = _tilemap.ray(loc, end, result);

		if (bad) return null;
		return result;
	}

	private function takePhoto():Void
	{
		var p:Photo = new Photo();

		var r:FlxRect = FlxRect.get(
				_player.shutter.x - FlxG.camera.scroll.x,
				_player.shutter.y - FlxG.camera.scroll.y,
				_player.shutter.width * _player.shutter.scale.x,
				_player.shutter.height * _player.shutter.scale.y);

		var rCentre:FlxPoint = FlxPoint.get(r.x + r.width / 2, r.y + r.height / 2);

		FlxScreenGrab.defineCaptureRegion(
				Std.int(r.x),
				Std.int(r.y),
				Std.int(r.width),
				Std.int(r.height));

		var target:Target = null;
		for (t in _targets)
		{
			if (r.containsFlxPoint(t.getMidpoint()))
			{
				if (target == null)
				{
					target = t;
					continue;
				} else if (t.getMidpoint().distanceTo(rCentre)
						< target.getMidpoint().distanceTo(rCentre)) target = t;
			}
		}

		if (target != null)
		{
			p.hitTarget = true;
			p.targetCentre.x = target.getMidpoint().x - r.x;
			p.targetCentre.y = target.getMidpoint().y - r.y;
			p.centrePercent =
				Math.round(target.getMidpoint().distanceTo(rCentre)
				/ Math.sqrt(Math.pow(r.width/2,2) + Math.pow(r.height/2,2))*100);
		}

		p.data = FlxScreenGrab.grab(null, null, true).bitmapData;
		Reg.photos.push(p);

		var p:FlxSprite = Reg.photos[Reg.photos.length-1].getSprite();
		p.x = FlxG.width / 2 - p.width / 2;
		p.y = FlxG.height / 2 - p.height / 2;
		add(p);

		_player.freezeInput = true;
		//Slow time
		FlxMintNumTween.t(1, 0.1, 0.5, 
				function (f:Float) {FlxG.timeScale=f; });

		//Fade out image
		FlxMintNumTween.t(1, 0, 0.5, 
				function (f:Float) {p.alpha=f;}, {startDelay:3}, true);

		//Speed time back up
		FlxMintNumTween.t(0.1, 1, 0.5, 
				function (f:Float) {FlxG.timeScale=f;}, {startDelay:3.5, onComplete: 
					function (f:FlxTween) {_player.freezeInput = false;}}, true);

		r.put();
		rCentre.put();
	}

	private function doorVPlayer(b1:FlxBasic, b2:FlxBasic):Void
	{
		var d:Door = cast(b1, Door);
		var p:Player = cast(b2, Player);

		var doorStates:Array<Int> = [Player.IDLE, Player.WALKING];
		if (p.up && doorStates.indexOf(p.state) != -1)
		{
			p.freezeInput = true;
			FlxG.camera.fade(0xFF000000, 1, false, function() {
				Reg.prevLoc = Reg.loc;
				Reg.loc = d.loc;
				FlxG.switchState(new GameState());
			}, false);
		}
	}

	private function targetVAiBlock(b1:FlxBasic, b2:FlxBasic):Void
	{
		var t:Target = cast(b1, Target);
		var b:FlxSprite = cast(b2, FlxSprite);

		if (
				(t.facing == FlxObject.LEFT && b.facing == FlxObject.LEFT) ||
				(t.facing == FlxObject.RIGHT && b.facing == FlxObject.RIGHT))
		{
			t.blocked(t.facing);
		}
	}

}

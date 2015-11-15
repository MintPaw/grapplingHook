package game;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;

class GameState extends FlxState
{
	private var _tilemap:FlxTilemap;
	private var _player:Player;
	private var _doors:FlxTypedGroup<Door>;
	private var _canvas:FlxSprite;

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();

		{ // Setup misc
		}

		{ // Setup tilemap
			var tiledMap:TiledMap = new TiledMap("assets/map/" + Reg.loc + ".tmx");
			_doors = new FlxTypedGroup<Door>();

			for (layer in tiledMap.layers) {
				if (layer.type == TiledLayerType.OBJECT) {
					for (obj in cast(layer, TiledObjectLayer).objects) {
						if (obj.type == "door") {
							var d:Door = new Door();
							d.x = obj.x;
							d.y = obj.y;
							d.loc = obj.properties.get("loc");
							d.exitTo = obj.properties.get("exitTo");
							_doors.add(d);
						}
					}
				}
			}
			
			_tilemap = new FlxTilemap();
			_tilemap.loadMapFromCSV(
					cast(tiledMap.layers[0], TiledTileLayer).csvData,
					"assets/" + tiledMap.tilesetArray[0].imageSource.substr(3),
					32,
					32,
					null,
					1);
		}

		{ // Setup player
			_player = new Player();
			_player.hookCallback = hook;
			for (d in _doors) {
				if (d.loc == Reg.prevLoc) {
					_player.x = d.x;
					_player.y = d.y;
					if (d.exitTo == "left") _player.facing = FlxObject.LEFT;
					if (d.exitTo == "right") _player.facing = FlxObject.RIGHT;
				}
			}
		}

		{ // Setup camera
			var tileWidth = 32;

			FlxG.camera.fade(0xFF000000, 1, true, function() {
				_player.freezeInput = false;
			}, false);

			FlxG.camera.setScrollBoundsRect(
					0,
					0,
					_tilemap.width - tileWidth,
					_tilemap.height, true);

			FlxG.camera.follow(_player, FlxCameraFollowStyle.PLATFORMER);
		}

		{ // Setup canvas
			_canvas = new FlxSprite();
			_canvas.makeGraphic(
					Std.int(FlxG.worldBounds.width),
					Std.int(FlxG.worldBounds.height), 0);
			add(_canvas);
			Reg.canvas = _canvas;
		}

		add(_tilemap);
		add(_doors);
		add(_player);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		{ // Update collision
			_player.hittingMap = FlxG.collide(_tilemap, _player);
			FlxG.overlap(_doors, _player, doorVPlayer);
		}

		{ // Update drawing api
			_canvas.pixels.fillRect(_canvas.pixels.rect, 0);

			if (_player.state == Player.HOOKING || _player.state == Player.HANGING)
				Reg.drawLine(_player.hookPoint.x, 
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

	private function doorVPlayer(b1:FlxBasic, b2:FlxBasic):Void
	{
		var d:Door = cast(b1, Door);
		var p:Player = cast(b2, Player);

		if (p.up) {
			p.freezeInput = true;
			FlxG.camera.fade(0xFF000000, 1, false, function() {
				Reg.prevLoc = Reg.loc;
				Reg.loc = d.loc;
				FlxG.switchState(new GameState());
			}, false);
		}
	}

}

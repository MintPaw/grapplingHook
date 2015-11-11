package game;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;

class GameState extends FlxState
{
	private var _tilemap:FlxTilemap;
	private var _player:Player;

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();

		{ // Setup tilemap
			var tiledMap:TiledMap = new TiledMap("assets/map/test.tmx");
			
			_tilemap = new FlxTilemap();
			_tilemap.loadMapFromCSV(
					cast(tiledMap.layers[0], TiledTileLayer).csvData,
					"assets/" + tiledMap.tilesetArray[0].imageSource.substr(3),
					32,
					32,
					null,
					1);
			add(_tilemap);
		}

		{ // Setup player
			_player = new Player();
			_player.hookCallback = hook;
			_player.x = 300;
			_player.y = 200;
			add(_player);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(_tilemap, _player);
	}

	private function hook(loc:FlxPoint, a:Float):FlxPoint
	{
		var result:FlxPoint = new FlxPoint();
		var end:FlxPoint = new FlxPoint();

		end.x = loc.x + Math.cos(a)*1000;
		end.y = loc.y + Math.sin(a)*1000;
		var bad:Bool = _tilemap.ray(loc, end, result);

		FlxG.log.add("--" + bad);

		if (bad) return null;
		FlxG.log.add("Going to return: " + result);
		return result;
	}
}

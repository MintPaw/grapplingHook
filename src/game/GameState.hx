package game;

import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;

class GameState extends FlxState
{
	private var _tilemap:FlxTilemap;

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
			//_tilemap.
		}
	}
}

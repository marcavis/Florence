package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	var player:Player;
	var npcs:FlxTypedGroup<NPC>;
	var mapX:Int;
	var mapY:Int;
	var distance:Int;
	var occupation:Array<Array<Bool>> = [for (x in 0...30) [for (y in 0...30) false]];
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var solidAreas:FlxGroup;

	override public function create()
	{
		map = new FlxOgmo3Loader(AssetPaths.florence__ogmo, AssetPaths.test1__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "ground");
		walls.follow();
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, ANY);
		add(walls);

		// for (tile in walls.getTile)
		// {
		// 	trace(tile);
		// }

		player = new Player(48, 48, this);
		add(player);
		npcs = new FlxTypedGroup<NPC>();
		npcs.add(new NPC(144, 128, this));

		add(npcs);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		// FlxG.overlap(player, npcs, npcBump);
		// FlxG.collide(player, walls, bumpAway);
		// FlxG.collide(npcs, walls, wat);
		checkInteractions();
		// checkOccupation();
		// if (collideWithLevel(player))
		// {
		// 	player.moveToNextTile = false;
		// }
	}

	public function collideWithLevel(obj:MapSprite):Bool
	{
		if (walls.overlapsWithCallback(obj, bumpAway(obj, walls)))
		{
			return true;
		}
		return false;
	}

	public function npcBump(pc:MapSprite, npc:MapSprite)
	{
		trace(pc.x, pc.y, npc.x, npc.y);
		npc.x = npc.mapX * 16;
		npc.y = npc.mapY * 16;
		npc.moveDirection = NONE;
		pc.x = pc.mapX * 16;
		pc.y = pc.mapY * 16;
		// FlxObject.separate(pc, npc);
	}

	public function bumpAway(pc:MapSprite, map:FlxObject):Bool
	{
		pc.x = pc.mapX * 16;
		pc.y = pc.mapY * 16;
		// FlxObject.separate(pc, map);
		trace(pc.x, pc.y, pc.mapX, pc.mapY);
		return true;
	}

	public function wat(npc:MapSprite, map:FlxObject)
	{
		trace(npc);
	}

	public function canMove(obj:MapSprite, x:Int, y:Int)
	{
		var mapWalkable:Bool = walls.getTile(x, y) == 1;
		var nobodyHere:Bool = true;
		// if (Std.is(obj, Player))
		// {

		// }
		for (n in npcs)
		{
			if (n != obj)
			{
				if (n.mapX == x && n.mapY == y)
					return false;
				if (n.nextMapX == x && n.nextMapY == y)
					return false;
			}
		}
		if (Std.isOfType(obj, NPC))
		{
			nobodyHere = x != player.mapX || y != player.mapY;
			nobodyHere = nobodyHere && (x != player.nextMapX || y != player.nextMapY);
		}
		// trace(obj, mapWalkable, nobodyHere);
		return mapWalkable && nobodyHere;
	}

	function checkInteractions()
	{
		if (FlxG.keys.pressed.Z)
		{
			for (n in npcs)
			{
				distance = abs(n.mapX - player.mapX) + abs(n.mapY - player.mapY);
				// trace(distance);
				if (distance == 1)
				{
					trace("talking!");
				}
			}
		}
	}

	// not working lol
	function checkOccupation()
	{
		occupation[player.mapX][player.mapY] = true;
		for (n in npcs)
		{
			occupation[n.mapX][n.mapY] = true;
		}
		for (n in npcs)
		{
			if (occupation[n.nextMapX][n.nextMapY])
				n.moveDirection = NONE;
		}
		if (occupation[player.nextMapX][player.nextMapY])
		{
			player.moveDirection = NONE;
		}
	}

	function abs(value:Int)
	{
		return value < 0 ? (-value) : value;
	}
}

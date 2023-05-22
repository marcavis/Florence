package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	var player:Player;
	var npcs:FlxTypedGroup<NPC>;
	var mapX:Int;
	var mapY:Int;
	var distance:Int;
	var occupation:Array<Array<Bool>> = [for (x in 0...30) [for (y in 0...30) false]];

	override public function create()
	{
		player = new Player(48, 48);
		add(player);
		npcs = new FlxTypedGroup<NPC>();
		npcs.add(new NPC(128, 128));

		add(npcs);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		// FlxG.collide(player, npcs);
		checkInteractions();
		checkOccupation();
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

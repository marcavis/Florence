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

	function abs(value:Int)
	{
		return value < 0 ? (-value) : value;
	}
}

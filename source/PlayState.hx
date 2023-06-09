package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

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

	var boom:Explosion;
	var screen:FlxSprite;
	// chatgpt explosion
	private var explosionEmitter:FlxTypedEmitter<FlxParticle>;
	private var lightBeamEmitter:FlxTypedEmitter<FlxParticle>;

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

		// explosionEmitter = new FlxTypedEmitter(96, 96, 10);
		// explosionEmitter.makeParticles(8, 8, FlxColor.RED, 10);
		// add(explosionEmitter);
		// explosionEmitter.start(false, 0.3);
		// explosionEmitter.speed.set(20, 70);
		// explosionEmitter.angle.set(-90, 90);
		// explosionEmitter.lifespan.set(2, 5);
		// trace(explosionEmitter.launchMode);

		// boom = new Explosion(128, 128);
		// add(boom);
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

		if (FlxG.keys.anyPressed([Q]))
		{
			startDeathAnimation();
		}
	}

	public function startDeathAnimation():Void
	{
		// Hide the enemy sprite.
		// visible = false;

		// Create the explosion emitter effect.
		// explosionEmitter.x = x + width / 2;
		// explosionEmitter.y = y + height / 2;
		// explosionEmitter.start(true, 0.5, 10);

		// // Create the light beam emitter effect.
		// lightBeamEmitter.x = x + width / 2;
		// lightBeamEmitter.y = y + height / 2;
		// lightBeamEmitter.start(true, 0.5, 10);

		// // Create a white flash effect on the background.
		var flashSprite:FlxSprite = new FlxSprite();
		flashSprite.makeGraphic(FlxG.width, FlxG.height, 0xffffffff);
		flashSprite.alpha = 0;
		// FlxG.camera.getContainerSprite().addChild(flashSprite);

		screen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		var waveEffect = new FlxWaveEffect(FlxWaveMode.ALL, 4, -1, 4);
		var waveSprite = new FlxEffectSprite(screen, [waveEffect]);
		add(waveSprite);
		add(screen);
		screen.drawFrame();

		// Sequence the death animation effects using FlxTween and FlxTimer.
		// You can adjust the durations and delays to your liking.

		// Tween the enemy sprite to become transparent red.
		FlxTween.tween(npcs.getRandom(), {alpha: 0}, 1.5, {
			onComplete: function(_)
			{
				// Remove the enemy sprite and emitters from the game state.
				FlxG.state.remove(this);
				FlxG.state.remove(explosionEmitter);
				FlxG.state.remove(lightBeamEmitter);
			}
		});

		// Add the emitters to the game state.
		// FlxG.state.add(explosionEmitter);
		// FlxG.state.add(lightBeamEmitter);

		// Delay for a short duration before the final explosion.
		// FlxTimer.delay(1.5, function()
		// {
		// 	// Create the final explosion effect.
		// 	// For now, draw a red circle at the enemy's position as a placeholder.
		// 	var finalExplosion:FlxSprite = new FlxSprite();
		// 	finalExplosion.makeGraphic(50, 50, 0xFFFF0000);
		// 	finalExplosion.x = x + width / 2 - finalExplosion.width / 2;
		// 	finalExplosion.y = y + height / 2 - finalExplosion.height / 2;
		// 	FlxG.state.add(finalExplosion);

		// 	// Shake the screen.
		// 	FlxG.camera.shake(0.05, 0.5);

		// 	// Flash the background to white.
		// 	FlxTween.tween(flashSprite, {alpha: 1}, 0.1, {
		// 		onComplete: function()
		// 		{
		// 			FlxG.state.remove(flashSprite);
		// 		}
		// 	});
		// });
	}

	// public function collideWithLevel(obj:MapSprite):Bool
	// {
	// 	if (walls.overlapsWithCallback(obj, bumpAway(obj, walls)))
	// 	{
	// 		return true;
	// 	}
	// 	return false;
	// }
	// public function npcBump(pc:MapSprite, npc:MapSprite)
	// {
	// 	trace(pc.x, pc.y, npc.x, npc.y);
	// 	npc.x = npc.mapX * 16;
	// 	npc.y = npc.mapY * 16;
	// 	npc.moveDirection = NONE;
	// 	pc.x = pc.mapX * 16;
	// 	pc.y = pc.mapY * 16;
	// 	// FlxObject.separate(pc, npc);
	// }
	// public function bumpAway(pc:MapSprite, map:FlxObject):Bool
	// {
	// 	pc.x = pc.mapX * 16;
	// 	pc.y = pc.mapY * 16;
	// 	// FlxObject.separate(pc, map);
	// 	trace(pc.x, pc.y, pc.mapX, pc.mapY);
	// 	return true;
	// }

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
					interact();
				}
			}
		}
	}

	public function interact():Void
	{
		var dialogueBox = new DialogueBox();
		dialogueBox.showDialogue("Hello World");

		// Add the dialogue box to the game state or appropriate group.
		// For example: FlxG.state.add(dialogueBox);
		add(dialogueBox);

		// Set a timer or handle user input to remove the dialogue box.
		// For example: FlxG.timer.start(3, 1, function() { FlxG.state.remove(dialogueBox); });

		new FlxTimer().start(3, function(_)
		{
			remove(dialogueBox);
		});
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

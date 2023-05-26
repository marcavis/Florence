package;

// import Sprite.MoveDirection;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.util.FlxDirectionFlags;

class NPC extends MapSprite
{
	var stepSound:FlxSound;

	var desireToMove:Int = 50;
	var idleTimer:Float = 0;
	var randomDirection:FlxDirectionFlags;

	public function new(x:Int = 0, y:Int = 0, playState:PlayState)
	{
		super(x, y, playState);
		loadGraphic(AssetPaths.greenslime__png, true, 16, 16);
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, false, false);
		animation.add("d_idle", [1]);
		animation.add("l_idle", [4]);
		animation.add("r_idle", [7]);
		animation.add("u_idle", [10]);
		animation.add("d_walk", [1, 0, 1, 2], 6);
		animation.add("l_walk", [4, 3, 4, 5], 6);
		animation.add("r_walk", [7, 6, 7, 8], 6);
		animation.add("u_walk", [10, 9, 10, 11], 6);

		stepSound = FlxG.sound.load(AssetPaths.step__wav);

		movementSpeed = 1;

		immovable = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		idleTimer -= elapsed;

		if (FlxG.random.bool(desireToMove) && idleTimer <= 0)
		{
			randomDirection = FlxG.random.getObject([DOWN, UP, LEFT, RIGHT]);

			facing = randomDirection;
			idleTimer = FlxG.random.int(1, 2);
			switch (randomDirection)
			{
				case LEFT:
					moveTo(LEFT, mapX - 1, mapY);
					animation.play("l_walk");
				case RIGHT:
					moveTo(RIGHT, mapX + 1, mapY);
					animation.play("r_walk");
				case UP:
					moveTo(UP, mapX, mapY - 1);
					animation.play("u_walk");
				case DOWN:
					moveTo(DOWN, mapX, mapY + 1);
					animation.play("d_walk");
				case _:
			}
		}

		if (!moveToNextTile)
		{
			switch (facing)
			{
				case LEFT:
					animation.play("l_idle");
				case RIGHT:
					animation.play("r_idle");
				case UP:
					animation.play("u_idle");
				case DOWN:
					animation.play("d_idle");
				case _:
			}
		}
	}
}

/**
 * Tiled movement: @author .:BuzzJeux:.
 */

import flixel.FlxSprite;
import flixel.util.FlxDirectionFlags;
import haxe.macro.Compiler.IncludePosition;

class MapSprite extends FlxSprite
{
	/**
	 * How big the tiles of the tilemap are.
	 */
	static inline var TILE_SIZE:Int = 16;

	/**
	 * How many pixels to move each frame. Has to be a divider of TILE_SIZE
	 * to work as expected (move one block at a time), because we use the
	 * modulo-operator to check whether the next block has been reached.
	 */
	var movementSpeed:Int = 2;

	/**
	 * Flag used to check if char is moving.
	 */
	public var moveToNextTile:Bool;

	/**
	 * Var used to hold moving direction.
	 */
	public var moveDirection:FlxDirectionFlags;

	public var mapX:Int;
	public var mapY:Int;
	public var nextMapX:Int;
	public var nextMapY:Int;

	override public function new(x:Int = 0, y:Int = 0)
	{
		super(x, y);
		nextMapX = Std.int(x / TILE_SIZE);
		nextMapY = Std.int(y / TILE_SIZE);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		// Move the player to the next block
		if (moveToNextTile)
		{
			switch (moveDirection)
			{
				case UP:
					y -= movementSpeed;
				case DOWN:
					y += movementSpeed;
				case LEFT:
					x -= movementSpeed;
				case RIGHT:
					x += movementSpeed;
				case _:
			}
		}

		// Check if the player has now reached the next block
		if ((x % TILE_SIZE == 0) && (y % TILE_SIZE == 0))
		{
			moveToNextTile = false;
			mapX = Std.int(x / TILE_SIZE);
			mapY = Std.int(y / TILE_SIZE);
		}
		if (movementSpeed == 2)
			trace(mapX, mapY, nextMapX, nextMapY);
	}

	public function moveTo(Direction:FlxDirectionFlags):Void
	{
		// Only change direction if not already moving
		if (!moveToNextTile)
		{
			moveDirection = Direction;
			moveToNextTile = true;
			switch (moveDirection)
			{
				case UP:
					nextMapY--;
				case DOWN:
					nextMapY++;
				case LEFT:
					nextMapX--;
				case RIGHT:
					nextMapX++;
				case _:
			}

			if (nextMapY < 0)
			{
				nextMapY = 0;
				moveDirection = NONE;
			}
			if (nextMapX < 0)
			{
				nextMapX = 0;
				moveDirection = NONE;
			}
		}
	}
}

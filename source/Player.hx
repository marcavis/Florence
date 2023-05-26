package;

// import Sprite.MoveDirection;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.util.FlxDirectionFlags;

class Player extends MapSprite
{
	#if mobile
	var _virtualPad:FlxVirtualPad;
	#end

	var stepSound:FlxSound;

	public function new(x:Int = 0, y:Int = 0, playState:PlayState)
	{
		super(x, y, playState);
		loadGraphic(AssetPaths.bluelady__png, true, 16, 16);
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

		// drag.x = drag.y = 800;
		// setSize(8, 8);
		// offset.set(4, 8);

		stepSound = FlxG.sound.load(AssetPaths.step__wav);

		movementSpeed = 2;
		elasticity = 1;

		#if mobile
		_virtualPad = new FlxVirtualPad(FULL, NONE);
		_virtualPad.alpha = 0.5;
		FlxG.state.add(_virtualPad);
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var tryingToMove:Bool = false;
		#if mobile
		if (_virtualPad.buttonDown.pressed)
		{
			moveTo(DOWN);
		}
		else if (_virtualPad.buttonUp.pressed)
		{
			moveTo(UP);
		}
		else if (_virtualPad.buttonLeft.pressed)
		{
			moveTo(LEFT);
		}
		else if (_virtualPad.buttonRight.pressed)
		{
			moveTo(RIGHT);
		}
		#else
		// Check for WASD or arrow key presses and move accordingly
		if (FlxG.keys.anyPressed([DOWN, S]))
		{
			tryingToMove = true;
			moveTo(DOWN, mapX, mapY + 1);
			facing = DOWN;
			animation.play("d_walk");
		}
		else if (FlxG.keys.anyPressed([UP, W]))
		{
			tryingToMove = true;
			moveTo(UP, mapX, mapY - 1);
			facing = UP;
			animation.play("u_walk");
		}
		else if (FlxG.keys.anyPressed([LEFT, A]))
		{
			tryingToMove = true;
			moveTo(LEFT, mapX - 1, mapY);
			facing = LEFT;
			animation.play("l_walk");
		}
		else if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			tryingToMove = true;
			moveTo(RIGHT, mapX + 1, mapY);
			facing = RIGHT;
			animation.play("r_walk");
		}
		#end

		if (!moveToNextTile && !tryingToMove)
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

	public function moveTo(Direction:FlxDirectionFlags, newX:Int, newY:Int):Void
	{
		// Only change direction if not already moving
		if (!moveToNextTile)
		{
			moveDirection = Direction;
			nextMapX = newX;
			nextMapY = newY;
			if (playState.canMove(this, newX, newY))
			{
				moveToNextTile = true;
			}
		}
	}
}

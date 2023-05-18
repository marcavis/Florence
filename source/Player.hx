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

	public function new(x:Int = 0, y:Int = 0)
	{
		super(x, y);
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

		#if mobile
		_virtualPad = new FlxVirtualPad(FULL, NONE);
		_virtualPad.alpha = 0.5;
		FlxG.state.add(_virtualPad);
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

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
			moveTo(DOWN);
			facing = DOWN;
			animation.play("d_walk");
		}
		else if (FlxG.keys.anyPressed([UP, W]))
		{
			moveTo(UP);
			facing = UP;
			animation.play("u_walk");
		}
		else if (FlxG.keys.anyPressed([LEFT, A]))
		{
			moveTo(LEFT);
			facing = LEFT;
			animation.play("l_walk");
		}
		else if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			moveTo(RIGHT);
			facing = RIGHT;
			animation.play("r_walk");
		}
		#end

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
		// checkInteractions();
	}
}

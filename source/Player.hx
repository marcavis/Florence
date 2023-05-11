package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;

class Player extends FlxSprite
{
	static inline var SPEED:Float = 100;

	var stepSound:FlxSound;

	public function new(x:Float = 0, y:Float = 0)
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

		drag.x = drag.y = 800;
		setSize(8, 8);
		offset.set(4, 8);

		stepSound = FlxG.sound.load(AssetPaths.step__wav);
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}

	function updateMovement()
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		#if FLX_KEYBOARD
		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);
		#end

		#if mobile
		var virtualPad = PlayState.virtualPad;
		up = up || virtualPad.buttonUp.pressed;
		down = down || virtualPad.buttonDown.pressed;
		left = left || virtualPad.buttonLeft.pressed;
		right = right || virtualPad.buttonRight.pressed;
		#end

		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		if (up || down || left || right)
		{
			var newAngle:Float = 0;
			if (up)
			{
				newAngle = -90;
				if (left)
					newAngle -= 45;
				else if (right)
					newAngle += 45;
				facing = UP;
			}
			else if (down)
			{
				newAngle = 90;
				if (left)
					newAngle += 45;
				else if (right)
					newAngle -= 45;
				facing = DOWN;
			}
			else if (left)
			{
				newAngle = 180;
				facing = LEFT;
			}
			else if (right)
			{
				newAngle = 0;
				facing = RIGHT;
			}

			// determine our velocity based on angle and speed
			velocity.setPolarDegrees(SPEED, newAngle);
		}

		var action = "idle";
		// check if the player is moving, and not walking into walls
		if ((velocity.x != 0 || velocity.y != 0) && touching == NONE)
		{
			stepSound.play();
			action = "walk";
		}

		switch (facing)
		{
			case LEFT:
				animation.play("l_" + action);
			case RIGHT:
				animation.play("r_" + action);
			case UP:
				animation.play("u_" + action);
			case DOWN:
				animation.play("d_" + action);
			case _:
		}
	}
}

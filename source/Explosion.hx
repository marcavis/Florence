import flixel.FlxSprite;

class Explosion extends FlxSprite
{
	override public function new(x:Int = 0, y:Int = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.bigboom__png, true, 59, 59);
		animation.add("normal", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 6);
		animation.play("normal");
	}
}

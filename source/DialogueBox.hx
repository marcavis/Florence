import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

class DialogueBox extends FlxGroup
{
	var textField:FlxText;

	public function new()
	{
		super();

		textField = new FlxText(10, 10, FlxG.width - 20, "");
		textField.setFormat(null, 16, 0xffffff, "left");
		add(textField);
	}

	public function showDialogue(text:String):Void
	{
		textField.text = text;
	}
}

package utils;

import flixel.FlxG;
import flixel.FlxSprite;

class Interactions
{
	public function objectCollisionFSprite(object1:FlxSprite, object2:FlxSprite)
	{
		if (object1.x < object2.x + object2.width
			&& object1.x + object1.width > object2.x
			&& object1.y < object2.y + object2.height
			&& object1.y + object1.height > object2.y)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	public function objectCollisionMouseFSprite(object:FlxSprite)
	{
		if (FlxG.mouse.x > object.x
			&& FlxG.mouse.x < object.x + object.width
			&& FlxG.mouse.y > object.y
			&& FlxG.mouse.y < object.y + object.height
			&& object.alive)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	public function clickedObject(object:FlxSprite)
	{
		if (FlxG.mouse.x > object.x
			&& FlxG.mouse.x < object.x + object.width
			&& FlxG.mouse.y > object.y
			&& FlxG.mouse.y < object.y + object.height
			&& object.alive)
		{
			if (FlxG.mouse.justPressed)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}

	public function clickingObject(object:FlxSprite)
		{
			if (FlxG.mouse.x > object.x
				&& FlxG.mouse.x < object.x + object.width
				&& FlxG.mouse.y > object.y
				&& FlxG.mouse.y < object.y + object.height
				&& object.alive)
			{
				if (FlxG.mouse.pressed)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
}

class StaticInteractions
{
	public static function objectCollisionFSprite(object1:FlxSprite, object2:FlxSprite)
	{
		if (object1.x < object2.x + object2.width
			&& object1.x + object1.width > object2.x
			&& object1.y < object2.y + object2.height
			&& object1.y + object1.height > object2.y)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	public static function objectCollisionMouseFSprite(object:FlxSprite)
	{
		if (FlxG.mouse.x > object.x
			&& FlxG.mouse.x < object.x + object.width
			&& FlxG.mouse.y > object.y
			&& FlxG.mouse.y < object.y + object.height
			&& object.alive)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	public static function clickedObject(object:FlxSprite)
	{
		if (FlxG.mouse.x > object.x
			&& FlxG.mouse.x < object.x + object.width
			&& FlxG.mouse.y > object.y
			&& FlxG.mouse.y < object.y + object.height
			&& object.alive)
		{
			if (FlxG.mouse.justPressed)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}

	public static function clickingObject(object:FlxSprite)
		{
			if (FlxG.mouse.x > object.x
				&& FlxG.mouse.x < object.x + object.width
				&& FlxG.mouse.y > object.y
				&& FlxG.mouse.y < object.y + object.height
				&& object.alive)
			{
				if (FlxG.mouse.pressed)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
}

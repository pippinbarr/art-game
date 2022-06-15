package SaveAndReplay
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	
	public class SnakeSave extends Save
	{
		public var head:FlxPoint;
		public var body:Array;
		public var fruit:FlxPoint;
		public var tileSize:Number;
		

		public function SnakeSave()
		{
			type = Globals.SNAKE;
			
			head = null;
			body = null;
			fruit = null;
			tileSize = 0;
		}
		
		
		public function save(_title:String, _year:String, _tileSize:Number, _head:FlxSprite, _body:FlxGroup, _fruit:FlxSprite):void
		{		
			info = new ArtInfo(Globals.SNAKE_ARTIST,Globals.SNAKE_ARTIST_NATIONALITY,Globals.SNAKE_ARTIST_BIRTH_YEAR,_title,_year,Globals.SNAKE_MEDIUM);

			tileSize = _tileSize;
			
			head = new FlxPoint(_head.x, _head.y);
			fruit = new FlxPoint(_fruit.x, _fruit.y);
			
			body = new Array();
			for (var i:uint = 0; i < _body.members.length; i++)
			{
				if (_body.members[i] != null)
				{
					body.push(new FlxPoint(_body.members[i].x, _body.members[i].y));
				}
			}
		}
		
		
		public function createFromArrays(_title:String,_year:String,_tileSize:Number, _head:Array, _body:Array, _fruit:Array):void
		{		
			info = new ArtInfo(Globals.SNAKE_ARTIST,Globals.SNAKE_ARTIST_NATIONALITY,Globals.SNAKE_ARTIST_BIRTH_YEAR,_title,_year,Globals.SNAKE_MEDIUM);

			tileSize = _tileSize;
			
			head = new FlxPoint(_head[0], _head[1]);
			fruit = new FlxPoint(_fruit[0], _fruit[1]);
			
			body = new Array();
			for (var i:int = 0; i < _body.length; i++)
			{
				body.push(new FlxPoint(_body[i][0], _body[i][1]));
			}
		}

		
		
		public function createFromObject(_object:Object):void
		{
			type = _object.type;
			head = _object.head;
			body = _object.body;
			fruit = _object.fruit;
			tileSize = _object.tileSize;
		}
		
		
		public function print():void
		{
			var save:String = "";
			
			save += "[";
			
			save += "[" + head.x + "," + head.y + "],";
			
			save += "[";
			for (var i:uint = 0; i < body.length; i++)
			{
				save += "[" + body[i].x + "," + body[i].y + "]";
				if (i != body.length - 1)
				{
					save += ",";
				}
			}
			save += "],";
			
			save += "[" + fruit.x + "," + fruit.y + "]";
			save += "];";
			
			trace(save);
		}
		
		
		override public function destroy():void
		{
		}

	}
}
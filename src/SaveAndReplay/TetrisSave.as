package SaveAndReplay
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	
	public class TetrisSave extends Save
	{
		public var tileSize:Number;
		public var tetrominoes:Array;
		
		
		public function TetrisSave()
		{
			type = Globals.TETRIS;
			tileSize = 0;
			tetrominoes = null;
		}
		
		
		public function save(_title:String, _year:String, _tileSize:Number, _tetrominoes:Array):void
		{		
			info = new ArtInfo(Globals.TETRIS_ARTIST,Globals.TETRIS_ARTIST_NATIONALITY,Globals.TETRIS_ARTIST_BIRTH_YEAR,_title,_year,Globals.TETRIS_MEDIUM);

			tileSize = _tileSize;
			tetrominoes = _tetrominoes;
			
//			while(_tetrominoes.length > 0)
//			{
//				tetrominoes.push(_tetrominoes.pop());
//			}
		}
		
		
		public function print():void
		{
			var save:String = "";
			
			save += "const tileSize:Number = " + tileSize + "\n";
			save += "const tetrominoes:Array = [";
			for (var i:uint = 0; i < tetrominoes.length; i++)
			{
				save += "[";
				for (var j:uint = 0; j < tetrominoes[i].length; j++)
				{
					save += tetrominoes[i][j].toString();
					if (j != tetrominoes[i].length - 1) save += ",";
				}
				save += "]";
				if (i != tetrominoes.length) save += ",";
			}
			save += "];";
			
			trace(save);
		}
		
	}
}
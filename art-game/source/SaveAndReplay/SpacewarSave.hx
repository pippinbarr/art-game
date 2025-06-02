package SaveAndReplay
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	
	public class SpacewarSave extends Save
	{
		public var tileSize:Number;
		
		public var data:Array;
		
		public var wedgePositions:Array;
		public var needlePositions:Array;
		public var missilePositions:Array;
		
		
		public function SpacewarSave()
		{
			tileSize = 0;
			type = Globals.SPACEWAR;
			
			wedgePositions = null;
			needlePositions = null;
			missilePositions = null;
		}
		
		
		public function save(_title:String,_year:String,_tileSize:Number,_data:Array):void
		{				
			info = new ArtInfo(
				Globals.SPACEWAR_ARTIST,
				Globals.SPACEWAR_ARTIST_NATIONALITY,
				Globals.SPACEWAR_ARTIST_BIRTH_YEAR,
				_title,
				_year,
				Globals.SPACEWAR_MEDIUM);
			
			tileSize = _tileSize;
			
			data = _data;
		}
		
		
		public function print():void
		{
			var save:String = "";
			
			// Start overall array of save
			save += "[";
			
			for (var i:uint = 0; i < data.length; i++)
			{
				// Start sub array of data
				save += "[";
				for (var j:uint = 0; j < data[i].length; j++)
				{
					save += data[i][j].toString();
					if (j != data[i].length -1) save += ",";
				}
				
				save += "]";
				
				if (i != data.length - 1) save += ",";
			}
			
			save += "]";
			
			trace(save);
		}
	}
}
package SaveAndReplay
{
	public class ArtInfo
	{
		public var artist:String;
		public var nationality:String;
		public var birthYear:String;
		public var title:String;
		public var year:String;
		public var medium:String;
		
		public function ArtInfo(_artist:String,_nationality:String,_birthYear:String,_title:String,_year:String,_medium:String)
		{
			artist = _artist;
			nationality = _nationality;
			birthYear = _birthYear;
			title = _title;
			year = _year;
			medium = _medium;
		}
	}
}
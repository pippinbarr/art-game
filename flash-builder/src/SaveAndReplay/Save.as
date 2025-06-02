package SaveAndReplay
{
	public class Save
	{
		public var id:uint;
		public var type:uint;
		public var inShow:Boolean = false;
		public var info:ArtInfo;
		public var comment:String;

		public function Save()
		{
		}
		
		
		public function destroy():void
		{
			// Nothing...
		}
		
//		public function toString():String
//		{
//			var returnVal:String = "";
//			returnVal += "id: " + workID + "\n";
//			returnVal += "type: " + workType + "\n";
//			returnVal += "comment: " + comment;
//			return returnVal;
//		}
	}
}
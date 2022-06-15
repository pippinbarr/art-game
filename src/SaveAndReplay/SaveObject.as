package SaveAndReplay
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class SaveObject
	{
		public var type:uint;
		public var saves:Array;
		public var latest:Object;
		public var mode:uint;
		public var numShowWorks:uint;
		
		public function SaveObject(object:SaveObject = null)
		{			
			if (object != null)
			{
				type = object.type;
				saves = object.saves;
				latest = object.latest;
				mode = object.mode;
				numShowWorks = object.numShowWorks;
			}
			else
			{
				type = Globals.NONE;
				saves = new Array();
				latest = null;
				mode = 0;
				numShowWorks = 0;
			}
		}		
	}
}
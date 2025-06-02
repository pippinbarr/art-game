package Shared
{
	
	import org.flixel.*;
	import SaveAndReplay.SaveObject;
	
	public class Cookie
	{
		
		private static var _save:FlxSave;
		private static var _loaded:Boolean = false;
		
		private static var tempFadeIn:Boolean = false;
		private static var tempNextID:uint = 0;
		private static var tempCuratorVisits:uint = 0;
		private static var tempCuratorRejectedWorks:Array = new Array();
		private static var tempNewSelectionComments:Array = new Array();
		private static var tempReconsideredSelectionComments:Array = new Array();
		private static var tempType:int = -1;
		private static var tempSaveObject:Object = new Object();
		private static var tempStudioSaveObject:Object = new Object();
		private static var tempGallerySaveObject:Object = new Object();
		private static var tempState:uint = Globals.NO_STATE;
		private static var tempAvatarX:Number = -1;
		private static var tempAvatarY:Number = -1;
		private static var tempAvatar2X:Number = -1;
		private static var tempAvatar2Y:Number = -1;
		private static var tempMoveHelpSeen:Boolean = false;
		private static var tempGallerySeen:Boolean = false;
		private static var tempGalleryShowTitle:String = "";
		
		
		public function Cookie()
		{
		}
		
		public static function load():void 
		{	
			_save = new FlxSave();
			_loaded = _save.bind("ArtGameData");
			
			if (_loaded && _save.data.saveObject == null)
			{
				_save.data.saveObject = new SaveObject();
			}	
			if (_loaded && _save.data.studioSaveObject == null)
			{
				_save.data.studioSaveObject = new SaveObject();
			}
			if (_loaded && _save.data.gallerySaveObject == null)
			{
				_save.data.gallerySaveObject = new SaveObject();
			}

			if (_loaded && _save.data.state == null)
			{
				_save.data.state = Globals.NO_STATE;
			}
			if (_loaded && _save.data.type == null)
			{
				_save.data.type = -1;
			}
			if (_loaded && _save.data.nextID == null)
			{
				_save.data.nextID = 0;
			}
			if (_loaded && _save.data.curatorVisits == null)
			{
				_save.data.curatorVisits = 0;
			}
			if (_loaded && _save.data.curatorRejectedWorks == null)
			{
				_save.data.curatorRejectedWorks = new Array();
			}
			if (_loaded && _save.data.newSelectionComments == null)
			{
				_save.data.newSelectionComments = new Array();
			}
			if (_loaded && _save.data.reconsideredSelectionComments == null)
			{
				_save.data.reconsideredSelectionComments = new Array();
			}
			if (_loaded && _save.data.avatarX == null)
				_save.data.avatarX = -1;
			if (_loaded && _save.data.avatarY == null)
				_save.data.avatarY = -1;
			if (_loaded && _save.data.avatar2X == null)
				_save.data.avatar2X = -1;
			if (_loaded && _save.data.avatar2Y == null)
				_save.data.avatar2Y = -1;
			if (_loaded && _save.data.moveHelpSeen == null)
				_save.data.moveHelpSeen = false;
			if (_loaded && _save.data.gallerySeen == null)
				_save.data.gallerySeen = false;
			if (_loaded && _save.data.galleryShowTitle == null)
				_save.data.galleryShowTitle = "UNTITLED";
			if (_loaded && _save.data.fadeIn == null)
				_save.data.fadeIn = false;

		}
		
		public static function flush():void 
		{
			if (_loaded) _save.flush();
		}
		
		public static function erase():void 
		{
			if (_loaded) _save.erase();
		}
		
		public static function set saveObject(value:Object):void 
		{
			if (_loaded)
			{
				_save.data.saveObject = value;
			}
			else
			{
				tempSaveObject = value;
			}
		}
		
		public static function get saveObject():Object 
		{
			if (_loaded)
			{
				return _save.data.saveObject;
			}
			else
			{
				return tempSaveObject;
			}
		}
		
		public static function set studioSaveObject(value:Object):void 
		{
			if (_loaded)
			{
				_save.data.studioSaveObject = value;
			}
			else
			{
				tempStudioSaveObject = value;
			}
		}
		
		public static function get studioSaveObject():Object 
		{
			if (_loaded)
			{
				return _save.data.studioSaveObject;
			}
			else
			{
				return tempStudioSaveObject;
			}
		}
		
		public static function set gallerySaveObject(value:Object):void 
		{
			if (_loaded)
			{
				_save.data.gallerySaveObject = value;
			}
			else
			{
				tempGallerySaveObject = value;
			}
		}
		
		public static function get gallerySaveObject():Object 
		{
			if (_loaded)
			{
				return _save.data.gallerySaveObject;
			}
			else
			{
				return tempGallerySaveObject;
			}
		}

		
		
		public static function get state():uint
		{
			if (_loaded)
			{
				return _save.data.state;
			}
			else
			{
				return tempState;
			}
		}
		
		
		public static function set state(value:uint):void
		{
			if (_loaded)
			{
				_save.data.state = value;
			}
			else
			{
				tempState = value;
			}
		}
		
		public static function get type():int
		{
			if (_loaded)
			{
				return _save.data.type;
			}
			else
			{
				return tempType;
			}
		}
		
		
		public static function set type(value:int):void
		{
			if (_loaded)
			{
				_save.data.type = value;
			}
			else
			{
				tempType = value;
			}
		}
		
		public static function get nextID():uint
		{
			if (_loaded)
			{
				return _save.data.nextID;
			}
			else
			{
				return tempNextID;
			}
		}
		
		
		public static function set nextID(value:uint):void
		{
			if (_loaded)
			{
				_save.data.nextID = value;
			}
			else
			{
				tempNextID = value;
			}
		}
		
		
		public static function get curatorVisits():uint
		{
			if (_loaded)
			{
				return _save.data.curatorVisits;
			}
			else
			{
				return tempCuratorVisits;
			}
		}
		
		
		public static function set curatorVisits(value:uint):void
		{
			if (_loaded)
			{
				_save.data.curatorVisits = value;
			}
			else
			{
				tempCuratorVisits = value;
			}
		}

		
		public static function get curatorRejectedWorks():Array
		{
			if (_loaded)
			{
				return _save.data.curatorRejectedWorks;
			}
			else
			{
				return tempCuratorRejectedWorks;
			}
		}
		
		
		public static function set curatorRejectedWorks(value:Array):void
		{
			if (_loaded)
			{
				_save.data.curatorRejectedWorks = value;
			}
			else
			{
				tempCuratorRejectedWorks = value;
			}
		}
		
		
		public static function get newSelectionComments():Array
		{
			if (_loaded)
			{
				return _save.data.newSelectionComments;
			}
			else
			{
				return tempNewSelectionComments;
			}
		}
		
		
		public static function set newSelectionComments(value:Array):void
		{
			if (_loaded)
			{
				_save.data.newSelectionComments = value;
			}
			else
			{
				tempNewSelectionComments = value;
			}
		}
		
		
		public static function get reconsideredSelectionComments():Array
		{
			if (_loaded)
			{
				return _save.data.reconsideredSelectionComments;
			}
			else
			{
				return tempReconsideredSelectionComments;
			}
		}
		
		
		public static function set reconsideredSelectionComments(value:Array):void
		{
			if (_loaded)
			{
				_save.data.reconsideredSelectionComments = value;
			}
			else
			{
				tempReconsideredSelectionComments = value;
			}
		}
		
		
		public static function get avatarX():Number
		{
			if (_loaded)
				return _save.data.avatarX;
			else
				return tempAvatarX;
		}
		
		public static function set avatarX(value:Number):void
		{
			if (_loaded)
				_save.data.avatarX = value;
			else
				tempAvatarX = value;
		}
		
		public static function get avatarY():Number
		{
			if (_loaded)
				return _save.data.avatarY;
			else
				return tempAvatarY;
		}
		
		public static function set avatarY(value:Number):void
		{
			if (_loaded)
				_save.data.avatarY = value;
			else
				tempAvatarY = value;
		}
		
		public static function get avatar2X():Number
		{
			if (_loaded)
				return _save.data.avatar2X;
			else
				return tempAvatar2X;
		}
		
		public static function set avatar2X(value:Number):void
		{
			if (_loaded)
				_save.data.avatar2X = value;
			else
				tempAvatar2X = value;
		}
		
		public static function get avatar2Y():Number
		{
			if (_loaded)
				return _save.data.avatar2Y;
			else
				return tempAvatar2Y;
		}
		
		public static function set avatar2Y(value:Number):void
		{
			if (_loaded)
				_save.data.avatar2Y = value;
			else
				tempAvatar2Y = value;
		}
		
		public static function get moveHelpSeen():Boolean
		{
			if (_loaded)
				return _save.data.moveHelpSeen;
			else
				return tempMoveHelpSeen;
		}
		
		public static function set moveHelpSeen(value:Boolean):void
		{
			if (_loaded)
				_save.data.moveHelpSeen = value;
			else
				tempMoveHelpSeen = value;
		}
		
		public static function get gallerySeen():Boolean
		{
			if (_loaded)
				return _save.data.gallerySeen;
			else
				return tempGallerySeen;
		}
		
		public static function set gallerySeen(value:Boolean):void
		{
			if (_loaded)
				_save.data.gallerySeen = value;
			else
				tempGallerySeen = value;
		}

		public static function get galleryShowTitle():String
		{
			if (_loaded)
				return _save.data.galleryShowTitle;
			else
				return tempGalleryShowTitle;
		}
		
		public static function set galleryShowTitle(value:String):void
		{
			if (_loaded)
				_save.data.galleryShowTitle = value;
			else
				tempGalleryShowTitle = value;
		}
		
		public static function get fadeIn():Boolean
		{
			if (_loaded)
				return _save.data.fadeIn;
			else
				return tempFadeIn;
		}
		
		public static function set fadeIn(value:Boolean):void
		{
			if (_loaded)
				_save.data.fadeIn = value;
			else
				tempFadeIn = value;
		}



	}
}
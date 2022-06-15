package Shared
{
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.flixel.*;

	public class Helpers
	{
		
		public static var actionTimer:FlxTimer = new FlxTimer();
		public static var ACTION_DELAY:Number = 0.8;
		
		public function Helpers()
		{
			actionTimer.reset();
		}
		
		
		public static function randomSort(a:*, b:*):Number
		{
			if (Math.random() < 0.5) return -1;
			else return 1;
		}
		
		public static function setupAction():void
		{
			actionTimer.finished = true;
		}
		
		public static function actionString():String
		{
			if (Cookie.type != Globals.SPACEWAR)
			{
				return Globals.P1_ACTION_KEY_STRING;
			}
			else
			{
				return Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER";
			}
		}
		
		public static function action():Boolean
		{
			if (Cookie.type != Globals.SPACEWAR)
			{
				if (FlxG.keys.justPressed("ENTER"))
				{
					actionTimer.start(ACTION_DELAY,1);
					return true;
				}
			}
			else
			{
				trace("ACTION TIMER FINISHED: " + actionTimer.finished);
				if ((FlxG.keys.ENTER && FlxG.keys.justPressed("SPACE")) ||
					(FlxG.keys.SPACE && FlxG.keys.justPressed("ENTER")))
				{
					//actionTimer.start(ACTION_DELAY,1);
					return true;
				}
//				if (actionTimer.finished && FlxG.keys.ENTER && FlxG.keys.SPACE)
//				{
//					actionTimer.start(ACTION_DELAY,1);
//					return true;
//				}

			}
			
			return false;
		}
		
		public static function debugMemory(s:String):void
		{
			if (Globals.DEBUG_MEMORY)
				trace(s + ": " + Number(System.totalMemory/1024).toFixed(2));
		}
		
		
		public static function resetGame():void
		{
			Cookie.load();
			Cookie.erase();
			Cookie.flush();
			FlxG.switchState(new MainMenuState);
		}
		
		
	}
}
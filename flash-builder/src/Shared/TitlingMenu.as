package Shared
{
	import Gallery.GalleryState;
	
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.text.*;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class TitlingMenu extends FlxGroup
	{
		private var entered:Boolean = false;
		private var text:String = "";
		private var displayText:FlxText;
		
		private var x:Number = 0;
		private var y:Number;
		
		private var enabled:Boolean = false;
		
		private var textFormat:TextFormat = new TextFormat("Commodore",16,0xFFFFFF,null,null,null,null,null,"center",null,null,null,null);
		
		public function TitlingMenu(_y:Number,_menuDark:Boolean = true)
		{			
			super();
			
			x = 0;
			y = _y;
			
			// Text fields for items
			
			displayText = new FlxText(0,_y,FlxG.width,"\"\"");
			
			if (_menuDark)
				displayText.setFormat("Commodore",20,0xFFFFFF,"center");
			else
				displayText.setFormat("Commodore",20,0x000000,"center");
			
		}
		
		
		public override function update():void 
		{
			super.update();						
		}
		
		
		public function enable():void
		{
			enabled = true;
			text = "";
			displayText.text = "\"\"";
			entered = false;
			add(displayText);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		
		
		public function disable():void
		{
			remove(displayText);
			enabled = false;
		}
		
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (!enabled) return;
			
			if (e.keyCode == Keyboard.ENTER)
			{
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
				if (text == "")
					text = "UNTITLED";
				entered = true;
			}
			else if (e.keyCode == Keyboard.BACKSPACE && text.length > 0) 
			{
				text = text.substring(0,text.length-1);
			}
			else
			{	
				var character:String = String.fromCharCode(e.charCode);
				character = character.toUpperCase();				
				if (Globals.VALID_TITLE_CHARACTERS.indexOf(character) != -1 && text.length < Globals.MAX_TITLE_LENGTH) 
				{
					text += character;
				}
			}
			
			displayText.text = "\"" + text + "\"";
		}
		
		
		public function getTitle():String
		{
			if (entered) 
			{
				return text;
			}
			else 
			{
				return "";
			}
		}
		
		
		public override function destroy():void 
		{
			super.destroy();

			displayText.destroy();
		}
	}
}
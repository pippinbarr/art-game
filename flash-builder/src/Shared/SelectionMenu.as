package Shared
{
	import Gallery.GalleryState;
	
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.text.*;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class SelectionMenu extends FlxGroup
	{
		private var cursor:FlxSprite;
		
		public var selectionKey:String = "ENTER";
		public var selected:Boolean = false;
		public var selection:int = 0;
		
		private var x:Number = 0;
		private var y:Number;
		
		public var enabled:Boolean = false;
		
		public var items:Array;
		public var itemTextFields:Array;
		
		private var textFormat:TextFormat;
		
		private var twoPlayer:Boolean;
		
		private var inputDelay:FlxTimer = new FlxTimer();
		
		public function SelectionMenu(_y:Number, _cursorWidth:Number, _items:Array, _dark:Boolean = true, _twoPlayer:Boolean = false)
		{			
			super();
						
			x = 0;
			y = _y;
			items = _items;
			twoPlayer = _twoPlayer;

			if (_dark)
			{
				textFormat = new TextFormat("Commodore",16,0xFFFFFF,null,null,null,null,null,"center",null,null,null,null);
			}
			else
			{
				textFormat = new TextFormat("Commodore",16,0x000000,null,null,null,null,null,"center",null,null,null,null);
			}
			
			cursor = new FlxSprite(0,y);
			if (_dark)
			{
				cursor.makeGraphic(_cursorWidth,24,0xAAAAAAAA);
			}
			else
			{
				cursor.makeGraphic(_cursorWidth,24,0xAA888888);
			}
			cursor.x = FlxG.width/2 - cursor.width/2;
			
			// Text fields for items
			itemTextFields = new Array();
			
			for (var i:uint = 0; i < items.length; i++)
			{
				itemTextFields.push(makeTextField(items[i],x,y + i*24,textFormat));
				FlxG.stage.addChild(itemTextFields[i]);
			}
			
		}
		
		
		public function setSelectionKey(key:String):void
		{
			selectionKey = key;
		}
		
		public override function update():void 
		{
			super.update();
			
			if (enabled)
				checkInput();
		}
		
		
		public function enable():void
		{
			enabled = true;
			selected = false;
			add(cursor);
			for (var i:uint = 0; i < itemTextFields.length; i++)
			{
				itemTextFields[i].visible = true;
			}
			
			inputDelay.start(0.2,1);
		}
		
		
		public function disable():void
		{
			selected = false;
			enabled = false;
			remove(cursor);
			for (var i:uint = 0; i < itemTextFields.length; i++)
			{
				itemTextFields[i].visible = false;
			}
		}

		
		private function checkInput():void
		{
			if (selected) return;
			if (!enabled) return;
			if (!inputDelay.finished) return;
			
			if (FlxG.keys.justPressed(Globals.P1_UP_KEY))
			{
				selection--;
				if (selection < 0) selection = itemTextFields.length - 1;
				cursor.y = y + selection * 24;

			}
			else if (FlxG.keys.justPressed(Globals.P1_DOWN_KEY))
			{
				selection = (selection + 1) % itemTextFields.length;
				cursor.y = y + selection * 24;
			}
						
			if (FlxG.keys.justPressed(selectionKey))
			{
				selected = true;
			}
		}
		
		
		public function getSelection():int
		{
			if (!enabled || !inputDelay.finished)
				return -1;
			
			if (selected) 
			{
				selected = false;
				return selection;
			}
			else 
			{
				return -1;
			}
		}
		
		
		private function makeTextField(_text:String,_x:Number,_y:Number,_tf:TextFormat):TextField
		{
			var text:TextField = new TextField();
			text.defaultTextFormat = _tf;
			text.embedFonts = true;
			text.wordWrap = true;
			text.autoSize = "left";
			text.selectable = false;
			text.width = FlxG.width; 
			text.text = _text;
			
			text.x = _x;
			text.y = _y;
			
			text.visible = false;
			
			return text;
		}
		
		public override function destroy():void 
		{
			super.destroy();
			
			inputDelay.destroy();
			
			cursor.destroy();
			
			for (var i:uint = 0; i < itemTextFields.length; i++)
			{
				if (FlxG.stage.contains(itemTextFields[i]))
					FlxG.stage.removeChild(itemTextFields[i]);
			}
		}
	}
}
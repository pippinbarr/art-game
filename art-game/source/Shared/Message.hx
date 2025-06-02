package Shared
{
	import flash.events.KeyboardEvent;
	import flash.text.*;
	import flash.ui.Keyboard;
	import flash.display.*;
	
	import org.flixel.*;
	import Gallery.GalleryState;
	
	public class Message extends FlxGroup
	{
		private const x:int = 50;
		private const y:int = 50;
		
		private const MESSAGE_TIME:uint = 10;
		
		public var buffer:Sprite;
		
		private var outerBox:Bitmap;
		private var lineBox:Bitmap;
		private var innerBox:Bitmap;
		
		public var text:TextField;
		private var textFormat:TextFormat = new TextFormat("Commodore",20,0x000000,null,null,null,null,null,"left",null,null,null,null);
		
		private var timer:FlxTimer;
		
		public var message:String;
		
		private var counter:uint = 0;
		
		public function Message()
		{			
			super();
			
			buffer = new Sprite();
			
			text = new TextField();
			text.text = "";
			text.defaultTextFormat = textFormat;
			text.embedFonts = true;
			text.wordWrap = true;
			text.autoSize = "center";
			text.selectable = false;
			text.width = 480; 
			text.visible = false;
			
			visible = false;
			buffer.visible = false;
			
		}
		
		
		public function setup(_message:String):void
		{
			message = _message;
			timer = new FlxTimer();
			
			text.text = _message;
			
			outerBox = new Bitmap(new BitmapData(text.width + 48,text.height + 40,false,0xFFFFFF));
			lineBox = new Bitmap(new BitmapData(text.width + 48 - 8,text.height - 8 + 40,false,0xCCCCCC));
			innerBox = new Bitmap(new BitmapData(text.width + 48 - 16,text.height - 16 + 40,false,0xFFFFFF));
			
			outerBox.x = FlxG.width/2 - outerBox.width/2;
			outerBox.y = FlxG.height/2 - outerBox.height/2;
			
			lineBox.x = FlxG.width/2 - lineBox.width/2;
			lineBox.y = FlxG.height/2 - lineBox.height/2;
			
			innerBox.x = FlxG.width/2 - innerBox.width/2; 
			innerBox.y = FlxG.height/2 - innerBox.height/2;

			buffer.removeChildren();
			
			buffer.addChild(outerBox);
			buffer.addChild(lineBox);
			buffer.addChild(innerBox);
			buffer.addChild(text);
			
			displayMessage(null);
		}
		
		private function displayMessage(t:FlxTimer):void 
		{	
			text.text = message;	
			
			text.x = FlxG.width/2 - text.width/2;
			text.y = FlxG.height/2 - text.height/2;
			text.visible = true;
				
			FlxG.stage.addChild(buffer);

			outerBox.visible = true;
			lineBox.visible = true;
			innerBox.visible = true;

			buffer.visible = true;
			visible = true;
		}
		
		
		public override function update():void 
		{
			super.update();
		}
		
		
		public override function postUpdate():void 
		{
			super.postUpdate();
		}
				
		private function endOfMessage(t:FlxTimer):void 
		{
			setVisible(false);
		}		
		
		public function setVisible(value:Boolean):void
		{
			visible = value;
			buffer.visible = value;
		}
		
		public override function destroy():void {
			
			timer.destroy();
			
			if (FlxG.stage.contains(buffer))
				FlxG.stage.removeChild(buffer);
			
			FlxG.stage.focus = null;

			super.destroy();
		}
	}
}
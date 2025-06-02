package Shared
{
	import Gallery.GalleryState;
	
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.text.*;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class HelpOverlay extends FlxGroup
	{
		private var bg:Bitmap;
		public var buffer:Sprite;
		
		public var text:TextField;
		private var textFormat:TextFormat = new TextFormat("Commodore",16,0xFFFFFF,null,null,null,null,null,"left",null,null,null,null);
		
		private var message:String;
		
		private var counter:uint = 0;
		
		public function HelpOverlay(_message:String)
		{			
			super();
			
			message = _message;
			
			buffer = new Sprite();
			FlxG.stage.addChild(buffer);
			
			bg = new Bitmap(new BitmapData(FlxG.width,FlxG.height,false,0x111111));
			bg.alpha = 0.8;
			
			bg.x = 0;
			bg.y = 0;
			
			text = new TextField();
			text.defaultTextFormat = textFormat;
			text.embedFonts = true;
			text.wordWrap = true;
			text.autoSize = "left";
			text.selectable = false;
			text.width = FlxG.width - 64; 
			text.text = message;
			
			text.x = 32;
			
			text.y = 32;
			
			buffer.addChild(bg);
			buffer.addChild(text);
			
			buffer.visible = false;
		}
		
		
		public override function update():void 
		{
			super.update();
		}
		
		
		public override function postUpdate():void 
		{
			super.postUpdate();
		}
		
		
		public function setVisible(value:Boolean):void
		{
			buffer.visible = value;
		}
		
		public override function destroy():void {
			super.destroy();
			
			FlxG.stage.removeChild(buffer);
		}
	}
}
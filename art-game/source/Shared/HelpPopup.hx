package Shared
{
	import Gallery.GalleryState;
	
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.text.*;
	import flash.ui.Keyboard;
	
	import org.flixel.*;

	public class HelpPopup extends FlxGroup
	{
		private var bg:Bitmap;
		public var buffer:Sprite;
		
		public var text:TextField;
		private var textFormat:TextFormat = new TextFormat("Commodore",13,0xFFFFFF,null,null,null,null,null,"center",null,null,null,null);
		
		private var message:String;
		
		private var counter:uint = 0;
		
		public function HelpPopup(_message:String, _position:uint = FlxObject.DOWN, _doubleHeight:Boolean = false)
		{			
			super();
			
			message = _message;
			
			buffer = new Sprite();
			FlxG.stage.addChild(buffer);
			
			if (_doubleHeight)
				bg = new Bitmap(new BitmapData(FlxG.width,48,false,0x111111));
			else
				bg = new Bitmap(new BitmapData(FlxG.width,32,false,0x111111));
			bg.alpha = 0.8;
			
			bg.x = 0;
			if (_position == FlxObject.DOWN)
				bg.y = FlxG.height - bg.height;
			else if (_position == FlxObject.UP)
				bg.y = 0;
			
			text = new TextField();
			text.defaultTextFormat = textFormat;
			text.embedFonts = true;
			text.wordWrap = true;
			text.autoSize = "center";
			text.selectable = false;
			text.width = FlxG.width; 
			text.text = message;
			
			text.x = 0;
			
			text.y = bg.y + bg.height/2 - text.height/2;
						
			buffer.addChild(bg);
			buffer.addChild(text);
			
			buffer.visible = false;
			
			visible = false;
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
			visible = value;
		}
		
		public override function destroy():void {
			super.destroy();

			if (FlxG.stage.contains(buffer))
				FlxG.stage.removeChild(buffer);
		}
	}
}
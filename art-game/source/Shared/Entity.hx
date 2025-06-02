package Shared
{
	import org.flixel.*;
	
	
	public class Entity extends FlxObject
	{
		public var displayGroup:FlxGroupY;
		public var hitBox:FlxSprite;
		public var triggerZone:FlxSprite;
		
		
		public function Entity(_x:Number, _y:Number)
		{
			super(_x,_y);
			
			displayGroup = new FlxGroupY();
			hitBox = new FlxSprite();
			triggerZone = new FlxSprite();
		}
		
		
		override public function update():void
		{
			super.update();
		}
		
		
		override public function destroy():void
		{
			super.destroy();
			
			displayGroup.destroy();
			hitBox.destroy();
			triggerZone.destroy();
		}
	}
}
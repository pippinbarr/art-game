package SaveAndReplay
{
	import org.flixel.*;
	
	
	public class StudioArtwork extends Artwork
	{
		public function StudioArtwork()
		{
			super();
			
			style = STUDIO;
		}
		
		override protected function setupAsSnake(_x:Number, _y:Number, _tileSize:Number, _save:Object, _framed:Boolean = true):void
		{
			trace("setupAsSnake(" + _x + "," + _y + "," + _tileSize + "," + _save + ")");
			var scale:Number = _tileSize/_save.tileSize;
			
			width = FlxG.width * scale;
			height = FlxG.height * scale;
			
			if (_framed)
			{
				var frameSprite:FlxSprite = displayGroup.recycle(FlxSprite) as FlxSprite;
				frameSprite.x = _x - 4;
				frameSprite.y = _y - 4;
				frameSprite.makeGraphic(width + 8, height + 8, 0xFFDDDDDD);
				frameSprite.revive();
			}
			
			
			// SET UP HIT BOX
			
			hitBox = displayGroup.recycle(FlxSprite) as FlxSprite;
			hitBox.revive();
			hitBox.makeGraphic(width,30,Globals.DEBUG_HITBOX_COLOUR);
			hitBox.x = x;
			hitBox.y = y + height - hitBox.height;
			hitBox.visible = Globals.DEBUG_HITBOXES;
			
			// SET UP ZOOM ZONE
			
			triggerZone = displayGroup.recycle(FlxSprite) as FlxSprite;
			triggerZone.makeGraphic(FlxG.width * scale - 60, 40, Globals.DEBUG_TRIGGER_COLOUR);
			triggerZone.x = _x + 30;			
			triggerZone.y = y + height;
			triggerZone.revive();
			triggerZone.visible = Globals.DEBUG_HITBOXES;
			
			displayGroup.add(triggerZone);
			displayGroup.add(hitBox);
			
			super.setupAsSnake(_x,_y,_tileSize,_save);
		}
		
		override protected function setupAsSpacewar(_x:Number, _y:Number, _tileSize:Number, _save:Object):void
		{
			width = FlxG.width * scale;
			height = FlxG.height * scale;
			
			hitBox.x = -100;
			triggerZone.x = -100;
			
			displayGroup.add(triggerZone);
			displayGroup.add(hitBox);
			
			super.setupAsSpacewar(_x,_y,_tileSize,_save);
		}
		
		override protected function setupAsTetris(_x:Number, _y:Number, _tileSize:Number, _save:Object):void
		{
			width = _tileSize * _save.tetrominoes[0].length;
			height = _tileSize * _save.tetrominoes.length;
			
			// HIT BOX
			
			hitBox = new FlxSprite();
			hitBox.x = x;
			hitBox.y = y;
			hitBox.makeGraphic(10,10,Globals.DEBUG_HITBOX_COLOUR);
			
			hitBox.visible = Globals.DEBUG_HITBOXES;
			
			// ZOOM ZONE
			
			triggerZone = new FlxSprite();
			triggerZone.x = x - 20;
			triggerZone.y = y - 20;
			triggerZone.makeGraphic(width + 20 + 20, height + height + 20 + 20,Globals.DEBUG_TRIGGER_COLOUR);
			
			triggerZone.visible = Globals.DEBUG_HITBOXES;
			
			displayGroup.add(triggerZone);
			displayGroup.add(hitBox);
			
			trace("setupAsTetris(" + _x + "," + _y + "," + _tileSize + "," + _save + ")");
			super.setupAsTetris(_x,_y,_tileSize,_save);
		}
	}	
}
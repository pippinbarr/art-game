package SaveAndReplay
{
	
	import org.flixel.*;
	import Shared.Helpers;
	
	
	public class GalleryArtwork extends Artwork
	{
		public var focalPoint:FlxPoint;
		public var focalZoom:Number;
		
		public var infoZone:FlxSprite;
		
		public var audiencePositions:Array = new Array();

		
		public function GalleryArtwork(_x:Number = 0, _y:Number = 0)
		{
			super(_x,_y);	
			
			style = GALLERY;
		}
		
		
		override public function createFromSaveObject(_x:Number, _y:Number, _tileSize:Number, _save:Object, _framed:Boolean = true):void
		{
			super.createFromSaveObject(_x,_y,_tileSize,_save);
		}
		
		
		override protected function setupAsSnake(_x:Number, _y:Number, _tileSize:Number, _save:Object, _framed:Boolean = true):void
		{			
			width = FlxG.width * scale + 2*_tileSize;
			height = FlxG.height * scale + 2*_tileSize;
			
			var frameSprite:FlxSprite;
			frameSprite = new FlxSprite(_x - _tileSize, _y - _tileSize);
			frameSprite.makeGraphic(width, height, 0xFF111111);
			
			var infoSprite:FlxSprite;
			infoSprite = new FlxSprite(frameSprite.x - 30, frameSprite.y + frameSprite.height - 12);
			infoSprite.makeGraphic(20,12,0xFFFFFFFF);
			
			
			// SET UP ZOOM ZONE
			
			triggerZone = displayGroup.recycle(FlxSprite) as FlxSprite;
			triggerZone.makeGraphic(FlxG.width * scale - 60, 40, Globals.DEBUG_TRIGGER_COLOUR);
			triggerZone.x = _x + 30;			
			triggerZone.y = FlxG.height/2;
			triggerZone.revive();
			triggerZone.visible = Globals.DEBUG_HITBOXES;
			
			
			// SET UP INFO ZONE
			
			infoZone = new FlxSprite();
			infoZone.makeGraphic(infoSprite.width, 40, Globals.DEBUG_TRIGGER_COLOUR);
			infoZone.x = infoSprite.x;
			infoZone.y = FlxG.height/2;
			
			infoZone.visible = Globals.DEBUG_HITBOXES;
			
			
			// SET UP HIT BOX
			
			hitBox = displayGroup.recycle(FlxSprite) as FlxSprite;
			hitBox.revive();
			hitBox.makeGraphic(width,30,Globals.DEBUG_HITBOX_COLOUR);
			hitBox.x = x;
			hitBox.y = y + height - hitBox.height;
			hitBox.visible = Globals.DEBUG_HITBOXES;
			
			
			// FOCAL POINT
			
			focalPoint = new FlxPoint();
			focalPoint.x = _x + FlxG.width * scale * 0.5;
			focalPoint.y = _y + FlxG.height * scale * 0.5;
			
			focalZoom = 2.5;
			
			
			// AUDIENCE POSITIONS
			var defaultY:Number = Globals.GALLERY_WALL_Y + 20;
			
//			audiencePositions.push(new Array(x - 50,defaultY,FlxObject.RIGHT));
//			audiencePositions.push(new Array(x + frameSprite.width,defaultY,FlxObject.LEFT));
			audiencePositions.push(new Array(x + 0,defaultY,FlxObject.UP));
			audiencePositions.push(new Array(x + 1*width/3,defaultY,FlxObject.UP));
			audiencePositions.push(new Array(x + 2*width/3,defaultY,FlxObject.UP));
			
			audiencePositions.sort(Helpers.randomSort);
			
			displayGroup.add(frameSprite);
			displayGroup.add(infoSprite);
			displayGroup.add(infoZone);
			displayGroup.add(triggerZone);
			displayGroup.add(hitBox);
			
			super.setupAsSnake(_x,_y,_tileSize,_save);
		}
		
		
		override protected function setupAsSpacewar(_x:Number, _y:Number, _tileSize:Number, _save:Object):void
		{			
			width = FlxG.width * scale;
			height = FlxG.height * scale;

			var projector:FlxSprite = new FlxSprite(x, y - 56);
			projector.loadGraphic(Assets.PROJECTOR__SS_PNG,true,false,160,176);
			projector.addAnimation("flicker",[0,1],10);
			projector.play("flicker");
			
			
			var infoSprite:FlxSprite;
			infoSprite = new FlxSprite(x - 30, y + height - 12);
			infoSprite.makeGraphic(20,12,0xFFFFFFFF);			
			
			// SET UP ZOOM ZONE
			
			triggerZone.makeGraphic(FlxG.width * scale - 60, 40, Globals.DEBUG_TRIGGER_COLOUR);
			triggerZone.x = _x + 30;
			triggerZone.y = FlxG.height/2;
			
			triggerZone.visible = Globals.DEBUG_HITBOXES;
			
			// SET UP HIT ZONE
			
			hitBox = new FlxSprite(x,y);
			hitBox.makeGraphic(width,height,Globals.DEBUG_HITBOX_COLOUR);
			hitBox.visible = Globals.DEBUG_HITBOXES;
			
			// SET UP INFO ZONE
			
			infoZone = new FlxSprite();
			infoZone.makeGraphic(infoSprite.width, 40, Globals.DEBUG_TRIGGER_COLOUR);
			infoZone.x = infoSprite.x;
			infoZone.y = FlxG.height/2;
			
			infoZone.visible = Globals.DEBUG_HITBOXES;
			
			
			// FOCAL POINT
			
			focalPoint = new FlxPoint();
			focalPoint.x = x + FlxG.width * scale * 0.5;
			focalPoint.y = y + FlxG.height * scale * 0.5;
			
			focalZoom = 2.5;
			
			// AUDIENCE POSITIONS
			
			var defaultY:Number = Globals.GALLERY_WALL_Y + 20;
			
//			audiencePositions.push(new Array(x - 50,defaultY,FlxObject.RIGHT));
//			audiencePositions.push(new Array(x + width,defaultY,FlxObject.LEFT));
			audiencePositions.push(new Array(x + 0,defaultY,FlxObject.UP));
			audiencePositions.push(new Array(x + 1*width/3,defaultY,FlxObject.UP));
			audiencePositions.push(new Array(x + 2*width/3,defaultY,FlxObject.UP));
			
			audiencePositions.sort(Helpers.randomSort);
			
			super.setupAsSpacewar(_x,_y,_tileSize,_save);
			
			// Set up display group
			displayGroup.add(projector);
			displayGroup.add(infoSprite);
			displayGroup.add(infoZone);
			displayGroup.add(triggerZone);
			displayGroup.add(hitBox);
		}
		
		override protected function setupAsTetris(_x:Number, _y:Number, _tileSize:Number, _save:Object):void
		{
			width = _tileSize * _save.tetrominoes[0].length + (2 * _tileSize);
			height = _tileSize * _save.tetrominoes.length + _tileSize*2 + _tileSize*4;

			var plinthTop:FlxSprite;
			plinthTop = new FlxSprite(x - tileSize, y);
			plinthTop.makeGraphic(width,_tileSize * 2,0xFFEEEEEE);
			
			var plinthSide:FlxSprite;
			plinthSide = new FlxSprite(plinthTop.x, plinthTop.y + plinthTop.height);
			plinthSide.makeGraphic(width, plinthTop.height * 2,0xFFAAAAAA);
					
			// ZOOM ZONE
			
			triggerZone = new FlxSprite();
			triggerZone.x = plinthTop.x - 20;
			triggerZone.y = plinthTop.y;
			triggerZone.makeGraphic(plinthTop.width + 20 + 20, plinthTop.height + plinthSide.height + 20,Globals.DEBUG_TRIGGER_COLOUR);
			
			triggerZone.visible = Globals.DEBUG_HITBOXES;
			
			// SET UP INFO LABEL
			
			info = _save.info;

			var infoSprite:FlxSprite;
			infoSprite = new FlxSprite(plinthSide.x + plinthSide.width/2 - 10, plinthSide.y + plinthSide.height/2 - 6);
			infoSprite.makeGraphic(20,12,0xFFFFFFFF);
			
			// INFO ZONE
			
			infoZone = new FlxSprite();
			infoZone.makeGraphic(infoSprite.width, 20, Globals.DEBUG_TRIGGER_COLOUR);
			infoZone.x = infoSprite.x;
			infoZone.y = plinthSide.y + plinthSide.height;
			
			infoZone.visible = Globals.DEBUG_HITBOXES;
			
			// HIT ZONE
			
			hitBox = new FlxSprite(plinthSide.x,plinthSide.y);
			hitBox.makeGraphic(plinthSide.width,plinthTop.height,Globals.DEBUG_HITBOX_COLOUR);
			hitBox.x = plinthSide.x;
			hitBox.y = plinthSide.y + plinthSide.height - hitBox.height;
			hitBox.visible = Globals.DEBUG_HITBOXES;
			
			// FOCAL POINT
			
			focalPoint = new FlxPoint();
			focalPoint.x = x + width/2;
			focalPoint.y = y - 90;
			
			focalZoom = 1.3;
			
			// AUDIENCE POSITIONS
			Globals.TETRIS_PLINTH_BOTTOM = plinthSide.y + plinthSide.height;
			
			var lowY:Number = hitBox.y + hitBox.height + 5;
			var highY:Number = hitBox.y - Globals.PERSON_HITBOX_HEIGHT - 5;
			
//			audiencePositions.push(new Array(_x - Globals.PERSON_HITBOX_WIDTH - 5,(highY+lowY)/2,FlxObject.RIGHT));
//			audiencePositions.push(new Array(x + width,(highY+lowY)/2,FlxObject.LEFT));
			audiencePositions.push(new Array(x + 10,lowY,FlxObject.UP));
			audiencePositions.push(new Array(x + 10 + Globals.PERSON_HITBOX_WIDTH + 40,lowY,FlxObject.UP));
			audiencePositions.push(new Array(x + 10,highY,FlxObject.DOWN));
			audiencePositions.push(new Array(x + 10 + Globals.PERSON_HITBOX_WIDTH + 40,highY,FlxObject.DOWN));
			
			audiencePositions.sort(Helpers.randomSort);
			
			displayGroup.y = hitBox.y;
			
			displayGroup.add(plinthTop);
			displayGroup.add(plinthSide);
			displayGroup.add(infoSprite);
			displayGroup.add(infoZone);
			displayGroup.add(triggerZone);
			displayGroup.add(hitBox);
			
			super.setupAsTetris(_x,_y,_tileSize,_save);
		}
	}
}
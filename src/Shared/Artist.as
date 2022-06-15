package Shared
{
	import org.flixel.*;
	
	public class Artist extends Person
	{
		
		public var costume:FlxSprite;
		private var costumeType:uint;
		
		public var headHitBox:FlxSprite;
		public var costumeHitBox:FlxSprite;
		public var fallen:Boolean = false;
		
		public function Artist(_x:Number,_y:Number,_ss:Class,_facing:uint = FlxObject.RIGHT)
		{
			super(_x,_y,_ss,_facing);
			
			type = Globals.AVATAR;
		}
		
		
		public function toggleCostumeVisible():void
		{
			if (costume != null)
			{
				costume.visible = !costume.visible;
				if (costume.visible)
				{
					costumeHitBox.visible = Globals.DEBUG_HITBOXES;
				}
				else
				{
					costumeHitBox.visible = false;
				}
			}
		}
		
		
		public function addCostume(_type:uint):void
		{
			costumeType = _type;
			costume = new FlxSprite();
			costumeHitBox = new FlxSprite();
			
			if (costumeType == Globals.WEDGE)
			{
				costume.loadGraphic(Assets.WEDGE_SHIP_PNG,true,true,168,48);
				costume.x = sprite.x + sprite.width/2 - costume.width/2;
				costume.y = sprite.y;		
				
				costumeHitBox.makeGraphic(costume.width,costume.height/2,Globals.DEBUG_HITBOX_COLOUR);
				costumeHitBox.x = costume.x;
				costumeHitBox.y = costume.y + costume.height/4;
			}
			else if (costumeType == Globals.NEEDLE)
			{
				costume.loadGraphic(Assets.NEEDLE_SHIP_PNG,true,true,192,52);
				costume.x = sprite.x + sprite.width/2 - costume.width/2;
				costume.y = sprite.y;
				
				costumeHitBox.makeGraphic(costume.width,costume.height/2,Globals.DEBUG_HITBOX_COLOUR);
				costumeHitBox.x = costume.x;
				costumeHitBox.y = costume.y + costume.height/4;
			}
			
			headHitBox = new FlxSprite();
			headHitBox.makeGraphic(24,24,Globals.DEBUG_HITBOX_COLOUR);
			headHitBox.x = sprite.x + 20;
			headHitBox.y = sprite.y + 20;
			headHitBox.visible = Globals.DEBUG_HITBOXES;
			
			costume.visible = false;
			costumeHitBox.visible = false;
			
			displayGroup.add(costume);
			displayGroup.add(costumeHitBox);
			displayGroup.add(headHitBox);
		}
		
		
		override public function update():void
		{
			super.update();
			
			//updatePositions();
			updateSpriteAnimation();
		}
		

		
		override public function draw():void
		{			
			if (costume == null)
			{
				super.draw();
				return;
			}
			
			costume.facing = sprite.facing;
			
			if (costume.facing == FlxObject.DOWN || costume.facing == FlxObject.UP)
			{
				costumeHitBox.makeGraphic(costume.width/2,costume.height/2,Globals.DEBUG_HITBOX_COLOUR);
			}
			else if (costume.facing == FlxObject.LEFT || costume.facing == FlxObject.RIGHT)
			{
				costumeHitBox.makeGraphic(costume.width,costume.height/2,Globals.DEBUG_HITBOX_COLOUR);
			}
			
			if (costume.facing == FlxObject.DOWN)
			{
				costume.frame = 8;
				
				switch(costumeType)
				{
					case Globals.WEDGE:
						costume.x = sprite.x + width/2 - costume.width/2;
						costume.y = sprite.y + 8;				
						break;
					case Globals.NEEDLE:
						costume.x = sprite.x + sprite.width/2 - costume.width/2;
						costume.y = sprite.y;		
				}
			}
			else if (costume.facing == FlxObject.UP)
			{
				costume.frame = 9;
				
				switch(costumeType)
				{
					case Globals.WEDGE:
						costume.x = sprite.x + sprite.width/2 - costume.width/2;
						costume.y = sprite.y + 8;				
						break;
					case Globals.NEEDLE:
						costume.x = sprite.x + sprite.width/2 - costume.width/2;
						costume.y = sprite.y;		
				}
			}
			else if (costume.facing == FlxObject.LEFT)
			{
				costume.frame = sprite.frame;
				if (sprite.frame == 22)
				{
					// Idle frame
					costume.frame = 2;
				}
				
				switch(costumeType)
				{
					case Globals.WEDGE:
						costume.x = sprite.x + sprite.width/2 - costume.width/2;
						costume.y = sprite.y + 8;				
						break;
					case Globals.NEEDLE:
						costume.x = sprite.x + sprite.width/2 - costume.width/2;
						costume.y = sprite.y;		
				}
			}
			else if (costume.facing == FlxObject.RIGHT)
			{
				costume.frame = sprite.frame;
				if (sprite.frame == 22)
				{
					// Idle frame
					costume.frame = 2;
				}
				
				switch(costumeType)
				{
					case Globals.WEDGE:
						costume.x = sprite.x + sprite.width/2 - costume.width/2;
						costume.y = sprite.y + 8;				
						break;
					case Globals.NEEDLE:
						costume.x = sprite.x + sprite.width/2 - costume.width/2 - 4;
						costume.y = sprite.y;		
				}
			}
			
			if (costume.facing == FlxObject.DOWN || costume.facing == FlxObject.UP)
			{
				costumeHitBox.x = costume.x + costume.width/4;
				costumeHitBox.y = costume.y + costume.height/2;
			}
			else if (costume.facing == FlxObject.LEFT || costume.facing == FlxObject.RIGHT)
			{
				costumeHitBox.x = costume.x;
				costumeHitBox.y = costume.y + costume.height/2;
			}
			
			headHitBox.x = sprite.x + 16;
			headHitBox.y = sprite.y + 16;

			super.draw();
		}

		
		
		override protected function updateSpriteAnimation():void
		{
			if (fallen)
			{
				sprite.frame = Assets.FALL_FRAME;
				return;
			}
			
			super.updateSpriteAnimation();
			
			if (velocity.x != 0)
			{
				sprite.play("walking_side");
			}
			else if (velocity.y < 0)
			{
				sprite.play("walking_back");
			}
			else if (velocity.y > 0)
			{
				sprite.play("walking_front");
			}
			else if (sprite.facing == FlxObject.LEFT || sprite.facing == FlxObject.RIGHT)
			{
				sprite.play("idle_side");
			}
			else if (sprite.facing == FlxObject.DOWN)
			{
				sprite.play("idle_front");
			}
			else if (sprite.facing == FlxObject.UP)
			{
				sprite.play("idle_back");
			}
		}
		
		
		public function fall():void
		{
			fallen = true;
			stop();
		}

		
		override public function moveLeft():void
		{
			fallen = false;
			super.moveLeft();
		}
		
		override public function moveRight():void
		{
			fallen = false;
			super.moveRight();
		}
		
		override public function moveUp():void
		{
			fallen = false;
			super.moveUp();
		}
		
		override public function moveDown():void
		{
			fallen = false;
			super.moveDown();
		}
		

		override public function destroy():void
		{
			super.destroy();
			
			if (costume != null)
				costume.destroy();
			
			if (costumeHitBox != null)
				costumeHitBox.destroy();
			
			if (headHitBox != null)
				headHitBox.destroy();
		}	
	}
}
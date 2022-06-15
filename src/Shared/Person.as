package Shared
{
	import org.flixel.*;
	
	public class Person extends Entity
	{
		protected const SPRITE_WIDTH:Number = 56;
		protected const SPRITE_HEIGHT:Number = 140;

		public var X_SPEED:Number = 100;
		public var Y_SPEED:Number = 80;

		public var type:uint;
		
		public var sprite:FlxSprite;

		public function Person(_x:Number, _y:Number, _ss:Class, _facing:uint=FlxObject.RIGHT, _frame:int = -1)
		{
			super(_x,_y);
			
			width = SPRITE_WIDTH;
			height = SPRITE_HEIGHT;
			
			sprite = new FlxSprite(x,y);
			var spriteSheet:Class = _ss;
			sprite.loadGraphic(spriteSheet,true,true,56,140);
			sprite.facing = _facing;
			
			if (_frame != -1)
				sprite.frame = _frame;
			
			var frameRate:uint = 10;
			sprite.addAnimation("walking_side",Assets.SIDE_WALK_FRAMES,frameRate,true);
			sprite.addAnimation("walking_front",Assets.FRONT_WALK_FRAMES,frameRate,true);
			sprite.addAnimation("walking_back",Assets.BACK_WALK_FRAMES,frameRate,true);
			sprite.addAnimation("idle_side",[Assets.SIDE_IDLE_FRAME],0,false);
			sprite.addAnimation("idle_front",[Assets.FRONT_IDLE_FRAME],0,false);
			sprite.addAnimation("idle_back",[Assets.BACK_IDLE_FRAME],0,false);
			
			displayGroup.add(sprite);			
						
			// Hitbox
			hitBox.makeGraphic(Globals.PERSON_HITBOX_WIDTH,Globals.PERSON_HITBOX_HEIGHT,0xAA00FF00);
			hitBox.x = x + width/2 - hitBox.width/2;
			hitBox.y = y + height - hitBox.height;
			hitBox.visible = Globals.DEBUG_HITBOXES;
			
			// Trigger
			triggerZone.makeGraphic(hitBox.width * 2, hitBox.height * 2, 0xAAFF0000);
			triggerZone.x = hitBox.x + hitBox.width/2 - triggerZone.width/2;
			triggerZone.y = hitBox.y + hitBox.height/2 - triggerZone.height/2;
			triggerZone.visible = Globals.DEBUG_HITBOXES;
			
			displayGroup.add(hitBox);
			displayGroup.add(triggerZone);
			
			displayGroup.x = x;
			displayGroup.y = hitBox.y;
		}
		
		
		override public function update():void
		{
			super.update();
			
			updateSpriteAnimation();
		}
		
		
		override public function postUpdate():void
		{
			super.postUpdate();
			
			sprite.x = x;
			sprite.y = y;
			
			hitBox.x = x + width/2 - hitBox.width/2;
			hitBox.y = sprite.y + sprite.height - hitBox.height;
			
			triggerZone.x = hitBox.x + hitBox.width/2 - triggerZone.width/2;
			triggerZone.y = hitBox.y + hitBox.height/2 - triggerZone.height/2;
			
			displayGroup.x = x;
			displayGroup.y = hitBox.y;
		}
		
		
		protected function updateSpriteAnimation():void
		{
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
		
		
		public function moveLeft():void
		{
			
			sprite.facing = FlxObject.LEFT;
			
			if (velocity.x >= 0)
			{
				velocity.x = -X_SPEED;
				velocity.y = 0;
			}
			else
			{
				velocity.x = 0;
			}
		}
		
		
		public function moveRight():void
		{
			sprite.facing = FlxObject.RIGHT;
			
			if (velocity.x <= 0)
			{
				velocity.x = X_SPEED;
				velocity.y = 0;
			}
			else
			{
				velocity.x = 0;
			}
		}
		
		
		public function moveUp():void
		{
			sprite.facing = FlxObject.UP;
			
			if (velocity.y >= 0)
			{
				velocity.y = -Y_SPEED;
				velocity.x = 0;
			}
			else
			{
				velocity.y = 0;
			}
		}
		
		
		public function moveDown():void
		{
			sprite.facing = FlxObject.DOWN;
			
			if (velocity.y <= 0)
			{
				velocity.y = Y_SPEED;
				velocity.x = 0;
			}
			else
			{
				velocity.y = 0;
			}
		}
		
		
		public function stop(face:int = -1):void
		{
			velocity.x = 0;
			velocity.y = 0;
			
			if (face != -1)
			{
				sprite.facing = face;
			}
		}
		
		
		public function undoAndStop():void
		{
			x -= velocity.x * FlxG.elapsed;
			y -= velocity.y * FlxG.elapsed;
			
			velocity.y = 0;
			velocity.x = 0;
			
			updateSpriteAnimation();
		}

		
		override public function destroy():void
		{
			super.destroy();
		}
	}
}
package Gallery
{
	import SaveAndReplay.GalleryArtwork;
	import Shared.Person;
	
	import org.flixel.*;
	
	public class Visitor extends Person
	{
		public var artworkIndex:uint;
		public var previousArtworkIndex:uint;
		public var artworkPosition:Array;
		
		private var likesSnake:Boolean;
		private var likesTetris:Boolean;
		private var likesSpacewar:Boolean;
		
		private var talked:Boolean = false;
		
		private var currentTarget:FlxPoint = new FlxPoint();
		
		public var talkDelayTimer:FlxTimer = new FlxTimer();
		public var targetTimer:FlxTimer = new FlxTimer();
		
		
		private const NO_STATE:uint = 0;
		private const SEEKING_CHANNEL_Y:uint = 1;
		private const SEEKING_CHANNEL_X:uint = 5;
		private const SEEKING_ARTWORK_X:uint = 2;
		private const SEEKING_ARTWORK_Y:uint = 3;
		private const AT_ARTWORK:uint = 4;
		
		private var state:uint = AT_ARTWORK;
		
//		private const VIEWING_TIMES:Array = new Array(2,2);
				private const VIEWING_TIMES:Array = new Array(
					5,10,10,20,20,30,30,45,
					50,50,55,55,60,60,70,70,
					100,100,100,120,120,240,280,
					300,300,300,300);
		//		private const VIEWING_TIMES:Array = new Array(
		//			10,10,15,15,20,20,30,30,
		//			60,60,60,60,60,60,60,60,
		//			100,100,100,120,120,240,280,
		//			300,300,300,300,400,500,600,10000);
		
		public function Visitor(_artworkIndex:int, _type:int = Globals.GENERIC_VISITOR, _startX:Number = -1, _startY:Number = -1)
		{
			type = _type;
			
			var spriteSheet:Class;
			var startX:Number;
			var startY:Number;
			var startFacing:Number;
			
			likesSnake = Math.random() < 0.5;
			likesTetris = Math.random() < 0.5;
			likesSpacewar = Math.random() < 0.5;
			
			if (type != Globals.SPACEWAR_VISITOR)
			{
				trace("... making visitor of type " + type);
				artworkIndex = _artworkIndex;
				previousArtworkIndex = artworkIndex;
				
				var artworkPositionIndex:uint = int(Math.random() * Globals.ARTWORKS[artworkIndex].audiencePositions.length);
				artworkPosition = Globals.ARTWORKS[artworkIndex].audiencePositions.splice(artworkPositionIndex,1)[0];
				
				if (type == Globals.GENERIC_VISITOR)
					spriteSheet = Assets.AUDIENCE_SS[int(Math.random() * Assets.AUDIENCE_SS.length)];
				else if (type == Globals.SNAKE_VISITOR)
					spriteSheet = Assets.SNAKE_ARTIST_WALK_CYCLE_PNG;
				else if (type == Globals.TETRIS_VISITOR)
					spriteSheet = Assets.TETRIS_ARTIST_WALK_CYCLE_PNG;
				
				startX = artworkPosition[0];
				startY = artworkPosition[1] - 140 + 12;
				startFacing = artworkPosition[2];				
			}
			else
			{
				spriteSheet = Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG;
				startX = _startX;
				startY = _startY;
				startFacing = FlxObject.DOWN;
			}
			
			//			trace("Instantiating visitor of type " + type + " with spriteSheet " + spriteSheet + " at " + startX + "," + startY + " and facing " + startFacing);
			
			super(startX,startY,spriteSheet,startFacing);
			
			if (type != Globals.SPACEWAR_VISITOR)
				targetTimer.start(getViewingTime(),1,chooseTarget);
			
			talkDelayTimer.finished = true;
			
			X_SPEED = 70;
			Y_SPEED = 50;
		}
		
		
		override public function update():void
		{
			super.update();
			
			//			trace("currentTarget is: " + currentTarget.x + "," + currentTarget.y + ", state=" + state);
			//			trace("velocity is: " + velocity.x + "," + velocity.y);
			//			
			if (type != Globals.SPACEWAR_VISITOR)
			{
				checkTarget();
			}
		}
		
		
		public function chooseNewTarget():void
		{
			targetTimer.start(Math.random() * 20,1,chooseTarget);	
		}
		
		
		public function chooseTarget(t:FlxTimer):void
		{
			// Give up current target
			Globals.ARTWORKS[artworkIndex].audiencePositions.push(artworkPosition);
			
			previousArtworkIndex = artworkIndex;
			
			var artworkPositions:Array = new Array();
			while (artworkPositions.length == 0)
			{
				if (Globals.VISITOR_DEBUG)
					trace("chooseTarget() finding new artworkPositions");
				artworkIndex = int(Math.random() * Globals.ARTWORKS.length);
				if (Globals.VISITOR_DEBUG)
					trace("... chose index of " + artworkIndex);
				
				// 1. Choose an artwork to view
				while (artworkIndex == previousArtworkIndex)
				{
					if (Globals.VISITOR_DEBUG)
						trace("chooseTarget() finding new artworkIndex");
					artworkIndex = int(Math.random() * Globals.ARTWORKS.length);
					if (Globals.VISITOR_DEBUG)
						trace("... chose new index of " + artworkIndex);
				}
				
//				if (Globals.ARTWORKS[artworkIndex].type == Globals.TETRIS &&
//					Globals.ARTWORKS[previousArtworkIndex].type == Globals.TETRIS)
//				{
//					continue;
//				}
				
				// 2. Choose an audience position to view it from
				artworkPositions = Globals.ARTWORKS[artworkIndex].audiencePositions;
			}
			var artworkPositionIndex:uint = int(Math.random() * Globals.ARTWORKS[artworkIndex].audiencePositions.length);
			artworkPosition = Globals.ARTWORKS[artworkIndex].audiencePositions.splice(artworkPositionIndex,1)[0];
			
			// 3. Now choose a channel to walk along (appropriate to where you're standing
			
			const LOW:uint = 0;
			const HIGH:uint = 1;
			var channel:uint;
			
			if (Globals.ARTWORKS[previousArtworkIndex].type == Globals.TETRIS && 
				hitBox.y < Globals.ARTWORKS[previousArtworkIndex].hitBox.y)
			{
				channel = HIGH;
			}
			else if (Globals.ARTWORKS[previousArtworkIndex].type == Globals.TETRIS && 
				hitBox.y > Globals.ARTWORKS[previousArtworkIndex].hitBox.y)
			{
				channel = LOW;
			}
			else if (Math.random() < 0.4)
			{
				channel = LOW;
			}
			else
			{
				channel = HIGH;
			}
			
			if (channel == HIGH)
			{
				currentTarget.y = Globals.GALLERY_H_CHANNELS_HIGH[int(Math.random() * Globals.GALLERY_H_CHANNELS_HIGH.length)];
			}
			else if (channel == LOW)
			{
				currentTarget.y = Globals.GALLERY_H_CHANNELS_LOW[int(Math.random() * Globals.GALLERY_H_CHANNELS_LOW.length)];	
			}
			else
			{
				if (Globals.VISITOR_DEBUG)
					trace("ERROR: No channel chosen in Visitor.chooseTarget()");
			}
			
			if (hitBox.y < currentTarget.y)
			{
				moveDown();
			}
			else
			{
				moveUp();
			}
			
			state = SEEKING_CHANNEL_Y;
			if (Globals.VISITOR_DEBUG)
				trace("state -> SEEKING_CHANNEL_Y (" + currentTarget.y + ")");
		}
		
		
		private function checkTarget():void
		{
			if (state == SEEKING_CHANNEL_Y)
			{
				// Check if we have arrived
				if (hitBox.y > currentTarget.y - 2 && hitBox.y < currentTarget.y + 2)
				{
					if (Globals.VISITOR_DEBUG)
						trace("checkTarget() - arrived at CHANNEL_Y");
					if (Globals.VISITOR_DEBUG)
						if (Globals.ARTWORKS[artworkIndex].type == Globals.TETRIS &&
							((artworkPosition[1] < Globals.ARTWORKS[artworkIndex].hitBox.y && hitBox.y > Globals.ARTWORKS[artworkIndex].hitBox.y) ||
								(artworkPosition[1] > Globals.ARTWORKS[artworkIndex].hitBox.y && hitBox.y < Globals.ARTWORKS[artworkIndex].hitBox.y)))
						{
							currentTarget.x = Globals.ARTWORKS[artworkIndex].hitBox.x - (1 * Globals.PERSON_HITBOX_WIDTH + 10);
							state = SEEKING_CHANNEL_X;
							if (Globals.VISITOR_DEBUG)
								trace("... SPECIAL CASE -> SEEKING_CHANNEL_X");
						}
						else
						{
							// If so, we need to start moving toward our artwork's X
							currentTarget.x = artworkPosition[0];
							currentTarget.y = artworkPosition[1];
							
							state = SEEKING_ARTWORK_X;
							if (Globals.VISITOR_DEBUG)
								trace("state -> SEEKING_ARTWORK_X(" + currentTarget.x + ")");
						}
					if (hitBox.x < currentTarget.x)
					{
						moveRight();
					}
					else
					{
						moveLeft();
					}
					if (Globals.VISITOR_DEBUG)
					{
						trace("... x,y is " + hitBox.x + "," + hitBox.y);
						trace("... target x,y is " + currentTarget.x + "," + currentTarget.y);
					}
					
				}
			}
			else if (state == SEEKING_CHANNEL_X)
			{
				if (hitBox.x > currentTarget.x - 2 && hitBox.x < currentTarget.x + 2)
				{
					if (Globals.VISITOR_DEBUG)
						trace("... reached CHANNEL_X");
					const HIGH:uint = 0;
					const LOW:uint = 1;
					var channel:uint;
					
					// We have arrived.
					if (hitBox.y < Globals.ARTWORKS[artworkIndex].y)
					{
						moveDown();
						channel = LOW;
					}
					else if (hitBox.y > Globals.ARTWORKS[artworkIndex].y)
					{
						moveUp();
						channel = HIGH;
					}
					
					if (channel == HIGH)
					{
						currentTarget.y = Globals.GALLERY_H_CHANNELS_HIGH[int(Math.random() * Globals.GALLERY_H_CHANNELS_HIGH.length)];
					}
					else if (channel == LOW)
					{
						currentTarget.y = Globals.GALLERY_H_CHANNELS_LOW[int(Math.random() * Globals.GALLERY_H_CHANNELS_LOW.length)];	
					}
					
					state = SEEKING_CHANNEL_Y;
					
					if (Globals.VISITOR_DEBUG)
						trace("state -> SEEKING_CHANNEL_Y");
					
					if (Globals.VISITOR_DEBUG)
					{
						trace("... x,y is " + hitBox.x + "," + hitBox.y);
						trace("... target x,y is " + currentTarget.x + "," + currentTarget.y);
					}
				}
			}
			else if (state == SEEKING_ARTWORK_X)
			{
				if (hitBox.x > currentTarget.x - 2 && hitBox.x < currentTarget.x + 2)
				{
					// We have arrived
					if (Globals.ARTWORKS[artworkIndex].type == Globals.TETRIS)
					{
						if (hitBox.y < Globals.ARTWORKS[artworkIndex].hitBox.y)
						{
							currentTarget.y = Globals.ARTWORKS[artworkIndex].hitBox.y - hitBox.height - 2;
							moveDown();
						}
						else
						{
							currentTarget.y = Globals.ARTWORKS[artworkIndex].hitBox.y + Globals.ARTWORKS[artworkIndex].hitBox.height + 2;
							moveUp();
						}
					}
					else
					{
						moveUp();						
					}
					
					if (Globals.VISITOR_DEBUG)
						trace("state -> SEEKING_ARTWORK_Y(" + currentTarget.y + ")");
					state = SEEKING_ARTWORK_Y;
					
					if (Globals.VISITOR_DEBUG)
					{
						trace("... x,y is " + hitBox.x + "," + hitBox.y);
						trace("... target x,y is " + currentTarget.x + "," + currentTarget.y);
					}
				}
			}
			else if (state == SEEKING_ARTWORK_Y)
			{
				if (hitBox.y > currentTarget.y - 2 && hitBox.y < currentTarget.y + 2)
				{
					// We're here!
					stop();
					state = AT_ARTWORK;
					targetTimer.start(getViewingTime() + (Math.random() * 5),1,chooseTarget);
					
					if (Globals.VISITOR_DEBUG)
						trace("state -> AT_ARTWORK");
				}
			}
		}
		
		
		private function getNewTarget(t:FlxTimer):void
		{
			chooseTarget(null);
		}
		
		
		private function getViewingTime():Number
		{
			return VIEWING_TIMES[int(Math.random() * VIEWING_TIMES.length)];
		}
		
		
		public function handleCollision(_collider:Person):void
		{
			if (state == SEEKING_ARTWORK_X)
			{
				var newTargetY:Number;
				
				// Choose a different channel to walk on to avoid the collision
				// based on where currently on a high or low channel.
				if (hitBox.y > Globals.TETRIS_PLINTH_BOTTOM)
				{
					// We're on a low channel
					newTargetY = currentTarget.y;
					while (newTargetY == currentTarget.y)
					{
						newTargetY = Globals.GALLERY_H_CHANNELS_LOW[int(Math.random() * Globals.GALLERY_H_CHANNELS_LOW.length)];
					}
					currentTarget.y = newTargetY;
					state = SEEKING_CHANNEL_Y;
					
					if (Globals.VISITOR_DEBUG)
						trace("state --> SEEKING_CHANNEL_Y (SEEKING_ARTWORK_X INTERRUPTED)");
					
				}
				else
				{
					// We're on a high channel
					newTargetY = currentTarget.y;
					while (newTargetY == currentTarget.y)
					{
						newTargetY = Globals.GALLERY_H_CHANNELS_HIGH[int(Math.random() * Globals.GALLERY_H_CHANNELS_HIGH.length)];
					}
					currentTarget.y = newTargetY;
					
					state = SEEKING_CHANNEL_Y;
					
					if (Globals.VISITOR_DEBUG)
						trace("state --> SEEKING_CHANNEL_Y (SEEKING_ARTWORK_X INTERRUPTED)");
					
					
				}
				
				if (hitBox.y < currentTarget.y)
				{
					moveDown();
				}
				else
				{
					moveUp();
				}
			}
			else if (state == AT_ARTWORK)
			{
				// If the avatar walked into you from the artwork side, then just leave
				//				if (_collider.type == Globals.AVATAR)
				//				{
				//					if (Globals.ARTWORKS[artworkIndex].type != Globals.TETRIS &&
				//						_collider.hitBox.y - Globals.ARTWORKS[artworkIndex].y < hitBox.y - Globals.ARTWORKS[artworkIndex].y &&
				//						_collider.velocity.y > 0)
				//					{
				//						chooseTarget(null);
				//					}
				//				}
				// Otherwise no need to do anything, just keep enjoying the art
			}
			else if (state == SEEKING_ARTWORK_Y)
			{
				// We were trying to get to our spot, but someone was just leaving (or maybe the avatar fucked us)
				// So we'll just head elsewhere immediately.
				chooseTarget(null);
				
				// And if the person who fucked us by trying to leave at the worst moment is an AI visitor
				// then they can wait a tick and then find somewhere else as well.
				if (_collider.type == Globals.GENERIC_VISITOR || 
					_collider.type == Globals.SNAKE_VISITOR || 
					_collider.type == Globals.TETRIS_VISITOR)
				{
					(_collider as Visitor).pauseAndChooseNewTarget();
				}
			}
			else
			{
				pauseAndChooseNewTarget()
			}
		}
		
		
		public function pauseAndChooseNewTarget():void
		{
			stop();
			
			if (hitBox.y < Globals.TETRIS_PLINTH_BOTTOM)
				this.sprite.facing = FlxObject.UP;
			else
				this.sprite.facing = FlxObject.DOWN;
			
			state = NO_STATE;
			
			targetTimer.start(2 + Math.random() * 5,1,chooseTarget);
		}
		
		
		public function getDialog():String
		{
			if (!talkDelayTimer.finished)
				return null;
			
			talkDelayTimer.start(2 + Math.random() * 2);
			
			if (type == Globals.SPACEWAR_VISITOR && !talked)
			{
				talked = true;
				return "...";
			}
			else if (type == Globals.SPACEWAR_VISITOR && talked)
				return null;
			
			if (type == Globals.TETRIS_VISITOR && !talked)
			{
				talked = true;
				return "It is a great honor to be showing alongside you here. I apologize that I am too overwhelmed to speak further.";
			}
			else if (type == Globals.TETRIS_VISITOR && talked)
				return null;
			
			if (type == Globals.SNAKE_VISITOR && !talked)
			{
				talked = true;
				return "Oh hello, it's nice to meet you! Sorry, I can't talk right now. I'll catch up with you another time.";
			}
			else if (type == Globals.SNAKE_VISITOR && talked)
				return null
			
			if (state == AT_ARTWORK)
			{
				if (Globals.ARTWORKS[artworkIndex].type == Globals.TETRIS)
				{
					if (likesTetris)
					{
						if (Math.random() < 0.8)
							return Assets.tetrisTalkPositive[int(Math.random() * Assets.tetrisTalkPositive.length)];
						else if (Math.random() < 0.6)
							return Assets.genericTalkPositive[int(Math.random() * Assets.genericTalkPositive.length)];
						else
							return Assets.genericTalkNeutral[int(Math.random() * Assets.genericTalkNeutral.length)];
					}
					else
					{
						if (Math.random() < 0.8)
							return Assets.tetrisTalkNegative[int(Math.random() * Assets.tetrisTalkNegative.length)];
						else if (Math.random() < 0.6)
							return Assets.genericTalkNegative[int(Math.random() * Assets.genericTalkNegative.length)];
						else
							return Assets.genericTalkNeutral[int(Math.random() * Assets.genericTalkNeutral.length)];
					}					
				}
				
				if (Globals.ARTWORKS[artworkIndex].type == Globals.SNAKE)
				{
					if (likesSnake)
					{
						if (Math.random() < 0.8)
							return Assets.snakeTalkPositive[int(Math.random() * Assets.snakeTalkPositive.length)];
						else if (Math.random() < 0.6)
							return Assets.genericTalkPositive[int(Math.random() * Assets.genericTalkPositive.length)];
						else
							return Assets.genericTalkNeutral[int(Math.random() * Assets.genericTalkNeutral.length)];
					}
					else
					{
						if (Math.random() < 0.8)
							return Assets.snakeTalkNegative[int(Math.random() * Assets.snakeTalkNegative.length)];
						else if (Math.random() < 0.6)
							return Assets.genericTalkNegative[int(Math.random() * Assets.genericTalkNegative.length)];
						else
							return Assets.genericTalkNeutral[int(Math.random() * Assets.genericTalkNeutral.length)];
					}					
				}
				
				if (Globals.ARTWORKS[artworkIndex].type == Globals.SPACEWAR)
				{
					if (likesSpacewar)
					{
						if (Math.random() < 0.8)
							return Assets.spacewarTalkPositive[int(Math.random() * Assets.spacewarTalkPositive.length)];
						else if (Math.random() < 0.6)
							return Assets.genericTalkPositive[int(Math.random() * Assets.genericTalkPositive.length)];
						else
							return Assets.genericTalkNeutral[int(Math.random() * Assets.genericTalkNeutral.length)];
					}
					else
					{
						if (Math.random() < 0.8)
							return Assets.spacewarTalkNegative[int(Math.random() * Assets.spacewarTalkNegative.length)];
						else if (Math.random() < 0.6)
							return Assets.genericTalkNegative[int(Math.random() * Assets.genericTalkNegative.length)];
						else
							return Assets.genericTalkNeutral[int(Math.random() * Assets.genericTalkNeutral.length)];
					}					
				}
			}
			
			return Assets.genericExcuses[int(Math.random() * Assets.genericExcuses.length)];
		}
		
		
		override public function destroy():void
		{
			super.destroy();
			
			talkDelayTimer.destroy();
			targetTimer.destroy();
		}
	}
}
package Making
{
	
	import Shared.Cookie;
	import Shared.HelpPopup;
	import SaveAndReplay.*;
	import Shared.Helpers;
	
	import Studio.SnakeStudioState;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTimer;
	
	public class SnakeState extends FlxState
	{
		private const TILE_SIZE:uint = 32;
		private const SEGMENTS_PER_FRUIT:uint = 5;
		
		
		private var head:FlxSprite;
		private var body:FlxGroup;
		
		private var fruit:FlxSprite;
		
		private var speed:uint;
		private var segmentsToAdd:uint = 0;
		
		private var help:HelpPopup;
		private var helpTimer:FlxTimer;
		
		private const HELP:uint = 0;
		private const PLAY:uint = 1;
		private const END:uint = 2;
		private var state:uint = PLAY;
		
		private var elapsed:Number = 0;
		
		private var commands:Array = new Array();
		
		public function SnakeState()
		{
		}
		
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xFFDDDDDD;
			
			speed = 50;
			
			head = new FlxSprite(10 * TILE_SIZE,10 * TILE_SIZE);
			head.makeGraphic(TILE_SIZE,TILE_SIZE,Globals.SNAKE_HEAD_COLOUR);
			head.facing = FlxObject.RIGHT;
			
			body = new FlxGroup();
			for (var i:uint = 0; i < Globals.SNAKE_START_LENGTH; i++)
				body.add(new FlxSprite(head.x - (i + 1)*TILE_SIZE,head.y).makeGraphic(TILE_SIZE,TILE_SIZE,Globals.SNAKE_BODY_COLOUR));
			
			fruit = new FlxSprite(
				(Math.floor(Math.random() * FlxG.width / TILE_SIZE)) * TILE_SIZE,
				(Math.floor(Math.random() * FlxG.height / TILE_SIZE)) * TILE_SIZE);
			fruit.makeGraphic(TILE_SIZE,TILE_SIZE,Globals.SNAKE_FRUIT_COLOUR);
			
			add(fruit);
			add(head);
			add(body);
			
			help = new HelpPopup("USE " + Globals.P1_MOVEMENT_KEYS_STRING + " TO PAINT\nPRESS [ESCAPE] TO CANCEL PAINTING",FlxObject.DOWN,true);
			add(help);
			help.setVisible(true);		
			
			moveFruit();

			FlxG.flash(0xFF000000,2);
		}
		
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.ESCAPE) Helpers.resetGame();

			if (state == HELP)
			{
//				handleHelpInput();
			}
			else if (state == PLAY)
			{
				elapsed += FlxG.elapsed;
				
				if (head.alive)
				{
					handleInput();
					
					if (elapsed >= 0.04)
					{
						elapsed = 0;
						checkFruit();
						move();
						checkDeath();
					}
				}
			}
			else if (state == END)
			{
				
			}
		}
		
		
//		private function handleHelpInput():void
//		{
//			if (FlxG.keys.justPressed(Globals.P1_ACTION_KEY))
//			{
//				helpOverlay.setVisible(false);
//				state = PLAY;
//			}
//		}
//		
		
		private function handleInput():void
		{
			if (helpTimer == null && 
				(FlxG.keys.justPressed(Globals.P1_LEFT_KEY) ||
					FlxG.keys.justPressed(Globals.P1_RIGHT_KEY) ||
					FlxG.keys.justPressed(Globals.P1_UP_KEY) ||
					FlxG.keys.justPressed(Globals.P1_DOWN_KEY)))
			{
				helpTimer = new FlxTimer();
				helpTimer.start(2,1,turnOffHelp);
			}

			if (FlxG.keys.justPressed(Globals.P1_UP_KEY))
			{
				commands.push(FlxObject.UP);
			}
			else if (FlxG.keys.justPressed(Globals.P1_DOWN_KEY))
			{
				commands.push(FlxObject.DOWN);
			}
			else if (FlxG.keys.justPressed(Globals.P1_LEFT_KEY))
			{
				commands.push(FlxObject.LEFT);
			}
			else if (FlxG.keys.justPressed(Globals.P1_RIGHT_KEY))
			{
				commands.push(FlxObject.RIGHT);
			}	
			
			if (FlxG.keys.pressed(Globals.ESCAPE_KEY))
			{
				Cookie.studioSaveObject.latest = null;
				Cookie.flush();
				FlxG.fade(0xFF000000,1,goToStudio);
			}
		}
		
		
		private function turnOffHelp(t:FlxTimer):void
		{
			help.setVisible(false);
		}
		

		private function move():void
		{	
			var moveX:int = 0;
			var moveY:int = 0;
			
			var command:uint = head.facing;
			
			while ( commands.length != 0 )
			{
				command = commands.pop();
				
				if (legalCommand(command))
					break;
				else 
					command = head.facing;
			}
			
			head.facing = command;
			
			switch (head.facing)
			{
				case FlxObject.RIGHT:
					moveX = TILE_SIZE;
					break;
				case FlxObject.LEFT:
					moveX = -TILE_SIZE;
					break;
				case FlxObject.UP:
					moveY = -TILE_SIZE;
					break;
				case FlxObject.DOWN:
					moveY = TILE_SIZE;
					break;
			}
			
			
			var nextX:Number = head.x;
			var nextY:Number = head.y;
			
			head.x += moveX;
			head.y += moveY;			
			
			if (head.x < 0 || head.x >= FlxG.width)
				head.x = (FlxG.width - Math.abs(head.x));
			if (head.y < 0 || head.y >= FlxG.height)
				head.y = (FlxG.height - Math.abs(head.y));
			
			
			for (var i:int = 0; i < body.members.length; i++)
			{
				if (body.members[i] == null || !body.members[i].active)
					continue;
				
				var tempX:Number = body.members[i].x;
				var tempY:Number = body.members[i].y;
				
				body.members[i].x = nextX;
				body.members[i].y = nextY;
				
				nextX = tempX;
				nextY = tempY;
			}
			
			if (segmentsToAdd > 0)
			{
				body.add(new FlxSprite(nextX,nextY).makeGraphic(TILE_SIZE,TILE_SIZE,Globals.SNAKE_BODY_COLOUR));
				segmentsToAdd--;
			}
		}
		
		
		private function legalCommand(command:uint):Boolean
		{
			if (command == head.facing) 
			{
				return false;
			}
			if (command == FlxObject.UP && head.facing == FlxObject.DOWN)
			{
				return false;
			}
			if (command == FlxObject.DOWN && head.facing == FlxObject.UP)
			{
				return false;
			}
			if (command == FlxObject.LEFT && head.facing == FlxObject.RIGHT)
			{
				return false;
			}
			if (command == FlxObject.RIGHT && head.facing == FlxObject.LEFT)
			{
				return false;
			}
			
			return true;

		}
		
		private function checkFruit():void
		{
			if (head.x == fruit.x && head.y == fruit.y)
			{
				moveFruit();
				segmentsToAdd += SEGMENTS_PER_FRUIT;
			}
		}
		
		
		private function moveFruit():void
		{
			var fruitNotPlaced:Boolean = true;
			
			while (fruitNotPlaced)
			{
				// Check if there is room for the fruit
				if (body.length >= ((FlxG.width / TILE_SIZE) * (FlxG.height / TILE_SIZE)))
				{
					trace("Fruit placement: BODY FILLS THE SCREEN");
					fruit.x = 0;
					fruit.y = 0;
					fruitNotPlaced = false;
					continue;
				}
				// Check if the fruit is under the head
				if (fruit.x == head.x && fruit.y == head.y)
				{
					trace("Fruit placement: FRUIT UNDER HEAD");
					fruit.x = int(Math.random() * (FlxG.width / TILE_SIZE) - 1) * TILE_SIZE;
					fruit.y = int(Math.random() * (FlxG.height / TILE_SIZE) - 1) * TILE_SIZE;
					continue;
				}
				// Check if the fruit is under the body
				for (var i:uint = 0; i < body.members.length; i++)
				{
					if (body.members[i] != null && body.members[i].alive)
					{
						if (fruit.x == body.members[i].x && fruit.y == body.members[i].y)
						{
							trace("Fruit placement: FRUIT UNDER BODY");
							fruit.x = int(Math.random() * (FlxG.width / TILE_SIZE) - 1) * TILE_SIZE;
							fruit.y = int(Math.random() * (FlxG.height / TILE_SIZE) - 1) * TILE_SIZE;
							continue;
						}
					}
				}
				// Check if the fruit is under the help popup
				if (help.buffer.visible)
				{
					if (fruit.y + fruit.height >= FlxG.height - help.buffer.height)
					{
						trace("Fruit placement: FRUIT UNDER HELP");
						fruit.x = int(Math.random() * (FlxG.width / TILE_SIZE) - 1) * TILE_SIZE;
						fruit.y = int(Math.random() * (FlxG.height / TILE_SIZE) - 1) * TILE_SIZE;
						continue;
					}
				}
				
				fruitNotPlaced = false;
			}
		}
		
		
		private function checkDeath():void
		{
			if (collision())
			{
				state = END;
				endGame();				
			}
		}
		
		
		private function collision():Boolean
		{
			for (var i:int = 0; i < body.members.length; i++)
			{
				if (body.members[i] != null &&
					body.members[i].active && 
					(body.members[i].x == head.x) &&
					(body.members[i].y == head.y))
					return true;
			}
			
			return false;
		}
		
		
		private function endGame():void
		{
			Cookie.load();
			//			Cookie.erase();
			//			Cookie.flush();
			//			Cookie.load();
			
			Cookie.studioSaveObject.type = Globals.SNAKE;
			
			head.alive = false;
			
			var snakeSave:SnakeSave = new SnakeSave();
			var date:Date = new Date();
			snakeSave.save("Untitled", date.fullYear.toString(), TILE_SIZE, head, body, fruit);
						snakeSave.print();
			
			Cookie.studioSaveObject.latest = snakeSave;
			Cookie.state = Globals.DECISION_STATE; //DECISION;
			
			Cookie.flush();	
			
			FlxG.fade(0xFF000000,1,goToStudio);
		}
		
		private function goToStudio():void
		{
			FlxG.switchState(new SnakeStudioState);	
		}
		
		
		override public function destroy():void
		{
			head.destroy();
			body.destroy();
			fruit.destroy();
			help.destroy();
			if (helpTimer != null) helpTimer.destroy();
			
			
			super.destroy();
		}
	}
}
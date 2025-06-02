package SaveAndReplay
{
	
	import org.flixel.*;
	import Shared.Entity;

	
	public class Artwork extends Entity
	{
		protected const STUDIO:uint = 0;
		protected const GALLERY:uint = 1;
		
		public var id:uint;
		public var style:uint;
		public var type:uint;
		public var tileSize:Number;
		public var scale:Number;
		public var info:Object;		
				
		public function Artwork(_x:Number = 0, _y:Number = 0)
		{
			super(_x,_y);
		}
		
		public function createFromSaveObject(_x:Number, _y:Number, _tileSize:Number, _save:Object, _framed:Boolean = true):void
		{
			type = _save.type;
			tileSize = _tileSize;
			scale = _tileSize/_save.tileSize;
			info = _save.info;
			
			x = _x;
			y = _y;
			
			if (type == Globals.TETRIS)
			{
				setupAsTetris(_x,_y,_tileSize,_save);
			}
			else if (type == Globals.SNAKE)
			{
				setupAsSnake(_x,_y,_tileSize,_save,_framed);
			}
			else if (type == Globals.SPACEWAR)
			{
				setupAsSpacewar(_x,_y,_tileSize,_save);
			}
		}
		

		protected function setupAsSnake(_x:Number, _y:Number, _tileSize:Number, _save:Object, _framed:Boolean = true):void
		{
			x = _x;
			y = _y;
			tileSize = _tileSize;
			
			var scale:Number = _tileSize/_save.tileSize;
			
			var bgSprite:FlxSprite = displayGroup.recycle(FlxSprite) as FlxSprite;
			bgSprite.x = _x;
			bgSprite.y = _y;
			bgSprite.makeGraphic(scale * FlxG.width, scale * FlxG.height, 0xFFFFFFFF);
			bgSprite.revive();
			
			var headSprite:FlxSprite = displayGroup.recycle(FlxSprite) as FlxSprite;
			headSprite.x = _x + (_save.head.x * scale);
			headSprite.y = _y + (_save.head.y * scale);
			headSprite.makeGraphic(_tileSize, _tileSize, Globals.SNAKE_HEAD_COLOUR);
			headSprite.revive();
			
			var fruitSprite:FlxSprite = displayGroup.recycle(FlxSprite) as FlxSprite;
			fruitSprite.x = _x + (_save.fruit.x * scale);
			fruitSprite.y = _y + (_save.fruit.y * scale);
			fruitSprite.makeGraphic(_tileSize, _tileSize, Globals.SNAKE_FRUIT_COLOUR);
			fruitSprite.revive();
			
			for (var i:uint = 0; i < _save.body.length; i++)
			{
				var bodySprite:FlxSprite = displayGroup.recycle(FlxSprite) as FlxSprite;
				bodySprite.x = _x + (_save.body[i].x * scale);
				bodySprite.y = _y + (_save.body[i].y * scale);
				bodySprite.makeGraphic(_tileSize, _tileSize, Globals.SNAKE_BODY_COLOUR);
				bodySprite.revive();
				bodySprite.visible = true;
			}
		}
		
		
		protected function setupAsSpacewar(_x:Number, _y:Number, _tileSize:Number, _save:Object):void
		{
			x = _x;
			y = _y;
			tileSize = _tileSize;
						
			var bg:FlxSprite = displayGroup.recycle(FlxSprite) as FlxSprite;
			bg.revive();
			bg.x = x;
			bg.y = y;
			bg.makeGraphic(FlxG.width * scale, FlxG.height * scale, 0xFF555555);
			
			var spacewarPlaybackGroup:SpacewarPlaybackGroup = displayGroup.recycle(SpacewarPlaybackGroup) as SpacewarPlaybackGroup;
			spacewarPlaybackGroup.revive();
			spacewarPlaybackGroup.setup(x,y,scale,FlxG.width * scale,FlxG.height * scale,_save.data);
		}
		
		
		protected function setupAsTetris(_x:Number, _y:Number, _tileSize:Number, _save:Object):void
		{
			x = _x;
			y = _y;	
			tileSize = _tileSize;
			
			width = _save.tetrominoes[0].length * _tileSize;
			height = _save.tetrominoes.length * _tileSize;
						
			var sprite:FlxSprite;
			
			for (var i:int = _save.tetrominoes.length - 1; i >= 0; i--)
			{
				for (var j:uint = 0; j < _save.tetrominoes[i].length; j++)
				{
					if (_save.tetrominoes[i][j] == 1)
					{
						sprite = new FlxSprite(x + (j * _tileSize), y - ((_save.tetrominoes.length - 1 - i) * _tileSize));
						sprite.makeGraphic(_tileSize, _tileSize, Globals.TETRIS_BLOCK_COLOUR);
						displayGroup.add(sprite);
					}
				}
			}	
			
			//displayGroup.y = y + height - 140;
			displayGroup.visible = true;
		}
		
		
		public function updateDisplayGroup(_save:Object):void
		{
			if (type == Globals.SNAKE)
			{
				displayGroup.callAll("kill");
				setupAsSnake(x,y,tileSize,_save);
			}
			else if (type == Globals.TETRIS)
			{
				displayGroup.callAll("kill");
				setupAsTetris(x,y,tileSize,_save);
			}
			else if (type == Globals.SPACEWAR)
			{
				displayGroup.kill();
				displayGroup.revive();
				setupAsSpacewar(x,y,tileSize,_save);
			}
		}
		
	}
}
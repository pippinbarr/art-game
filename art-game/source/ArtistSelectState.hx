package
{
	import Shared.*;
	import Curation.*;
	import Studio.*;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.flixel.*;
	
	public class ArtistSelectState extends FlxState
	{
		private var chooseText:FlxText;
		private var artistMenu:SelectionMenu;
		private var artistOptions:Array;
		
		private var snakeArtist:Artist;
		private var tetrisArtist:Artist;
		private var spacewarArtist1:Artist;
		private var spacewarArtist2:Artist;
		
		private var bioText:FlxText;
		
		private var inputDelay:FlxTimer = new FlxTimer();
		
		private var artistSelectMenuHelp:HelpPopup;
		
		public function ArtistSelectState()
		{
		}
		
		
		override public function create():void
		{
			super.create();
			
			Cookie.load();
			
			FlxG.bgColor = 0xFFAAAAAA;
			
			chooseText = new FlxText(0,0,FlxG.width,"CHOOSE YOUR ARTIST");
			chooseText.setFormat("Commodore",32,0x000000,"center");
			add(chooseText);
			
			artistOptions = new Array();
			artistOptions.push(Globals.SNAKE_ARTIST + " (1 PLAYER)");
			artistOptions.push(Globals.TETRIS_ARTIST + " (1 PLAYER)");
			artistOptions.push(Globals.SPACEWAR_ARTIST + " (2 PLAYERS)");
			artistMenu = new SelectionMenu(350,FlxG.width - 100,artistOptions,false);	
			
			artistMenu.enable();
			add(artistMenu);
			
			bioText = new FlxText(100,220,FlxG.width - 200,"");
			bioText.setFormat("Commodore",14,0x000000,"center");
			bioText.text = Globals.SNAKE_ARTIST_BIO;
			add(bioText);
			
			snakeArtist = new Artist(FlxG.width/2 - 56/2, 60, Assets.SNAKE_ARTIST_WALK_CYCLE_PNG, FlxObject.DOWN);
			snakeArtist.displayGroup.visible = true;
			snakeArtist.sprite.frame = 14;
			tetrisArtist = new Artist(FlxG.width/2 - 56/2, 60, Assets.TETRIS_ARTIST_WALK_CYCLE_PNG, FlxObject.DOWN);
			tetrisArtist.displayGroup.visible = false;
			tetrisArtist.sprite.frame = 14;
			spacewarArtist1 = new Artist(FlxG.width/2 - 50 - 56/2, 60, Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG, FlxObject.DOWN);
			spacewarArtist2 = new Artist(FlxG.width/2 + 50 - 56/2, 60, Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG, FlxObject.DOWN);
			spacewarArtist1.sprite.frame = 14;
			spacewarArtist2.sprite.frame = 14;
			spacewarArtist1.displayGroup.visible = false;
			spacewarArtist2.displayGroup.visible = false;
			
			add(snakeArtist.displayGroup);
			add(tetrisArtist.displayGroup);
			add(spacewarArtist1.displayGroup);
			add(spacewarArtist2.displayGroup);
			
			artistSelectMenuHelp = new HelpPopup("USE [UP AND DOWN] AND [ENTER] TO SELECT AN ARTIST");
			add(artistSelectMenuHelp);
			artistSelectMenuHelp.setVisible(true);

		}
		
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.ESCAPE) Helpers.resetGame();

// TODO: Make sure they can't use menu during fade		
			if (artistMenu.enabled)
				handleMenuInput();
		}
		
		
		public function handleMenuInput():void
		{
			if (artistMenu.selection == 0)
			{
				snakeArtist.displayGroup.visible = true;
				tetrisArtist.displayGroup.visible = false;
				spacewarArtist1.displayGroup.visible = false;
				spacewarArtist2.displayGroup.visible = false;
				bioText.text = Globals.SNAKE_ARTIST_BIO;
				if (artistMenu.selected)
				{
					Cookie.erase();
					Cookie.flush();
					Cookie.load();
					
					//Cookie.state = Globals.NO_STATE;
					Cookie.moveHelpSeen = false;

					Cookie.type = Globals.SNAKE;
					Cookie.state = Globals.CURATOR_INTRO_STATE;
					Cookie.flush();
					
					artistMenu.enabled = false;
					artistSelectMenuHelp.setVisible(false);
					FlxG.fade(0xFF000000,1,newSnakeGame);
				}
			}
			else if (artistMenu.selection == 1)
			{
				snakeArtist.displayGroup.visible = false;
				tetrisArtist.displayGroup.visible = true;
				spacewarArtist1.displayGroup.visible = false;
				spacewarArtist2.displayGroup.visible = false;
				bioText.text = Globals.TETRIS_ARTIST_BIO;
				if (artistMenu.selected)
				{
					Cookie.erase();
					Cookie.flush();
					Cookie.load();
					
					//Cookie.state = Globals.NO_STATE;
					Cookie.moveHelpSeen = false;

					Cookie.type = Globals.TETRIS;
					Cookie.state = Globals.CURATOR_INTRO_STATE;
					Cookie.flush();
					
					artistMenu.enabled = false;
					artistSelectMenuHelp.setVisible(false);
					FlxG.fade(0xFF000000,1,newTetrisGame);
				}
			}
			else if (artistMenu.selection == 2)
			{
				snakeArtist.displayGroup.visible = false;
				tetrisArtist.displayGroup.visible = false;
				spacewarArtist1.displayGroup.visible = true;
				spacewarArtist2.displayGroup.visible = true;
				bioText.text = Globals.SPACEWAR_ARTIST_BIO;
				if (artistMenu.selected)
				{
					Cookie.erase();
					Cookie.flush();
					Cookie.load();
					
					//Cookie.state = Globals.NO_STATE;
					Cookie.moveHelpSeen = false;

					Cookie.type = Globals.SPACEWAR;
					Cookie.state = Globals.CURATOR_INTRO_STATE;
					Cookie.flush();
					
					artistMenu.enabled = false;
					
					artistSelectMenuHelp.setVisible(false);
					FlxG.fade(0xFF000000,1,newSpacewarGame);
				}
			}

		}
		
		private function newSnakeGame():void
		{
			FlxG.switchState(new SnakeCuratorState);
		}
		
		
		private function newTetrisGame():void
		{
			FlxG.switchState(new TetrisCuratorState);
		}
		
		private function newSpacewarGame():void
		{
			FlxG.switchState(new SpacewarCuratorState);
		}

		
		override public function destroy():void
		{
			super.destroy();
			
			chooseText.destroy();
			artistMenu.destroy();			
			snakeArtist.destroy();
			tetrisArtist.destroy();
			spacewarArtist1.destroy();
			spacewarArtist2.destroy();
						
			bioText.destroy();
			
			artistSelectMenuHelp.destroy();
		}
	}
}
package
{
	import Shared.*;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.flixel.*;
	import SaveAndReplay.*;

	public class EndState extends FlxState
	{
		private const PLAYER_STARS:uint = 0;;
		private const PLAYER_GOOD:uint = 1;
		private const PLAYER_DISAPPOINTING:uint = 2;
		private const PLAYER_NOT_INCLUDED:uint = 3;
		
		private var result:uint;
		
		private var artwork:StudioArtwork;
		
		private var af_bg:FlxSprite;
		private var af_frameout:FlxSprite;
		private var af_text:FlxSprite;
		
		private var coverGroup:FlxGroup;
		
		private var gameOverText:FlxText;
		private var text:FlxText;
		private var helpTimer:FlxTimer = new FlxTimer();
		
		private var playerArtistName:String;
		private var exhibitionStarType:int;
		private var exhibitionStarName:String;
		private var exhibitionName:String;
				
		private var help:HelpPopup;
		
		public function EndState()
		{
		}
		
		
		override public function create():void
		{
			super.create();
			
			Cookie.load();
			
			
			gameOverText = new FlxText(0,10,FlxG.width,"GAME OVER",true);
			gameOverText.setFormat("Commodore",36,0xFF000000,"center");
			
			
			if (Cookie.type == Globals.SPACEWAR)
			{
				FlxG.bgColor = 0xFFBBBBBB;
			}
			else
			{
				FlxG.bgColor = 0xFFBBBBBB;
			}
//			
//			if (Cookie.saveObject.saves.length != 0)
//			{
//				if (Cookie.type == Globals.SNAKE)
//				{
//					makeSnakeCover();
//				}
//				else if (Cookie.type == Globals.TETRIS)
//				{
//					makeTetrisCover();
//				}
//				else if (Cookie.type == Globals.SPACEWAR)
//				{
//					makeSpacewarCover();
//				}
//			}
			
			
			setupExhibitionResults();
			
			Cookie.erase();
			Cookie.flush();
			
			FlxG.flash(0xFF000000,2);
			
			add(gameOverText);
			
			help = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " TO RETURN TO MENU");
			helpTimer.start(10,1,showHelp);
		}
		
		
		private function showHelp(t:FlxTimer):void
		{
			help.setVisible(true);
		}
		
		
		private function setupExhibitionResults():void
		{
			
			var finalText:String;
			
			if (Cookie.type == Globals.SPACEWAR)
			{
				playerArtistName = Globals.SPACEWAR_ARTIST;
			}
			else if (Cookie.type == Globals.SNAKE)
			{
				playerArtistName = Globals.SNAKE_ARTIST;
			}
			else if (Cookie.type == Globals.TETRIS)
			{
				playerArtistName = Globals.TETRIS_ARTIST;
			}
			
			var notIncludedStrings:Array = new Array(
				"\"... the late non-inclusion of " + playerArtistName + " has this critic somewhat confused, unsure of whether to fault the curation or the work produced ...\" (p.22)",
				"\"... the surprising absence of work by " + playerArtistName + " was perhaps the most startling element of the show ...\" (p.23)",
				"\"... and yet equally sensational was the bizarre flame-out of " + playerArtistName + ", whose work was not even included in the show ...\" (p.44)",
				"\"... but I, for one, was disappointed in the shocking curatorial decision to exclude " + playerArtistName + " from the final show ...\" (p.18)",
				"\"... the fact that " + playerArtistName + " did not appear in the final show was not, perhaps, all that surprising ...\" (p.19)"
			);
			var starStrings:Array = new Array(
				"\"... critics were overwhelmed by the powerful work of " + playerArtistName + ", claiming it may present a new high-point in an already formidable career ...\" (p.23)",
				"\"... but best of all was the work of " + playerArtistName + ", which shook many of us present at the opening to our very cores ...\" (p.25)",
				"\"... unsurprisingly, perhaps, it was the work of " + playerArtistName + " that brought the show together and gave it its thematic core ...\" (p.17)",
				"\"... " + playerArtistName + " absolutely stole the show, making an undeniable claim for more worldwide attention ...\" (p.21)",
				"\"... with " + playerArtistName + " provided truly unforgettable work, invigorating what was otherwise a show playing it fairly safe ...\" (p.29)"
			);
			var alsoRanStrings:Array = new Array(
				"\"... also loved the work of " + playerArtistName + ", which quietly won a lot of attention from the sophisticated crowd at the opening event ...\" (p.41)",
				"\"... the work by " + playerArtistName + " was also magnificent and served as a wonderful counter-point ...\" (p.28)",
				"\"... and there was also much to like from " + playerArtistName + ", who had a strong if not overwhelming showing ...\" (p.31)",
				"\"... while not the sensation of the show, the work of " + playerArtistName + " was also quite moving ...\" (p.33)",
				"\"... and the work of " + playerArtistName + " also showed considerable subtlety and breadth of intelligence ...\" (p.34)"
			);
			var disappointingStrings:Array = new Array(
				"\"... one surprise was the forgettable work from " + playerArtistName + " who many had expected to be the major force in the exhibition ...\" (p.21)",
				"\"... it was almost embarrassing to see the work of " + playerArtistName + " fading into the background against stronger surrounding pieces ...\" (p.28)",
				"\"... while this critic is an avowed fan of " + playerArtistName + ", the work on display was not of particularly high quality ...\" (p.38)",
				"\"... meanwhile, the work from " + playerArtistName + " simply couldn't compare to the stronger showings of the other artists ...\" (p.19)",
				"\"... sadly, the work from " + playerArtistName + " looked almost out of place in an otherwise high-powered show ...\" (p.15)"
			);

			
			if (Cookie.saveObject.saves.length == 0)
			{
				trace("NO SAVES...");
				
				// Establish the exhibition name (just pick a random one, since it can't have been the player's
				exhibitionName = Assets.artworkTitles[Math.floor(Math.random() * Assets.artworkTitles.length)];
				
				// Establish the star of the exhibition (can't be the player's type)
				exhibitionStarType = Cookie.type;
				
				while (exhibitionStarType == Cookie.type)
					exhibitionStarType = 1 + Math.floor(Math.random() * 3);
				
				trace("EXHIBITION STAR TYPE IS " + exhibitionStarType);
				
				if (exhibitionStarType == Globals.SNAKE)
					makeSnakeCover();
				else if (exhibitionStarType == Globals.TETRIS)
					makeTetrisCover();
				else if (exhibitionStarType == Globals.SPACEWAR)
					makeSpacewarCover();
				
				// Establish the name of the star of the exhibition
				if (exhibitionStarType == Globals.SNAKE)
					exhibitionStarName = Globals.SNAKE_ARTIST;
				else if (exhibitionStarType == Globals.TETRIS)
					exhibitionStarName = Globals.TETRIS_ARTIST;
				else if (exhibitionStarType == Globals.SPACEWAR)
					exhibitionStarName = Globals.SPACEWAR_ARTIST;
				
				// They failed utterly
				finalText = notIncludedStrings[int(Math.random() * notIncludedStrings.length)];				
			}
			else
			{
				// Establish the exhibition name (just taking the first player work for now)
				// Should make this more sophisticated to avoid shows called Untitled
				exhibitionName = Cookie.saveObject.saves[0].info.title;
				
				// They had work
				if (Math.random() < 0.3 * Cookie.saveObject.saves.length)
				{
					if (Cookie.type == Globals.SNAKE)
						makeSnakeCover();
					else if (Cookie.type == Globals.TETRIS)
						makeTetrisCover();
					else if (Cookie.type == Globals.SPACEWAR)
						makeSpacewarCover();

					// They were the main event
					finalText = starStrings[int(Math.random() * starStrings.length)];				
				}
				else if (Math.random() < 0.4 * Cookie.saveObject.saves.length)
				{
					// Establish the star of the exhibition (can't be the player's type)
					exhibitionStarType = Cookie.type;
					while (exhibitionStarType == Cookie.type)
						exhibitionStarType = 1 + Math.floor(Math.random() * 3);
					
					if (exhibitionStarType == Globals.SNAKE)
						makeSnakeCover();
					else if (exhibitionStarType == Globals.TETRIS)
						makeTetrisCover();
					else if (exhibitionStarType == Globals.SPACEWAR)
						makeSpacewarCover();

					// They were notable
					finalText = alsoRanStrings[int(Math.random() * alsoRanStrings.length)];				
				}
				else
				{
					// Establish the star of the exhibition (can't be the player's type)
					exhibitionStarType = Cookie.type;
					while (exhibitionStarType == Cookie.type)
						exhibitionStarType = 1 + Math.floor(Math.random() * 3);
					
					if (exhibitionStarType == Globals.SNAKE)
						makeSnakeCover();
					else if (exhibitionStarType == Globals.TETRIS)
						makeTetrisCover();
					else if (exhibitionStarType == Globals.SPACEWAR)
						makeSpacewarCover();

					// They were forgettable
					finalText = disappointingStrings[int(Math.random() * disappointingStrings.length)];	
				}
			}
			
			text = new FlxText(50,370,FlxG.width - 100,finalText);
			text.setFormat("Commodore",14,0xFF000000,"center");
			
			add(text);
		}
		
		
		private function makeSnakeCover():void
		{
			trace("MAKING SNAKE COVER...");
			if (Cookie.type == Globals.SNAKE)
			{				
				af_bg = new FlxSprite(0,0,Assets.ARTFORUM_BG_WHITE_PNG);
				add(af_bg);
				
				// Make from one of their works
				artwork = new StudioArtwork();
				artwork.createFromSaveObject(140,65,18,Cookie.saveObject.saves[0],false);
				
				add(artwork.displayGroup);
				
				af_frameout = new FlxSprite(0,0,Assets.ARTFORUM_FRAMEOUT_PNG);
				add(af_frameout);
				
				af_text = new FlxSprite(0,0,Assets.ARTFORUM_COVER_TEXT_BLACK_PNG);
				add(af_text);
			}
			else
			{
				// Make from one of the AI snake works
				af_bg = new FlxSprite(0,0,Assets.ARTFORUM_BG_WHITE_PNG);
				add(af_bg);
				
				var save:SnakeSave = new SnakeSave();
				save.createFromArrays("","",32,Assets.snakeWorks[0][0],Assets.snakeWorks[0][1],Assets.snakeWorks[0][2]);
				
				// Make from one of their works
				artwork = new StudioArtwork();
				artwork.createFromSaveObject(140,65,18,save,false);
				
				add(artwork.displayGroup);
				
				af_frameout = new FlxSprite(0,0,Assets.ARTFORUM_FRAMEOUT_PNG);
				add(af_frameout);
				
				af_text = new FlxSprite(0,0,Assets.ARTFORUM_COVER_TEXT_BLACK_PNG);
				add(af_text);
			}
		}
		
		
		private function makeTetrisCover():void
		{
			trace("MAKING TETRIS COVER...");

			if (Cookie.type == Globals.TETRIS)
			{				
				af_bg = new FlxSprite(0,0,Assets.ARTFORUM_BG_WHITE_PNG);
				add(af_bg);
				
				// Make from one of their works
				artwork = new StudioArtwork();
				artwork.createFromSaveObject(230,380,18,Cookie.saveObject.saves[0],false);
				
				add(artwork.displayGroup);
				
				af_frameout = new FlxSprite(0,0,Assets.ARTFORUM_FRAMEOUT_PNG);
				add(af_frameout);
				
				af_text = new FlxSprite(0,0,Assets.ARTFORUM_COVER_TEXT_GRAY_PNG);
				add(af_text);
			}
			else
			{
				// Make from one of the AI snake works
				af_bg = new FlxSprite(0,0,Assets.ARTFORUM_BG_WHITE_PNG);
				add(af_bg);
				
				var save:TetrisSave = new TetrisSave();
				save.save("one","19",32,Assets.tetrisWorks[0]);
				
				// Make from one of their works
				artwork = new StudioArtwork();
				artwork.createFromSaveObject(230,380,18,save,false);
				
				add(artwork.displayGroup);
				
				af_frameout = new FlxSprite(0,0,Assets.ARTFORUM_FRAMEOUT_PNG);
				add(af_frameout);
				
				af_text = new FlxSprite(0,0,Assets.ARTFORUM_COVER_TEXT_GRAY_PNG);
				add(af_text);
			}
		}
		
		
		private function makeSpacewarCover():void
		{
			trace("MAKING SPACEWAR COVER...");

			af_bg = new FlxSprite(0,0,Assets.ARTFORUM_BG_BLACK_PNG);
			add(af_bg);
			
			coverGroup = new FlxGroup();
			var ship1:Artist = new Artist(230,200,Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG,FlxObject.RIGHT);
			ship1.addCostume(0);
			ship1.toggleCostumeVisible();
			var ship2:Artist = new Artist(360,120,Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG,FlxObject.LEFT);
			ship2.addCostume(1);
			ship2.costume.facing = FlxObject.LEFT;
			ship2.toggleCostumeVisible();
			coverGroup.add(ship1.displayGroup);
			coverGroup.add(ship2.displayGroup);
			
			add(coverGroup);
			
			af_text = new FlxSprite(0,0,Assets.ARTFORUM_COVER_TEXT_WHITE_PNG);
			
			add(af_text);
			
			af_frameout = new FlxSprite(0,0,Assets.ARTFORUM_FRAMEOUT_PNG);
			add(af_frameout);

		}
		
		
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.ESCAPE) Helpers.resetGame();

			if (help.visible)
				handleMenuInput();
		}
		
		
		public function handleMenuInput():void
		{
			if (FlxG.keys.justPressed(Globals.P1_ACTION_KEY))
			{
				Cookie.load();
				Cookie.erase();
				Cookie.flush();
				FlxG.switchState(new MainMenuState);
			}
		}
		
		
		
		
		override public function destroy():void
		{
			super.destroy();
			
			if (artwork != null) artwork.destroy();
			help.destroy();
			af_bg.destroy();
			af_frameout.destroy();
			af_text.destroy();
			if (coverGroup != null) coverGroup.destroy();
			text.destroy();
		}
	}
}
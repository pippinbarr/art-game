package Gallery
{
	
	import Shared.*;
	import SaveAndReplay.*;

	import flash.sensors.Accelerometer;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	
	public class GalleryState extends FlxState
	{
		private const GALLERY:uint = 0;
		private const ZOOMED:uint = 1;
		private const INFO:uint = 2;
		private const TALK:uint = 3;
		private const HELP:uint = 4;
		
		private var mode:uint = GALLERY;
		
		private const SNAKE_Y:Number = 60;
		private const SPACEWAR_Y:Number = 56;
		
		
		private var galleryBG:FlxSprite;
		private var galleryFG:FlxSprite;
		private var galleryFG2:FlxSprite;
		private var galleryHM:FlxSprite;
		
		private var showTitleText:FlxText;
		private var showArtistsText:FlxText;
		
		private var avatar:Artist;
		private var avatar2:Artist;
		
		private var visitors:Array;
		private var talker:Visitor;
		
		private var artworks:Array;
		
		private var collidables:Array;
		private var triggers:Array;
		
		private var ySortGroup:FlxGroup;
		
		private var camera:FlxCamera;
		
		private var messageBox:Message;
		
		private var infoHelp:HelpPopup;
		private var zoomHelp:HelpPopup;
		private var talkHelp:HelpPopup;
		
		private var infoHelp2:HelpPopup;
		private var zoomHelp2:HelpPopup;
		private var talkHelp2:HelpPopup;
		
		private var screenLeaveHelp:HelpPopup;
		private var screenLeaveHelp2:HelpPopup;
		
		private var galleryLeaveHelp:HelpPopup;
		private var galleryLeaveHelp2:HelpPopup;
		
		private var messageTimer:FlxTimer = new FlxTimer();
		private var pauseTimer:FlxTimer = new FlxTimer();
		private var followObject:FlxSprite;
		
		public function GalleryState()
		{
		}
		
		
		override public function create():void
		{
			super.create();
			
			trace("GalleryState.create()");
			
			Cookie.load();
//			Cookie.erase();
//			Cookie.flush();
//			Cookie.type = 2;
//			Cookie.type = -1;
//			Cookie.gallerySeen = false;
//			
//			if (Cookie.type == -1)
//				Cookie.type = Globals.SNAKE;
			
			
//			Cookie.erase();
//			Cookie.type = Globals.SPACEWAR;
//			Cookie.flush();
			//Cookie.load();
			
			FlxG.bgColor = 0xFFFF0000;
			
			// Sorting
			
			ySortGroup = new FlxGroup();
			
			// Create environment
			
			galleryBG = new FlxSprite(0,0,Assets.GALLERY_BG_PNG);
			galleryFG = new FlxSprite(0,0,Assets.GALLERY_FG_PNG);
			galleryFG2 = new FlxSprite (FlxG.width * 5 - 960,0,Assets.GALLERY_FG2_PNG);
			galleryHM = new FlxSprite(0,0,Assets.GALLERY_HM_PNG);
			galleryHM.visible = Globals.DEBUG_MODE;
			
			showTitleText = new FlxText(280,20,350,"UNTITLED",true);
			showTitleText.setFormat("Commodore",40,0xFF000000);
			
			showArtistsText = new FlxText(280,showTitleText.y + showTitleText.height,300,"",true);
			showArtistsText.setFormat("Commodore",14,0xFF000000);
			
			if (Cookie.type == Globals.SNAKE)
			{
				showArtistsText.text = Globals.SNAKE_ARTIST + "\n" + Globals.SPACEWAR_ARTIST + "\n" + Globals.TETRIS_ARTIST;
			}
			else if (Cookie.type == Globals.TETRIS)
			{
				showArtistsText.text = Globals.TETRIS_ARTIST + "\n" + Globals.SPACEWAR_ARTIST + "\n" + Globals.SNAKE_ARTIST;
			}
			else if (Cookie.type == Globals.SPACEWAR)
			{
				showArtistsText.text = Globals.SPACEWAR_ARTIST + "\n" + Globals.SNAKE_ARTIST + "\n" + Globals.TETRIS_ARTIST;
			}
			
			showArtistsText.y = showTitleText.y + showTitleText.height + 20;
			
			collidables = new Array();
			triggers = new Array();
			
			
			
			add(galleryBG);
			add(showTitleText);
			add(showArtistsText);
			add(galleryHM);
			
			artworks = new Array();
			
			makeExhibition();
			
			if (Cookie.type == Globals.SPACEWAR)
			{
				trace("GalleryState.create() making a spacewar avatar");
				avatar = new Artist(450,250,Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG,FlxObject.RIGHT);
			}
			else if (Cookie.type == Globals.SNAKE)
			{
				trace("GalleryState.create() making a snake avatar");
				avatar = new Artist(450,230,Assets.SNAKE_ARTIST_WALK_CYCLE_PNG,FlxObject.RIGHT);
			}
			else if (Cookie.type == Globals.TETRIS)
			{
				trace("GalleryState.create() making a tetris avatar");
				avatar = new Artist(450,230,Assets.TETRIS_ARTIST_WALK_CYCLE_PNG,FlxObject.RIGHT);
			}
			add(avatar);
			ySortGroup.add(avatar.displayGroup);
			
			if (Cookie.type == Globals.SPACEWAR)
			{
				avatar2 = new Artist(450,210,Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG,FlxObject.RIGHT);
				add(avatar2);
				ySortGroup.add(avatar2.displayGroup);
				
				collidables.push(avatar.hitBox);
				collidables.push(avatar2.hitBox);
			}
			
			
			
			addAudience();
			
			add(ySortGroup);
			
			messageBox = new Message();
			messageBox.setup("...");
			messageBox.setVisible(false);
			add(messageBox);
			
			
			infoHelp = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " TO READ THE LABEL");
			zoomHelp = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " TO VIEW THE ARTWORK");
			talkHelp = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " TO CONTINUE");
			
			infoHelp2 = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO READ THE LABEL",FlxObject.UP);
			zoomHelp2 = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO VIEW THE ARTWORK",FlxObject.UP);
			talkHelp2 = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO CONTINUE",FlxObject.UP);
			
			if (Cookie.type == Globals.SPACEWAR)
			{
				infoHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO READ THE LABEL";
				zoomHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO VIEW THE ARTWORK";
				talkHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO CONTINUE";
			}
			
			if (Cookie.type == Globals.SPACEWAR)
			{
				screenLeaveHelp = new HelpPopup("YOU CAN'T LEAVE THE SCREEN ALONE, WAIT FOR YOUR PARTNER");
				screenLeaveHelp2 = new HelpPopup("YOU CAN'T LEAVE THE SCREEN ALONE, WAIT FOR YOUR PARTNER",FlxObject.UP);
				
				screenLeaveHelp.setVisible(false);
				screenLeaveHelp2.setVisible(false);
				
				add(screenLeaveHelp);
				add(screenLeaveHelp2);
			}	
			
			galleryLeaveHelp = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " TO LEAVE THE GALLERY");
			galleryLeaveHelp.setVisible(false);
			add(galleryLeaveHelp);
			
			if (Cookie.type == Globals.SPACEWAR)
			{
				galleryLeaveHelp2 = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + "TOGETHER TO LEAVE THE GALLERY",FlxObject.UP);
				
				galleryLeaveHelp2.setVisible(false);
				
				add(galleryLeaveHelp2);
			}	
			
			
			var tempGroup:FlxGroupY = new FlxGroupY();
			tempGroup.add(galleryFG);
			tempGroup.add(galleryFG2);
			tempGroup.y = FlxG.height - 94;
			ySortGroup.add(tempGroup);
			
			FlxG.flash(0xFF000000,2);
			
			Cookie.gallerySeen = true;
			
			followObject = new FlxSprite(avatar.x,FlxG.height/2);
			followObject.makeGraphic(1,1,0xFFFF0000);
			FlxG.camera.follow(followObject);			
		}
		
		
		private function makeExhibition():void
		{			
			Assets.resetTitles();
			
			if (Cookie.gallerySeen)
			{
				makePreSeenExhibition();
				return;
			}
			else if (Cookie.saveObject.saves.length == 0)
			{				
				makeAIExhibition();
				return;
			}
			else
			{
				makePlayerExhibition();
				return;
			}
		}
		
		
		private function makePreSeenExhibition():void
		{
			trace("GalleryState.makePreSeenExhibition()");
			
			showTitleText.text = Cookie.galleryShowTitle;
			showArtistsText.y = showTitleText.y + showTitleText.height + 20;
			
			for (var i:uint = 0; i < Cookie.gallerySaveObject.saves.length; i++)
			{
				artworks.push(Cookie.gallerySaveObject.saves[i]);
			}
			
			placeArtworks(artworks,false);
		}
		
		
		private function makeAIExhibition():void
		{
			trace("GalleryState.makeAIExhibition()");
			
			trace("... titling show.");
			showTitleText.text = Assets.showTitles[Math.floor(Math.random() * Assets.showTitles.length)];
			Cookie.galleryShowTitle = showTitleText.text;
			Cookie.flush();
			showArtistsText.y = showTitleText.y + showTitleText.height + 20;
			
			var i:uint;
			var artworkIndex:uint;
			var tetrisSave:TetrisSave;
			var snakeSave:SnakeSave;
			var spacewarSave:SpacewarSave;
			
			trace("... gathering tetris works.");
			// GATHER TETRIS WORKS
			for (i = 0; i < 3; i++)
			{
				tetrisSave = new TetrisSave;
				artworkIndex = int(Math.random() * Assets.tetrisWorks.length);
				var tetrisWork:Array = Assets.tetrisWorks.splice(artworkIndex,1);
				tetrisSave.save(Assets.artworkTitles.pop(),"2012",32,tetrisWork[0]);
				artworks.push(tetrisSave);
			}
			
			
			trace("... gathering snake works.");
			// GATHER SNAKE WORKS
			for (i = 0; i < 3; i++)
			{
				snakeSave = new SnakeSave();
				artworkIndex = int(Math.random() * Assets.snakeWorks.length);
				var snakeWork:Array = Assets.snakeWorks.splice(artworkIndex,1);
				snakeSave.createFromArrays(Assets.artworkTitles.pop(),"2012",32,snakeWork[0][0],snakeWork[0][1],snakeWork[0][2]);
				artworks.push(snakeSave);
			}
			
			trace("... gathering spacewar works.");
			// GATHER SPACEWAR WORKS
			for (i = 0; i < 2; i++)
			{
				spacewarSave = new SpacewarSave();
				artworkIndex = int(Math.random() * Assets.spacewarWorks.length);
				var spacewarWork:Array = Assets.spacewarWorks.splice(artworkIndex,1);
				spacewarSave.save(Assets.artworkTitles.pop(),"2012",32,spacewarWork[0]);
				artworks.push(spacewarSave);
			}				
			
			trace("... placing works");
			placeArtworks(artworks);
		}
		
		
		private function makePlayerExhibition():void
		{
			trace("GalleryState.makePlayerExhibition()");
			
			showTitleText.text = Assets.showTitles[Math.floor(Math.random() * Assets.showTitles.length)];
			Cookie.galleryShowTitle = showTitleText.text;
			Cookie.flush();
			showArtistsText.y = showTitleText.y + showTitleText.height + 20;
			
			var i:uint;
			var artworkIndex:uint;
			
			var tetrisSave:TetrisSave;
			var snakeSave:SnakeSave;
			var spacewarSave:SpacewarSave;
			
			artworks = new Array();
			
			// Add all the player's works
			trace("... adding player's " + Cookie.saveObject.saves.length + " works to be placed.");
						
			for (i = 0; i < Cookie.saveObject.saves.length; i++)
			{						
				artworks.push(Cookie.saveObject.saves[i]);
			}
			
			// Add enough AI works to fill out the show
			while (artworks.length < 8)
			{
				trace("... adding a tetris work.");
				if (Cookie.type != Globals.TETRIS)
				{
					trace("... adding a tetris work.");
					tetrisSave = new TetrisSave();
					artworkIndex = int(Math.random() * Assets.tetrisWorks.length);
					var tetrisSaveArray:Array = Assets.tetrisWorks.splice(artworkIndex,1);
					tetrisSave.save(Assets.artworkTitles.pop(),"2012",32,tetrisSaveArray[0]);
					artworks.push(tetrisSave);
				}
				if (artworks.length == 8)
					break;
				if (Cookie.type != Globals.SNAKE)
				{
					trace("... adding a snake work.");
					snakeSave = new SnakeSave();
					artworkIndex = int(Math.random() * Assets.snakeWorks.length);
					var snakeSaveArrays:Array = Assets.snakeWorks.splice(artworkIndex,1);
					snakeSave.createFromArrays(Assets.artworkTitles.pop(),"2012",32,snakeSaveArrays[0][0],snakeSaveArrays[0][1],snakeSaveArrays[0][2]);
					artworks.push(snakeSave);
				}
				if (artworks.length == 8)
					break;
				if (Cookie.type != Globals.SPACEWAR)
				{
					trace("... adding a spacewar work.");
					spacewarSave = new SpacewarSave;
					artworkIndex = int(Math.random() * Assets.spacewarWorks.length);
					var spacewarSaveArray:Array = Assets.spacewarWorks.splice(artworkIndex,1);
					spacewarSave.save(Assets.artworkTitles.pop(),"2012",32,spacewarSaveArray[0]);
					artworks.push(spacewarSave);
				}
				if (artworks.length == 8)
					break;
			}
			
			// NOW WE HAVE AN ARRAY OF ARTWORK SAVES TO PLACE
			
			placeArtworks(artworks);
		}
		
		
		private function randomSort(a:*, b:*):Number
		{
			if (Math.random() < 0.5) return -1;
			else return 1;
		}
		
		
		private function placeArtworks(_artworks:Array,_randomize:Boolean = true):void
		{
			trace("GalleryState.placeArtworks()");
			// SET UP SPACING
			
			var artworkWidth:Number = 8/32 * FlxG.width;
			
			var artLeft:Number = 0 + 700;
			var artRight:Number = galleryBG.width - 200 - artworkWidth;
			var artWidth:Number = artRight - artLeft;
			
			var numWorks:uint = 8;
			var worksToAdd:uint = numWorks;
			
			var totalArtworkWidths:Number = numWorks * artworkWidth;
			var remainingWallSpace:Number = artWidth - totalArtworkWidths;
			
			var spacing:Number = remainingWallSpace / (numWorks - 1);
			
			var currentArtworkX:Number = artLeft;
			
			// RANDOM SORT
			if (_randomize)
			{
				var firstPlayerWork:Object = _artworks.shift();
				_artworks.sort(Helpers.randomSort);
				_artworks.unshift(firstPlayerWork);
			}
			
			// PLACE THEM
			var lastArtwork:int = -1;
			while(_artworks.length > 1)
			{
				var save:Object = _artworks.shift();
				trace("... getting ready to place a " + save.type + " work.");
				var loopCount:uint = 0;
				while (save.type == lastArtwork &&
					   loopCount <= _artworks.length)
				{
					trace("...... no, that's a repeat, selecting a new work");
					var temp:Object = save;
					save = _artworks.shift();
					artworks.push(temp);
					loopCount++;
					trace("...... chose a " + save.type + " work instead.");
				}
				trace("... placing the work.");
				placeWork(save,currentArtworkX);
				currentArtworkX += (artworkWidth + spacing);
				lastArtwork = save.type;
			}
			
			trace("... placing the final work.");
			placeWork(_artworks[0],currentArtworkX);
		}
		
		
		private function placeWork(_save:Object,_x:Number):void
		{
			trace("GalleryState.placework()");
			
			var artwork:Artwork;
			var tileSize:Number;
			var y:Number;
			
			if (!Cookie.gallerySeen)
				Cookie.gallerySaveObject.saves.push(_save);
			
			if (_save.type == Globals.TETRIS)
			{
				artwork = new GalleryArtwork();
				tileSize = 10;
				y = Globals.TETRIS_PLINTH_TOP;
			}
			else if (_save.type == Globals.SPACEWAR)
			{
				artwork = new GalleryArtwork();
				tileSize = 8;
				y = SPACEWAR_Y;
			}
			else if (_save.type == Globals.SNAKE)
			{
				artwork = new GalleryArtwork();
				tileSize = 8;
				y = SNAKE_Y;
			}
			
			artwork.createFromSaveObject(_x,y,tileSize,_save);
			
			if (artwork.type == Globals.TETRIS)
			{
				ySortGroup.add(artwork.displayGroup);
			}
			else
			{
				add(artwork.displayGroup);
			}
			
			Globals.ARTWORKS.push(artwork);
		}
		
		
		private function addAudience():void
		{
			visitors = new Array();
			
//						var visitor:Visitor = new Visitor(0);
//						
//						ySortGroup.add(visitor.displayGroup);
//						
//						add(visitor);
//						collidables.push(visitor.hitBox);
//						visitors.push(visitor);
//						return;
			
			for (var i:uint = 0; i < Globals.ARTWORKS.length; i++)
			{
				var numViewers:int = 1 + int(Math.random() * (Globals.ARTWORKS[i].audiencePositions.length - 1));
				
				for (var j:uint = 0; j < numViewers; j++)
				{
					var visitor:Visitor = new Visitor(i,Globals.GENERIC_VISITOR);
					
					ySortGroup.add(visitor.displayGroup);
					
					add(visitor);
//					collidables.push(visitor.hitBox);
					visitors.push(visitor);
				}
			}	
			
			// Add artist visitors
			
			if (Cookie.type != Globals.SPACEWAR)
			{
				trace("... adding Spacewar artist visitors.");
				//			var swVisitor1:Visitor = new Visitor(-1,Globals.SPACEWAR,galleryBG.width - 200,FlxG.height/2);
				var swVisitor1:Visitor = new Visitor(-1,Globals.SPACEWAR_VISITOR,FlxG.width * 4 + 360,FlxG.height/2 - 60);
				ySortGroup.add(swVisitor1.displayGroup);
				collidables.push(swVisitor1.hitBox);
				visitors.push(swVisitor1);
				swVisitor1.undoAndStop();
				
				var swVisitor2:Visitor = new Visitor(-1,Globals.SPACEWAR_VISITOR,swVisitor1.x + Globals.PERSON_HITBOX_WIDTH + 10,swVisitor1.y);
				ySortGroup.add(swVisitor2.displayGroup);
				collidables.push(swVisitor2.hitBox);
				visitors.push(swVisitor2);
				swVisitor2.undoAndStop();
			}
			
			var randomIndex:uint;
			if (Cookie.type != Globals.SNAKE)
			{
				trace("... adding Snake artist visitor.");
				randomIndex = int(Math.random() * Globals.ARTWORKS.length);
				while (Globals.ARTWORKS[randomIndex].audiencePositions.length == 0)
					randomIndex = int(Math.random() * Globals.ARTWORKS.length);
				
				var snakeVisitor:Visitor = new Visitor(randomIndex,Globals.SNAKE_VISITOR);
				add(snakeVisitor);
				ySortGroup.add(snakeVisitor.displayGroup);
//				collidables.push(snakeVisitor.hitBox);
				visitors.push(snakeVisitor);
//				snakeVisitor.undoAndStop();
			}
			if (Cookie.type != Globals.TETRIS)
			{
				trace("... adding Tetris artist visitor.");
				randomIndex = int(Math.random() * Globals.ARTWORKS.length);
				while (Globals.ARTWORKS[randomIndex].audiencePositions.length == 0)
					randomIndex = int(Math.random() * Globals.ARTWORKS.length);

				var tetrisVisitor:Visitor = new Visitor(randomIndex,Globals.TETRIS_VISITOR);
				add(tetrisVisitor);
				ySortGroup.add(tetrisVisitor.displayGroup);
//				collidables.push(tetrisVisitor.hitBox);
				visitors.push(tetrisVisitor);
//				tetrisVisitor.undoAndStop();
			}
		}
		
		
		override public function update():void
		{
			Helpers.debugMemory("GalleryState.update() start");			
			
			if (FlxG.keys.ESCAPE) Helpers.resetGame();
		
			
			if(FlxG.paused)
			{
				if (mode == TALK)
				{
					handleTalkInput();
				}
				else if (mode == INFO)
				{
					handleInfoInput();
				}
				return;
			}
			
			super.update();
			
			// UPDATE CAMERA
			
			
			updateCamera();
			
			ySortGroup.sort("y", ASCENDING);
			
			
			if (mode == GALLERY && Cookie.state != Globals.END_STATE)
			{
				checkLeaving();
				
				Helpers.debugMemory("GalleryState.update() post check leaving");			
				
				
				handleCollisions(avatar);
				if (Cookie.type == Globals.SPACEWAR)
					handleCollisions(avatar2);
				
				handleVisitorCollisions();
				
				Helpers.debugMemory("GalleryState.update() post handle collisions");			
								
				if (Cookie.type != Globals.SPACEWAR)
				{
					handleInfoInput();
				}
				else
				{
					handleInfoInput2Player();
				}				
				if (Cookie.type != Globals.SPACEWAR)
					handleZoomInput();
				else
					handleZoomInput2Player();
				handleAvatarInput();				
			}
			else if (mode == ZOOMED)
			{
				handleCollisions(avatar);
				if (Cookie.type == Globals.SPACEWAR)
					handleCollisions(avatar2);
				
				handleVisitorCollisions();

				if (Cookie.type != Globals.SPACEWAR)
					handleZoomInput();
				else
					handleZoomInput2Player();
			}
			else if (mode == INFO)
			{
				if (Cookie.type != Globals.SPACEWAR)
					handleInfoInput();
				else
					handleInfoInput2Player();
			}
		}
		
		
		private function checkLeaving():void
		{
			var avatarLeft:Number = avatar.x;
			var avatarRight:Number = avatar.x + avatar.sprite.width;
			var galleryLeft:Number = 0;
			var galleryRight:Number = FlxG.width * 5;
			
			if (Cookie.type != Globals.SPACEWAR)
			{
				if (avatarLeft < galleryLeft + 50 ||
					avatarRight > galleryRight - 50)
				{
					if (avatarLeft < galleryLeft ||
						avatarRight > galleryRight)
						avatar.undoAndStop();
					galleryLeaveHelp.setVisible(true);
					
					if (Helpers.action())
					{
						Cookie.state = Globals.END_STATE;
						Cookie.flush();
						galleryLeaveHelp.setVisible(false);
						FlxG.fade(0xFF000000,1,goToEnding);
					}
				}
				else
				{
					galleryLeaveHelp.setVisible(false);
				}
			}
			else
			{
				var avatar2Left:Number = avatar2.x;
				var avatar2Right:Number = avatar2.x + avatar2.sprite.width;
				
				if ((avatarLeft < galleryLeft + 50 && avatar2Left < galleryLeft + 50) ||
					(avatarRight > galleryRight - 50 && avatar2Right > galleryRight - 50))
				{
					if (avatarLeft < galleryLeft || avatarRight > galleryRight)
						avatar.undoAndStop();
					if (avatar2Left < galleryLeft || avatar2Right > galleryRight)
						avatar2.undoAndStop();
					galleryLeaveHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO LEAVE THE GALLERY";
					galleryLeaveHelp.setVisible(true);
					galleryLeaveHelp2.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO LEAVE THE GALLERY";
					galleryLeaveHelp2.setVisible(true);
					
					if (Helpers.action())
					{
						Cookie.state = Globals.END_STATE;
						
						Cookie.flush();
						galleryLeaveHelp.setVisible(false);
						galleryLeaveHelp2.setVisible(false);
						FlxG.fade(0xFF000000,1,goToEnding);
					}
				}
				else if ((avatarLeft < galleryLeft + 10 && avatar2Left >= galleryLeft + 10) ||
					(avatarRight > galleryRight - 10 && avatar2Right <= galleryRight - 10))
				{
					if (avatarLeft < galleryLeft ||
						avatarRight > galleryRight)
						avatar.undoAndStop();
					galleryLeaveHelp.text.text = "YOU CAN'T LEAVE THE GALLERY ALONE";
					galleryLeaveHelp.setVisible(true);
					galleryLeaveHelp2.setVisible(false);
				}
				else if ((avatar2Left < galleryLeft + 10 && avatarLeft >= galleryLeft + 10) ||
					(avatar2Right > galleryRight - 10 && avatarRight <= galleryRight - 10))
				{
					if (avatar2Left < galleryLeft ||
						avatar2Right > galleryRight)
						avatar2.undoAndStop();
					galleryLeaveHelp2.text.text = "YOU CAN'T LEAVE THE GALLERY ALONE";
					galleryLeaveHelp2.setVisible(true);
					galleryLeaveHelp.setVisible(false);
				}
				else
				{
					galleryLeaveHelp.setVisible(false);
					galleryLeaveHelp2.setVisible(false);
				}	
			}
		}
		
		
		
		private function goToEnding():void
		{
			FlxG.switchState(new EndState);
		}
		
		
		private function updateCamera():void
		{			
			if (Cookie.type == Globals.SPACEWAR)
			{
				followObject.x = (avatar.x + avatar2.x) / 2;
				followObject.y = FlxG.height/2;
				
				if (Math.abs(avatar.x - avatar2.x) > Globals.SPACEWAR_MAX_AVATAR_SEPARATION)
				{
					avatar.undoAndStop();
					avatar2.undoAndStop();
				}
				if (Math.abs(avatar.x - avatar2.x) > Globals.SPACEWAR_MAX_AVATAR_SEPARATION - 10)
				{
					screenLeaveHelp.text.text = "DON'T MOVE TOO FAR APART";
					screenLeaveHelp2.text.text = "DON'T MOVE TOO FAR APART";
					
					screenLeaveHelp.setVisible(true);
					screenLeaveHelp2.setVisible(true);
					
					infoHelp.setVisible(false);
					infoHelp2.setVisible(false);
					zoomHelp.setVisible(false);
					zoomHelp2.setVisible(false);
					galleryLeaveHelp.setVisible(false);
					galleryLeaveHelp2.setVisible(false);
				}
				else
				{
					screenLeaveHelp.setVisible(false);
					screenLeaveHelp2.setVisible(false);
				}
			}
			else
			{
				followObject.x = avatar.x;
				followObject.y = FlxG.height/2;
//				trace("followObject.y is " + followObject.y);
			}
			
			if (followObject.x <= FlxG.width/2) followObject.x = FlxG.width/2;
			if (followObject.x >= galleryBG.width - FlxG.width/2) followObject.x = galleryBG.width - FlxG.width/2;
			
			
		}
		
		
		private function handleVisitorCollisions():void
		{
			for (var i:int = 0; i < visitors.length; i++)
			{
				if (visitors[i].hitBox.overlaps(avatar.hitBox))
				{
					avatar.undoAndStop();
					visitors[i].undoAndStop();
					visitors[i].handleCollision(avatar);
					
					talker = visitors[i];
					talk(null);
					
					return;

				}
				if (avatar2 != null && visitors[i].hitBox.overlaps(avatar2.hitBox))
				{
					avatar2.undoAndStop();
					visitors[i].undoAndStop();
					visitors[i].handleCollision(avatar2);
					
					talker = visitors[i];
					talk(null);
					
					return;
				}
					
				for (var j:int = i+1; j < visitors.length; j++)
				{
					if (visitors[i].hitBox.overlaps(visitors[j].hitBox))
					{
						visitors[i].undoAndStop();
						visitors[i].handleCollision(visitors[j]);
						
						visitors[j].undoAndStop();
						visitors[j].handleCollision(visitors[i]);
						
						return;
					}
				}
				
				for (var k:int = 0; k < Globals.ARTWORKS.length; k++)
				{
					if (visitors[i].hitBox.overlaps(Globals.ARTWORKS[k].hitBox))
					{
						visitors[i].undoAndStop();
						visitors[i].chooseTarget(null);
						
						return;
					}
				}
			}
		}
		
		
		private function handleCollisions(_avatar:Artist):void
		{
			if (FlxCollision.pixelPerfectCheck(_avatar.hitBox,galleryHM))
			{
				trace("COLLISION WITH HM");
				_avatar.undoAndStop();
				return;
			}
			
			for (var i:int = 0; i < collidables.length; i++)
			{
				if (_avatar.hitBox.overlaps(collidables[i]))
				{
					if (collidables[i] == _avatar.hitBox)
						continue;
					trace("COLLISION WITH COLLIDABLE");
					_avatar.undoAndStop();
					return;
				}
				
				//				Helpers.debugMemory("GalleryState.update() post pixelPerfectCheck");			
			}
			
			for (i = 0; i < Globals.ARTWORKS.length; i++)
			{
				if (Globals.ARTWORKS[i].hitBox != null)
				{
					if (_avatar.hitBox.overlaps(Globals.ARTWORKS[i].hitBox))
					{
						trace("COLLISION WITH ARTWORK");
						_avatar.undoAndStop();
						return;
					}
				}
			}
		}
		
		

		
		private function pause(t:FlxTimer):void
		{
			avatar.active = !avatar.active;
			if (avatar2 != null) avatar2.active = !avatar2.active;
			for (var i:uint = 0; i < visitors.length; i++)
			{
				visitors[i].active = !visitors[i].active;
			}
		}
		
		
		private function getTalkPauseTime():Number
		{
			return (3 + Math.random() * 5);
		}
		
		
		private function talk(timer:FlxTimer):void
		{
			var saying:String = talker.getDialog();
			
			if (mode == ZOOMED)
			{
				return;
			}
			if (saying == null)
			{
				return;
			}
			
			if (screenLeaveHelp != null && screenLeaveHelp.visible)
				return;
			
			if (galleryLeaveHelp.visible)
			{
				return;
			}
			if (screenLeaveHelp != null && screenLeaveHelp.visible)
			{
				return;
			}
			if (galleryLeaveHelp2 != null)
				if (galleryLeaveHelp2.visible)
					return;
			if (screenLeaveHelp2 != null)
				if (screenLeaveHelp2.visible)
					return;
			
			mode = TALK;
			avatar.stop();
			
			messageBox.setup("\"" + saying + "\"");
			messageBox.setVisible(true);
			
			talker = null;
			
			infoHelp.setVisible(false);
			zoomHelp.setVisible(false);
			talkHelp.setVisible(true);
			
			if (Cookie.type == Globals.SPACEWAR)
			{
				infoHelp2.setVisible(false);
				zoomHelp2.setVisible(false);
				talkHelp2.setVisible(true);
				avatar2.stop();
			}
			
			FlxG.paused = true;
			//			messageTimer.start(1);
		}
		
		
		private function handleTalkInput():void
		{
			if (screenLeaveHelp != null && screenLeaveHelp.visible)
				return;
			if (mode == TALK && Helpers.action())
			{
				messageBox.setVisible(false);
				mode = GALLERY;
				
				talkHelp.setVisible(false);
				if (Cookie.type == Globals.SPACEWAR)
				{
					talkHelp2.setVisible(false);
				}		
				
				FlxG.paused = false;
				
				//				}
			}
		}
		
		
		private function handleInfoInput():void
		{
			if (screenLeaveHelp != null && screenLeaveHelp.visible)
				return;
			
			var infoHelpVisible:Boolean = false;
			
			if (mode == TALK)
				return;
			
			for (var i:int = 0; i < Globals.ARTWORKS.length; i++)
			{
				if (avatar.hitBox.overlaps(Globals.ARTWORKS[i].infoZone))
				{
					infoHelpVisible = true;
				}
				
				if (avatar.hitBox.overlaps(Globals.ARTWORKS[i].infoZone) && Helpers.action())
				{
					if (mode == GALLERY)
					{
						infoHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " TO CONTINUE";
						
						mode = INFO;
						
						var infoString:String = "";
						infoString += Globals.ARTWORKS[i].info.artist;
						infoString += "\n";
						infoString += Globals.ARTWORKS[i].info.nationality;
						infoString += ", ";
						infoString += "born " + Globals.ARTWORKS[i].info.birthYear;
						infoString += "\n\n";
						infoString += Globals.ARTWORKS[i].info.title.toUpperCase();
						infoString += "\n";
						infoString += Globals.ARTWORKS[i].info.medium;
						
						messageBox.setup(infoString);
						messageBox.setVisible(true);
						
						avatar.stop();
						
						FlxG.paused = true;
					}
					else if (mode == INFO)
					{
						infoHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " TO READ THE LABEL";
						
						mode = GALLERY;
						messageBox.setVisible(false);
						
						FlxG.paused = false;
					}
				}
			}
			
			infoHelp.setVisible(infoHelpVisible);
		}
		
		
		private function handleInfoInput2Player():void
		{
			if (screenLeaveHelp.visible)
				return;
			if (mode == TALK)
				return;
			
			var a1overlaps:int = -1;
			var a2overlaps:int = -1
			
			for (var i:int = 0; i < Globals.ARTWORKS.length; i++)
			{
				if (avatar.hitBox.overlaps(Globals.ARTWORKS[i].infoZone))
					a1overlaps = i;
				if (avatar2.hitBox.overlaps(Globals.ARTWORKS[i].infoZone))
					a2overlaps = i;
			}
			
			if (a1overlaps != -1 && a1overlaps == a2overlaps)
			{
				// BOTH OVERLAPPING
				infoHelp.setVisible(true);
				infoHelp2.setVisible(true);
				
				if (mode != INFO)
				{
					infoHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO READ THE LABEL";
					infoHelp2.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO READ THE LABEL";
				}
				
				
				if (Helpers.action())
				{
					if (mode == GALLERY)
					{
						infoHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO CONTINUE";
						infoHelp2.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO CONTINUE";
						
						mode = INFO;
						
						var infoString:String = "";
						infoString += Globals.ARTWORKS[a1overlaps].info.artist;
						infoString += "\n";
						infoString += Globals.ARTWORKS[a1overlaps].info.nationality;
						infoString += ", ";
						infoString += "born " + Globals.ARTWORKS[a1overlaps].info.birthYear;
						infoString += "\n\n";
						infoString += Globals.ARTWORKS[a1overlaps].info.title.toUpperCase();
						infoString += "\n";
						infoString += Globals.ARTWORKS[a1overlaps].info.medium;
						
						messageBox.setup(infoString);
						messageBox.setVisible(true);
						
						avatar.stop();
						avatar2.stop();
					}
					else if (mode == INFO)
					{
						infoHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO READ THE LABEL";
						infoHelp2.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO READ THE LABEL";
						
						mode = GALLERY;
						messageBox.setVisible(false);
					}
				}
			}
			else 
			{
				if (a1overlaps != -1)
				{
					// Avatar is overlapping something (but not with the other avatar)
					infoHelp.text.text = "YOU CAN'T READ THE LABEL ALONE";
					infoHelp.setVisible(true);
				}
				else
				{
					infoHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO READ THE LABEL";
					infoHelp.setVisible(false);
				}
				
				if (a2overlaps != -1)
				{
					// Avatar is overlapping something (but not with the other avatar)
					infoHelp2.text.text = "YOU CAN'T READ THE LABEL ALONE";
					infoHelp2.setVisible(true);
				}
				else
				{
					infoHelp2.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO READ THE LABEL";
					infoHelp2.setVisible(false);
				}
			}
		}
		
		
		private function handleZoomInput():void
		{			
			var zoomHelpVisible:Boolean = false;
			
			if (screenLeaveHelp != null && screenLeaveHelp.visible)
				return;
			if (mode == TALK)
				return;
			
			for (var i:int = 0; i < Globals.ARTWORKS.length; i++)
			{
				if (avatar.hitBox.overlaps(Globals.ARTWORKS[i].triggerZone))
				{
					zoomHelpVisible = !avatar.hitBox.overlaps(Globals.ARTWORKS[i].infoZone);
				}
				
				if (avatar.hitBox.overlaps(Globals.ARTWORKS[i].triggerZone) && Helpers.action())
				{
					if (mode == GALLERY)
					{
						zoomHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " TO CONTINUE";
						
						mode = ZOOMED;
						
						FlxG.camera.follow(null);
						
						
						FlxG.camera.zoom = Globals.ARTWORKS[i].focalZoom;
						FlxG.camera.focusOn(Globals.ARTWORKS[i].focalPoint);
						avatar.stop();
					}
					else if (mode == ZOOMED)
					{
						zoomHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " TO VIEW THE ARTWORK";
						
						mode = GALLERY;
						FlxG.camera.zoom = 1;
						
						FlxG.camera.follow(followObject);
					}
				}
			}
			
			zoomHelp.setVisible(zoomHelpVisible);
		}
		
		
		private function handleZoomInput2Player():void
		{	
			if (screenLeaveHelp.visible)
				return;
			if (mode == TALK)
				return;
			
			var a1overlaps:int = -1;
			var a2overlaps:int = -1
			
			
			for (var i:int = 0; i < Globals.ARTWORKS.length; i++)
			{
				if (avatar.hitBox.overlaps(Globals.ARTWORKS[i].triggerZone) && !avatar.hitBox.overlaps(Globals.ARTWORKS[i].infoZone))
					a1overlaps = i;
				if (avatar2.hitBox.overlaps(Globals.ARTWORKS[i].triggerZone) && !avatar2.hitBox.overlaps(Globals.ARTWORKS[i].infoZone))
					a2overlaps = i;
			}
			
			if (a1overlaps != -1 && a1overlaps == a2overlaps)
			{
				// BOTH OVERLAPPING
				zoomHelp.setVisible(true);
				zoomHelp2.setVisible(true);
				
				if (mode != ZOOMED)
				{
					zoomHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO VIEW THE ARTWORK";
					zoomHelp2.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO VIEW THE ARTWORK";
				}
				
				
				if (Helpers.action())
				{
					if (mode == GALLERY)
					{
						zoomHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO CONTINUE";
						zoomHelp2.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO CONTINUE";
						
						mode = ZOOMED;
						
						FlxG.camera.follow(null);
						
						FlxG.camera.zoom = Globals.ARTWORKS[a1overlaps].focalZoom;
						FlxG.camera.focusOn(Globals.ARTWORKS[a1overlaps].focalPoint);
						
						avatar.stop();
						avatar2.stop();
					}
					else if (mode == ZOOMED)
					{
						zoomHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO VIEW THE ARTWORK";
						zoomHelp2.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO VIEW THE ARTWORK";
						
						mode = GALLERY;
						
						FlxG.camera.zoom = 1;
						FlxG.camera.follow(followObject);
					}
				}
			}
			else 
			{
				if (a1overlaps != -1)
				{
					// Avatar is overlapping something (but not with the other avatar)
					zoomHelp.text.text = "YOU CAN'T VIEW THE ARTWORK ALONE";
					zoomHelp.setVisible(true);
				}
				else
				{
					zoomHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO VIEW THE ARTWORK";
					zoomHelp.setVisible(false);
				}
				
				if (a2overlaps != -1)
				{
					// Avatar is overlapping something (but not with the other avatar)
					zoomHelp2.text.text = "YOU CAN'T VIEW THE ARTWORK ALONE";
					zoomHelp2.setVisible(true);
				}
				else
				{
					zoomHelp2.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO VIEW THE ARTWORK";
					zoomHelp2.setVisible(false);
				}
			}
		}
		
		
		
		private function handleAvatarInput():void
		{
			if (messageBox.visible)
			{
				return;
			}
			
			if (FlxG.keys.justPressed(Globals.P1_LEFT_KEY))
			{
				avatar.moveLeft();
			}
			else if (FlxG.keys.justPressed(Globals.P1_RIGHT_KEY))
			{
				avatar.moveRight();
			}
			else if (FlxG.keys.justPressed(Globals.P1_UP_KEY))
			{
				avatar.moveUp();
			}
			else if (FlxG.keys.justPressed(Globals.P1_DOWN_KEY))
			{
				avatar.moveDown();
			}
			
			if (Cookie.type == Globals.SPACEWAR)
			{
				if (FlxG.keys.justPressed(Globals.P2_LEFT_KEY))
				{
					avatar2.moveLeft();
				}
				else if (FlxG.keys.justPressed(Globals.P2_RIGHT_KEY))
				{
					avatar2.moveRight();
				}
				else if (FlxG.keys.justPressed(Globals.P2_UP_KEY))
				{
					avatar2.moveUp();
				}
				else if (FlxG.keys.justPressed(Globals.P2_DOWN_KEY))
				{
					avatar2.moveDown();
				}
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			galleryBG.destroy();
			galleryFG.destroy();
			galleryFG2.destroy();
			galleryHM.destroy();
			
			showTitleText.destroy();
			showArtistsText.destroy();
			
			avatar.destroy();
			if (avatar2 != null)
				avatar2.destroy();
			
			for (var i:uint = 0; i < visitors.length; i++)
				visitors[i].destroy();
			
			//			talkTimer.destroy();
			
			for (i = 0; i < Globals.ARTWORKS.length; i++)
				Globals.ARTWORKS[i].destroy();
			
			messageBox.destroy();
			messageTimer.destroy();
			
			infoHelp.destroy();
			zoomHelp.destroy();
			talkHelp.destroy();
			galleryLeaveHelp.destroy();
			
			if (Cookie.type == Globals.SPACEWAR)
			{
				infoHelp2.destroy();
				zoomHelp2.destroy();
				talkHelp2.destroy();
				
				screenLeaveHelp.destroy();
				screenLeaveHelp2.destroy();
				galleryLeaveHelp2.destroy();
			}
		}
	}
}
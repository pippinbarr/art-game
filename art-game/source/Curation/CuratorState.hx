package Curation
{
	import Gallery.GalleryState;
	import SaveAndReplay.*;

	import Shared.*;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class CuratorState extends FlxState
	{
		protected const GAME_INTRO:uint = 5;
		protected const GAME_OUTRO:uint = 6;
		protected const TRANSITION:uint = 4;
		protected const START:uint = 0;
		protected const INTRO:uint = 1;
		protected const SELECTIONS:uint = 2;
		protected const OUTRO:uint = 3;
		protected var state:uint = START;
		
		protected var type:uint = Globals.NONE;
		
		protected var GAME_INTRO_MESSAGE:String;		
		protected var GAME_OUTRO_MESSAGE:String;
		
		protected var currentSelectionWork:StudioArtwork;
		protected var currentSelectionSave:Object;
		protected var currentSelectionIndex:int;
		protected var currentSelectionNumberText:FlxText;
		protected var currentSelectionTitleText:FlxText;		
		
		protected var selectionDisplayX:Number;
		protected var selectionDisplayY:Number;
		protected var selectionDisplayTileSize:Number;
		protected var selectionOverlayColour:uint;
		protected var selectionTextColour:uint;
		protected var selectionMenuTextString:String;
		
		protected var curatorMenu:FlxGroup;
		protected var curatorMenuText:FlxText;
		
		protected var studioBG:FlxSprite;
		
		protected var savedWorks:Array;
		protected var savedWorkScale:Number;
		
		
		protected var avatar:Artist;
		protected var curator:FlxSprite;
		
		protected var ySortGroup:FlxGroup;
		
		protected var studioClass:Class;
		
		protected var curatorHelp:HelpPopup;
		
		protected var menuDark:Boolean = true;
		
		protected var curatorIntroSpeech:Message;
		protected var noWorkIntros:Array;
		protected var noSelectionIntros:Array;
		protected var selectionIntros:Array;
		protected var allSelectionIntros:Array;
		protected var partialSelectionIntros:Array;
		
		protected var newSelectionComments:Array;
		protected var reconsideredSelectionComments:Array;
		
		protected var curatorOutroSpeech:Message;
		protected var threeWorkFinalOutros:Array;
		protected var someNewWorkFinalOutros:Array;
		protected var someOldWorkFinalOutros:Array;
		protected var noWorkStudioOutros:Array;
		protected var someNewWorkStudioOutros:Array;
		protected var someOldWorkStudioOutros:Array;
		protected var noWorkRejectedOutros:Array;
		protected var toGalleryOutros:Array;
		
		protected var anyWork:Boolean = false;
		protected var newWork:Boolean = false;
		
		
		protected const FINAL_SELECTION_MADE:uint = 0;;
		protected const RETURN_TO_STUDIO:uint = 1;
		protected const REMOVED_FROM_EXHIBITION:uint = 2;
		protected var decision:uint;
		
		protected var newSelections:Array = new Array();
		protected var reconsideredSelections:Array = new Array();
		protected var selections:Array = new Array();
		
		protected var timer:FlxTimer = new FlxTimer();
		
		public function CuratorState()
		{
		}
		
		
		override public function create():void
		{
			super.create();
			
			trace("CuratorState.create()");
			Cookie.load();
			
			//Cookie.load();
			//									Cookie.erase();
			//									Cookie.flush();
			
			
			setupResponseArrays();
			
			if (Cookie.state == Globals.CURATOR_INTRO_STATE)
			{
				trace("GAME INTRO...");
				state = this.GAME_INTRO;
			}
			else
			{
				Cookie.curatorVisits++;
				Cookie.state = Globals.CURATOR_STATE;
				Cookie.flush();
				state = START;
			}
			
			ySortGroup = new FlxGroup();
			
			makeStudio();			
			makeAvatar();
			makeSavedWorks();
			
			add(avatar);
			add(ySortGroup);
			
			
			
			makeSelections();
			
			curatorIntroSpeech = new Message();
			add(curatorIntroSpeech);
			curatorOutroSpeech = new Message();
			add(curatorOutroSpeech);
			
			makeCuratorIntro();
			curatorIntroSpeech.setVisible(false);
			makeCuratorOutro();
			curatorOutroSpeech.setVisible(false);
			
			curatorHelp = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " TO CONTINUE");
			curatorHelp.setVisible(false);
			add(curatorHelp);
			
			
			
			timer.start(3,1,sayCuratorIntro);
			
			FlxG.camera.flash(0xFF000000,2);
		}
		
		
		protected function makeStudio():void
		{
			add(studioBG);
		}
		
		
		protected function makeAvatar():void
		{			
		}
		
		
		protected function makeSavedWorks():void
		{
		}
		
		
		protected function makeCuratorSelectionScreen(t:FlxTimer = null):void
		{
			state = SELECTIONS;
			
			curatorMenu = new FlxGroup();
			
			var overlay:FlxSprite = new FlxSprite(0,0);
			overlay.makeGraphic(FlxG.width,FlxG.height,selectionOverlayColour);
			curatorMenu.add(overlay);
			
			currentSelectionIndex = 0;
			currentSelectionSave = selections[currentSelectionIndex];
			currentSelectionWork = new StudioArtwork();
			currentSelectionWork.createFromSaveObject(selectionDisplayX,selectionDisplayY,selectionDisplayTileSize,currentSelectionSave);
			curatorMenu.add(currentSelectionWork.displayGroup);
			
			currentSelectionNumberText = new FlxText(0,55,FlxG.width,"");
			currentSelectionNumberText.setFormat("Commodore",18,selectionTextColour,"center");
			currentSelectionNumberText.text = (currentSelectionIndex+1) + "/" + selections.length;
			curatorMenu.add(currentSelectionNumberText);
			
			currentSelectionTitleText = new FlxText(0,320,FlxG.width,"");
			currentSelectionTitleText.setFormat("Commodore",18,selectionTextColour,"center");
			currentSelectionTitleText.text = "\"" + selections[currentSelectionIndex].info.title.toUpperCase() + "\"";
			currentSelectionTitleText.text += "\n";
			curatorMenu.add(currentSelectionTitleText);
			
			curatorMenuText = new FlxText(0,370,FlxG.width,"");
			curatorMenuText.setFormat("Commodore",18,selectionTextColour,"center");
			curatorMenuText.text = selections[currentSelectionIndex].comment;
			curatorMenu.add(curatorMenuText);
			
			curatorMenu.visible = true;
			
			if (selections.length > 1)
				curatorHelp.text.text = "PRESS " + Helpers.actionString() + " TO VIEW NEXT SELECTION";
			else
				curatorHelp.text.text = "PRESS " + Helpers.actionString() + " TO CONTINUE";
			curatorHelp.setVisible(true);
			
			add(curatorMenu);
		}
		
		
		public function makeSelections():void
		{
			// SETUP
			
//			// DEBUG
//			trace("makeSelections() DEBUG MODE SELECTS ALL WORK");
//			anyWork = true;
//			
//			while (Cookie.studioSaveObject.saves.length > 0)
//			{
//				var selection:Object = Cookie.studioSaveObject.saves.shift();
//				Cookie.saveObject.saves.push(selection);
//				selections.push(selection);
//				if (Math.random() > 0.5)
//					newSelections.push(selection);
//				else
//					reconsideredSelections.push(selection);
//				
//				selections[selections.length - 1].comment = Cookie.newSelectionComments.shift() as String;
//				trace("... made a selection.");
//			}
//			trace("selections.length is " + selections.length);
//			trace("Cookie.saveObject.saves.length is " + Cookie.saveObject.saves.length);
//			return;
//			// DEBUG
			
			var numWorks:uint = Cookie.studioSaveObject.saves.length;
			// Have they brought any work?
			anyWork = (numWorks != 0);
			
			if (!anyWork) return;
			
			// Have they brought any new work (e.g. at least the most recent work is unseen)
			var numNewWorks:uint = 0;
			for (var i:uint = 0; i < Cookie.studioSaveObject.saves.length; i++)
			{
				if (Cookie.curatorRejectedWorks.indexOf(Cookie.studioSaveObject.saves[i].id) == -1)
				{
					numNewWorks++;
				}
			}
			newWork = (numNewWorks > 0);
			
			
			
			var numVisits:uint = Cookie.curatorVisits;
			var numSelections:uint = Cookie.saveObject.saves.length;
			
			// ESTABLISH CURATOR MOOD VALUE
			
			var proportionNewWorks:Number = numNewWorks / numWorks; // 0..1
			
			var numToSelect:uint = 0;
			if (Math.random() > 0.9 ||
				(Math.random() > 0.75 && proportionNewWorks > 0.5) ||
				(Math.random() > 0.5 && numNewWorks > 3))
			{
				numToSelect = 2;
			}
			else if (Math.random() > 0.75 ||
				(Math.random() > 0.5 && proportionNewWorks > 0.3) ||
				(Math.random() > 0.3 && numNewWorks > 2))
			{
				numToSelect = 1;
			}
			else
			{
				numToSelect = 0;
			}
			
			if (numToSelect + Cookie.saveObject.saves.length > 3)
			{
				numToSelect = 3 - Cookie.saveObject.saves.length;
			}
			
			
			// SELECT THE WORKS
			
			var newWorkSelectionChance:Number = 0.7;
			var oldWorkSelectionChance:Number = 0.3;
			
			newSelections = new Array();
			reconsideredSelections = new Array();
			
			// Randomly look at work they've brought and consider accepting them
			var selected:Array;
			while (numToSelect > 0 && Cookie.studioSaveObject.saves.length > 0)
			{
				var ri:int = Math.floor(Math.random() * Cookie.studioSaveObject.saves.length);
				
				if (Cookie.curatorRejectedWorks.indexOf(Cookie.studioSaveObject.saves[ri].id) == -1)
				{									
					if (Math.random() < newWorkSelectionChance || Cookie.studioSaveObject.saves.length == numToSelect)
					{
						// A new work
						trace("Adding new selection of index " + ri);
						trace("newSelectionComments looks like this:");
						trace(Cookie.newSelectionComments);
						selected = Cookie.studioSaveObject.saves.splice(ri,1);
						selected[0].comment = Cookie.newSelectionComments.shift() as String;
						trace("Added comment of " + selected[0].comment);
						newSelections.push(selected[0]);
						numToSelect--;
					}
				}
				else
				{
					if (Math.random() < oldWorkSelectionChance || Cookie.studioSaveObject.saves.length == numToSelect)
					{
						// An old work
						selected = Cookie.studioSaveObject.saves.splice(ri,1);
						selected[0].comment = Cookie.reconsideredSelectionComments.shift();
						reconsideredSelections.push(selected[0]);
						numToSelect--;
					}
				}
			}
			
			
			// REMEMBER ALL REMAINING WORKS AS SEEN
			
			for (i = 0; i < Cookie.studioSaveObject.saves.length; i++)
			{
				if (Cookie.curatorRejectedWorks.indexOf(Cookie.studioSaveObject.saves[i].id == -1))
					Cookie.curatorRejectedWorks.push(Cookie.studioSaveObject.saves[i].id);
			}
			
			
			// ADD SELECTIONS TO APPROPRIATE ARRAYS
			
			selections = new Array();
			
			for (i = 0; i < newSelections.length; i++)
			{
				Cookie.saveObject.saves.push(newSelections[i]);
				selections.push(newSelections[i]);
			}
			for (i = 0; i < reconsideredSelections.length; i++)
			{
				Cookie.saveObject.saves.push(reconsideredSelections[i]);
				selections.push(reconsideredSelections[i]);
			}
			
			Cookie.flush();
			
			trace("CuratorState made " + selections.length + " selections.");
		}
		
		
		public function makeCuratorIntro():void
		{			
			// CASE: NO SELECTIONS TO DISCUSS
			
			if (Cookie.state == Globals.CURATOR_INTRO_STATE)
			{
				trace("MAKING CURATOR GAME INTRO...");
				curatorIntroSpeech.setup(GAME_INTRO_MESSAGE);
				return;
			}
			
			if (!anyWork)
			{
				// Artist turned up with no work at all so tell them off for wasting the curator's time
				// (Catch stuff about currently selected work in outro)
				curatorIntroSpeech.setup(this.noWorkIntros.shift());
				return;
			}
			else if (selections.length == 0)
			{
				// Artist has work, but nothing was selected
				curatorIntroSpeech.setup(this.noSelectionIntros.shift());
			}
			else if (selections.length != 0)
			{
				// Artist has work, and something was selected
				if (selections.length == Cookie.studioSaveObject.saves.length)
				{
					// Taking everything
					curatorIntroSpeech.setup(this.selectionIntros.shift() + " " + this.allSelectionIntros.shift());
				}
				else
				{
					// Taking a subset
					curatorIntroSpeech.setup(this.selectionIntros.shift() + " " + this.partialSelectionIntros.shift());
				}
				return;
			}
		}
		
		
		public function makeCuratorOutro():void
		{			
			if (Cookie.state == Globals.CURATOR_INTRO_STATE)
			{
				trace("\"MAKING\" CURATOR GAME OUTRO");
				curatorOutroSpeech.setup(GAME_OUTRO_MESSAGE);
				curatorOutroSpeech.setVisible(false);
				return;
			}
			
			if (Cookie.saveObject.saves.length == 3)
			{
				trace("makeCuratorOutro() setting decision (selected three works)");
				decision = this.FINAL_SELECTION_MADE;
			}
			else if (Cookie.saveObject.saves.length == 2 && Cookie.curatorVisits >= 3)
			{
				decision = this.FINAL_SELECTION_MADE;
			}
			else if (Cookie.saveObject.saves.length == 1 && Cookie.curatorVisits >= 4)
			{
				decision = this.FINAL_SELECTION_MADE;
			}
			else if (Cookie.saveObject.saves.length == 0 && Cookie.curatorVisits >= 4)
			{
				decision = this.REMOVED_FROM_EXHIBITION;
			}
			else
			{
				decision = this.RETURN_TO_STUDIO;
			}
			
			curatorOutroSpeech.message = "";
			
			
			if (decision == FINAL_SELECTION_MADE)
			{
				// Whatever has happened, the curator is taking the artist to the gallery
				if (Cookie.saveObject.saves.length == 3)
				{
					// Best case, three works!
					trace("makeCuratorOutro() running setup() on curatorOutroSpeech");
					curatorOutroSpeech.setup(this.threeWorkFinalOutros.shift());
					trace("... set the text to " + curatorOutroSpeech.text.text);
				}
				else
				{
					// One or two works
					if (selections.length != 0)
					{
						// One of them selected this time
						curatorOutroSpeech.setup(this.someNewWorkFinalOutros.shift());
					}
					else
					{
						// Nothing selected this time
						curatorOutroSpeech.setup(this.someOldWorkFinalOutros.shift());
					}
				}
			}
			else if (decision == RETURN_TO_STUDIO)
			{
				// Whatever has happened, the curator is not bringing the artist to the gallery yet
				if (selections.length == 0)
				{
					// Artist is yet to produce any interesting work at all
					curatorOutroSpeech.setup(this.noWorkStudioOutros.shift());
				}
				else if (selections.length > 0)
				{
					if (this.newSelections.length > 0)
					{
						// Artist has one work selected this time
						curatorOutroSpeech.setup(this.someNewWorkStudioOutros.shift());
					}
					else if (this.reconsideredSelections.length > 0)
					{
						curatorOutroSpeech.setup(this.someOldWorkStudioOutros.shift());
					}
				}
			}
			else if (decision == REMOVED_FROM_EXHIBITION)
			{
				// The worst case, you've been fired for not producing interesting enough work for too long.
				curatorOutroSpeech.setup(this.noWorkRejectedOutros.shift());
			} 			
		}
		
		
		protected function sayCuratorIntro(t:FlxTimer):void
		{
			curatorIntroSpeech.setVisible(true);
			curatorHelp.setVisible(true);
			if (Cookie.state == Globals.CURATOR_INTRO_STATE)
			{
				state = this.GAME_INTRO;
			}
			else
			{
				state = INTRO;
			}
		}
		
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.ESCAPE) Helpers.resetGame();

			ySortGroup.sort();
			
			if (Cookie.state == Globals.CURATOR_INTRO_STATE)
			{
				if (state == this.GAME_INTRO)
				{
					handleIntroInput();
				}
				else if (state == this.GAME_OUTRO)
				{
					handleOutroInput();
				}
			}
			else if (state == INTRO)
			{
				handleIntroInput();
			}
			else if (state == SELECTIONS)
			{
				handleCuratorSelectionInput();
				updateCuratorSelectionScreen();
			}
			else if (state == OUTRO)
			{
				handleOutroInput();
			}
		}
		
		
		override public function postUpdate():void
		{
			super.postUpdate();
		}
		
		
		protected function updateCuratorSelectionScreen():void
		{
			
		}
		
		
		protected function handleIntroInput():void
		{
			//			if (FlxG.keys.justPressed(Globals.P1_ACTION_KEY) && curatorIntroSpeech.text.visible)
			if (Helpers.action() && curatorIntroSpeech.visible)
			{
				curatorIntroSpeech.setVisible(false);
				curatorHelp.setVisible(false);
				if (selections.length != 0)
				{
					state = TRANSITION;
					timer.start(1,1,makeCuratorSelectionScreen);
				}
				else
				{
					state = TRANSITION;
					timer.start(1,1,showOutro);
				}
			}
		}
		
		
		protected function showOutro(t:FlxTimer):void
		{
			if (Cookie.state == Globals.CURATOR_INTRO_STATE)
			{
				state = GAME_OUTRO;
			}
			else
			{
				state = OUTRO;
			}
			
			curatorOutroSpeech.setVisible(true);
			curatorHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " TO CONTINUE";
			curatorHelp.setVisible(true);
		}
		
		
		protected function handleOutroInput():void
		{
			//			if (FlxG.keys.justPressed(Globals.P1_ACTION_KEY) && curatorOutroSpeech.text.visible)
			if (Helpers.action() && curatorOutroSpeech.visible)
			{
				Cookie.flush();
				
				curatorOutroSpeech.setVisible(false);
				curatorHelp.setVisible(false);
				
				if (Cookie.state == Globals.CURATOR_INTRO_STATE)
				{
					timer.start(1,1,fadeToStudio);
				}
				else if (decision == this.FINAL_SELECTION_MADE)
				{
					// Currently switches if any selections at all
					timer.start(1,1,fadeToGallery);	
				}
				else if (decision == this.RETURN_TO_STUDIO)
				{
					timer.start(1,1,fadeToStudio);
				}
				else if (decision == this.REMOVED_FROM_EXHIBITION)
				{
					timer.start(1,1,fadeToEnding);
				}
			}
		}
		
		
		protected function fadeToGallery(t:FlxTimer):void
		{
			FlxG.fade(0xFF000000,1,goToGallery);
		}
		
		protected function fadeToStudio(t:FlxTimer):void
		{
			FlxG.fade(0xFF000000,1,goToStudio);
			
		}
		
		protected function fadeToEnding(t:FlxTimer):void
		{
			FlxG.fade(0xFF000000,1,goToEnding);
			
		}
		
		protected function goToGallery():void
		{
			Cookie.state = Globals.GALLERY_STATE;
			Cookie.flush();
			FlxG.switchState(new GalleryState);
		}
		
		
		protected function goToStudio():void
		{
			Cookie.avatarX = -1;
			Cookie.avatarY = -1;
			
			if (Cookie.type == Globals.SPACEWAR)
			{
				Cookie.avatar2X = -1;
				Cookie.avatar2Y = -1;
			}
			
			Cookie.fadeIn = true;
			Cookie.flush();
			
			FlxG.switchState(new studioClass);
		}
		
		
		protected function goToEnding():void
		{
			FlxG.switchState(new EndState);
		}
		
		
		
		protected function handleCuratorSelectionInput():void
		{
			if (Helpers.action())
			{
				if (currentSelectionIndex < selections.length - 1)
				{
					// Show next work
					currentSelectionIndex = (currentSelectionIndex + 1) % selections.length;
					currentSelectionSave = selections[currentSelectionIndex];
					currentSelectionNumberText.text = (currentSelectionIndex+1) + "/" + selections.length;
					currentSelectionTitleText.text = "\"" + currentSelectionSave.info.title.toUpperCase() + "\"";
					currentSelectionTitleText.text += "\n";
					curatorMenuText.text = currentSelectionSave.comment;
					
					currentSelectionWork.updateDisplayGroup(selections[currentSelectionIndex]);
					
					if (currentSelectionIndex < selections.length - 1)
					{
						// There are more works to show
						curatorHelp.text.text = "PRESS " + Helpers.actionString() + " TO VIEW NEXT SELECTION";
					}
					else
					{
						curatorHelp.text.text = "PRESS " + Helpers.actionString() + " TO CONTINUE";
					}
				}
				else
				{
					state = TRANSITION;
					timer.start(1,1,showOutro);
					curatorMenu.visible = false;
					curatorHelp.setVisible(false);
				}
			}
		}
		
		
		//		protected function handleCuratorSelectionInput():void
		//		{
		//			if (this.selections.length > 1 && FlxG.keys.justPressed(Globals.P1_LEFT_KEY))
		//			{
		//				// Scroll left
		//				currentSelectionIndex--;
		//				if (currentSelectionIndex < 0)
		//					currentSelectionIndex = selections.length - 1;
		//				currentSelectionSave = selections[currentSelectionIndex];
		//				currentSelectionNumberText.text = (currentSelectionIndex+1) + "/" + selections.length;
		//				currentSelectionTitleText.text = "\"" + currentSelectionSave.info.title.toUpperCase() + "\"";
		//				currentSelectionTitleText.text += "\n";
		//				curatorMenuText.text = currentSelectionSave.comment;
		//				
		//				currentSelectionWork.updateDisplayGroup(selections[currentSelectionIndex]);
		//			}
		//			else if (this.selections.length > 1 && FlxG.keys.justPressed(Globals.P1_RIGHT_KEY))
		//			{
		//				// Scroll right
		//				currentSelectionIndex = (currentSelectionIndex + 1) % selections.length;
		//				currentSelectionSave = selections[currentSelectionIndex];
		//				currentSelectionNumberText.text = (currentSelectionIndex+1) + "/" + selections.length;
		//				currentSelectionTitleText.text = "\"" + currentSelectionSave.info.title.toUpperCase() + "\"";
		//				currentSelectionTitleText.text += "\n";
		//				curatorMenuText.text = currentSelectionSave.comment;
		//				
		//				currentSelectionWork.updateDisplayGroup(selections[currentSelectionIndex]);
		//			}
		//				//			else if (FlxG.keys.justPressed(Globals.P1_ACTION_KEY))
		//			else if (Helpers.action())
		//			{
		//				state = TRANSITION;
		//				timer.start(1,1,showOutro);
		//				curatorMenu.visible = false;
		//				curatorHelp.setVisible(false);
		//			}
		//		}
		
		
		protected function setupResponseArrays():void
		{
			trace("CuratorState.setupResponseArrays()");
			noWorkIntros = new Array(
				"And you called me to your studio because...?",
				"Is this a new kind of minimalism in your work, or is there genuinely nothing here?",
				"Okay... I'm not seeing any work here at all.",
				"Is this some kind of joke? Where is the work?",
				"Forgive me for being direct, but you don't seem to have any work here.",
				"Unless I'm mistaken, you haven't produced any work at all...",
				"Why did you call me if you don't have any work to show me?",
				"You know, I'm a busy woman, you should only call if you have work to show.",
				"There's nothing here. There's no point in calling me if you have nothing to show me.",
				"There's nothing here to see...",
				"So you've made… nothing?",
				"I'm seeing nothing here, which doesn't really help me put a show together.",
				"Nothing. Okay…",
				"Well, there's nothing here.",
				"I'm here, but there's no art…"
			);
			noSelectionIntros = new Array(
				"It's good to see this, but it's not quite what I'm looking for.",
				"It's very good, but I don't think it's there yet.",
				"Hmmm, there's a lot to like here, but it's not quite ready to show.",
				"I do like this, but it's not really what I was thinking of in terms of the show.",
				"Okay, this is good, but I don't think it's right for the show...",
				"There's a lot of potential with this work, but I think there's something missing.",
				"Right, this is nice work, really nice. But I think you can push further.",
				"It's good, there's no question. But is it great?",
				"There are some lovely touches here, but it's not quite coming together for me.",
				"I'm glad you showed me this, but... I don't know... it's not quite right...",
				"There's something good about this, but it's not ready for the show.",
				"This is nice work, but we need something punchier for the show.",
				"There are some lovely touches here, but it isn't quite coming together.",
				"You're moving in the right direction, I think, but there's nothing I can commit to here.",
				"Yes, this is good work. But not quite what I was thinking of for this show..."
			);
			selectionIntros = new Array(
				"Magic.",
				"Wonderful. This is exactly why I wanted you involved in this show.",
				"Wow. Just wow.",
				"Powerful stuff.",
				"Fantastic!",
				"Yes. I like this a lot.",
				"What can I say? You're making fantastic work.",
				"I knew you'd come through with something great.",
				"It's so exciting to see an artist producing their best work.",
				"This is really special. I'm honoured to be standing here.",
				"You're really on form with this, I'm so impressed.",
				"Yes. Yes. Yes. Great.",
				"You've nailed it.",
				"Perfection.",
				"This is why we wanted you so much for this show."
			);
			
			allSelectionIntros = new Array(
				"Here's what I'm going to take...",
				"Here's what I want...",
				"Here's what I want in the show...",
				"Here's what I'm taking...",
				"I've picked out the following work for the show..."
			);
			partialSelectionIntros = new Array(
				"Here's what I'm going to take...",
				"Here's what I want...",
				"Here's what I want in the show...",
				"Here's what I'm taking...",
				"I've picked out the following work for the show..."
			);
			
			noWorkIntros.sort(Helpers.randomSort);
			noSelectionIntros.sort(Helpers.randomSort);
			selectionIntros.sort(Helpers.randomSort);
			allSelectionIntros.sort(Helpers.randomSort);
			partialSelectionIntros.sort(Helpers.randomSort);
			
			threeWorkFinalOutros = new Array(
				"So, that's fantastic. We have three really strong works from you in the show.",
				"Wonderful. We have what we need for the show now. I'm excited!",
				"So, great, you've really made some genuinely powerful work. I think the show's going to be very exciting.",
				"You've really done a great job, this show is going to be amazing.",
				"So that's three very powerful works for the show now. Superb.",
				"Now we have three of your works for the show. It's going to be great.",
				"That makes three works of yours that will be in the show. Excellent.",
				"Okay, so you've really done a great job. The show will be so strong with your work in there.",
				"That's it. I think the show's ready now. Your works will be totally central to the theme.",
				"Alright. Well, that gives us a really strong and representative set of your works for the show I think."
			);
			someNewWorkFinalOutros = new Array(
				"So that's great. I think that at this point we'll move ahead with what we have now.",
				"So, great, I think we have what we need now.",
				"So, thanks for that. I think we can move ahead with the show at this point.",
				"I'm really pleased. Given the time constraints, I think we'll now move ahead with the show.",
				"So I'm very happy with this. I'll go ahead and put the show together now.",
				"Alright? Great. I think we have what we need and can proceed with the show.",
				"Okay? Good. So we're going ahead with the show at this point I think. Good job.",
				"Great. And with that we're going to go ahead and get the show running now.",
				"Excellent. So I'm going to get the show started now, I think. Your work will be great in there.",
				"It really is good work. In fact, I think we have what we need to get the show going."
			);
			someOldWorkFinalOutros = new Array(
				"So, look, we're on something of a timeline here. I'm going to go ahead and use the work we've already discussed for the show.",
				"With the opening so soon, I think we'll just use the work of yours we've already selected.",
				"At this point, I think we're better to stick with the work we've already taken.",
				"Anyway, we've already selected really strong work of yours and I think we'll move forward with that.",
				"Still, we already have great work from you, so we're going to move ahead with the exhibition that way.",
				"At this point, rather than keep pushing, we're going to go ahead with the work we've already chosen.",
				"So at this stage I think we're better off sticking with the work we've already taken and moving forward with the show.",
				"As of right now I'm going to say we'll stay with the work of your we already have and just move ahead.",
				"So, hmmm. I think what we're going to do is use the work we've already chosen and build the show around that.",
				"That said, I think what we already have is very, very strong, and we're going to base the exhibition around that."
			);
			toGalleryOutros = new Array(
				"See you at the opening!",
				"Obviously I'll hope to see you at the opening as a guest of honour!",
				"It's going to be great!",
				"This is going to be wonderful!",
				"I'm so thrilled to have your work in the show. See you there!",
				"I'm already looking forward to seeing you at the opening!",
				"I'll see you at the opening!",
				"I hope you like what you see at the opening!",
				"I'm looking forward to your thoughts on the exhibition at the opening!",
				"This is going to be a fantastic exhibition!"
			);
			noWorkStudioOutros = new Array(
				"So, hmmm, hopefully you get back into it and try to put something together.",
				"Okay. Well, I think you should just settle in and get to work, really.",
				"I think you need to push your practice a little further.",
				"Still, I'm looking forward to seeing what you can come up with. I'm sure you'll hit it.",
				"Okay. Time for you to get back to work and for me to get back to the museum, I think.",
				"I think the best place for you right now is here in your studio. Working.",
				"Okay, well, I'll see you next time - work hard! I know you can do it!",
				"So ultimately I think the best thing is for you to just re-engage with your practice.",
				"It's not for me to say, perhaps, but I think you really just need to put in some more time with your work.",
				"Let me know when you've got something new. Bye for now!"
			);
			someNewWorkStudioOutros = new Array(
				"So, great stuff. Really looking forward to seeing what you'll come up with next!",
				"This is very exciting. Let me know when you have some more work to view!",
				"Okay, great! So I'll let you get back to work. Call when you've got something new!",
				"You're really on the right track, I think. Call when you have more!",
				"Perfect, this is great work and it's going to be great in the show. Call when you have something new to see!",
				"Excellent. I'll take the work with me and will look forward to your next call!",
				"Okay, so this is really good work. Call when you have some new stuff to look at!",
				"You're doing a great job! Give me a call when there's more to see.",
				"Wonderful, so I'll look forward to your next call.",
				"It's so great to see you producing such high quality work. Call when you have more!"
			);
			someOldWorkStudioOutros = new Array(
				"So I'm glad that we looked at that again. Maybe you could work in that direction with some new work?",
				"I'm so glad we reconsidered that work, it makes the show so much stronger. More please!",
				"It's funny how work can look so different when you see it again. I think this is a good direction for you.",
				"Great, I'm glad we're building up the show. I'm looking forward to your next call.",
				"So it's lucky that we took another look at that work. It's really strong. I'd love to see more.",
				"Some work just takes time. Keep it up, you're definitely onto something with this!",
				"This is a very positive step for the show. Keep making strong work!",
				"I think that work is a great addition to the show. Looking forward to seeing more!",
				"That work is going to be sensational at the show. Can't wait to see what's next!",
				"Lucky we looked at that again! Maybe you can work in that direction some more..."
			);
			noWorkRejectedOutros = new Array(
				"Look, this is kind of awkward, but we've run out of time. We're going to have to drop you from the show. I'm so sorry.",
				"This is always difficult, but we're going to have to drop you from the show I'm afraid. We're right out of time.",
				"God, this is horrible, but we've hit our deadline and we just can't find a way to include you in the show. I'm so sorry.",
				"Look, it's never pleasant to say this, but we're going to drop you from the show - it just isn't working out. I'm sorry.",
				"Oh dear. To be honest, we all out of time for you to produce something for the show. We're going to have to move ahead without you.",
				"This is tough, but we're going to move on with the show without you. This isn't about you, we're just out of time.",
				"I'm really sorry about this, but we're going to have to leave you out of the show at this point. There's just no more time.",
				"I hate to say it, but I think we're going to go ahead without you in the show at this point. This just isn't working.",
				"Hmmm, look... this is terrible, but we're going to drop you from the show. I'm sure there will be another opportunity another time...",
				"I'm really sorry to say it, but we're going to have to leave you out of the show. I mean, it's so very close, but it's just not there."
			);
			
			threeWorkFinalOutros.sort(Helpers.randomSort);
			someNewWorkFinalOutros.sort(Helpers.randomSort);
			someOldWorkFinalOutros.sort(Helpers.randomSort);
			noWorkStudioOutros.sort(Helpers.randomSort);
			someNewWorkStudioOutros.sort(Helpers.randomSort);
			someOldWorkStudioOutros.sort(Helpers.randomSort);
			noWorkRejectedOutros.sort(Helpers.randomSort);
			toGalleryOutros.sort(Helpers.randomSort);			
		}
		
		
		override public function destroy():void
		{
			super.destroy();
			
			if (currentSelectionNumberText != null)
				currentSelectionNumberText.destroy();
			if (currentSelectionTitleText != null)
				currentSelectionTitleText.destroy();		
			
			if (curatorMenu != null)
				curatorMenu.destroy();
			if (curatorMenuText != null)
				curatorMenuText.destroy();
			
			studioBG.destroy();
			
			for (var i:uint = 0; i < savedWorks.length; i++)
				savedWorks[i].destroy();			
			
			avatar.destroy();
			curator.destroy();
			curatorHelp.destroy();
			
			curatorIntroSpeech.destroy();
			curatorOutroSpeech.destroy();
			
			timer.destroy();
		}
	}
}
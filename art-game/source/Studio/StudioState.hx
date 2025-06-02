package Studio
{
	import Gallery.GalleryState;
	import Shared.*;
	import SaveAndReplay.*;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class StudioState extends FlxState
	{
		protected const NONE:uint = 0;
		protected const TITLING:uint = 1;
		
		protected var mode:uint = NONE;
		
		protected var previousState:uint = Globals.NO_STATE;
		protected var previousMenuText:String = "";
		
		protected var type:uint = Globals.NONE;
		
		protected var currentSelectionWork:StudioArtwork;
		protected var currentSelectionSave:Object;
		protected var currentSelectionIndex:int;
		protected var currentSelectionNumberText:FlxText;
		protected var currentSelectionTitleText:FlxText;
		protected var selectionMenuText:FlxText;
		
		protected var selectionMenuItems:Array;
		
		protected var selectionDisplayX:Number;
		protected var selectionDisplayY:Number;
		protected var selectionDisplayTileSize:Number;
		protected var selectionOverlayColour:uint;
		protected var selectionTextColour:uint;
		protected var selectionMenuTextString:String;
		protected var decisionMenuTextString:String;
		
		protected var studioBG:FlxSprite;
		protected var studioHM:FlxSprite;
		
		protected var savedWorks:Array;
		protected var savedWorkScale:Number;
		
		protected var avatar:Artist;
		
		protected var telephoneTriggerZone:FlxSprite;
		
		protected var collidables:Array = new Array();
		protected var ySortGroup:FlxGroup;
		
		protected var studioClass:Class;
		
		protected var leftWall:FlxSprite;
		protected var rightWall:FlxSprite;
		
		protected var moveHelpTimer:FlxTimer = new FlxTimer();
		protected var moveHelp:HelpPopup;
		protected var moveHelpVisible:Boolean = true;
		protected var makeHelp:HelpPopup;
		protected var selectHelp:HelpPopup;
		protected var telephoneHelp:HelpPopup;
		protected var decisionMenuHelp:HelpPopup;
		protected var selectionMenuHelp:HelpPopup;
		
		protected var helpOverlay:HelpOverlay;
		protected var selectionMenu:SelectionMenu;
		protected var decisionMenu:SelectionMenu;
		protected var titlingMenu:TitlingMenu;
		
		protected var decisionMenuItems:Array;
		protected var menuDark:Boolean = true;
		
		
		public function StudioState()
		{
		}
		
		
		override public function create():void
		{
			super.create();
			
			trace("StudioState.create()");
			
			Cookie.load();
			//									Cookie.erase();
			//									Cookie.flush();
			
			ySortGroup = new FlxGroup();
			
			makeStudio();			
			makeAvatar();
			
			
			makeSavedWorks();
			
			
			add(avatar);
			add(ySortGroup);
			
			helpOverlay = new HelpOverlay("");
			helpOverlay.setVisible(false);
			
			selectionMenuItems = new Array();
			selectionMenuItems.push("RETITLE WORK");
			selectionMenuItems.push("TRASH WORK");
			selectionMenuItems.push("EXIT");
			
			decisionMenuItems = new Array();
			decisionMenuItems.push("TITLE WORK");
			decisionMenuItems.push("TRASH WORK");
			decisionMenuItems.push("KEEP WORK");
			
			decisionMenu = new SelectionMenu(360,FlxG.width - 300,decisionMenuItems,menuDark,Cookie.type == Globals.SPACEWAR);
			decisionMenu.disable();
			add(decisionMenu);
			
			selectionMenu = new SelectionMenu(360,FlxG.width - 300,selectionMenuItems,menuDark,Cookie.type == Globals.SPACEWAR);
			selectionMenu.disable();
			add(selectionMenu);
			
			titlingMenu = new TitlingMenu(360,menuDark);
			titlingMenu.disable();
			add(titlingMenu);
			
			
			decisionMenuHelp = new HelpPopup("USE [UP AND DOWN] AND " + Globals.P1_ACTION_KEY_STRING + " TO SELECT AN OPTION");
			decisionMenuHelp.setVisible(false);
			selectionMenuHelp = new HelpPopup("USE [UP AND DOWN] AND " + Globals.P1_ACTION_KEY_STRING + " TO SELECT AN OPTION",FlxObject.DOWN,true);
			selectionMenuHelp.setVisible(false);
			
			
			if (Cookie.state == Globals.DECISION_STATE && Cookie.studioSaveObject.latest != null)
			{
				FlxG.camera.flash(0xFF000000,2);
				makeArtDecisionScreen();
			}
			else if (Cookie.state == Globals.SELECTION_STATE)
			{
				makeArtSelectionScreen();
			}
			else 
			{
				Cookie.state = Globals.STUDIO_STATE;
			}
			
			if (Cookie.fadeIn)
			{
				FlxG.camera.flash(0xFF000000,2);
			}

		}
		
		
		protected function makeStudio():void
		{
			add(studioBG);
			add(studioHM);
			
			leftWall = new FlxSprite(-50,0);
			leftWall.makeGraphic(50,FlxG.height);
			add(leftWall);
			
			rightWall = new FlxSprite(FlxG.width,0);
			rightWall.makeGraphic(50,FlxG.height);
			add(rightWall);
			
			collidables.push(leftWall);
			collidables.push(rightWall);
		}
		
		
		protected function makeAvatar():void
		{
			
		}
		
		
		protected function makeSavedWorks():void
		{
			
		}
		
		
		protected function makeArtDecisionScreen():void
		{
			// We have to display a recently made artwork
			var overlay:FlxSprite = new FlxSprite(0,0);
			overlay.makeGraphic(FlxG.width,FlxG.height,selectionOverlayColour);
			decisionMenu.add(overlay);
			
			currentSelectionSave = Cookie.studioSaveObject.latest;
			var artwork:StudioArtwork = new StudioArtwork();
			
			artwork.createFromSaveObject(selectionDisplayX,selectionDisplayY,selectionDisplayTileSize,currentSelectionSave);
			decisionMenu.add(artwork.displayGroup);
			
			currentSelectionTitleText = new FlxText(0,320,FlxG.width,"");
			currentSelectionTitleText.setFormat("Commodore",18,selectionTextColour,"center");
			if (artwork.info.title != "Untitled")
				currentSelectionTitleText.text = "\"" + artwork.info.title + "\"";
			else
				currentSelectionTitleText.text = "\"UNTITLED\"";
			
			decisionMenu.add(currentSelectionTitleText);
			
			decisionMenu.enable();
			
			add(decisionMenuHelp);
			decisionMenuHelp.setVisible(true);
			
		}		
		
		
		
		
		
		protected function makeArtSelectionScreen():void
		{
			var overlay:FlxSprite = new FlxSprite(0,0);
			overlay.makeGraphic(FlxG.width,FlxG.height,selectionOverlayColour);
			selectionMenu.add(overlay);
			
			currentSelectionIndex = Cookie.studioSaveObject.saves.length - 1;
			currentSelectionSave = Cookie.studioSaveObject.saves[currentSelectionIndex];
			currentSelectionWork = new StudioArtwork();
			currentSelectionWork.createFromSaveObject(selectionDisplayX,selectionDisplayY,selectionDisplayTileSize,currentSelectionSave);
			selectionMenu.add(currentSelectionWork.displayGroup);
			
			currentSelectionNumberText = new FlxText(0,55,FlxG.width,"");
			currentSelectionNumberText.setFormat("Commodore",18,selectionTextColour,"center");
			currentSelectionNumberText.text = (currentSelectionIndex+1) + "/" + Cookie.studioSaveObject.saves.length;
			selectionMenu.add(currentSelectionNumberText);
			
			currentSelectionTitleText = new FlxText(0,320,FlxG.width,"");
			currentSelectionTitleText.setFormat("Commodore",18,selectionTextColour,"center");
			currentSelectionTitleText.text = "\"" + Cookie.studioSaveObject.saves[currentSelectionIndex].info.title.toUpperCase() + "\"";
			currentSelectionTitleText.text += "\n";
			selectionMenu.add(currentSelectionTitleText);
			
			selectionMenuText = new FlxText(0,370,FlxG.width,"");
			selectionMenuText.setFormat("Commodore",18,selectionTextColour,"center");
			selectionMenuText.text = "";
			selectionMenu.add(selectionMenuText);
			
			selectionMenu.enable();
			
			if (Cookie.studioSaveObject.saves.length > 1)
				selectionMenuHelp.text.text = "USE [LEFT AND RIGHT] TO VIEW WORKS AND\n" +
					"[UP AND DOWN] AND " + Globals.P1_ACTION_KEY_STRING + " TO SELECT AN OPTION";
			else
				selectionMenuHelp.text.text = "USE [UP AND DOWN] AND " + Globals.P1_ACTION_KEY_STRING + " TO SELECT AN OPTION";

			add(selectionMenuHelp);
			selectionMenuHelp.setVisible(true);
		}
		
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.ESCAPE) Helpers.resetGame();

			ySortGroup.sort("y", ASCENDING);
			
			if (Cookie.state == Globals.STUDIO_STATE)
			{
				updateStudioMode();
			}
			else if (Cookie.state == Globals.DECISION_STATE)
			{
				updateDecisionMode()
			}
			else if (Cookie.state == Globals.SELECTION_STATE)
			{
				updateSelectionMode();
			}
		}
		
		
		override public function postUpdate():void
		{
			super.postUpdate();
		}
		
		
		protected function checkHelpInput():void
		{
			if (FlxG.keys.justPressed(Globals.P1_ACTION_KEY))
			{
				helpOverlay.setVisible(false);
				Cookie.state = Globals.STUDIO_STATE;
			}
		}
		
		
		protected function updateStudioMode():void
		{
			handleCollisions();
			handleTriggers();			
			handleAvatarInput();
		}
		
		
		protected function updateDecisionMode():void
		{
			if (mode == TITLING)
			{
				updateTitlingMode();
			}
			else
			{
				handleDecisionInput();
			}
		}
		
		
		protected function updateSelectionMode():void
		{
			if (mode == TITLING)
			{
				updateTitlingMode();
			}
			else
			{
				handleSelectionInput();
			}
		}
		
		
		protected function updateTitlingMode():void
		{
			var title:String = titlingMenu.getTitle();
			
			if (title != "")
			{
				mode = NONE;
				
				currentSelectionSave.info.title = title;
				currentSelectionTitleText.text = "\"" + title + "\"";
				Cookie.flush();
				
				if (Cookie.state == Globals.SELECTION_STATE)
				{
					if (Cookie.studioSaveObject.saves.length > 1)
						selectionMenuHelp.text.text = "USE [LEFT AND RIGHT] TO VIEW WORKS AND\n" +
							"[UP AND DOWN] AND " + Globals.P1_ACTION_KEY_STRING + " TO SELECT AN OPTION";
					else
						selectionMenuHelp.text.text = "USE [UP AND DOWN] AND " + Globals.P1_ACTION_KEY_STRING + " TO SELECT AN OPTION";
					selectionMenu.enable();
				}
				else if (Cookie.state == Globals.DECISION_STATE)
				{
					decisionMenuHelp.text.text = "USE [UP AND DOWN] AND " + Globals.P1_ACTION_KEY_STRING + " TO SELECT AN OPTION";
					decisionMenu.enable();
				}
				titlingMenu.disable();
			}
			else
			{
				if (Cookie.state == Globals.SELECTION_STATE)
				{
					selectionMenuHelp.text.text = "TYPE A TITLE AND PRESS [ENTER] TO ACCEPT";
				}
				else if (Cookie.state == Globals.DECISION_STATE)
				{
					decisionMenuHelp.text.text = "TYPE A TITLE AND PRESS [ENTER] TO ACCEPT";
				}
			}
		}
		
		
		private function updateSelectionScreen():void
		{
			
		}
		
		
		protected function handleCollisions():void
		{
			for (var i:int = 0; i < collidables.length; i++)
			{
				if (FlxCollision.pixelPerfectCheck(avatar.hitBox,collidables[i]))
				{
					avatar.x -= avatar.velocity.x * FlxG.elapsed;
					avatar.y -= avatar.velocity.y * FlxG.elapsed;
					
					avatar.velocity.x = 0;
					avatar.velocity.y = 0;
				}
			}
		}
		
		
		protected function handleTriggers():void
		{
			handleArtMakingTrigger();
			handleSelectionTrigger();	
			handleTelephoneTrigger();
		}
		
		
		protected function handleArtMakingTrigger():void
		{
			
		}
		
		
		protected function handleTelephoneTrigger():void
		{
			if (FlxCollision.pixelPerfectCheck(avatar.hitBox,telephoneTriggerZone))
			{
				telephoneHelp.setVisible(true);				
			}
			else
			{
				telephoneHelp.setVisible(false);
			}
		}
		
		
		protected function handleSelectionTrigger():void
		{
		}
		
		
		protected function handleAvatarInput():void
		{
			if ((FlxG.keys.justPressed(Globals.P1_LEFT_KEY) ||
				FlxG.keys.justPressed(Globals.P1_RIGHT_KEY) ||
				FlxG.keys.justPressed(Globals.P1_UP_KEY) ||
				FlxG.keys.justPressed(Globals.P1_DOWN_KEY)) &&
				moveHelpVisible)
			{
				Cookie.moveHelpSeen = true;
				moveHelpVisible = false;
				moveHelpTimer.start(1,1,removeMoveHelp);
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
		}
		
		
		protected function removeMoveHelp(t:FlxTimer):void
		{
			moveHelp.setVisible(false);
		}
		
		protected function handleDecisionInput():void
		{
			if (decisionMenu.selected)
			{
				if (decisionMenu.selection == 0)
				{
					decisionMenu.disable();					
					titlingMenu.enable();
					
					mode = TITLING;
					
					decisionMenuHelp.text.text = "TYPE A TITLE AND PRESS [ENTER] TO ACCEPT";
				}
				else if (decisionMenu.selection == 1)
				{
					Cookie.studioSaveObject.latest = null;
					
					decisionMenu.disable();
					
					Cookie.state = Globals.STUDIO_STATE;
					
					FlxG.switchState(new studioClass);
					
				}
				else if (decisionMenu.selection == 2)
				{
					Cookie.studioSaveObject.latest.id = Cookie.nextID;
					Cookie.nextID++;
					Cookie.studioSaveObject.saves.push(Cookie.studioSaveObject.latest);
					Cookie.studioSaveObject.latest = null;
					
					decisionMenu.disable();
					
					Cookie.state = Globals.STUDIO_STATE;
					
					Cookie.flush();
					
					FlxG.switchState(new studioClass);
				}
			}
		}
		
		
		protected function handleSelectionInput():void
		{
			if (FlxG.keys.justPressed(Globals.P1_LEFT_KEY))
			{
				// Scroll left
				currentSelectionIndex--;
				if (currentSelectionIndex < 0)
					currentSelectionIndex = Cookie.studioSaveObject.saves.length - 1;
				currentSelectionSave = Cookie.studioSaveObject.saves[currentSelectionIndex];
				currentSelectionNumberText.text = (currentSelectionIndex+1) + "/" + Cookie.studioSaveObject.saves.length;
				currentSelectionTitleText.text = "\"" + currentSelectionSave.info.title.toUpperCase() + "\"";
				currentSelectionTitleText.text += "\n";
				
				currentSelectionWork.updateDisplayGroup(Cookie.studioSaveObject.saves[currentSelectionIndex]);
			}
			else if (FlxG.keys.justPressed(Globals.P1_RIGHT_KEY))
			{
				// Scroll right
				currentSelectionIndex = (currentSelectionIndex + 1) % Cookie.studioSaveObject.saves.length;
				currentSelectionSave = Cookie.studioSaveObject.saves[currentSelectionIndex];
				currentSelectionNumberText.text = (currentSelectionIndex+1) + "/" + Cookie.studioSaveObject.saves.length;
				currentSelectionTitleText.text = "\"" + currentSelectionSave.info.title.toUpperCase() + "\"";
				currentSelectionTitleText.text += "\n";
				
				currentSelectionWork.updateDisplayGroup(Cookie.studioSaveObject.saves[currentSelectionIndex]);
			}
			else if (selectionMenu.selected)
			{
				if (selectionMenu.selection == 0)
				{
					selectionMenu.disable();					
					titlingMenu.enable();
					
					mode = TITLING;
					
					selectionMenuHelp.text.text = "TYPE A TITLE AND PRESS [ENTER] TO ACCEPT";
				}
				else if (selectionMenu.selection == 1)
				{
					Cookie.studioSaveObject.saves.splice(currentSelectionIndex,1);
					selectionMenu.selected = false;
					
					if (Cookie.studioSaveObject.saves.length == 0)
					{
						currentSelectionIndex = 0;
						selectionMenu.disable();
						Cookie.state = Globals.STUDIO_STATE;
						FlxG.switchState(new studioClass);
					}
					else
					{
						currentSelectionIndex--;
						if (currentSelectionIndex < 0)
							currentSelectionIndex = Cookie.studioSaveObject.saves.length - 1;
						currentSelectionSave = Cookie.studioSaveObject.saves[currentSelectionIndex];
						currentSelectionNumberText.text = (currentSelectionIndex+1) + "/" + Cookie.studioSaveObject.saves.length;
						currentSelectionTitleText.text = "\"" + currentSelectionSave.info.title.toUpperCase() + "\"";
						currentSelectionTitleText.text += "\n";
						
						currentSelectionWork.updateDisplayGroup(Cookie.studioSaveObject.saves[currentSelectionIndex]);
					}
					
				}
				else if (selectionMenu.selection == 2)
				{
					// Exit selection mode
					Cookie.state = Globals.STUDIO_STATE;
					selectionMenu.disable();
					
					FlxG.switchState(new studioClass);
				}
			}
		}
		
		
		override public function destroy():void
		{
			super.destroy();
			
			if (currentSelectionNumberText != null)
				currentSelectionNumberText.destroy();
			if (currentSelectionTitleText != null)
				currentSelectionTitleText.destroy();
			if (selectionMenuText != null)
				selectionMenuText.destroy();
			
			studioBG.destroy();
			studioHM.destroy();
			
			for (var i:uint = 0; i < savedWorks.length; i++)
				savedWorks[i].destroy();
			
			avatar.destroy();
			
			telephoneTriggerZone.destroy();
			
			leftWall.destroy();
			rightWall.destroy();

			moveHelp.destroy();
			makeHelp.destroy();
			selectHelp.destroy();
			telephoneHelp.destroy();
			decisionMenuHelp.destroy();
			selectionMenuHelp.destroy();
			
			helpOverlay.destroy();
			selectionMenu.destroy();
			decisionMenu.destroy();
			titlingMenu.destroy()				
		}
	}
}
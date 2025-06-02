package Studio 
{
	import Gallery.*;
	
	import Making.SpacewarState;
	
	import Shared.*;
	import SaveAndReplay.*;
	import Curation.*;
	import Studio.*;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class SpacewarStudioState extends StudioState
	{				
		private var selectionTriggerZone:FlxSprite;
		
		private var avatar2:Artist;
		
		private var needleShipHanging:FlxSprite;
		private var needleShipHangingHitBox:FlxSprite;
		private var needleShipHangingTriggerZone:FlxSprite;
		
		private var wedgeShipHanging:FlxSprite;
		private var wedgeShipHangingHitBox:FlxSprite;
		private var wedgeShipHangingTriggerZone:FlxSprite;
		
		private var studioCostumeHM:FlxSprite;
		
		private var avatar1Suited:Boolean = false;
		private var avatar2Suited:Boolean = false; // Note this will be a problem on reload after art making
		
		private var moveHelpTimer2:FlxTimer = new FlxTimer();
		private var moveHelpVisible2:Boolean = true;
		private var moveHelp2:HelpPopup;
		private var makeHelp2:HelpPopup;
		private var selectHelp2:HelpPopup;
		private var telephoneHelp2:HelpPopup;
		
		private var selectHelpSuited:HelpPopup;
		private var telephoneHelpSuited:HelpPopup;
		private var selectHelpSuited2:HelpPopup;
		private var telephoneHelpSuited2:HelpPopup;
		
		private var selectHelpSolo:HelpPopup;
		private var telephoneHelpSolo:HelpPopup;
		private var selectHelpSolo2:HelpPopup;
		private var telephoneHelpSolo2:HelpPopup;
		
		private var decisionMenuHelp2:HelpPopup;
		private var selectionMenuHelp2:HelpPopup;
		
		public function SpacewarStudioState()
		{
		}
		
		
		override public function create():void
		{
			//						Cookie.load();
			//						Cookie.erase();
			//						Cookie.flush();
			//			
			Cookie.load();
			Cookie.type = Globals.SPACEWAR;
			
			studioClass = SpacewarStudioState;
			selectionDisplayX = 180;
			selectionDisplayY = FlxG.height/2 - 150;
			selectionDisplayTileSize = 14;
			selectionOverlayColour = 0xBB000000;
			selectionTextColour = 0xFFFFFFFF;
			selectionMenuTextString = "";
			decisionMenuTextString = "";
			
			savedWorkScale = 2.5;
			
			menuDark = true;
			
			decisionMenuHelp2 = new HelpPopup("USE [UP AND DOWN] TO SELECT AN OPTION",FlxObject.UP);
			decisionMenuHelp2.setVisible(false);
			selectionMenuHelp2 = new HelpPopup("USE [UP AND DOWN] TO SELECT AN OPTION",FlxObject.UP,true);
			selectionMenuHelp2.setVisible(false);
			
			
			super.create();
			
			selectionMenu.setSelectionKey(Globals.P2_ACTION_KEY);
			decisionMenu.setSelectionKey(Globals.P2_ACTION_KEY);
			
			helpOverlay.text.text = "";
			
			trace("SpacewarStudioState.create()");
			
			makeTelephone();
			
			selectionTriggerZone = new FlxSprite(300,280);
			selectionTriggerZone.makeGraphic(100,60,Globals.DEBUG_TRIGGER_COLOUR);
			selectionTriggerZone.visible = Globals.DEBUG_HITBOXES;
			add(selectionTriggerZone);
			
			add(telephoneTriggerZone);
			
			moveHelp = new HelpPopup("USE " + Globals.P1_MOVEMENT_KEYS_STRING + " TO MOVE AROUND THE STUDIO");
			moveHelp2 = new HelpPopup("USE " + Globals.P2_MOVEMENT_KEYS_STRING + " TO MOVE AROUND THE STUDIO",FlxObject.UP);
			
			if (!Cookie.moveHelpSeen)
			{
				moveHelp.setVisible(true);
				moveHelp2.setVisible(true);
			}
			else
			{
				moveHelpVisible = false;
				moveHelp.setVisible(false);
				moveHelp2.setVisible(false);
			}			
			add(moveHelp);
			add(moveHelp2);
			
			//soloMakeHelp = new HelpPopup("BOTH ARTISTS MUST BE IN COSTUME TO START A PERFORMANCE");
			makeHelp = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " TO PUT ON YOUR COSTUME");
			if (Cookie.studioSaveObject.saves.length > 0)
			{
				selectHelp = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO WATCH YOUR PERFORMANCES");
			}
			else
			{
				selectHelp = new HelpPopup("THERE ARE NO PERFORMANCES TO LOOK AT YET");
			}			
			telephoneHelp = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO CALL THE CURATOR");
			add(makeHelp);
			add(selectHelp);
			add(telephoneHelp);
			
			
			makeHelp2 = new HelpPopup("PRESS " + Globals.P2_ACTION_KEY_STRING + " TO PUT ON YOUR COSTUME",FlxObject.UP);
			if (Cookie.studioSaveObject.saves.length > 0)
			{
				selectHelp2 = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO WATCH YOUR PERFORMANCES",FlxObject.UP);
			}
			else
			{
				selectHelp2 = new HelpPopup("THERE ARE NO PERFORMANCES TO LOOK AT YET",FlxObject.UP);
			}
			telephoneHelp2 = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO CALL THE CURATOR",FlxObject.UP);
			add(makeHelp2);
			add(selectHelp2);
			add(telephoneHelp2);
			
			selectHelpSuited = new HelpPopup("YOU CAN'T USE THE COMPUTER WHILE IN COSTUME");
			telephoneHelpSuited = new HelpPopup("YOU CAN'T CALL THE CURATOR WHILE IN COSTUME");
			add(selectHelpSuited);
			add(telephoneHelpSuited);
			
			selectHelpSuited2 = new HelpPopup("YOU CAN'T USE THE COMPUTER WHILE IN COSTUME",FlxObject.UP);
			telephoneHelpSuited2 = new HelpPopup("YOU CAN'T CALL THE CURATOR WHILE IN COSTUME",FlxObject.UP);
			add(selectHelpSuited2);
			add(telephoneHelpSuited2);
			
			selectHelpSolo = new HelpPopup("YOU CAN'T USE THE COMPUTER ON YOUR OWN");
			telephoneHelpSolo = new HelpPopup("YOU CAN'T CALL THE CURATOR ON YOUR OWN");
			add(selectHelpSolo);
			add(telephoneHelpSolo);
			
			selectHelpSolo2 = new HelpPopup("YOU CAN'T USE THE COMPUTER ON YOUR OWN", FlxObject.UP);
			telephoneHelpSolo2 = new HelpPopup("YOU CAN'T CALL THE CURATOR ON YOUR OWN", FlxObject.UP);
			add(selectHelpSolo2);
			add(telephoneHelpSolo2);		
			
		}
		
		
		override protected function makeStudio():void
		{
			studioBG = new FlxSprite(0,0,Assets.SPACEWAR_STUDIO_BG_PNG);
			
			studioHM = new FlxSprite(0,0,Assets.SPACEWAR_STUDIO_HM_PNG);
			studioHM.visible = false;
			collidables.push(studioHM);
			
			super.makeStudio();
			
			studioCostumeHM = new FlxSprite(0,0,Assets.SPACEWAR_STUDIO_COSTUME_HM_PNG);
			studioCostumeHM.visible = false;
			add(studioCostumeHM);
			
			needleShipHanging = new FlxSprite(35,110,Assets.NEEDLE_SHIP_HANGING_PNG);
			needleShipHanging.visible = true;
			add(needleShipHanging);
			
			needleShipHangingHitBox = new FlxSprite(0,0);
			needleShipHangingHitBox.makeGraphic(needleShipHanging.width,50,Globals.DEBUG_HITBOX_COLOUR);
			needleShipHangingHitBox.x = needleShipHanging.x;
			needleShipHangingHitBox.y = needleShipHanging.y + needleShipHanging.height - needleShipHangingHitBox.height;
			needleShipHangingHitBox.visible = Globals.DEBUG_HITBOXES;
			add(needleShipHangingHitBox);
			
			needleShipHangingTriggerZone = new FlxSprite(0,0);
			needleShipHangingTriggerZone.makeGraphic(needleShipHanging.width,50,Globals.DEBUG_TRIGGER_COLOUR);
			needleShipHangingTriggerZone.x = needleShipHanging.x;
			needleShipHangingTriggerZone.y = needleShipHanging.y + needleShipHanging.height;
			needleShipHangingTriggerZone.visible = Globals.DEBUG_HITBOXES;
			add(needleShipHangingTriggerZone);
			
			wedgeShipHanging = new FlxSprite(120,125,Assets.WEDGE_SHIP_HANGING_PNG);
			wedgeShipHanging.visible = true;
			add(wedgeShipHanging);
			
			wedgeShipHangingHitBox = new FlxSprite(0,0);
			wedgeShipHangingHitBox.makeGraphic(wedgeShipHanging.width,50,Globals.DEBUG_HITBOX_COLOUR);
			wedgeShipHangingHitBox.x = wedgeShipHanging.x;
			wedgeShipHangingHitBox.y = wedgeShipHanging.y + wedgeShipHanging.height - wedgeShipHangingHitBox.height;
			wedgeShipHangingHitBox.visible = Globals.DEBUG_HITBOXES;
			add(wedgeShipHangingHitBox);
			
			wedgeShipHangingTriggerZone = new FlxSprite(0,0);
			wedgeShipHangingTriggerZone.makeGraphic(wedgeShipHanging.width,50,Globals.DEBUG_TRIGGER_COLOUR);
			wedgeShipHangingTriggerZone.x = wedgeShipHanging.x;
			wedgeShipHangingTriggerZone.y = wedgeShipHanging.y + wedgeShipHanging.height;
			wedgeShipHangingTriggerZone.visible = Globals.DEBUG_HITBOXES;
			add(wedgeShipHangingTriggerZone);
			
		}
		
		
		override protected function makeAvatar():void
		{
			if (Cookie.avatarX == -1 && Cookie.avatarY == -1)
			{
				avatar = new Artist(280,300,Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG,FlxObject.RIGHT);
			}
			else
			{
				if (Cookie.state == Globals.DECISION_STATE)
				{
					avatar = new Artist(40,180,Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG,FlxObject.UP);
					Cookie.avatarX = avatar.x;
					Cookie.avatarY = avatar.y;
					Cookie.flush();
				}
				else
				{
					avatar = new Artist(Cookie.avatarX,Cookie.avatarY,Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG,FlxObject.UP);
				}
			}
			avatar.addCostume(Globals.NEEDLE);
			
			if (Cookie.avatar2X == -1 && Cookie.avatar2Y == -1)
			{
				avatar2 = new Artist(380,300,Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG,FlxObject.LEFT);
			}
			else
			{
				if (Cookie.state == Globals.DECISION_STATE)
				{
					avatar2 = new Artist(160,180,Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG,FlxObject.UP);
					Cookie.avatar2X = avatar2.x;
					Cookie.avatar2Y = avatar2.y;
					Cookie.flush();
				}
				else
				{
					avatar2 = new Artist(Cookie.avatar2X,Cookie.avatar2Y,Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG,FlxObject.UP);
				}
			}
			avatar2.addCostume(Globals.WEDGE);
			
			ySortGroup.add(avatar.displayGroup);
			
			ySortGroup.add(avatar2.displayGroup);
			
			add(avatar2);
		}
		
		
		override protected function makeSavedWorks():void
		{
			trace("SpacewarStudioState.makeSavedWorks()");
			savedWorks = new Array();
			
			
			if (Cookie.studioSaveObject.saves.length == 0)
			{
				trace("... studio saves are empty.");
				return;
			}
			
			trace("... adding most recent video to screen.");
			
			var save:Object = Cookie.studioSaveObject.saves[Cookie.studioSaveObject.saves.length-1];
			var artwork:StudioArtwork = new StudioArtwork();
			
			artwork.createFromSaveObject(
				321,
				192,
				savedWorkScale,
				save);
			
			add(artwork.displayGroup);
		}
		
		
		override protected function makeArtDecisionScreen():void
		{
			super.makeArtDecisionScreen();
			
			decisionMenuHelp.text.text = "USE " + Globals.P2_ACTION_KEY_STRING + " TO SELECT THE CURRENT OPTION";
			decisionMenuHelp2.setVisible(true);
			add(decisionMenuHelp2);
		}
		
		
		override protected function makeArtSelectionScreen():void
		{
			super.makeArtSelectionScreen();
			
			if (Cookie.studioSaveObject.saves.length > 1)
			{
				selectionMenuHelp.text.text = "USE [LEFT AND RIGHT] TO VIEW WORKS\nUSE [UP AND DOWN] TO HIGHLIGHT AN OPTION";
				selectionMenuHelp2.text.text = "USE " + Globals.P2_ACTION_KEY_STRING + " TO SELECT THE CURRENT OPTION";
			}
			else
			{
				selectionMenuHelp.text.text = "USE [UP AND DOWN] TO HIGHLIGHT AN OPTION";
				selectionMenuHelp2.text.text = "USE " + Globals.P2_ACTION_KEY_STRING + " TO SELECT THE CURRENT OPTION";
			}
			
			selectionMenuHelp2.setVisible(true);
			add(selectionMenuHelp2);
		}
		
		
		
		private function makeTelephone():void
		{
			telephoneTriggerZone = new FlxSprite();
			telephoneTriggerZone.makeGraphic(70,50,Globals.DEBUG_TRIGGER_COLOUR);
			telephoneTriggerZone.x = 530;
			telephoneTriggerZone.y = FlxG.height/2 + 40;
			telephoneTriggerZone.visible = Globals.DEBUG_HITBOXES;
		}
		
		
		override protected function checkHelpInput():void
		{
			//			if (FlxG.keys.justPressed(Globals.P2_ACTION_KEY))
			//			{
			//				super.checkHelpInput();
			//			}
			
			if (Helpers.action())
			{
				helpOverlay.setVisible(false);
				Cookie.state = Globals.STUDIO_STATE;
			}
		}
		
		
		override protected function updateTitlingMode():void
		{
			super.updateTitlingMode();
			
			if (mode == NONE)
			{
				if (Cookie.state == Globals.SELECTION_STATE)
				{
					if (Cookie.studioSaveObject.saves.length > 1)
					{
						selectionMenuHelp.text.text = "USE [LEFT AND RIGHT] TO VIEW WORKS\nUSE [UP AND DOWN] TO HIGHLIGHT AN OPTION";
						selectionMenuHelp2.text.text = "USE " + Globals.P2_ACTION_KEY_STRING + " TO SELECT THE CURRENT OPTION";
					}
					else
					{
						selectionMenuHelp.text.text = "USE [UP AND DOWN] TO HIGHLIGHT AN OPTION";
						selectionMenuHelp2.text.text = "USE " + Globals.P2_ACTION_KEY_STRING + " TO SELECT THE CURRENT OPTION";
					}
				}
				else if (Cookie.state == Globals.DECISION_STATE)
				{
					decisionMenuHelp.text.text = "USE [UP AND DOWN] TO HIGHLIGHT AN OPTION";
					decisionMenuHelp2.text.text = "USE " + Globals.P2_ACTION_KEY_STRING + " TO SELECT THE CURRENT OPTION";
				}
			}
			else if (mode == TITLING)
			{
				if (Cookie.state == Globals.SELECTION_STATE)
				{
					selectionMenuHelp2.text.text = "TYPE A TITLE AND PRESS [ENTER] TO ACCEPT";
				}
				else if (Cookie.state == Globals.DECISION_STATE)
				{
					decisionMenuHelp2.text.text = "TYPE A TITLE AND PRESS [ENTER] TO ACCEPT";
				}
				
			}
		}
		
		
		override protected function handleDecisionInput():void
		{
			super.handleDecisionInput();
			
			if (mode == TITLING)
			{
				decisionMenuHelp2.text.text = "TYPE A TITLE AND PRESS [ENTER] TO ACCEPT";
			}
		}
		
		
		override protected function handleSelectionInput():void
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
					selectionMenuHelp2.text.text = "TYPE A TITLE AND PRESS [ENTER] TO ACCEPT";
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
		
		
		override protected function handleArtMakingTrigger():void
		{
			makeHelp.setVisible(false);
			makeHelp2.setVisible(false);
			
			if (FlxCollision.pixelPerfectCheck(avatar.hitBox,needleShipHangingTriggerZone) && !avatar.fallen)
			{
				if (avatar1Suited)
					makeHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " TO REMOVE YOUR COSTUME";
				else
					makeHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " TO PUT ON YOUR COSTUME";
				makeHelp.setVisible(true);
			}
			else if (FlxCollision.pixelPerfectCheck(avatar.hitBox,wedgeShipHangingTriggerZone) && !avatar.fallen)
			{
				makeHelp.text.text = "THIS IS NOT YOUR COSTUME";
				makeHelp.setVisible(true);	
			}
			
			if (FlxCollision.pixelPerfectCheck(avatar2.hitBox,wedgeShipHangingTriggerZone) && !avatar2.fallen)
			{
				if (avatar2Suited)
					makeHelp2.text.text = "PRESS " + Globals.P2_ACTION_KEY_STRING + " TO REMOVE YOUR COSTUME";
				else
					makeHelp2.text.text = "PRESS " + Globals.P2_ACTION_KEY_STRING + " TO PUT ON YOUR COSTUME";
				makeHelp2.setVisible(true);	
			}
			else if (FlxCollision.pixelPerfectCheck(avatar2.hitBox,needleShipHangingTriggerZone) && !avatar2.fallen)
			{
				makeHelp2.text.text = "THIS IS NOT YOUR COSTUME";
				makeHelp2.setVisible(true);	
			}
			
			
			if (avatar1Suited && avatar2Suited)
			{
				Cookie.avatarX = avatar.sprite.x;
				Cookie.avatarY = avatar.sprite.y;
				Cookie.flush();
				
				Cookie.avatar2X = avatar2.sprite.x;
				Cookie.avatar2Y = avatar2.sprite.y;
				
				Cookie.state = Globals.MAKE_STATE;
				
				makeHelp.setVisible(false);
				makeHelp2.setVisible(false);
				
				Cookie.flush();
				
				avatar.stop();
				avatar2.stop();
				
				FlxG.fade(0xFF000000,1,goToSpacewarState);
				
			}
		}
		
		
		private function goToSpacewarState():void
		{
			FlxG.switchState(new SpacewarState);
		}
		
		override protected function handleSelectionTrigger():void
		{
			selectHelp.setVisible(!avatar1Suited &&
				!avatar2Suited &&
				FlxCollision.pixelPerfectCheck(avatar.hitBox,selectionTriggerZone) &&
				FlxCollision.pixelPerfectCheck(avatar2.hitBox,selectionTriggerZone));
			
			selectHelp2.setVisible(!avatar1Suited &&
				!avatar2Suited &&
				FlxCollision.pixelPerfectCheck(avatar.hitBox,selectionTriggerZone) &&
				FlxCollision.pixelPerfectCheck(avatar2.hitBox,selectionTriggerZone));
			
			selectHelpSolo.setVisible(!avatar1Suited &&
				FlxCollision.pixelPerfectCheck(avatar.hitBox,selectionTriggerZone) &&
				(!FlxCollision.pixelPerfectCheck(avatar2.hitBox,selectionTriggerZone) ||
					avatar2Suited));
			
			selectHelpSolo2.setVisible(!avatar2Suited &&
				(!FlxCollision.pixelPerfectCheck(avatar.hitBox,selectionTriggerZone) ||
					avatar1Suited) &&
				FlxCollision.pixelPerfectCheck(avatar2.hitBox,selectionTriggerZone));
			
			selectHelpSuited.setVisible(avatar1Suited && FlxCollision.pixelPerfectCheck(avatar.hitBox,selectionTriggerZone));
			
			selectHelpSuited2.setVisible(avatar2Suited && FlxCollision.pixelPerfectCheck(avatar2.hitBox,selectionTriggerZone));
			
			if (avatar1Suited || avatar2Suited)
			{
				return;	
			}
			
			if (FlxCollision.pixelPerfectCheck(avatar.hitBox,selectionTriggerZone) &&
				FlxCollision.pixelPerfectCheck(avatar2.hitBox,selectionTriggerZone) &&
				Cookie.studioSaveObject.saves.length > 0)
			{
				//				if (FlxG.keys.justPressed(Globals.P1_ACTION_KEY) && FlxG.keys.justPressed(Globals.P2_ACTION_KEY))
				if (Helpers.action())
				{
					Cookie.state = Globals.SELECTION_STATE;	
					
					Cookie.avatarX = avatar.sprite.x;
					Cookie.avatarY = avatar.sprite.y;
					Cookie.flush();
					
					Cookie.avatar2X = avatar2.sprite.x;
					Cookie.avatar2Y = avatar2.sprite.y;
					Cookie.flush();
					
					FlxG.switchState(new studioClass);
				}
			}
		}
		
		
		override protected function handleTelephoneTrigger():void
		{
			telephoneHelp.setVisible(!avatar1Suited &&
				!avatar2Suited &&
				FlxCollision.pixelPerfectCheck(avatar.hitBox,telephoneTriggerZone) &&
				FlxCollision.pixelPerfectCheck(avatar2.hitBox,telephoneTriggerZone));
			
			telephoneHelp2.setVisible(!avatar1Suited &&
				!avatar2Suited &&
				FlxCollision.pixelPerfectCheck(avatar.hitBox,telephoneTriggerZone) &&
				FlxCollision.pixelPerfectCheck(avatar2.hitBox,telephoneTriggerZone));
			
			telephoneHelpSolo.setVisible(!avatar1Suited &&
				FlxCollision.pixelPerfectCheck(avatar.hitBox,telephoneTriggerZone) &&
				(!FlxCollision.pixelPerfectCheck(avatar2.hitBox,telephoneTriggerZone) ||
					avatar2Suited));
			
			telephoneHelpSolo2.setVisible(!avatar2Suited &&
				(!FlxCollision.pixelPerfectCheck(avatar.hitBox,telephoneTriggerZone) ||
					avatar1Suited) &&
				FlxCollision.pixelPerfectCheck(avatar2.hitBox,telephoneTriggerZone));
			
			telephoneHelpSuited.setVisible(avatar1Suited && FlxCollision.pixelPerfectCheck(avatar.hitBox,telephoneTriggerZone));
			
			telephoneHelpSuited2.setVisible(avatar2Suited && FlxCollision.pixelPerfectCheck(avatar2.hitBox,telephoneTriggerZone));
			
			
			if (avatar1Suited || avatar2Suited)
			{
				return;	
			}
			
			if (FlxCollision.pixelPerfectCheck(avatar2.hitBox,telephoneTriggerZone) &&
				FlxCollision.pixelPerfectCheck(avatar.hitBox,telephoneTriggerZone))
			{
				//				if (FlxG.keys.justPressed(Globals.P2_ACTION_KEY) && FlxG.keys.justPressed(Globals.P1_ACTION_KEY))
				if (Helpers.action())
				{			
					FlxG.fade(0xFF000000,1,goToCuratorState);
					avatar.stop();
					avatar2.stop();
					Cookie.state = Globals.CURATOR_STATE;
					telephoneHelp.setVisible(false);
					telephoneHelp2.setVisible(false);
					Cookie.flush();
				}
			}
		}
		
		private function goToCuratorState():void
		{
			FlxG.switchState(new SpacewarCuratorState);
		}
		
		
		override public function update():void
		{
			super.update();	
		}
		
		
		override protected function handleCollisions():void
		{
			super.handleCollisions();
			
			var a1collision:Boolean = false;
			var a2collision:Boolean = false;
			
			// CHECK: Collision with collidables
			for (var i:int = 0; i < collidables.length; i++)
			{
				if (FlxCollision.pixelPerfectCheck(avatar2.hitBox,collidables[i]))
				{
					a2collision = true;
				}
			}
			
			// CHECK: Collision with costumes
			if ((FlxCollision.pixelPerfectCheck(avatar.hitBox,this.needleShipHangingHitBox) &&
				this.needleShipHanging.visible) ||
				(FlxCollision.pixelPerfectCheck(avatar.hitBox,this.wedgeShipHangingHitBox) &&
					this.wedgeShipHanging.visible))
			{
				a1collision = true;
			}			
			if ((FlxCollision.pixelPerfectCheck(avatar2.hitBox,this.needleShipHangingHitBox) &&
				this.needleShipHanging.visible) ||
				(FlxCollision.pixelPerfectCheck(avatar2.hitBox,this.wedgeShipHangingHitBox) &&
					this.wedgeShipHanging.visible))
			{
				a2collision = true;
			}
			
			if (avatar.hitBox.overlaps(avatar2.hitBox) || avatar2.hitBox.overlaps(avatar.hitBox))
			{
				a1collision = true;
				a2collision = true;
			}
			
			// CHECK: Avatar knocked down by costume
			if (!avatar2.fallen && 
				avatar.costume.visible && 
				avatar.costumeHitBox.overlaps(avatar2.headHitBox))
			{
				a1collision = true;
				a2collision = true;
				avatar2.velocity.x *= 2;
				avatar2.velocity.y *= 2;
				avatar2.fall();
			}	
			if (!avatar.fallen && 
				avatar2.costume.visible && 
				avatar2.costumeHitBox.overlaps(avatar.headHitBox))
			{
				a1collision = true;
				a2collision = true;
				avatar.velocity.x *= 2;
				avatar.velocity.y *= 2;
				avatar.fall();
			}
			
			// CHECK: Costume hitting side walls
			if (avatar.costume.visible &&
				((avatar.costumeHitBox.overlaps(leftWall) && avatar.sprite.facing == FlxObject.LEFT) || 
					(avatar.costumeHitBox.overlaps(rightWall) && avatar.sprite.facing == FlxObject.RIGHT)))
			{
				a1collision = true;
			}
			if (avatar2.costume.visible &&
				((avatar2.costumeHitBox.overlaps(leftWall) && avatar2.sprite.facing == FlxObject.LEFT) || 
					(avatar2.costumeHitBox.overlaps(rightWall) && avatar2.sprite.facing == FlxObject.RIGHT)))
			{
				a2collision = true;
			}
			
			// CHECK: Costume hitting costume collision map
			if (avatar.costume.visible &&
				avatar.sprite.facing == FlxObject.UP &&
				FlxCollision.pixelPerfectCheck(avatar.costumeHitBox,studioCostumeHM))
			{
				a1collision = true;
			}
			if (avatar2.costume.visible &&
				avatar2.sprite.facing == FlxObject.UP &&
				FlxCollision.pixelPerfectCheck(avatar2.costumeHitBox,studioCostumeHM))
			{
				a2collision = true;
			}
			
			// Adjsut for the collision
			if (a1collision)
			{
				avatar.x -= avatar.velocity.x * FlxG.elapsed;
				avatar.y -= avatar.velocity.y * FlxG.elapsed;
				
				avatar.velocity.x = 0;
				avatar.velocity.y = 0;
			}
			if (a2collision)
			{
				avatar2.x -= avatar2.velocity.x * FlxG.elapsed;
				avatar2.y -= avatar2.velocity.y * FlxG.elapsed;
				
				avatar2.velocity.x = 0;
				avatar2.velocity.y = 0;
			}
			
		}
		
		
		override protected function handleTriggers():void
		{
			super.handleTriggers();
			
			handleCostumeTrigger();
		}
		
		
		private function handleCostumeTrigger():void
		{
			if (avatar.hitBox.overlaps(needleShipHangingTriggerZone) && FlxG.keys.justPressed(Globals.P1_ACTION_KEY) && !avatar.fallen)
			{
				avatar.toggleCostumeVisible();
				needleShipHanging.visible = !needleShipHanging.visible;
				avatar1Suited = !needleShipHanging.visible;
			}
			if (avatar2.hitBox.overlaps(wedgeShipHangingTriggerZone) && FlxG.keys.justPressed(Globals.P2_ACTION_KEY) && !avatar2.fallen)
			{
				avatar2.toggleCostumeVisible();
				wedgeShipHanging.visible = !wedgeShipHanging.visible;
				avatar2Suited = !wedgeShipHanging.visible;
			}
		}
		
		
		override protected function handleAvatarInput():void
		{
			if ((FlxG.keys.justPressed(Globals.P2_LEFT_KEY) || 
				FlxG.keys.justPressed(Globals.P2_RIGHT_KEY) || 
				FlxG.keys.justPressed(Globals.P2_UP_KEY) ||
				FlxG.keys.justPressed(Globals.P2_DOWN_KEY)) &&
				moveHelpVisible2)
			{
				Cookie.moveHelpSeen = true;
				moveHelpVisible2 = false;
				moveHelpTimer2.start(1,1,removeMoveHelp2);
			}
			
			if (FlxG.keys.justPressed(Globals.P1_LEFT_KEY) || 
				FlxG.keys.justPressed(Globals.P1_RIGHT_KEY) || 
				FlxG.keys.justPressed(Globals.P1_UP_KEY) ||
				FlxG.keys.justPressed(Globals.P1_DOWN_KEY))
			{
				if (!(avatar.fallen && avatar2.costume.visible && avatar.headHitBox.overlaps(avatar2.costumeHitBox)))
				{
					super.handleAvatarInput();
				}
				else
				{
					avatar.sprite.frame = Assets.SIDE_IDLE_FRAME;
				}
			}
			
			if ((FlxG.keys.justPressed(Globals.P2_LEFT_KEY) || 
				FlxG.keys.justPressed(Globals.P2_RIGHT_KEY) || 
				FlxG.keys.justPressed(Globals.P2_UP_KEY) ||
				FlxG.keys.justPressed(Globals.P2_DOWN_KEY)) && 
				avatar2.fallen && 
				avatar.costume.visible && 
				avatar2.headHitBox.overlaps(avatar.costumeHitBox))
			{
				avatar2.sprite.frame = Assets.SIDE_IDLE_FRAME;
				return;
			}
			
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
		
		
		private function removeMoveHelp2(t:FlxTimer):void
		{
			moveHelp2.setVisible(false);
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			selectionTriggerZone.destroy();
			
			avatar2.destroy();
			
			
			needleShipHanging.destroy();
			needleShipHangingHitBox.destroy();
			needleShipHangingTriggerZone.destroy();
			
			wedgeShipHanging.destroy();
			wedgeShipHangingHitBox.destroy();
			wedgeShipHangingTriggerZone.destroy();
			
			studioCostumeHM.destroy();
			
			moveHelp2.destroy();
			makeHelp2.destroy();
			selectHelp2.destroy();
			telephoneHelp2.destroy();
			
			selectHelpSuited.destroy();
			telephoneHelpSuited.destroy();
			selectHelpSuited2.destroy();
			telephoneHelpSuited2.destroy();
			
			selectHelpSolo.destroy();
			telephoneHelpSolo.destroy();
			selectHelpSolo2.destroy();
			telephoneHelpSolo2.destroy();
			
			decisionMenuHelp2.destroy();
			selectionMenuHelp2.destroy();
		}
	}
}
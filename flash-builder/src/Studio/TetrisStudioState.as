package Studio 
{
	import Gallery.*;
	import Making.TetrisState;
	import SaveAndReplay.*;
	import Curation.*;
	import Shared.*;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class TetrisStudioState extends StudioState
	{		
		private var workbench:FlxSprite;
		private var workbenchHitBox:FlxSprite;
		private var workbenchTriggerZone:FlxSprite;
		
		private var selectionTriggerZone:FlxSprite;
		
		public function TetrisStudioState()
		{
		}
		
		
		override public function create():void
		{
			trace("TetrisStudioState.create()");

			Cookie.load();
			Cookie.type = Globals.TETRIS;

			type = Globals.TETRIS;
			
			studioClass = TetrisStudioState;
			//			selectionDisplayX = FlxG.width/2/2;
			selectionDisplayX = 255;
			selectionDisplayY = FlxG.height/2 + 50;
			selectionDisplayTileSize = 9;
			selectionOverlayColour = 0xCCFFFFFF;
			selectionTextColour = 0xFF000000;
			selectionMenuTextString = "";
			decisionMenuTextString = "";

			savedWorkScale = 10;

			menuDark = false;


			super.create();
					
			helpOverlay.text.text = "";
			
			makeWorkbench();
			makeTelephone();
			
			selectionTriggerZone = new FlxSprite(50,300);
			selectionTriggerZone.makeGraphic(420,50,0xAA00FF00);
			selectionTriggerZone.visible = Globals.DEBUG_HITBOXES;
			add(selectionTriggerZone);
			
			add(workbenchHitBox);
			add(workbenchTriggerZone);
			add(telephoneTriggerZone);
			
			moveHelp = new HelpPopup("USE " + Globals.P1_MOVEMENT_KEYS_STRING + " TO MOVE AROUND THE STUDIO");
			if (!Cookie.moveHelpSeen)
			{
				moveHelp.setVisible(true);
			}
			else
			{
				moveHelpVisible = false;
				moveHelp.setVisible(false);
			}

			makeHelp = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " TO START MAKING A NEW SCULPTURE");
			selectHelp = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " TO LOOK AT YOUR CURRENT SCULPTURES");
			telephoneHelp = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " TO CALL THE CURATOR");
			add(makeHelp);
			add(selectHelp);
			add(telephoneHelp);
			
		}
		
		
		override protected function makeStudio():void
		{
			trace("TetrisStudioState.makeStudio()");
			
			studioBG = new FlxSprite(0,0,Assets.TETRIS_STUDIO_BG_PNG);
			
			studioHM = new FlxSprite(0,0,Assets.TETRIS_STUDIO_HM_PNG);
			studioHM.visible = false;
			collidables.push(studioHM);
			
			super.makeStudio();
		}
		
		
		private function makeWorkbench():void
		{
			workbench = new FlxSprite(130,380,Assets.TETRIS_STUDIO_WORKBENCH_PNG);
			ySortGroup.add(workbench);
			
			workbenchHitBox = new FlxSprite(0,0);
			workbenchHitBox.makeGraphic(workbench.width, 30, 0xAA00FF00);
			workbenchHitBox.x = workbench.x;
			workbenchHitBox.y = workbench.y + workbench.height - workbenchHitBox.height;
			workbenchHitBox.visible = Globals.DEBUG_HITBOXES;
			collidables.push(workbenchHitBox);
			ySortGroup.add(workbenchHitBox);
			
			workbenchTriggerZone = new FlxSprite(0,0);
			workbenchTriggerZone.makeGraphic(workbench.width,40,0xAA00FF00);
			workbenchTriggerZone.x = workbench.x;
			workbenchTriggerZone.y = workbench.y + workbench.height/2 - workbenchTriggerZone.height;
			workbenchTriggerZone.visible = Globals.DEBUG_HITBOXES;
			ySortGroup.add(workbenchTriggerZone)
		}
		
		
		override protected function makeAvatar():void
		{
			if (Cookie.avatarX == -1 && Cookie.avatarY == -1)
			{
				avatar = new Artist(300,190,Assets.TETRIS_ARTIST_WALK_CYCLE_PNG,FlxObject.DOWN);
			}
			else
			{
				if (Cookie.avatarY > FlxG.height/2)
					avatar = new Artist(Cookie.avatarX,Cookie.avatarY,Assets.TETRIS_ARTIST_WALK_CYCLE_PNG,FlxObject.DOWN);
				else
					avatar = new Artist(Cookie.avatarX,Cookie.avatarY,Assets.TETRIS_ARTIST_WALK_CYCLE_PNG,FlxObject.UP);
			}

			ySortGroup.add(avatar.sprite);
		}
		
		
		override protected function makeSavedWorks():void
		{
			trace("TetrisStudioState.makeSavedWorks()");
			
			savedWorks = new Array();
						
			for (var i:int = 0, j:int = Cookie.studioSaveObject.saves.length - 2; 
				i < 2 && j < Cookie.studioSaveObject.saves.length; 
				i++, j++)
			{
				if (j < 0) continue;
				
				var save:Object = Cookie.studioSaveObject.saves[j];
				var artwork:StudioArtwork = new StudioArtwork();
				
				artwork.createFromSaveObject(
					Globals.TETRIS_WORK_STUDIO_POSITIONS[i][0],
					Globals.TETRIS_WORK_STUDIO_POSITIONS[i][1],
					savedWorkScale,save);
				
				savedWorks.push(artwork);
				collidables.push(artwork.hitBox);
				
				add(artwork.displayGroup);
			}
		}
		
		
		private function makeTelephone():void
		{
			telephoneTriggerZone = new FlxSprite();
			telephoneTriggerZone.makeGraphic(30,40,0xAA00FF00);
			telephoneTriggerZone.x = 565;
			telephoneTriggerZone.y = FlxG.height/2 + 40;
			telephoneTriggerZone.visible = Globals.DEBUG_HITBOXES;
		}
		
		
		override protected function handleArtMakingTrigger():void
		{
			if (FlxCollision.pixelPerfectCheck(avatar.hitBox,workbenchTriggerZone))
			{
				if (moveHelp.text.visible)
				{
					moveHelp.setVisible(false);
				}
				makeHelp.setVisible(true);
				
				if (FlxG.keys.justPressed(Globals.P1_ACTION_KEY))
				{
					Cookie.avatarX = avatar.sprite.x;
					Cookie.avatarY = avatar.sprite.y;
					
					Cookie.state = Globals.MAKE_STATE;
					makeHelp.setVisible(false);
					
					Cookie.flush();

					avatar.stop();
					
					FlxG.fade(0xFF000000,1,goToTetrisState);
				}
			}
			else
			{
				makeHelp.setVisible(false);
			}
		}
		
		
		private function goToTetrisState():void
		{
			FlxG.switchState(new TetrisState);
		}
		
		
		override protected function handleSelectionTrigger():void
		{
			if (FlxCollision.pixelPerfectCheck(avatar.hitBox,selectionTriggerZone) && Cookie.studioSaveObject.saves.length != 0)
			{
				selectHelp.setVisible(true);

				if (FlxG.keys.justPressed(Globals.P1_ACTION_KEY))
				{
					Cookie.state = Globals.SELECTION_STATE;	
					
					Cookie.avatarX = avatar.sprite.x;
					Cookie.avatarY = avatar.sprite.y;
					Cookie.flush();

					FlxG.switchState(new studioClass);
				}
			}
			else
			{
				selectHelp.setVisible(false);
			}

		}
		
		
		override protected function handleTelephoneTrigger():void
		{
			if (Cookie.state != Globals.NO_STATE)
				super.handleTelephoneTrigger();
			
			if (FlxCollision.pixelPerfectCheck(avatar.hitBox,telephoneTriggerZone) && FlxG.keys.justPressed(Globals.P1_ACTION_KEY))
			{				
				FlxG.fade(0xFF000000,1,goToCuratorState);
				telephoneHelp.setVisible(false);
				Cookie.state = Globals.CURATOR_STATE;
				Cookie.flush();
				
				avatar.stop();
			}
		}
		
		private function goToCuratorState():void
		{
			FlxG.switchState(new TetrisCuratorState);
		}
		
		
		override public function update():void
		{
			super.update();			
		}
		
		
		override public function destroy():void
		{
			super.destroy();
			
			workbench.destroy();
			workbenchHitBox.destroy();
			workbenchTriggerZone.destroy();
			
			selectionTriggerZone.destroy();

		}
	}
}
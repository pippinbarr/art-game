package Studio 
{
	import Gallery.*;
	
	import Making.SnakeState;
	import SaveAndReplay.*;
	import Curation.*;
	import Shared.*;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class SnakeStudioState extends StudioState
	{		
		private var easel:FlxSprite;
		private var easelHitBox:FlxSprite;
		private var easelTriggerZone:FlxSprite;
			
		
		public function SnakeStudioState()
		{
		}
		
		
		override public function create():void
		{
			
			trace("SnakeStudioState.create()");
			
			Cookie.load();
			Cookie.type = Globals.SNAKE;
			
			type = Globals.SNAKE;
			
			studioClass = SnakeStudioState;
			selectionDisplayTileSize = 14;
			selectionDisplayX = (FlxG.width / 2) - 140;
			selectionDisplayY = FlxG.height/2 - 150;
			selectionOverlayColour = 0xBB000000;
			selectionTextColour = 0xFFFFFFFF;
			selectionMenuTextString = "";
			decisionMenuTextString = "";
			savedWorkScale = 8;
			
			menuDark = true;
			
			super.create();

			helpOverlay.text.text = "";

			makeEasel();
			makeTelephone();
			
			add(easelHitBox);
			add(easelTriggerZone);
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
			makeHelp = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " TO START A NEW PAINTING");
			selectHelp = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " TO LOOK AT YOUR CURRENT PAINTINGS");
			telephoneHelp = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " TO CALL THE CURATOR");
			add(moveHelp);
			add(makeHelp);
			add(selectHelp);
			add(telephoneHelp);
			
		}
		
		
		override protected function makeStudio():void
		{
			studioBG = new FlxSprite(0,0,Assets.SNAKE_STUDIO_BG_PNG);
			
			studioHM = new FlxSprite(0,0,Assets.SNAKE_STUDIO_HM_PNG);
			studioHM.visible = false;
			collidables.push(studioHM);
			
			super.makeStudio();
		}
		
		
		private function makeEasel():void
		{
			easel = new FlxSprite(50,200,Assets.EASEL_PNG);
			
			easelHitBox = new FlxSprite(0,0);
			easelHitBox.makeGraphic(easel.width, 30, 0xAA00FF00);
			easelHitBox.x = easel.x;
			easelHitBox.y = easel.y + easel.height - easelHitBox.height;
			easelHitBox.visible = Globals.DEBUG_HITBOXES;
			collidables.push(easelHitBox);
			ySortGroup.add(easel);
			
			easelTriggerZone = new FlxSprite(0,0);
			easelTriggerZone.makeGraphic(easel.width - 50,40,0xAA00FF00);
			easelTriggerZone.x = easel.x + 25;
			easelTriggerZone.y = easel.y + easel.height;
			easelTriggerZone.visible = Globals.DEBUG_HITBOXES;
		}
		
		
		override protected function makeAvatar():void
		{
			if (Cookie.avatarX != -1 && Cookie.avatarY != -1)
				avatar = new Artist(Cookie.avatarX,Cookie.avatarY,Assets.SNAKE_ARTIST_WALK_CYCLE_PNG,FlxObject.UP);
			else
				avatar = new Artist(300,200,Assets.SNAKE_ARTIST_WALK_CYCLE_PNG,FlxObject.DOWN);
			ySortGroup.add(avatar.sprite);
		}
		
		
		override protected function makeSavedWorks():void
		{
			savedWorks = new Array();
			
			for (var i:int = 0, j:int = Cookie.studioSaveObject.saves.length - 3; 
				i < 3 && j < Cookie.studioSaveObject.saves.length; 
				i++, j++)
			{
				if (j < 0) continue;
				
				var save:Object = Cookie.studioSaveObject.saves[j];
				var artwork:StudioArtwork = new StudioArtwork();
				
				trace("Loading saved work " + i);
				trace("makeSavedWorks() -> artwork.createFromSaveObject(" + Globals.SNAKE_WORK_STUDIO_POSITIONS[i][0] + 
					  "," + Globals.SNAKE_WORK_STUDIO_POSITIONS[i][1] +
					  "," + savedWorkScale +
					  "," + save);
				artwork.createFromSaveObject(
					Globals.SNAKE_WORK_STUDIO_POSITIONS[i][0],
					Globals.SNAKE_WORK_STUDIO_POSITIONS[i][1],
					savedWorkScale,
					save);
				
				savedWorks.push(artwork);
				collidables.push(artwork.hitBox);
				
				add(artwork.displayGroup);
			}
		}
		
		
		private function makeTelephone():void
		{
			telephoneTriggerZone = new FlxSprite();
			telephoneTriggerZone.makeGraphic(30,40,0xAA00FF00);
			telephoneTriggerZone.x = 590;
			telephoneTriggerZone.y = FlxG.height/2 + 40;
			telephoneTriggerZone.visible = Globals.DEBUG_HITBOXES;
		}
		
		
		override protected function handleArtMakingTrigger():void
		{
			if (FlxCollision.pixelPerfectCheck(avatar.hitBox,easelTriggerZone))
			{
				makeHelp.setVisible(true);
				
				if (FlxG.keys.justPressed(Globals.P1_ACTION_KEY))
				{
					Cookie.avatarX = avatar.sprite.x;
					Cookie.avatarY = avatar.sprite.y;
					
					makeHelp.setVisible(false);
					
					Cookie.state = Globals.MAKE_STATE;
					
					Cookie.flush();
					
					avatar.stop();
					
					FlxG.fade(0xFF000000,1,goToSnakeState);
				}
			}
			else
			{
				makeHelp.setVisible(false);
			}
		}
		
		
		private function goToSnakeState():void
		{
			FlxG.switchState(new SnakeState);
		}
		
		
		override protected function handleSelectionTrigger():void
		{
			var helpVisible:Boolean = false;
			
			for (var i:int = 0; i < savedWorks.length; i++)
			{
				if (FlxCollision.pixelPerfectCheck(avatar.hitBox,savedWorks[i].triggerZone))
				{
					helpVisible = true;
					
					if (FlxG.keys.justPressed(Globals.P1_ACTION_KEY))
					{
						Cookie.state = Globals.SELECTION_STATE;
						
						Cookie.avatarX = avatar.sprite.x;
						Cookie.avatarY = avatar.sprite.y;
						Cookie.flush();
						FlxG.switchState(new studioClass);
					}
				}
			}
			
			selectHelp.setVisible(helpVisible);
		}

		
		override protected function handleTelephoneTrigger():void
		{
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
			FlxG.switchState(new SnakeCuratorState);
		}

		
		
		override public function update():void
		{
			super.update();			
		}
		
		
		override public function destroy():void
		{
			super.destroy();
			
			easel.destroy();
			easelHitBox.destroy();
			easelTriggerZone.destroy();
		}
	}
}
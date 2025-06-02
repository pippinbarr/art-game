package Curation 
{
	import Gallery.*;
	
	import Shared.*;
	import SaveAndReplay.*;

	import Studio.*;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class SpacewarCuratorState extends CuratorState
	{						
		private var avatar2:Artist;
		
		private var curatorHelp2:HelpPopup;
		
		private var needleShipHanging:FlxSprite;		
		private var wedgeShipHanging:FlxSprite;
		
		public function SpacewarCuratorState()
		{
		}
		
		
		override public function create():void
		{
			//						Cookie.load();
			//						Cookie.erase();
			//						Cookie.flush();
			Cookie.load();
			Cookie.type = Globals.SPACEWAR;
			//			
			type = Globals.SPACEWAR;
			
			studioClass = SpacewarStudioState;
			selectionDisplayX = 180;
			selectionDisplayY = FlxG.height/2 - 150;
			selectionDisplayTileSize = 14;
			selectionOverlayColour = 0xBB000000;
			selectionTextColour = 0xFFFFFFFF;
			selectionMenuTextString = "";
			
			savedWorkScale = 2.5;
			
			menuDark = true;
			
			GAME_INTRO_MESSAGE = "" +
				"Hi " + Globals.SPACEWAR_ARTIST_FIRST_NAME + ", " +
				"it's great to have you involved in our new show at MoMA. " +
				"I've always deeply admired your work.";		
			GAME_OUTRO_MESSAGE = "" +
				"Give me a call when you've made some candidate videos and I'll come over and take a look.";
			
			
			if (Cookie.newSelectionComments.length == 0)
			{
				trace("Making newSelectionComments Array");
				Cookie.newSelectionComments = new Array(
					"It rare for a performance work to be so clear, but here I think we really see into the heart of things.",
					"This is such an evocative use of movement, it makes me weep and smile at the same time.",
					"I don't really understand the thought process behind this, but it's such a wonderful aesthetic performance.",
					"For me, this just so clearly channels the preoccupations of our contemporary culture. It speaks through movement.",
					"What a powerful statement this is about aggression and forgiveness. It's masterful.",
					"You both move so beautifully together here, it's really very poignant to watch.",
					"I think even the harshest critic will agree that this is a powerful and touching performance.",
					"I just love that you were so brave with this performance. It's the kind of thing people need to see more of.",
					"This is a stunning display of how movement can translate so flawlessly into a kind of kinetic poetry.",
					"It's a tour de force of video art. I feel so privileged to be able to include this in the show.",
					"I don't know how you come up with the choreography of these pieces, but this one is just divine.",
					"It's effortless and breathtaking. Bravo.",
					"Such raw emotion here. I'm finding it difficult to remain calm while watching it.",
					"I'm in love with this work. You move so beautifully together.",
					"It's so very human, and that makes it so very sad and beautiful. I love it."
				);
			}
			if (Cookie.reconsideredSelectionComments.length == 0)
			{
				Cookie.reconsideredSelectionComments = new Array(
					"I hadn't quite grasped some of the subtleties of the piece the first time, but now I see it far more clearly. Wonderful.",
					"I admit I overlooked this when I first saw it, but this is a truly magnificent exhibition of the human form in motion.",
					"How you achieve this level of narrative through movement I simply do not understand.",
					"What a terrific piece this is - it took seeing it again to really come to terms with the poetry involved.",
					"This really is an aesthetically challenging work. At first I was repelled, but now I'm fascinated.",
					"I think you're breaking boundaries here. I was unsure about it's inclusion, but people must see this performance.",
					"This is, quite simply, a masterful piece of video art. It's quiet on first glance, but I love the way it grows to a thunderclap.",
					"What a piece of magic you have made together here. I'm so full of admiration for the thoughtfulness it shows.",
					"I'm ashamed to say I didn't even consider this at first, but now I find myself utterly drawn to the emotions it pours out.",
					"It really breaks my heart. It's not until several repeat viewings that you can really feel this piece.",
					"I just can't believe I missed this the first time. It's lyrical and muscular at the same time.",
					"This blows me away now that I'm seeing it again. Such forceful choreography.",
					"There's so much pain in this work, I think I wasn't able to cope with it the first time I saw it.",
					"This time around I can see how much subtlety there is here, building to such a crescendo. Bravo.",
					"The story of this piece stuck with me after the first time and it just won't let me go."
				);
			}
			
			Cookie.newSelectionComments.sort(Helpers.randomSort);
			Cookie.reconsideredSelectionComments.sort(Helpers.randomSort);
			
			Cookie.flush();
			
			super.create();
			
			curatorHelp2 = new HelpPopup("PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO CONTINUE",FlxObject.UP);
			curatorHelp2.setVisible(false);
			curatorHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO CONTINUE";
			makeTelephone();			
		}
		
		
		override protected function makeStudio():void
		{
			studioBG = new FlxSprite(0,0,Assets.SPACEWAR_STUDIO_BG_PNG);
			
			super.makeStudio();
			
			needleShipHanging = new FlxSprite(35,110,Assets.NEEDLE_SHIP_HANGING_PNG);
			needleShipHanging.visible = true;
			add(needleShipHanging);
			
			wedgeShipHanging = new FlxSprite(120,125,Assets.WEDGE_SHIP_HANGING_PNG);
			wedgeShipHanging.visible = true;
			add(wedgeShipHanging);			
		}
		
		
		override protected function makeAvatar():void
		{
			if (Cookie.state == Globals.CURATOR_INTRO_STATE)
			{
				avatar = new Artist(380,200,Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG,FlxObject.LEFT);
				avatar.addCostume(Globals.NEEDLE);
				
				avatar2 = new Artist(280,200,Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG,FlxObject.RIGHT);
				avatar2.addCostume(Globals.WEDGE);
				
				curator = new FlxSprite(330,180);
				curator.loadGraphic(Assets.CURATOR_CYCLE_PNG,true,true,56,140);
				curator.facing = FlxObject.DOWN;
				curator.frame = 14;
			}
			else
			{
				avatar = new Artist(380,200,Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG,FlxObject.UP);
				avatar.addCostume(Globals.NEEDLE);
				
				avatar2 = new Artist(280,200,Assets.SPACEWAR_ARTIST_WALK_CYCLE_PNG,FlxObject.UP);
				avatar2.addCostume(Globals.WEDGE);
				
				curator = new FlxSprite(330,200);
				curator.loadGraphic(Assets.CURATOR_CYCLE_PNG,true,true,56,140);
				curator.facing = FlxObject.UP;
				curator.frame = 21;
			}
			
			
			ySortGroup.add(curator);
			
			ySortGroup.add(avatar.displayGroup);
			
			ySortGroup.add(avatar2.displayGroup);
			
			add(avatar2);
		}
		
		
		override protected function makeSavedWorks():void
		{
			savedWorks = new Array();
			
			if (Cookie.studioSaveObject.saves.length == 0)
			{
				trace("Studio saves are empty.");
				return;
			}
			
			trace("SpacewarStudioState.makeSavedWorks()");
			
			var save:Object = Cookie.studioSaveObject.saves[Cookie.studioSaveObject.saves.length-1];
			var artwork:StudioArtwork = new StudioArtwork();
			
			artwork.createFromSaveObject(
				321,192,
				savedWorkScale,
				save);
			
			add(artwork.displayGroup);
		}
		
		override protected function makeCuratorSelectionScreen(t:FlxTimer = null):void
		{
			super.makeCuratorSelectionScreen();
			
			if (selections.length > 1)
				//			{
				//				curatorHelp2.text.text = "USE [A AND D] TO VIEW SELECTED WORKS";
				//				curatorHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " WHEN DONE";
				//				curatorHelp2.setVisible(true);
				//			}
				
				if (selections.length > 1)
					curatorHelp2.text.text = "PRESS " + Helpers.actionString() + " TO VIEW NEXT SELECTION";
				else
					curatorHelp2.text.text = "PRESS " + Helpers.actionString() + " TO CONTINUE";
			curatorHelp2.setVisible(true);
			
		}
		
		
		override protected function sayCuratorIntro(t:FlxTimer):void
		{
			super.sayCuratorIntro(t);
			curatorHelp2.setVisible(true);
		}
		
		
		
		override protected function handleIntroInput():void
		{
			trace("handleIntroInput()");
			//			if (FlxG.keys.justPressed(Globals.P2_ACTION_KEY) && FlxG.keys.justPressed(Globals.P1_ACTION_KEY) && curatorIntroSpeech.text.visible)
			if (Helpers.action() && curatorIntroSpeech.visible)
			{
				curatorIntroSpeech.setVisible(false);
				curatorHelp.setVisible(false);
				curatorHelp2.setVisible(false);
				
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
		
		
		override protected function showOutro(t:FlxTimer):void
		{
			curatorHelp2.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO CONTINUE";
			curatorHelp2.setVisible(true);
			super.showOutro(t);
			curatorHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " AND " + Globals.P2_ACTION_KEY_STRING + " TOGETHER TO CONTINUE";
		}
		
		
		override protected function handleOutroInput():void
		{
			//			if (FlxG.keys.justPressed(Globals.P2_ACTION_KEY) && FlxG.keys.justPressed(Globals.P1_ACTION_KEY) && curatorOutroSpeech.text.visible)
			if (Helpers.action() && curatorOutroSpeech.visible)
			{
				curatorHelp.setVisible(false);
				curatorHelp2.setVisible(false);
				Cookie.flush();
				
				curatorOutroSpeech.setVisible(false);
				
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
		
		
		override protected function handleCuratorSelectionInput():void
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
						curatorHelp2.text.text = "PRESS " + Helpers.actionString() + " TO VIEW NEXT SELECTION";
					}
					else
					{
						curatorHelp.text.text = "PRESS " + Helpers.actionString() + " TO CONTINUE";
						curatorHelp2.text.text = "PRESS " + Helpers.actionString() + " TO CONTINUE";
					}
				}
				else
				{
					state = TRANSITION;
					timer.start(1,1,showOutro);
					curatorMenu.visible = false;
					curatorHelp.setVisible(false);
					curatorHelp2.setVisible(false);
				}
			}
		}
		
		
		
		private function makeTelephone():void
		{
		}
		
		
		override public function update():void
		{
			super.update();	
		}
		
		
		override public function destroy():void
		{
			super.destroy();
			
			avatar2.destroy();
			curatorHelp2.destroy();
			needleShipHanging.destroy();
			wedgeShipHanging.destroy();
		}
	}
}
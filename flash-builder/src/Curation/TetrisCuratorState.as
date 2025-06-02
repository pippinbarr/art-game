package Curation 
{
	import Gallery.*;
	import Shared.*;
	
	import Making.TetrisState;
	import Studio.*;
	
	import Shared.Artist;
	import Shared.Cookie;
	import Shared.HelpPopup;
	import SaveAndReplay.StudioArtwork;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class TetrisCuratorState extends CuratorState
	{		
		private var workbench:FlxSprite;
		
		public function TetrisCuratorState()
		{
		}
		
		
		override public function create():void
		{
			
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
			
			savedWorkScale = 10;
			
			menuDark = false;
			
			GAME_INTRO_MESSAGE = "" +
				"Hi " + Globals.TETRIS_ARTIST_FIRST_NAME + ", " +
				"it's great to be able to include you in our new show at MoMA. " +
				"I think your sculptures are really going to bring the show together.";		
			GAME_OUTRO_MESSAGE = "" +
				"Give me a call when you've made some candidate sculptures and I'll come over and take a look.";

			if (Cookie.newSelectionComments.length == 0)
			{
				trace("Making newSelectionComments Array");
				Cookie.newSelectionComments = new Array(
					"It's honestly a great honour to stand in front of a work like this. Superb.",
					"I'm not sure how you achieved such a perfect balance of gravity and lightness here, but it's incredible.",
					"It really speaks to me as a piece about what it means to be human today. It's in.",
					"I think this is going to cause a sensation at the show, the level of mastery is just unbelievable.",
					"What an emotional piece this is. Heart-stopping.",
					"I just love this. Nothing's held back. It's raw feeling.",
					"It's silly perhaps, but for me this truly is the meaning of the word 'sculptural'. Just lovely.",
					"I love that there's so much open space for interpretation here, you've really welcomed the audience in.",
					"It's almost unspeakably beautiful. A real tour de force.",
					"I really think people are going to be talking about this work for a long time. Such grace.",
					"This is so exhilaratingly physical - it almost forces me to take a step back just to cope with its presence.",
					"This is such a monument to sculpture, if you'll pardon the expression. Very postmodern.",
					"I knew you'd have something so wonderfully architectural in you for the show. Wonderful.",
					"It's almost like a cathedral, a place for people to be quiet and reverent.",
					"This is simply a masterpiece. There's nothing I can say, really."
				);
			}
			if (Cookie.reconsideredSelectionComments.length == 0)
			{
				trace("Making reconsideredSelectionComments Array");
				Cookie.reconsideredSelectionComments = new Array(
					"Now I see this again, I feel I've really connected with the materiality of the work.",
					"What a monumental work. I'm not clear why I didn't put it in the show immediately, but let me correct that now.",
					"This work simply demands serious thought, I'm embarrassed I overlooked it earlier.",
					"It's overpowering, really. I don't think I understood what I was seeing last time. It's in.",
					"This is a truly great work. This could easily be the piece that holds the whole show together.",
					"I missed this somehow last time. Now I see that while it's a quiet piece, it's a potent one.",
					"Such a wonderfully feminine spirit expressed here - it's completely won me over.",
					"This is gorgeous, but it's a slow burner. I hadn't really connected with it the first time.",
					"People are going to be really challenged by this. I wasn't sure about including it, but I think we have to.",
					"I think this is the kind of work that defines careers. I apologize for not recognizing its genius sooner.",
					"I was mistaken in passing this one up earlier, this is a powerful work.",
					"Seeing it again, I understand the narrative that much better I think. Magnificent.",
					"I'm sorry for missing this one last time, it's so clearly engaging with contemporary practice.",
					"It's extraordinary. I think I only missed it last time because I wasn't truly ready to engage at its level.",
					"It's a juggernaut of sculpture. I think it was too epic in ambition for me to comprehend last time."
				);
			}
			Cookie.newSelectionComments.sort(Helpers.randomSort);
			Cookie.reconsideredSelectionComments.sort(Helpers.randomSort);

			Cookie.flush();

			trace("newSelectionComments looks like this:");
			trace(Cookie.newSelectionComments);

			super.create();
			
			makeWorkbench();
			makeTelephone();			
		}
		
		
		override protected function makeStudio():void
		{
			trace("TetrisStudioState.makeStudio()");
			
			studioBG = new FlxSprite(0,0,Assets.TETRIS_STUDIO_BG_PNG);			
			
			super.makeStudio();
		}
		
		
		private function makeWorkbench():void
		{
			workbench = new FlxSprite(130,380,Assets.TETRIS_STUDIO_WORKBENCH_PNG);
			ySortGroup.add(workbench);
		}
		
		
		override protected function makeAvatar():void
		{
			if (Cookie.state == Globals.CURATOR_INTRO_STATE)
			{
				avatar = new Artist(200,200,Assets.TETRIS_ARTIST_WALK_CYCLE_PNG,FlxObject.RIGHT);
				avatar.sprite.frame = 22;
				
				curator = new FlxSprite(260,200);
				curator.loadGraphic(Assets.CURATOR_CYCLE_PNG,true,true,56,140);
				curator.facing = FlxObject.LEFT;
				curator.frame = 22;
			}
			else
			{
				avatar = new Artist(200,200,Assets.TETRIS_ARTIST_WALK_CYCLE_PNG,FlxObject.UP);
				avatar.sprite.frame = 21;
				
				curator = new FlxSprite(260,200);
				curator.loadGraphic(Assets.CURATOR_CYCLE_PNG,true,true,56,140);
				curator.facing = FlxObject.UP;
				curator.frame = 21;
			}
			
			ySortGroup.add(avatar.displayGroup);
			ySortGroup.add(curator);
		}
		
		
		override protected function makeSavedWorks():void
		{
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
				
				add(artwork.displayGroup);
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
			
			workbench.destroy();
		}
	}
}
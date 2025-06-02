package Curation 
{
	import Gallery.*;
	import Studio.*;
	
	import Making.SnakeState;
	
	import Shared.*;
	import SaveAndReplay.*;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class SnakeCuratorState extends CuratorState
	{		
		private var easel:FlxSprite;
		
		
		public function SnakeCuratorState()
		{
		}
		
		
		override public function create():void
		{
			
			trace("SnakeCuratorState.create()");
			
			Cookie.load();
			Cookie.type = Globals.SNAKE;
			
			type = Globals.SNAKE;
			
			studioClass = SnakeStudioState;
			selectionDisplayX = 180;
			selectionDisplayY = FlxG.height/2 - 150;
			selectionDisplayTileSize = 14;
			selectionOverlayColour = 0xBB000000;
			selectionTextColour = 0xFFFFFFFF;
			selectionMenuTextString = "";
			
			savedWorkScale = 8;
			
			menuDark = true;
			
			GAME_INTRO_MESSAGE = "" +
				"Hi " + Globals.SNAKE_ARTIST_FIRST_NAME + ", " +
				"so it's great to have you in our new show at MoMA. " +
				"I think your paintings are really going to stand out.";		
			GAME_OUTRO_MESSAGE = "" +
				"Give me a call when you've made some candidate paintings and I'll come over and take a look.";
			
			if (Cookie.newSelectionComments.length == 0)
			{
				trace("Making new Cookie.newSelectionComments Array");
				Cookie.newSelectionComments = new Array(
					"It's such a strong line you've achieved here. Bold but able to be so lyrical at the same time.",
					"This is a spectacular piece of work, everything is in the right place.",
					"This draws the eye in immediately and somehow you just can't look away. So forceful!",
					"It's so rare these days for minimalism to be emotional, but somehow you achieve it.",
					"It's hard to believe you've managed to reach the tonalities of feeling you have here.",
					"It's so gracefully done, as if one can re-read the very path of the brushstrokes.",
					"This is such a powerful work, it demands attention and then rewards it deeply.",
					"This almost leaves me speechless, you really are a poet with the brush.",
					"You've really got something here, I almost wonder if this is a new direction for painting.",
					"It's just wonderful, light-hearted, but seeming to hold deep secrets.",
					"This is a sensation. No one paints like you.",
					"It's so brooding and magnificent - this will look extraordinary in the gallery space.",
					"What an incredible painting this is. You've really captured something deeply emotional here.",
					"I've never seen anything so moody and optimistic at the same time. It's genius.",
					"The use of space here is what makes this such an important painting."
				);
			}
			
			if (Cookie.reconsideredSelectionComments.length == 0)
			{
				trace("Making new Cookie.reconsideredSelectionComments Array");
				Cookie.reconsideredSelectionComments = new Array(
					"In re-encountering this work, it really has something. It rewards attentive viewing.",
					"I couldn't stop thinking about this work after I left last time. It's absolutely in the show.",
					"It's strange, I passed this over before, but now I find it mesmerising, the form is incredible.",
					"I've fallen in love with this work now. It takes time to understand, but when you do... wow.",
					"What an evocative piece. I'd earlier thought it was perhaps too much, but clearly I was wrong. It's in.",
					"This is the kind of work I love. It takes some getting used to, but then overpowers you with emotion.",
					"This is a sensation. I couldn't see it at first, but now I know. It's a masterpiece.",
					"You've really achieved something wonderful here. I love it.",
					"We'll have people coming back to the show just to spend more time with this work I think. It's a companion.",
					"What a beautiful painting you've made here, I'm not sure how I missed it last time.",
					"Wow. I think I wasn't ready for this painting last time. Now it's hitting me full force.",
					"I was so wrong to pass this by earlier, it's a truly magnetic work.",
					"How did I miss this last time? This is painting at its absolute finest, somehow both abstract and figurative.",
					"I may have passed this one by last time, but this is absolutely in the show. Magnificent.",
					"I missed it before, but the quality and expressiveness of the brushwork here is just magical."
				);
			}
			
			Cookie.newSelectionComments.sort(Helpers.randomSort);
			Cookie.reconsideredSelectionComments.sort(Helpers.randomSort);
			
			trace("Flushing Cookie.");
			Cookie.flush();
			
			super.create();
			
			makeEasel();
			makeTelephone();			
		}
		
		
		override protected function makeStudio():void
		{
			studioBG = new FlxSprite(0,0,Assets.SNAKE_STUDIO_BG_PNG);
			
			super.makeStudio();
		}
		
		
		private function makeEasel():void
		{
			easel = new FlxSprite(50,200,Assets.EASEL_PNG);
			ySortGroup.add(easel);			
		}
		
		
		override protected function makeAvatar():void
		{
			if (Cookie.state == Globals.CURATOR_INTRO_STATE)
			{
				avatar = new Artist(350,230,Assets.SNAKE_ARTIST_WALK_CYCLE_PNG,FlxObject.RIGHT);
				avatar.sprite.frame = 22;
				
				curator = new FlxSprite(430,230);
				curator.loadGraphic(Assets.CURATOR_CYCLE_PNG,true,true,56,140);
				curator.facing = FlxObject.LEFT;
				curator.frame = 22;
			}
			else
			{
				avatar = new Artist(350,230,Assets.SNAKE_ARTIST_WALK_CYCLE_PNG,FlxObject.UP);
				avatar.sprite.frame = 21;
				
				curator = new FlxSprite(400,230);
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
			
			for (var i:int = 0, j:int = Cookie.studioSaveObject.saves.length - 3; 
				i < 3 && j < Cookie.studioSaveObject.saves.length; 
				i++, j++)
			{
				if (j < 0) continue;
				
				var save:Object = Cookie.studioSaveObject.saves[j];
				var artwork:StudioArtwork = new StudioArtwork();				
				
				artwork.createFromSaveObject(
					Globals.SNAKE_WORK_STUDIO_POSITIONS[i][0],
					Globals.SNAKE_WORK_STUDIO_POSITIONS[i][1],
					savedWorkScale,
					save);
				
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
		}
	}
}
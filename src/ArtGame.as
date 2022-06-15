package
{
	
	import org.flixel.FlxGame;
	import org.flixel.FlxG;
	import Gallery.*;
	import Studio.*;
	import Making.*;
	import Shared.*;
	
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.system.fscommand;
	
	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
	//[Frame(factoryClass="ArtGamePreloader")]

	public class ArtGame extends FlxGame
	{
		public function ArtGame()
		{
			Helpers.setupAction();
			
//			super(640,480,SnakeState,Globals.ZOOM,Globals.FRAME_RATE,30);
//			super(640,480,TetrisState,Globals.ZOOM,Globals.FRAME_RATE,30);
//			super(640,480,SpacewarState,Globals.ZOOM,Globals.FRAME_RATE,30);
//			super(640,480,TetrisStudioState,Globals.ZOOM,Globals.FRAME_RATE,30);
//			super(640,480,SnakeStudioState,Globals.ZOOM,Globals.FRAME_RATE,30);
//			super(640,480,SpacewarStudioState,Globals.ZOOM,Globals.FRAME_RATE,30);
//			super(640,480,GalleryState,Globals.ZOOM,Globals.FRAME_RATE,30);
			super(640,480,MainMenuState,Globals.ZOOM,Globals.FRAME_RATE,30,false);
//			super(640,480,EndState,Globals.ZOOM,Globals.FRAME_RATE,30);
		
			this.useSoundHotKeys = false;
			FlxG.volume = 1.0;
			FlxG.debug = Globals.DEBUG_MODE;
			FlxG.visualDebug = false; //Globals.DEBUG_HITBOXES;	
			
			/////////////////////////////////
			
			
			FlxG.stage.showDefaultContextMenu = false;
			FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
			FlxG.stage.scaleMode = StageScaleMode.SHOW_ALL;
			FlxG.stage.fullScreenSourceRect = new Rectangle(0,0,640,480);
			
			FlxG.stage.align = StageAlign.TOP;
			
			fscommand("trapallkeys","true");
		}
	}
}
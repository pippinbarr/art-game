package Making
{
	
	import Shared.*;
	import SaveAndReplay.*;
	import Studio.SpacewarStudioState;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	
	public class SpacewarState extends FlxState
	{
		private const TILE_SIZE:Number = 32; // Just for scaling.
		
		private var needle:SpacewarShip;
		private var needleMissiles:FlxGroup;
		
		private var wedge:SpacewarShip;
		private var wedgeMissiles:FlxGroup;
		
		private var star:FlxSprite;
		
		private var bg:FlxSprite;
		
		private var needleKeys:Array = new Array(Globals.P1_LEFT_KEY,Globals.P1_RIGHT_KEY,Globals.P1_UP_KEY,Globals.P1_ACTION_KEY);
		private var wedgeKeys:Array = new Array(Globals.P2_LEFT_KEY,Globals.P2_RIGHT_KEY,Globals.P2_UP_KEY,Globals.P2_ACTION_KEY);
		
		private var data:Array;
		
		//		private var wedgePositions:Array = new Array();
		//		private var needlePositions:Array = new Array();
		//		private var missilePositions:Array = new Array();
		
		private var gameOver:Boolean = false;
		
		private var help1:HelpPopup;
		private var help2:HelpPopup;
		private var help1Timer:FlxTimer = new FlxTimer();
		private var help2Timer:FlxTimer = new FlxTimer();
		
		private const HELP:uint = 0;
		private const PLAY:uint = 1;
		private const END:uint = 2;
		private var state:uint = PLAY;
		
		private var frames:int = 0;
		private var timeElapsed:Number = 0;
		
		public function SpacewarState()
		{
		}
		
		
		override public function create():void
		{
			super.create();
//			
			Cookie.load();
//			Cookie.erase();
//			Cookie.flush();
			
			FlxG.bgColor = 0xFF222222;
			
			bg = new FlxSprite(0,0);
			bg.loadGraphic(Assets.SPACEWAR_BG_PNG);
			add(bg);
			
			needleMissiles = new FlxGroup();
			needle = new SpacewarShip();
			needle.setup(0,50,75,needleMissiles,needleKeys);
			
			wedgeMissiles = new FlxGroup();
			wedge = new SpacewarShip();
			wedge.setup(1,FlxG.width - 50,FlxG.height - 100,wedgeMissiles,wedgeKeys);
			
			star = new FlxSprite(FlxG.width/2 - 4, FlxG.height/2 - 12);
			star.makeGraphic(20,20,0xCC0000FF);
			star.visible = false;
			
			add(needleMissiles);
			add(wedgeMissiles);
			
			add(star);
			add(needle);
			add(wedge);
			
			help1 = new HelpPopup("USE [LEFT, RIGHT, UP, ENTER] TO PERFORM\nPRESS [ESCAPE] TO CANCEL PERFORMANCE",FlxObject.DOWN,true);
			help2 = new HelpPopup("USE [A, D, W, SPACE] TO PERFORM\nPRESS [ESCAPE] TO CANCEL PERFORMANCE", FlxObject.UP,true);
			
			add(help1);
			add(help2);
			
			help1.setVisible(true);
			help2.setVisible(true);
			
			FlxG.flash(0xFF000000,2);
			
			FlxG.keys.record();
		}
		
		
		override public function update():void
		{
			super.update();

			if (FlxG.keys.ESCAPE) Helpers.resetGame();

			if (gameOver)
				return;
			
			
			if (state == HELP)
			{
				handleHelpInput();
			}
			else if (state == PLAY)
			{
				
				checkInput();

				savePositions();
					
				checkCollisions();

				frames++;
			}				
		}
		
		
		private function checkInput():void
		{

			if (FlxG.keys.justPressed(Globals.P1_LEFT_KEY) ||
				FlxG.keys.justPressed(Globals.P1_RIGHT_KEY) ||
				FlxG.keys.justPressed(Globals.P1_UP_KEY) ||
				FlxG.keys.justPressed(Globals.P1_ACTION_KEY))
			{
				help1Timer.start(1,1,turnOffHelp1);
			}
			
			if (FlxG.keys.justPressed(Globals.P2_LEFT_KEY) ||
				FlxG.keys.justPressed(Globals.P2_RIGHT_KEY) ||
				FlxG.keys.justPressed(Globals.P2_UP_KEY) ||
				FlxG.keys.justPressed(Globals.P2_ACTION_KEY))
			{
				help2Timer.start(1,1,turnOffHelp2);
			}
			
			if (FlxG.keys.pressed(Globals.ESCAPE_KEY))
			{
				Cookie.studioSaveObject.latest = null;
				Cookie.flush();
				FlxG.fade(0xFF000000,1,goToStudio);
			}
		}
		
		
		private function turnOffHelp1(t:FlxTimer):void
		{
			help1.setVisible(false);
		}
		
		private function turnOffHelp2(t:FlxTimer):void
		{
			help2.setVisible(false);
		}
		
		
		private function handleHelpInput():void
		{
			if (FlxG.keys.justPressed(Globals.P1_ACTION_KEY) && FlxG.keys.justPressed(Globals.P2_ACTION_KEY))
			{
				wedge.inputAllowed = true;
				needle.inputAllowed = true;
				
				state = PLAY;
			}
		}

		
		private function checkCollisions():void
		{			
//			if (needle.overlaps(wedge))
//				shipHit(needle,wedge);
//			if (needle.overlaps(star))
//				starHit(needle,star);
//			if (wedge.overlaps(star))
//				starHit(wedge,star);
			if (FlxCollision.pixelPerfectCheck(needle,wedge))
				shipHit(needle,wedge);
			if (FlxCollision.pixelPerfectCheck(wedge,star))
				starHit(wedge,star);
			if (FlxCollision.pixelPerfectCheck(needle,star))
				starHit(needle,star);
			
			for (var i:int = 0; i < needleMissiles.members.length; i++)
			{
				if (needleMissiles.members[i] != null &&
					needleMissiles.members[i].alive &&
					FlxCollision.pixelPerfectCheck(wedge,needleMissiles.members[i]))
				{
					missileHit(wedge,needleMissiles.members[i]);
				}
			}
			for (i = 0; i < wedgeMissiles.members.length; i++)
			{
				if (wedgeMissiles.members[i] != null &&
					wedgeMissiles.members[i].alive &&
					FlxCollision.pixelPerfectCheck(needle,wedgeMissiles.members[i]))
				{
					missileHit(needle,wedgeMissiles.members[i]);
				}
			}
		}
		
		
		private function shipHit(ship1:FlxObject, ship2:FlxObject):void
		{
			ship1.kill();
			ship2.kill();
			endGame();
		}
		
		
		private function starHit(theShip:FlxObject, theStar:FlxObject):void
		{
			trace("starHit()");
			theShip.kill();
			endGame();
		}
		
		
		private function missileHit(theShip:FlxObject, theMissile:FlxObject):void
		{
			theShip.kill();
			theMissile.kill();
			endGame();
		}
		
		
		private function endGame():void
		{
			state = END;
						
			var temp:Array = new Array(Globals.NUM_SPACEWAR_DATA_POINTS);
			saveFrameData(temp);
			temp[Globals.SPACEWAR_FRAME]++;
			data.push(temp);
			
			Cookie.load();
			//			Cookie.erase();
			//			Cookie.flush();
			//			Cookie.load();
			
			Cookie.saveObject.type = Globals.SPACEWAR;
			
			var spacewarSave:SpacewarSave = new SpacewarSave();
			var date:Date = new Date();
			spacewarSave.save("Untitled",date.fullYear.toString(),TILE_SIZE, data);
			
			Cookie.studioSaveObject.latest = spacewarSave;
			Cookie.state = Globals.DECISION_STATE; //DECISION;
			
			spacewarSave.print();
			
			Cookie.flush();	
			
			needle.kill();
			needle.velocity.x = 0;
			needle.velocity.y = 0;
			wedge.kill();
			wedge.velocity.x = 0;
			wedge.velocity.y = 0;
			this.wedgeMissiles.kill();
			this.needleMissiles.kill();
			
			FlxG.fade(0xFF000000,1,goToStudio);
		}
		
		private function goToStudio():void
		{
			FlxG.switchState(new SpacewarStudioState);	
		}
		
		
		private function savePositions():void
		{
			// SHOULD CHECK ALIVE
			if (!wedge.alive || !needle.alive)
				return;
			
			// NEW DATA MODEL HERE...
			
			var thisFrameData:Array = new Array(Globals.NUM_SPACEWAR_DATA_POINTS);
			saveFrameData(thisFrameData);
			
			if (data == null)
			{
				trace("CREATING NEW DATA ARRAY WITH FIRST FRAME");
				data = new Array(thisFrameData);
			}
			else if (wedge.missiles > 0 || wedge.fuel > 0 || needle.missiles > 0 || needle.fuel > 0)
			{
				if (!duplicateFrame(thisFrameData,data[data.length - 1]))
				{
					data.push(thisFrameData);
					trace("DATA PUSHED: " + thisFrameData);
				}
				else
				{
				}
			}

		}
		
		
		private function duplicateFrame(array1:Array, array2:Array):Boolean
		{
			if (array1[Globals.SPACEWAR_P1_THRUST])
				return false;
			if (array1[Globals.SPACEWAR_P2_THRUST])
				return false;
			if (array1[Globals.SPACEWAR_P1_MISSILE])
				return false;
			if (array1[Globals.SPACEWAR_P2_MISSILE])
				return false;
			return true;
		}
		
		private function saveFrameData(_array:Array):void
		{
//			_array[Globals.SPACEWAR_FRAME] = timeElapsed;
			_array[Globals.SPACEWAR_FRAME] = frames;
			_array[Globals.SPACEWAR_P1_ANGLE] = needle.angle;
			_array[Globals.SPACEWAR_P1_THRUST] = needle.thrusted();
			_array[Globals.SPACEWAR_P1_MISSILE] = needle.firedMissile();
			_array[Globals.SPACEWAR_P2_ANGLE] = wedge.angle;
			_array[Globals.SPACEWAR_P2_THRUST] = wedge.thrusted();
			_array[Globals.SPACEWAR_P2_MISSILE] = wedge.firedMissile();
		}
		
		override public function destroy():void
		{
			bg.destroy();
			
			needle.destroy();
			wedge.destroy();
			star.destroy();
			
			needleMissiles.destroy();
			wedgeMissiles.destroy();
			
			help1.destroy();
			help2.destroy();
			
			help1Timer.destroy();
			help2Timer.destroy();
			
			super.destroy();
		}
	}
}
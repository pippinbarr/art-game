package SaveAndReplay
{
	import Making.*;
	
	import org.flixel.*;
	
	public class SpacewarPlaybackGroup extends FlxGroup
	{
		private var frameCount:int = 0;
		private var timeElapsed:Number = 0;

		private var data:Array;
		private var currentIndex:int;

		private var xOffset:Number;
		private var yOffset:Number;
		private var scaleFactor:Number;
				
		private var startX:Number;
		private var startY:Number;
		
		private var screenWidth:Number;
		private var screenHeight:Number;
		
		private var star:FlxSprite;
		private var needle:FlxSprite;
		private var wedge:FlxSprite;
		private var missiles:FlxGroup;
		
		private var w:SpacewarShip;
		private var n:SpacewarShip;
		private var ms:FlxGroup;
		private var st:FlxSprite;		
		
		private var needleStart:FlxPoint = new FlxPoint();
		private var wedgeStart:FlxPoint = new FlxPoint();
		
		
		public function SpacewarPlaybackGroup()
		{
			super();
		}
		
		
		public function setup(_xOffset:Number, _yOffset:Number, _scale:Number, _screenWidth:Number, _screenHeight:Number, _data:Array):void
		{
			xOffset = _xOffset;
			yOffset = _yOffset;
			
			scaleFactor = _scale;
			
			frameCount = 0;
			currentIndex = 0;
			data = _data;
					
			makeSimulation(false);
			makeDisplay(true);
		}
		
		private function makeDisplay(_visible:Boolean = false):void
		{
			// SET UP FULL SIZE REPLACE ELEMENTS
			// Missile group
			
			missiles = recycle(FlxGroup) as FlxGroup;
			missiles.revive();
			missiles.visible = _visible;
			
			// Make the star
			star = recycle(FlxSprite) as FlxSprite;
			star.revive();
			
			var starSize:Number = scaleFactor * st.width;
			starSize = starSize < 1 ? 1 : starSize;
			star.makeGraphic(starSize, starSize, 0xFFFFFFFF);
			star.x = xOffset + st.x * scaleFactor;
			star.y = yOffset + st.y * scaleFactor;
			star.visible = _visible;
			
			// Make the ships
			
			needle = recycle(FlxSprite) as FlxSprite;
			needle.revive();
			needle.makeGraphic(n.width * scaleFactor / 2,n.height* scaleFactor / 2,0xFFFFFFFF);
			needle.x = xOffset + n.x * scaleFactor;
			needle.y = yOffset + n.y * scaleFactor;
			needle.width = n.width * scaleFactor;
			needle.height = n.height * scaleFactor;
			needle.offset.x = -needle.width/4;
			needle.offset.y = -needle.height/4;
			needle.visible = _visible;
			
			wedge = recycle(FlxSprite) as FlxSprite;
			wedge.revive();
			wedge.makeGraphic(w.width * scaleFactor / 2,w.height* scaleFactor / 2,0xFFFFFFFF);
			wedge.x = xOffset + w.x * scaleFactor;
			wedge.y = yOffset + w.y * scaleFactor;
			wedge.width = w.width * scaleFactor;
			wedge.height = w.height * scaleFactor;
			wedge.offset.x = -wedge.width/4;
			wedge.offset.y = -wedge.height/4;
			wedge.visible = _visible;
		}
		
		
		private function makeSimulation(_visible:Boolean = false):void
		{
			// SET UP FULL SIZE REPLACE ELEMENTS
			// Missile group
			
			ms = recycle(FlxGroup) as FlxGroup;
			ms.revive();
			ms.callAll("kill");
			ms.visible = _visible;
			
			// Make the star
			st = recycle(FlxSprite) as FlxSprite;
			st.revive();
			st.makeGraphic(10, 10, 0xFFFFFFFF);
			st.x = FlxG.width / 2 - st.width/2;
			st.y = FlxG.height / 2 - st.width/2;
			st.visible = _visible;
			
			// Make the ships
			
			n = recycle(SpacewarShip) as SpacewarShip;
			n.revive();
			n.setup(0,50,75,ms,null);
			n.visible = _visible;
			
			resetN();
			
			w = recycle(SpacewarShip) as SpacewarShip;
			w.revive();
			w.setup(1,FlxG.width - 50,FlxG.height - 100,ms,null);
			w.visible = _visible;
			
			resetW();
		}
	
		
		private function resetN():void
		{
			n.x = 50;
			n.y = 75;
			n.angle = 270;
			n.velocity.x = 0;
			n.velocity.y = 0;
		}
		
		private function resetW():void
		{
			w.x = FlxG.width - 50;
			w.y = FlxG.height - 100;
			w.angle = 270;
			w.velocity.x = 0;
			w.velocity.y = 0;
		}

		
		
		override public function preUpdate():void
		{
			// Update the underlying simulation
			if (data[currentIndex][Globals.SPACEWAR_FRAME] == frameCount && currentIndex < data.length - 1)
			{
				updateN();
				updateW();
			}

			
			// Update the displayed ships
			needle.x = xOffset + scaleFactor * n.x;
			needle.y = yOffset + scaleFactor * n.y;
			
			wedge.x = xOffset + scaleFactor * w.x;
			wedge.y = yOffset + scaleFactor * w.y;
			
			// Display the missiles
			missiles.callAll("kill");
			for (var i:uint = 0; i < ms.members.length; i++)
			{
				if (ms.members[i] != null && ms.members[i].alive)
				{
					var missile:FlxSprite = missiles.recycle(FlxSprite) as FlxSprite;
					missile.revive();
					var missileWidth:Number = 8 * scaleFactor;
					if (missileWidth < 1) missileWidth = 1;
					var missileHeight:Number = 2 * scaleFactor;
					if (missileHeight < 1) missileHeight = 1;
					missile.makeGraphic(missileWidth,missileHeight,0xFFFFFFFF);
					missile.x = xOffset + scaleFactor * ms.members[i].x;
					missile.y = yOffset + scaleFactor * ms.members[i].y;
					missile.angle = ms.members[i].angle;
				}
			}
			
			super.preUpdate();

		}
		
		override public function update():void
		{
//			trace("SpacewarpPlaybackGroup.update()");
			super.update();
			
			if (data[currentIndex][Globals.SPACEWAR_FRAME] == frameCount)
			{
				if (currentIndex >= data.length - 1)
				{
					currentIndex = 0;
					frameCount = -1;
					timeElapsed = 0;

					resetW();
					resetN();
					
					ms.callAll("kill");
					missiles.callAll("kill");
				}
				else
				{
					currentIndex++;
				}
			}		
			
			frameCount++;
				
			handleMWrapping();

//			trace("SpacewarpPlaybackGroup.applyGravity()");
		}
		
		
		private function updateN():void
		{
			n.angle = data[currentIndex][Globals.SPACEWAR_P1_ANGLE];
			if (data[currentIndex][Globals.SPACEWAR_P1_THRUST])
			{
				n.applyThrust();
			}
			
			if (data[currentIndex][Globals.SPACEWAR_P1_MISSILE])
			{
				fireM(n);
			}
		}
		
		
		private function updateW():void
		{
			w.angle = data[currentIndex][Globals.SPACEWAR_P2_ANGLE];
			if (data[currentIndex][Globals.SPACEWAR_P2_THRUST])
			{
				w.applyThrust();
			}
			if (data[currentIndex][Globals.SPACEWAR_P2_MISSILE])
			{
				fireM(w);
			}
		}
		
		
		private function fireM(s:FlxSprite):void
		{
			var m:FlxSprite = ms.recycle(FlxSprite) as FlxSprite;
			m.revive();
			m.makeGraphic(10, 10, 0xFF0000FF);
			m.angle = s.angle;
			m.x = s.x + s.width/2 + s.width/2 * Math.cos(s.angle * Math.PI/180);
			m.y = s.y + s.height/2 + s.width/2 * Math.sin(s.angle * Math.PI/180);
			m.velocity.x = Globals.SPACEWAR_MISSILE_SPEED * Math.cos(Math.PI/180 * m.angle);
			m.velocity.y = Globals.SPACEWAR_MISSILE_SPEED * Math.sin(Math.PI/180 * m.angle);

			m.visible = true;
		}
		
				
		private function handleMWrapping():void
		{
			var m:FlxSprite;
			
			for (var i:uint = 0; i < ms.members.length; i++)
			{
				m = ms.members[i];
				
				if (m != null && m.alive)
				{
					if (m.x < 0)
						m.x = FlxG.width - m.width;
					else if (m.x + m.width > FlxG.width)
						m.x = 0;
					if (m.y < 0)
						m.y = FlxG.height - m.height;
					else if (m.y + m.height > FlxG.height)
						m.y = 0;			
				}
			}
		}
		
				
		override public function destroy():void
		{
			super.destroy();
			
			star.destroy();
			needle.destroy();
			wedge.destroy();
			missiles.destroy();
			
			st.destroy();
			n.destroy();
			w.destroy();
			ms.destroy();
		}
	}
}
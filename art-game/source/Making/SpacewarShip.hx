package Making
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	public class SpacewarShip extends FlxSprite
	{
		private const NEEDLE:uint = 0;
		private const WEDGE:uint = 1;
		
		private const ROTATE_LEFT:uint = 0;
		private const ROTATE_RIGHT:uint = 1;
		private const THRUST:uint = 2;
		private const FIRE:uint = 3;
		
		private const STARTING_MISSILES:uint = 40;
		private const STARTING_FUEL:uint = Globals.FRAME_RATE * 30;
		
		private const ROTATION_AMOUNT:Number = 10;
		private const THRUST_AMOUNT:Number = Globals.SPACEWAR_SHIP_THRUST;
		
		
		private var missileGroup:FlxGroup;
		
		public var missiles:uint = STARTING_MISSILES;
		public var fuel:uint = STARTING_FUEL;
		
		private var keys:Array;
		
		private var type:uint;
		
		public var inputAllowed:Boolean = false;
		
		public var justFiredMissile:Boolean = false;
		public var justThrusted:Boolean = false;
		
		
		public function SpacewarShip():void
		{
			super();
		}
			
		
		public function setup(_type:uint, X:Number, Y:Number, MissileGroup:FlxGroup, Keys:Array):void
		{
			type = _type;
			x = X;
			y = Y;
			
			missileGroup = MissileGroup;
			keys = Keys;
			
			if (type == NEEDLE)
			{
				this.loadRotatedGraphic(Assets.NEEDLE_PNG,20);
			}
			else
			{
				this.loadRotatedGraphic(Assets.WEDGE_PNG,20);
			}
			
			this.angle = 270;								   
		}
		
		
		override public function preUpdate():void
		{
			super.preUpdate();			
		}
		override public function update():void
		{
			super.update();
			
			handleInput();
			applyGravity();
			limitSpeed();
			handleWrapping();
		}
		
		override public function postUpdate():void
		{
			super.postUpdate();
		}
		
		
		private function handleInput():void
		{
			if (keys == null)
				return;
				
			if (FlxG.keys.pressed(keys[ROTATE_LEFT]))
			{
				angle -= ROTATION_AMOUNT;
			}
			else if (FlxG.keys.pressed(keys[ROTATE_RIGHT]))
			{
				angle += ROTATION_AMOUNT;
			}
			
			if (FlxG.keys.pressed(keys[THRUST]))
			{
				applyThrust();
			}
			
			if (FlxG.keys.justPressed(keys[FIRE]))
			{
				fireMissile();
			}
		}
		
		
		
		
		
		private function applyGravity():void
		{
			var dx:Number = x - FlxG.width/2;
			var dy:Number = y - FlxG.height/2;
			
			var g:Number = -gravity(dx,dy);
			
			var theta:Number = Math.atan2(dy,dx);
			
			var dvx:Number = g * Math.cos(theta);
			var dvy:Number = g * Math.sin(theta);
			
			velocity.x += dvx;
			velocity.y += dvy;
			
//			trace("applied gravity of " + dvx + "," + dvy);
		}
		
		
		private function gravity(dx:Number, dy:Number):Number
		{
			return 200/(Math.sqrt(dx*dx + dy*dy));
		}
		
		
		private function limitSpeed():void
		{
			if (velocity.x < -Globals.SPACEWAR_MAX_SPEED)
				velocity.x = -Globals.SPACEWAR_MAX_SPEED;
			if (velocity.x > Globals.SPACEWAR_MAX_SPEED)
				velocity.x = Globals.SPACEWAR_MAX_SPEED;
			
			if (velocity.y < -Globals.SPACEWAR_MAX_SPEED)
				velocity.y = -Globals.SPACEWAR_MAX_SPEED;
			if (velocity.y > Globals.SPACEWAR_MAX_SPEED)
				velocity.y = Globals.SPACEWAR_MAX_SPEED;
		}
		
		
		private function applyHyperspace():void
		{
			x = Math.random() * FlxG.width;
			y = Math.random() * FlxG.height;
		}
		
		
		public function applyThrust():void
		{
			if (fuel <= 0)
				return;
			
			fuel -= 1;
			
			velocity.x += THRUST_AMOUNT * Math.cos(Math.PI/180 * angle);				
			velocity.y += THRUST_AMOUNT * Math.sin(Math.PI/180 * angle);	
			
			justThrusted = true;
		}
		
		
		private function fireMissile():void
		{
			if (missiles <= 0)
				return;
			
			justFiredMissile = true;
			missiles--;
			
			var missile:SpacewarMissile;
			
			var mX:Number = this.x + this.width/2 + this.width/2 * Math.cos(this.angle * Math.PI/180);
			var mY:Number = this.y + this.height/2 + this.width/2 * Math.sin(this.angle * Math.PI/180);
			
			missile = new SpacewarMissile(mX,mY,this.angle,missileGroup);			
		}
		
		
		public function firedMissile():Boolean
		{
			if (justFiredMissile)
			{
				justFiredMissile = false;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		
		public function thrusted():Boolean
		{
			if (justThrusted)
			{
				justThrusted = false;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function handleWrapping():void
		{
			if (this.x < 0)
				this.x = FlxG.width - width;
			else if (this.x + this.width > FlxG.width)
				this.x = 0;
			if (this.y < 0)
				this.y = FlxG.height - height;
			else if (this.y + this.height > FlxG.height)
				this.y = 0;			
			
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
	}
}
package Making
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	
	public class SpacewarMissile extends FlxSprite
	{
		private const LIFE_TIME:Number = 5;
				
		private var group:FlxGroup;
		private var timer:FlxTimer = new FlxTimer();
		
		
		public function SpacewarMissile(X:Number, Y:Number, theAngle:Number, MissileGroup:FlxGroup)
		{
			super(X,Y);
			
			x = X;
			y = Y;
			angle = theAngle;
			
			velocity.x = Globals.SPACEWAR_MISSILE_SPEED * Math.cos(Math.PI/180 * this.angle);
			velocity.y = Globals.SPACEWAR_MISSILE_SPEED * Math.sin(Math.PI/180 * this.angle);
			
			group = MissileGroup;
			
			loadRotatedGraphic(Assets.MISSILE_PNG,20);
			
			group.add(this);
			
			timer.start(LIFE_TIME,1,expire);
		}
		
		
		override public function update():void
		{
			super.update();
			
			handleWrapping();
		}
		
		
		private function handleWrapping():void
		{
			if (this.x < 0)
				this.x = FlxG.width - this.width;
			else if (this.x + this.width > FlxG.width)
				this.x = 0;
			if (this.y < 0)
				this.y = FlxG.height - this.height;
			else if (this.y + this.height > FlxG.height)
				this.y = 0;			
		}
		
		
		private function expire(timer:FlxTimer):void
		{
			this.kill();
		}
		
		
		override public function destroy():void
		{
			super.destroy();
		}
	}
}
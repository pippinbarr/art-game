package
{
	import org.flixel.FlxG;
	
	public class Globals
	{
		public static const DEBUG_MODE:Boolean = false;
		public static const DEBUG_HITBOXES:Boolean = false;
		public static const DEBUG_MEMORY:Boolean = false;
		public static const VISITOR_DEBUG:Boolean = true;
		
		public static const DEBUG_TRIGGER_COLOUR:uint = 0xAA0000FF;
		public static const DEBUG_HITBOX_COLOUR:uint = 0xAAFF0000;
		
		public static const ZOOM:uint = 1;
		public static const FRAME_RATE:uint = 30;
		
		public static const ESCAPE_KEY:String = "ESCAPE"; 
			
		public static const P1_ACTION_KEY_STRING:String = "[ENTER]";
		public static const P1_MOVEMENT_KEYS_STRING:String = "[UP, DOWN, LEFT, RIGHT]";
		public static const P1_ACTION_KEY:String = "ENTER";
		public static const P1_LEFT_KEY:String = "LEFT";
		public static const P1_RIGHT_KEY:String = "RIGHT";
		public static const P1_UP_KEY:String = "UP";
		public static const P1_DOWN_KEY:String = "DOWN";
		
		public static const P2_ACTION_KEY_STRING:String = "[SPACE]";
		public static const P2_MOVEMENT_KEYS_STRING:String = "[W, A, S, D]";
		public static const P2_ACTION_KEY:String = "SPACE";
		public static const P2_LEFT_KEY:String = "A";
		public static const P2_RIGHT_KEY:String = "D";
		public static const P2_UP_KEY:String = "W";
		public static const P2_DOWN_KEY:String = "S";

		
		// STATES
		public static const NO_STATE:uint = 0;
		public static const CURATOR_INTRO_STATE:uint = 1;
		public static const STUDIO_STATE:uint = 2;
		public static const MAKE_STATE:uint = 3;
		public static const CURATOR_STATE:uint = 4;
		public static const DECISION_STATE:uint = 5;
		public static const SELECTION_STATE:uint = 6;
		public static const GALLERY_STATE:uint = 7;
		public static const END_STATE:uint = 8;
				
		// Types of person
		public static const AVATAR:int = 0;
		public static const SNAKE_VISITOR:int = 1;
		public static const SPACEWAR_VISITOR:int = 2;
		public static const TETRIS_VISITOR:int = 3;
		public static const GENERIC_VISITOR:int = 4;
		
		// Types of art
		public static const NONE:uint = 0;
		public static const SNAKE:uint = 1;
		public static const TETRIS:uint = 2;
		public static const SPACEWAR:uint = 3;

		// PEOPLE
		public static const PERSON_HITBOX_WIDTH:Number = 40;
		public static const PERSON_HITBOX_HEIGHT:Number = 12;
		
		// GALLERY
		
		public static const GALLERY_VISITOR_SPEED:Number = 200;
		public static var ARTWORKS:Array = new Array();
		
		public static const TETRIS_PLINTH_TOP:Number = 300;
		public static var TETRIS_PLINTH_BOTTOM:Number;

		public static const GALLERY_WALL_Y:Number = 245;
		
		public static var GALLERY_H_CHANNELS_HIGH:Array = new Array(
			GALLERY_WALL_Y + PERSON_HITBOX_HEIGHT * 3,
			GALLERY_WALL_Y + PERSON_HITBOX_HEIGHT * 4.5
		);
		public static var GALLERY_H_CHANNELS_LOW:Array = new Array(
			480 - PERSON_HITBOX_HEIGHT * 4,
			480 - PERSON_HITBOX_HEIGHT * 6
		);
		
		
		// TITLING
		public static const VALID_TITLE_CHARACTERS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ.,1234567890 ";
		public static const MAX_TITLE_LENGTH:uint = 70;
		
		// SNAKE
		public static const SNAKE_START_LENGTH:uint = 5;
		public static const SNAKE_HEAD_COLOUR:uint = 0xFF222222;
		public static const SNAKE_BODY_COLOUR:uint = 0xFF777777;
		public static const SNAKE_FRUIT_COLOUR:uint = 0xFF555555;
		
		public static const SNAKE_WORK_STUDIO_POSITIONS:Array = new Array([400,170],[300,174],[350,178]);
		public static const TETRIS_WORK_STUDIO_POSITIONS:Array = new Array([60,270],[300,270]);
		
		// TETRIS
		public static const TETRIS_BLOCK_COLOUR:uint = 0xFF000000;
		
		// SPACEWAR
		public static const SPACEWAR_FRAME_MODULO:uint = 1;
		public static const SPACEWAR_SHIP_THRUST:Number = 20;
		public static const SPACEWAR_MISSILE_SPEED:Number = 200;

		public static const NUM_SPACEWAR_DATA_POINTS:uint = 7;
		public static const SPACEWAR_MAX_SPEED:Number = 200;

		public static const SPACEWAR_FRAME:uint = 0;
		public static const SPACEWAR_P1_ANGLE:uint = 1;
		public static const SPACEWAR_P1_THRUST:uint = 2;
		public static const SPACEWAR_P1_MISSILE:uint = 3;
		public static const SPACEWAR_P2_ANGLE:uint = 4;
		public static const SPACEWAR_P2_THRUST:uint = 5;
		public static const SPACEWAR_P2_MISSILE:uint = 6;
		
		public static const SPACEWAR_MAX_AVATAR_SEPARATION:Number = 300;
		
		// WORK INFO
		
		public static const GALLERY_WORK:uint = 0;
		public static const STUDIO_WORK:uint = 1;
		
		public static const SNAKE_ARTIST:String = "Cicero Sassoon";
		public static const SNAKE_ARTIST_FIRST_NAME:String = "Cicero";
		public static const SNAKE_ARTIST_NATIONALITY:String = "French";
		public static const SNAKE_ARTIST_BIRTH_YEAR:String = "1970";
		public static const SNAKE_MEDIUM:String = "Oil on canvas";
		public static const SNAKE_ARTIST_BIO:String = "" +
			"Born in Paris in 1970, Cicero Sassoon is one of the most famous minimalist painters working today. " +
			"Renowned for his strong lines and potent symbolism, he's an artist at the peak " +
			"of his abilities.";

		public static const SNAKE_GALLERY_Y:Number = 60;
		
		public static const SPACEWAR_ARTIST:String = "William Edge & Susan Needle";
		public static const SPACEWAR_ARTIST_FIRST_NAME:String = "William and Susan";
		public static const SPACEWAR_ARTIST_NATIONALITY:String = "American";
		public static const SPACEWAR_ARTIST_BIRTH_YEAR:String = "1962";
		public static const SPACEWAR_MEDIUM:String = "Video";
		public static const SPACEWAR_ARTIST_BIO:String = "" +
			"Since their emergence in the 1980s, William Edge and Susan Needle have been variously rumoured to be a twin brother and sister, " +
			"a married couple, cousins, or completely unrelated. Whatever the case, their " +
			"video works have been stirring up the art world for many years now.";
		
		
		public static const TETRIS_ARTIST:String = "Alexandra Tetranov";
		public static const TETRIS_ARTIST_FIRST_NAME:String = "Alexandra";
		public static const TETRIS_ARTIST_NATIONALITY:String = "Russian";
		public static const TETRIS_ARTIST_BIRTH_YEAR:String = "1981";
		public static const TETRIS_MEDIUM:String = "Stainless steel";
		public static const TETRIS_ARTIST_BIO:String = "" +
			"Alexandra Tetranov burst out of the Russian art scene onto the international stage " +
			"in the late 2000s. Since then, she has been an unstoppable force in the world of " +
			"sculpture, producing work after work of masterful quality.";
		
		// COSTUMES
		public static const NEEDLE:uint = 0;
		public static const WEDGE:uint = 1;
		
		public function Globals()
		{
		}
	}
}
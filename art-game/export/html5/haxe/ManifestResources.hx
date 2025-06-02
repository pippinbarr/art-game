package;


import haxe.io.Bytes;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

		}

		if (rootPath == null) {

			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif console
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_fonts_commodore_pixelized_v1_2_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		#end

		var data, manifest, library, bundle;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:pathy36:assets%2Fmusic%2Fmusic-goes-here.txty4:sizezy4:typey4:TEXTy2:idR1y7:preloadtgoR0y37:assets%2Fimages%2Fsnake_studio_bg.pngR2i11105R3y5:IMAGER5R7R6tgoR0y32:assets%2Fimages%2Fhallway_hm.pngR2i7441R3R8R5R9R6tgoR0y38:assets%2Fimages%2Ftetris_studio_bg.pngR2i10696R3R8R5R10R6tgoR0y40:assets%2Fimages%2Fart_forum_frameout.pngR2i8170R3R8R5R11R6tgoR0y32:assets%2Fimages%2Fneedle_old.pngR2i1253R3R8R5R12R6tgoR0y36:assets%2Fimages%2Faudience_03_ss.pngR2i7670R3R8R5R13R6tgoR0y53:assets%2Fimages%2Fart_forum_cover_text_gray_small.pxiR2i1050885R3y6:BINARYR5R14R6tgoR0y32:assets%2Fimages%2Fwedge_ship.pngR2i4138R3R8R5R16R6tgoR0y36:assets%2Fimages%2Faudience_11_ss.pngR2i7641R3R8R5R17R6tgoR0y31:assets%2Fimages%2Fprojector.pngR2i2390R3R8R5R18R6tgoR0y48:assets%2Fimages%2Fspacewar_studio_costume_hm.pngR2i8331R3R8R5R19R6tgoR0y29:assets%2Fimages%2Fmissile.pngR2i1148R3R8R5R20R6tgoR0y41:assets%2Fimages%2Fneedle_ship_hanging.pngR2i2144R3R8R5R21R6tgoR0y28:assets%2Fimages%2Fneedle.pngR2i1272R3R8R5R22R6tgoR0y33:assets%2Fimages%2Fgallery_fg2.pngR2i11013R3R8R5R23R6tgoR0y36:assets%2Fimages%2Faudience_01_ss.pngR2i7369R3R8R5R24R6tgoR0y48:assets%2Fimages%2Fart_forum_cover_text_black.pngR2i8855R3R8R5R25R6tgoR0y47:assets%2Fimages%2Fart_forum_cover_text_gray.pngR2i8862R3R8R5R26R6tgoR0y35:assets%2Fimages%2Fcurator_cycle.pngR2i7758R3R8R5R27R6tgoR0y36:assets%2Fimages%2Faudience_05_ss.pngR2i7525R3R8R5R28R6tgoR0y36:assets%2Fimages%2Faudience_09_ss.pngR2i7467R3R8R5R29R6tgoR0y46:assets%2Fimages%2Fwalk_cycle_coloured_full.pngR2i8557R3R8R5R30R6tgoR0y54:assets%2Fimages%2Fart_forum_cover_text_white_small.pngR2i8678R3R8R5R31R6tgoR0y40:assets%2Fimages%2Fspacewar_studio_hm.pngR2i7912R3R8R5R32R6tgoR0y53:assets%2Fimages%2Fart_forum_cover_text_gray_small.pngR2i8750R3R8R5R33R6tgoR0y45:assets%2Fimages%2Fsnake_artist_walk_cycle.pngR2i7455R3R8R5R34R6tgoR0y42:assets%2Fimages%2Fspacewar_avatar_1_ss.pngR2i7410R3R8R5R35R6tgoR0y54:assets%2Fimages%2Fart_forum_cover_text_black_small.pngR2i8748R3R8R5R36R6tgoR0y34:assets%2Fimages%2Fprojector_ss.pngR2i2884R3R8R5R37R6tgoR0y32:assets%2Fimages%2Fgallery_hm.pngR2i30263R3R8R5R38R6tgoR0y36:assets%2Fimages%2Faudience_07_ss.pngR2i7517R3R8R5R39R6tgoR0y40:assets%2Fimages%2Fwedge_ship_hanging.pngR2i2720R3R8R5R40R6tgoR0y41:assets%2Fimages%2Fwalk_cycle_coloured.pngR2i3906R3R8R5R41R6tgoR0y32:assets%2Fimages%2Fgallery_fg.pngR2i11012R3R8R5R42R6tgoR0y40:assets%2Fimages%2Fart_forum_bg_black.pngR2i8163R3R8R5R43R6tgoR0y27:assets%2Fimages%2Feasel.pngR2i2338R3R8R5R44R6tgoR0y36:assets%2Fimages%2Faudience_02_ss.pngR2i7617R3R8R5R45R6tgoR0y27:assets%2Fimages%2Fwedge.pngR2i1320R3R8R5R46R6tgoR0y36:assets%2Fimages%2Faudience_10_ss.pngR2i7653R3R8R5R47R6tgoR0y37:assets%2Fimages%2Fsnake_studio_hm.pngR2i7443R3R8R5R48R6tgoR0y46:assets%2Fimages%2Fart_forum_frameout_small.pngR2i8193R3R8R5R49R6tgoR0y38:assets%2Fimages%2Ftetris_studio_hm.pngR2i7787R3R8R5R50R6tgoR0y32:assets%2Fimages%2Fhallway_bg.pngR2i30518R3R8R5R51R6tgoR0y42:assets%2Fimages%2Faudience_coloured_ss.pngR2i2835R3R8R5R52R6tgoR0y36:assets%2Fimages%2Faudience_12_ss.pngR2i7760R3R8R5R53R6tgoR0y48:assets%2Fimages%2Fart_forum_cover_text_white.pngR2i8736R3R8R5R54R6tgoR0y33:assets%2Fimages%2Fneedle_ship.pngR2i4780R3R8R5R55R6tgoR0y29:assets%2Fimages%2Fcurator.pngR2i1729R3R8R5R56R6tgoR0y46:assets%2Fimages%2Fart_forum_bg_white_small.pngR2i8259R3R8R5R57R6tgoR0y49:assets%2Fimages%2Fgeneric_walk_cycle_fullsize.pngR2i8557R3R8R5R58R6tgoR0y36:assets%2Fimages%2Faudience_04_ss.pngR2i7414R3R8R5R59R6tgoR0y48:assets%2Fimages%2Fspacewar_artist_walk_cycle.pngR2i7483R3R8R5R60R6tgoR0y40:assets%2Fimages%2Fspacewar_studio_bg.pngR2i9497R3R8R5R61R6tgoR0y36:assets%2Fimages%2Faudience_08_ss.pngR2i7705R3R8R5R62R6tgoR0y33:assets%2Fimages%2Fspacewar_bg.pngR2i8721R3R8R5R63R6tgoR0y32:assets%2Fimages%2Fgallery_bg.pngR2i31163R3R8R5R64R6tgoR0y44:assets%2Fimages%2Fsnake_artist_walkcycle.pngR2i8557R3R8R5R65R6tgoR0y46:assets%2Fimages%2Fart_forum_bg_black_small.pngR2i8186R3R8R5R66R6tgoR0y46:assets%2Fimages%2Ftetris_artist_walk_cycle.pngR2i7661R3R8R5R67R6tgoR0y36:assets%2Fimages%2Fimages-go-here.txtR2zR3R4R5R68R6tgoR0y36:assets%2Fimages%2Faudience_06_ss.pngR2i7662R3R8R5R69R6tgoR0y31:assets%2Fimages%2Fwedge_old.pngR2i1306R3R8R5R70R6tgoR0y41:assets%2Fimages%2Fwalk_cycle_spacewar.pngR2i7482R3R8R5R71R6tgoR0y34:assets%2Fimages%2Fwalkcycle_ss.pngR2i7480R3R8R5R72R6tgoR0y45:assets%2Fimages%2Ftetris_studio_workbench.pngR2i2253R3R8R5R73R6tgoR0y40:assets%2Fimages%2Fart_forum_bg_white.pngR2i8255R3R8R5R74R6tgoR0y36:assets%2Fsounds%2Fsounds-go-here.txtR2zR3R4R5R75R6tgoR2i20324R3y4:FONTy9:classNamey50:__ASSET__assets_fonts_commodore_pixelized_v1_2_ttfR5y49:assets%2Ffonts%2FCommodore%20Pixelized%20v1.2.ttfR6tgoR0y34:assets%2Fdata%2Fdata-goes-here.txtR2zR3R4R5R80R6tgoR2i39706R3y5:MUSICR5y28:flixel%2Fsounds%2Fflixel.mp3y9:pathGroupaR82y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i2114R3R81R5y26:flixel%2Fsounds%2Fbeep.mp3R83aR85y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i5794R3y5:SOUNDR5R86R83aR85R86hgoR2i33629R3R87R5R84R83aR82R84hgoR2i15744R3R76R77y35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R76R77y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i519R3R8R5R92R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i3280R3R8R5R93R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

		#end

	}


}


#if kha

null

#else

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_snake_studio_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_hallway_hm_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_tetris_studio_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_frameout_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_needle_old_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_audience_03_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_cover_text_gray_small_pxi extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_wedge_ship_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_audience_11_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_projector_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_spacewar_studio_costume_hm_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_missile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_needle_ship_hanging_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_needle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_gallery_fg2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_audience_01_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_cover_text_black_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_cover_text_gray_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_curator_cycle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_audience_05_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_audience_09_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_walk_cycle_coloured_full_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_cover_text_white_small_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_spacewar_studio_hm_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_cover_text_gray_small_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_snake_artist_walk_cycle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_spacewar_avatar_1_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_cover_text_black_small_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_projector_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_gallery_hm_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_audience_07_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_wedge_ship_hanging_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_walk_cycle_coloured_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_gallery_fg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_bg_black_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_easel_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_audience_02_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_wedge_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_audience_10_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_snake_studio_hm_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_frameout_small_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_tetris_studio_hm_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_hallway_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_audience_coloured_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_audience_12_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_cover_text_white_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_needle_ship_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_curator_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_bg_white_small_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_generic_walk_cycle_fullsize_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_audience_04_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_spacewar_artist_walk_cycle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_spacewar_studio_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_audience_08_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_spacewar_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_gallery_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_snake_artist_walkcycle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_bg_black_small_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_tetris_artist_walk_cycle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_audience_06_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_wedge_old_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_walk_cycle_spacewar_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_walkcycle_ss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_tetris_studio_workbench_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_bg_white_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_fonts_commodore_pixelized_v1_2_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:file("assets/music/music-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends haxe.io.Bytes {}
@:keep @:image("assets/images/snake_studio_bg.png") @:noCompletion #if display private #end class __ASSET__assets_images_snake_studio_bg_png extends lime.graphics.Image {}
@:keep @:image("assets/images/hallway_hm.png") @:noCompletion #if display private #end class __ASSET__assets_images_hallway_hm_png extends lime.graphics.Image {}
@:keep @:image("assets/images/tetris_studio_bg.png") @:noCompletion #if display private #end class __ASSET__assets_images_tetris_studio_bg_png extends lime.graphics.Image {}
@:keep @:image("assets/images/art_forum_frameout.png") @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_frameout_png extends lime.graphics.Image {}
@:keep @:image("assets/images/needle_old.png") @:noCompletion #if display private #end class __ASSET__assets_images_needle_old_png extends lime.graphics.Image {}
@:keep @:image("assets/images/audience_03_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_audience_03_ss_png extends lime.graphics.Image {}
@:keep @:file("assets/images/art_forum_cover_text_gray_small.pxi") @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_cover_text_gray_small_pxi extends haxe.io.Bytes {}
@:keep @:image("assets/images/wedge_ship.png") @:noCompletion #if display private #end class __ASSET__assets_images_wedge_ship_png extends lime.graphics.Image {}
@:keep @:image("assets/images/audience_11_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_audience_11_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/projector.png") @:noCompletion #if display private #end class __ASSET__assets_images_projector_png extends lime.graphics.Image {}
@:keep @:image("assets/images/spacewar_studio_costume_hm.png") @:noCompletion #if display private #end class __ASSET__assets_images_spacewar_studio_costume_hm_png extends lime.graphics.Image {}
@:keep @:image("assets/images/missile.png") @:noCompletion #if display private #end class __ASSET__assets_images_missile_png extends lime.graphics.Image {}
@:keep @:image("assets/images/needle_ship_hanging.png") @:noCompletion #if display private #end class __ASSET__assets_images_needle_ship_hanging_png extends lime.graphics.Image {}
@:keep @:image("assets/images/needle.png") @:noCompletion #if display private #end class __ASSET__assets_images_needle_png extends lime.graphics.Image {}
@:keep @:image("assets/images/gallery_fg2.png") @:noCompletion #if display private #end class __ASSET__assets_images_gallery_fg2_png extends lime.graphics.Image {}
@:keep @:image("assets/images/audience_01_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_audience_01_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/art_forum_cover_text_black.png") @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_cover_text_black_png extends lime.graphics.Image {}
@:keep @:image("assets/images/art_forum_cover_text_gray.png") @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_cover_text_gray_png extends lime.graphics.Image {}
@:keep @:image("assets/images/curator_cycle.png") @:noCompletion #if display private #end class __ASSET__assets_images_curator_cycle_png extends lime.graphics.Image {}
@:keep @:image("assets/images/audience_05_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_audience_05_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/audience_09_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_audience_09_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/walk_cycle_coloured_full.png") @:noCompletion #if display private #end class __ASSET__assets_images_walk_cycle_coloured_full_png extends lime.graphics.Image {}
@:keep @:image("assets/images/art_forum_cover_text_white_small.png") @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_cover_text_white_small_png extends lime.graphics.Image {}
@:keep @:image("assets/images/spacewar_studio_hm.png") @:noCompletion #if display private #end class __ASSET__assets_images_spacewar_studio_hm_png extends lime.graphics.Image {}
@:keep @:image("assets/images/art_forum_cover_text_gray_small.png") @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_cover_text_gray_small_png extends lime.graphics.Image {}
@:keep @:image("assets/images/snake_artist_walk_cycle.png") @:noCompletion #if display private #end class __ASSET__assets_images_snake_artist_walk_cycle_png extends lime.graphics.Image {}
@:keep @:image("assets/images/spacewar_avatar_1_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_spacewar_avatar_1_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/art_forum_cover_text_black_small.png") @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_cover_text_black_small_png extends lime.graphics.Image {}
@:keep @:image("assets/images/projector_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_projector_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/gallery_hm.png") @:noCompletion #if display private #end class __ASSET__assets_images_gallery_hm_png extends lime.graphics.Image {}
@:keep @:image("assets/images/audience_07_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_audience_07_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/wedge_ship_hanging.png") @:noCompletion #if display private #end class __ASSET__assets_images_wedge_ship_hanging_png extends lime.graphics.Image {}
@:keep @:image("assets/images/walk_cycle_coloured.png") @:noCompletion #if display private #end class __ASSET__assets_images_walk_cycle_coloured_png extends lime.graphics.Image {}
@:keep @:image("assets/images/gallery_fg.png") @:noCompletion #if display private #end class __ASSET__assets_images_gallery_fg_png extends lime.graphics.Image {}
@:keep @:image("assets/images/art_forum_bg_black.png") @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_bg_black_png extends lime.graphics.Image {}
@:keep @:image("assets/images/easel.png") @:noCompletion #if display private #end class __ASSET__assets_images_easel_png extends lime.graphics.Image {}
@:keep @:image("assets/images/audience_02_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_audience_02_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/wedge.png") @:noCompletion #if display private #end class __ASSET__assets_images_wedge_png extends lime.graphics.Image {}
@:keep @:image("assets/images/audience_10_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_audience_10_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/snake_studio_hm.png") @:noCompletion #if display private #end class __ASSET__assets_images_snake_studio_hm_png extends lime.graphics.Image {}
@:keep @:image("assets/images/art_forum_frameout_small.png") @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_frameout_small_png extends lime.graphics.Image {}
@:keep @:image("assets/images/tetris_studio_hm.png") @:noCompletion #if display private #end class __ASSET__assets_images_tetris_studio_hm_png extends lime.graphics.Image {}
@:keep @:image("assets/images/hallway_bg.png") @:noCompletion #if display private #end class __ASSET__assets_images_hallway_bg_png extends lime.graphics.Image {}
@:keep @:image("assets/images/audience_coloured_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_audience_coloured_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/audience_12_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_audience_12_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/art_forum_cover_text_white.png") @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_cover_text_white_png extends lime.graphics.Image {}
@:keep @:image("assets/images/needle_ship.png") @:noCompletion #if display private #end class __ASSET__assets_images_needle_ship_png extends lime.graphics.Image {}
@:keep @:image("assets/images/curator.png") @:noCompletion #if display private #end class __ASSET__assets_images_curator_png extends lime.graphics.Image {}
@:keep @:image("assets/images/art_forum_bg_white_small.png") @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_bg_white_small_png extends lime.graphics.Image {}
@:keep @:image("assets/images/generic_walk_cycle_fullsize.png") @:noCompletion #if display private #end class __ASSET__assets_images_generic_walk_cycle_fullsize_png extends lime.graphics.Image {}
@:keep @:image("assets/images/audience_04_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_audience_04_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/spacewar_artist_walk_cycle.png") @:noCompletion #if display private #end class __ASSET__assets_images_spacewar_artist_walk_cycle_png extends lime.graphics.Image {}
@:keep @:image("assets/images/spacewar_studio_bg.png") @:noCompletion #if display private #end class __ASSET__assets_images_spacewar_studio_bg_png extends lime.graphics.Image {}
@:keep @:image("assets/images/audience_08_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_audience_08_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/spacewar_bg.png") @:noCompletion #if display private #end class __ASSET__assets_images_spacewar_bg_png extends lime.graphics.Image {}
@:keep @:image("assets/images/gallery_bg.png") @:noCompletion #if display private #end class __ASSET__assets_images_gallery_bg_png extends lime.graphics.Image {}
@:keep @:image("assets/images/snake_artist_walkcycle.png") @:noCompletion #if display private #end class __ASSET__assets_images_snake_artist_walkcycle_png extends lime.graphics.Image {}
@:keep @:image("assets/images/art_forum_bg_black_small.png") @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_bg_black_small_png extends lime.graphics.Image {}
@:keep @:image("assets/images/tetris_artist_walk_cycle.png") @:noCompletion #if display private #end class __ASSET__assets_images_tetris_artist_walk_cycle_png extends lime.graphics.Image {}
@:keep @:file("assets/images/images-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends haxe.io.Bytes {}
@:keep @:image("assets/images/audience_06_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_audience_06_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/wedge_old.png") @:noCompletion #if display private #end class __ASSET__assets_images_wedge_old_png extends lime.graphics.Image {}
@:keep @:image("assets/images/walk_cycle_spacewar.png") @:noCompletion #if display private #end class __ASSET__assets_images_walk_cycle_spacewar_png extends lime.graphics.Image {}
@:keep @:image("assets/images/walkcycle_ss.png") @:noCompletion #if display private #end class __ASSET__assets_images_walkcycle_ss_png extends lime.graphics.Image {}
@:keep @:image("assets/images/tetris_studio_workbench.png") @:noCompletion #if display private #end class __ASSET__assets_images_tetris_studio_workbench_png extends lime.graphics.Image {}
@:keep @:image("assets/images/art_forum_bg_white.png") @:noCompletion #if display private #end class __ASSET__assets_images_art_forum_bg_white_png extends lime.graphics.Image {}
@:keep @:file("assets/sounds/sounds-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/Commodore Pixelized v1.2.ttf") @:noCompletion #if display private #end class __ASSET__assets_fonts_commodore_pixelized_v1_2_ttf extends lime.text.Font {}
@:keep @:file("assets/data/data-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/4,11,0/assets/sounds/flixel.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/4,11,0/assets/sounds/beep.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/4,11,0/assets/sounds/beep.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/4,11,0/assets/sounds/flixel.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/nokiafc22.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:keep @:font("export/html5/obj/webfont/monsterrat.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:keep @:image("/usr/local/lib/haxe/lib/flixel/4,11,0/assets/images/ui/button.png") @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:keep @:image("/usr/local/lib/haxe/lib/flixel/4,11,0/assets/images/logo/default.png") @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__assets_fonts_commodore_pixelized_v1_2_ttf') @:noCompletion #if display private #end class __ASSET__assets_fonts_commodore_pixelized_v1_2_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/fonts/Commodore Pixelized v1.2"; #else ascender = 1800; descender = -200; height = 2000; numGlyphs = 204; underlinePosition = -156; underlineThickness = 22; unitsPerEM = 2048; #end name = "Commodore 64 Pixelized"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22"; #else ascender = 2048; descender = -512; height = 2816; numGlyphs = 172; underlinePosition = -640; underlineThickness = 256; unitsPerEM = 2048; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat"; #else ascender = 968; descender = -251; height = 1219; numGlyphs = 263; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "Monsterrat"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__assets_fonts_commodore_pixelized_v1_2_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_commodore_pixelized_v1_2_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_commodore_pixelized_v1_2_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__assets_fonts_commodore_pixelized_v1_2_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_commodore_pixelized_v1_2_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_commodore_pixelized_v1_2_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#end

#end
#end

#end

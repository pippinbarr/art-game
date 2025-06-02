package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class MainMenuState extends FlxState
{
	private var gameTitle:FlxText;
	private var mainMenu:SelectionMenu;
	private var menuOptions:Array<Dynamic>;

	private var aboutText:FlxText;

	//		private var testVersionOverlay:HelpOverlay;
	private var mainMenuHelp:HelpPopup;

	override public function create():Void
	{
		super.create();

		Cookie.load();

		FlxG.bgColor = 0xFFAAAAAA;

		gameTitle = new FlxText(0, 0, FlxG.width, "ART GAME");
		gameTitle.setFormat("Commodore", 128, 0x000000, "center");
		add(gameTitle);

		menuOptions = new Array();
		menuOptions.push("NEW GAME");
		if (Cookie.type != -1)
			menuOptions.push("CONTINUE");
		menuOptions.push("ABOUT");
		mainMenu = new SelectionMenu(300, FlxG.width - 300, menuOptions, false);

		add(mainMenu);

		aboutText = new FlxText(50, 50, FlxG.width - 100, "");
		aboutText.setFormat("Commodore", 18, 0x000000, "left");
		aboutText.text = ""
			+ "THIS IS \"ART GAME\" BY PIPPIN BARR"
			+ "\n\n\n"
			+ "ADDITIONAL TEXTS BY:"
			+ "\n\n"
			+ "JIM BARR AND MARY BARR"
			+ "\n\n\n"
			+ "TIRELESS FEEDBACK AND PHILOSOPHY BY:"
			+ "\n\n"
			+ "AMANI, ANEESA, BREDON, CHAD, CLAIRE, COSTA, COURTNEY, DAN, DOUG, ELENA, ELTONS, "
			+ "GORDON, IAN, JAKOB, JESPER, JIM, MARY, MIGUEL, NICOLE, RILLA, SCILLA, AND XAVIER";
		add(aboutText);
		aboutText.visible = false;

		//			testVersionOverlay = new HelpOverlay("" +
		//				"THIS IS A TEST VERSION OF ART GAME." +
		//				"\n\n\n" +
		//				"THERE'S PROBABLY A HELL OF A LOT WRONG WITH IT." +
		//				"\n\n\n" +
		//				"IF YOU SEE SOMETHING, SAY SOMETHING." +
		//				"\n\n\n" +
		//				"THANKS!\n\n" +
		//				"PIPPIN." +
		//				"\n\n\n\n" +
		//				"CLICK IN THIS WINDOW THEN PRESS [ENTER] TO START");
		//			testVersionOverlay.setVisible(true);
		//			add(testVersionOverlay);

		mainMenu.enable();

		mainMenuHelp = new HelpPopup("USE [UP AND DOWN] AND [ENTER] TO SELECT AN OPTION");
		add(mainMenuHelp);
		mainMenuHelp.setVisible(true);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		//			if (testVersionOverlay.buffer.visible && FlxG.keys.justPressed(Globals.P1_ACTION_KEY))
		//			{
		//				testVersionOverlay.setVisible(false);
		//				mainMenu.enable();
		//			}

		handleMenuInput();
	}

	public function handleMenuInput():Void
	{
		if (mainMenu.selected && mainMenu.selection == 0)
		{
			FlxG.switchState(new ArtistSelectState());
		}
		else if (mainMenu.selected && mainMenu.selection == 1 && Cookie.type != -1)
		{
			trace("Cookie state is " + Cookie.state);
			trace("Cookie type is " + Cookie.type);

			// If they were in the gallery and quit,
			// of if they were finished and quit,
			// then they get the end screen.
			if (Cookie.state == Globals.GALLERY_STATE)
			{
				FlxG.switchState(new GalleryState());
			}

			// Otherwise, if they were making art
			// or selecting, or deciding, or hanging out
			// in the studio,
			// then they get the studio.
			if (Cookie.state == Globals.STUDIO_STATE
				|| Cookie.state == Globals.DECISION_STATE
				|| Cookie.state == Globals.SELECTION_STATE
				|| Cookie.state == Globals.MAKE_STATE
				|| Cookie.state == Globals.NO_STATE)
			{
				if (Cookie.type == Globals.SNAKE)
				{
					FlxG.switchState(new SnakeStudioState());
				}
				else if (Cookie.type == Globals.TETRIS)
				{
					FlxG.switchState(new TetrisStudioState());
				}
				else if (Cookie.type == Globals.SPACEWAR)
				{
					FlxG.switchState(new SpacewarStudioState());
				}
			}
			else if (Cookie.state == Globals.CURATOR_INTRO_STATE)
			{
				if (Cookie.type == Globals.SNAKE)
				{
					FlxG.switchState(new SnakeCuratorState());
				}
				else if (Cookie.type == Globals.TETRIS)
				{
					FlxG.switchState(new TetrisCuratorState());
				}
				else if (Cookie.type == Globals.SPACEWAR)
				{
					FlxG.switchState(new SpacewarCuratorState());
				}
			}
			else if (Cookie.state == Globals.CURATOR_STATE)
			{
				if (Cookie.saveObject.saves.length == 3)
				{
					FlxG.switchState(new GalleryState());
				}
				else
				{
					if (Cookie.type == Globals.SNAKE)
					{
						FlxG.switchState(new SnakeStudioState());
					}
					else if (Cookie.type == Globals.TETRIS)
					{
						FlxG.switchState(new TetrisStudioState());
					}
					else if (Cookie.type == Globals.SPACEWAR)
					{
						FlxG.switchState(new SpacewarStudioState());
					}
				}
			}
		}
		else if (mainMenu.selected && ((mainMenu.selection == 1 && Cookie.type == -1) || mainMenu.selection == 2))
		{
			mainMenu.disable();
			aboutText.visible = true;
			gameTitle.visible = false;
			mainMenuHelp.text.text = "PRESS " + Globals.P1_ACTION_KEY_STRING + " TO RETURN";
		}
		else if (aboutText.visible && FlxG.keys.justPressed(Globals.P1_ACTION_KEY))
		{
			gameTitle.visible = true;
			aboutText.visible = false;
			mainMenu.enable();
			mainMenuHelp.text.text = "USE [UP AND DOWN] AND " + Globals.P1_ACTION_KEY_STRING + " TO SELECT AN OPTION";
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		gameTitle.destroy();
		mainMenu.destroy();
		aboutText.destroy();
		mainMenuHelp.destroy();
	}
}

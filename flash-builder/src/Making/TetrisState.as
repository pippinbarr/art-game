package Making
{
	import Shared.*;
	import SaveAndReplay.*;
	import Studio.TetrisStudioState;
	
	import org.flixel.*;
		
		public class TetrisState extends FlxState
		{
			private const TILE_SIZE:uint = 20;
			private const FIELD_WIDTH:uint = 300;
			private const FIELD_HEIGHT:uint = FlxG.height;
			private const FIELD_X:Number = (FlxG.width - FIELD_WIDTH) / 2;
			private const FIELD_Y:Number = 0;
			private const NUM_TETROMINOES:uint = 7;
			private var TETROMINO_DROP_RATE:Number = 0.5;
			
			private var fieldArray:Array;
			private var fieldSprites:Array;
			private var fieldSprite:FlxSprite;
			
			private var tetrominoes:Array;
			private var currentTetromino:uint = 0;
			private var currentRotation:uint = 0;
			private var currentRow:int;
			private var currentColumn:int;
			
			private var tetromino:FlxGroup;
			private var stoppedTetrominoes:FlxGroup;
			
			private var movementTimer:FlxTimer = new FlxTimer();
			private var leftRepeatTimer:FlxTimer = new FlxTimer();
			private var rightRepeatTimer:FlxTimer = new FlxTimer();
			private var upRepeatTimer:FlxTimer = new FlxTimer();
			
			private var gameOver:Boolean = false;
			
			
			
			private var help:HelpPopup;
			private var helpTimer:FlxTimer;
			
			private const HELP:uint = 0;
			private const PLAY:uint = 1;
			private const END:uint = 2;
			private var state:uint = PLAY;
			
			private var frames:uint = 0;
			
			private var gameOn:Boolean = false;
			
			public function TetrisState()
			{
			}
			
			
			override public function create():void
			{
				super.create();
				
				FlxG.bgColor = 0xFF222222;
				
				leftRepeatTimer.finished = true;
				rightRepeatTimer.finished = true;
				upRepeatTimer.finished = true;
				
				fieldSprite = new FlxSprite(FIELD_X,FIELD_Y);
				fieldSprite.makeGraphic(FIELD_WIDTH,FIELD_HEIGHT,0xFFFFFFFF);
				
				fieldArray = new Array(FIELD_HEIGHT/TILE_SIZE);
				for (var i:uint = 0; i < fieldArray.length; i++)
				{
					fieldArray[i] = new Array(FIELD_WIDTH/TILE_SIZE);
					for (var j:uint = 0; j < fieldArray[i].length; j++)
						fieldArray[i][j] = 0;
				}
				
				fieldSprites = new Array(FIELD_HEIGHT/TILE_SIZE);
				for (i = 0; i < fieldSprites.length; i++)
				{
					fieldSprites[i] = new Array(FIELD_WIDTH/TILE_SIZE);
					for (j = 0; j < fieldSprites[i].length; j++)
						fieldSprites[i][j] = null;
				}
				
				
				add(fieldSprite);
				
				makeTetrominoes();
				
				stoppedTetrominoes = new FlxGroup();
				add(stoppedTetrominoes);
				
				help = new HelpPopup("USE " + Globals.P1_MOVEMENT_KEYS_STRING + " TO SCULPT\nPRESS [ESCAPE] TO CANCEL SCULPTURE",FlxObject.DOWN,true);
				add(help);
				help.setVisible(true);
				
									
				FlxG.flash(0xFF000000,2,startTetris);

			}
			
			
			private function startTetris():void
			{
				movementTimer.start(TETROMINO_DROP_RATE,1,moveTetrominoDown);
				makeTetromino();
				gameOn = true;
			}
			
			
			private function makeTetrominoes():void
			{
				tetrominoes = new Array();
				
				// ADD I ROTATIONS
				tetrominoes.push([[[0,0,0,0],[1,1,1,1],[0,0,0,0],[0,0,0,0]],
					[[0,1,0,0],[0,1,0,0],[0,1,0,0],[0,1,0,0]]]);			
				
				// ADD T ROTATIONS
				tetrominoes.push([[[0,0,0,0],[1,1,1,0],[0,1,0,0],[0,0,0,0]],
					[[0,1,0,0],[1,1,0,0],[0,1,0,0],[0,0,0,0]],
					[[0,1,0,0],[1,1,1,0],[0,0,0,0],[0,0,0,0]],
					[[0,1,0,0],[0,1,1,0],[0,1,0,0],[0,0,0,0]]]);
				
				// ADD L ROTATIONS
				tetrominoes.push([[[0,0,0,0],[1,1,1,0],[1,0,0,0],[0,0,0,0]],
					[[1,1,0,0],[0,1,0,0],[0,1,0,0],[0,0,0,0]],
					[[0,0,1,0],[1,1,1,0],[0,0,0,0],[0,0,0,0]],
					[[0,1,0,0],[0,1,0,0],[0,1,1,0],[0,0,0,0]]]);
				
				// ADD J ROTATIONS
				tetrominoes.push([[[1,0,0,0],[1,1,1,0],[0,0,0,0],[0,0,0,0]],
					[[0,1,1,0],[0,1,0,0],[0,1,0,0],[0,0,0,0]],
					[[0,0,0,0],[1,1,1,0],[0,0,1,0],[0,0,0,0]],
					[[0,1,0,0],[0,1,0,0],[1,1,0,0],[0,0,0,0]]]);
				
				// ADD Z ROTATIONS
				tetrominoes.push([[[0,0,0,0],[1,1,0,0],[0,1,1,0],[0,0,0,0]],
					[[0,0,1,0],[0,1,1,0],[0,1,0,0],[0,0,0,0]]]);
				
				// ADD S ROTATIONS
				tetrominoes.push([[[0,0,0,0],[0,1,1,0],[1,1,0,0],[0,0,0,0]],
					[[0,1,0,0],[0,1,1,0],[0,0,1,0],[0,0,0,0]]]);
				
				// ADD O ROTATION
				tetrominoes.push([[[0,1,1,0],[0,1,1,0],[0,0,0,0],[0,0,0,0]]]);
				
			}
			
			
			private function makeTetromino():void
			{
				if (gameOver)
					return;
				
				currentTetromino = Math.floor(Math.random() * NUM_TETROMINOES);
				currentRotation = 0;
				currentRow = 0;
				currentColumn = 6;
				
				var thisTetromino:Array = tetrominoes[currentTetromino][currentRotation];
				
				// Correct for tetrominoes with a blank first row
				if (currentRow == 0 && thisTetromino[0].indexOf(1) == -1) 
				{
					currentRow = -1;
				}
				
				drawTetromino();
				
				if (!canFit(currentRow,currentColumn,currentRotation))
				{
					endGame();
					return;
				}
				
			}
			
			
			private function drawTetromino():void
			{
				remove(tetromino);
				
				tetromino = new FlxGroup();
				
				var thisTetromino:Array = tetrominoes[currentTetromino][currentRotation];
				
				for (var y:uint = 0; y < thisTetromino.length; y++)
				{
					for (var x:uint = 0; x < thisTetromino[y].length; x++)
					{
						if (thisTetromino[y][x] == 1)
						{
							tetromino.add(new FlxSprite(FIELD_X + (currentColumn*TILE_SIZE + x*TILE_SIZE),
								FIELD_Y + (currentRow*TILE_SIZE + y*TILE_SIZE)).makeGraphic(TILE_SIZE,TILE_SIZE,0xFF000000));
						}
					}
				}
				
				add(tetromino);
			}
			
			
			override public function update():void
			{
				super.update();
				
				if (FlxG.keys.ESCAPE) Helpers.resetGame();

				
				if (gameOver)
					return;
				
				if (state == HELP)
				{
					//					handleHelpInput();
				}
				else if (state == PLAY)
				{
					if (gameOn)
					{
						frames++;
						handleInput();
					}
				}
			}
			
			
			
			//			private function handleHelpInput():void
			//			{
			//				if (FlxG.keys.justPressed(Globals.P1_ACTION_KEY))
			//				{
			//					movementTimer.start(TETROMINO_DROP_RATE,1,moveTetrominoDown);
			//					makeTetromino();
			//					state = PLAY;
			//					helpOverlay.setVisible(false);
			//				}
			//			}
			//			
			
			private function handleInput():void
			{
				if (helpTimer == null && 
					(FlxG.keys.justPressed(Globals.P1_LEFT_KEY) ||
						FlxG.keys.justPressed(Globals.P1_RIGHT_KEY) ||
						FlxG.keys.justPressed(Globals.P1_UP_KEY) ||
						FlxG.keys.justPressed(Globals.P1_DOWN_KEY)))
				{
					helpTimer = new FlxTimer();
					helpTimer.start(2,1,turnOffHelp);
				}
								
//				if (FlxG.keys.LEFT && !FlxG.keys.justPressed("LEFT"))
//					if (FlxG.keys.justPressed(Globals.P1_LEFT_KEY))
				if ((FlxG.keys.LEFT && leftRepeatTimer.finished) || FlxG.keys.justPressed("LEFT"))
				{
					if (FlxG.keys.justPressed("LEFT")) leftRepeatTimer.reset();
					if (canFit(currentRow,currentColumn - 1,currentRotation))
					{
						currentColumn--;
						drawTetromino();
					}
					leftRepeatTimer.start(0.1);
				}
//				else if (FlxG.keys.RIGHT)
//					else if (FlxG.keys.justPressed(Globals.P1_RIGHT_KEY))
				else if ((FlxG.keys.RIGHT && rightRepeatTimer.finished) || FlxG.keys.justPressed("RIGHT"))
				{
					if (FlxG.keys.justPressed("RIGHT")) rightRepeatTimer.reset();
					if (canFit(currentRow,currentColumn + 1,currentRotation))
					{
						currentColumn++;
						drawTetromino();
					}
					rightRepeatTimer.start(0.1);
				}
//				else if (FlxG.keys.UP)
//					else if (FlxG.keys.justPressed(Globals.P1_UP_KEY))
				else if ((FlxG.keys.UP && upRepeatTimer.finished) || FlxG.keys.justPressed("UP"))
				{
					if (FlxG.keys.justPressed("UP")) upRepeatTimer.reset();

					var newRotation:uint = (currentRotation + 1) % tetrominoes[currentTetromino].length;
					var newRow:int = currentRow;
					var newColumn:int = currentColumn;
					
					var newTetromino:Array = tetrominoes[currentTetromino][newRotation];
					
					if (newRow == 0 && newTetromino[0].indexOf(1) == -1) 
					{
						newRow = -1;
					}
					else if (newRow == -1 && newTetromino[0].indexOf(1) != -1)
					{
						newRow = 0;
					}
					
					if (canFit(newRow,newColumn,newRotation))
					{
						currentRotation = newRotation;
						currentRow = newRow;
						
						drawTetromino();
					}
					upRepeatTimer.start(0.1);

				}
				
				if (FlxG.keys.DOWN)
				{
					//hardDrop();
					TETROMINO_DROP_RATE = 0.05;
					movementTimer.stop();
					moveTetrominoDown(null);
				}
				else
				{
					TETROMINO_DROP_RATE = 0.5;
				}
				
				if (FlxG.keys.ESCAPE)
//					if (FlxG.keys.justPressed(Globals.ESCAPE_KEY))
				{
					Cookie.studioSaveObject.latest = null;
					Cookie.flush();
					FlxG.fade(0xFF000000,1,goToStudio);
				}
					
			}
			
			
			private function turnOffHelp(t:FlxTimer):void
			{
				help.setVisible(false);
			}
			
			
			private function moveTetrominoDown(timer:FlxTimer):void
			{
				trace("moveTetrominoDown()");
				
				if (gameOver)
					return;
				
				if (canFit(currentRow + 1,currentColumn,currentRotation))
				{
					currentRow++;
					drawTetromino();
				}
				else
				{
					stopTetromino();
					makeTetromino();
				}
				
//				if (timer != null)
					movementTimer.start(TETROMINO_DROP_RATE,1,moveTetrominoDown);
			}
			
			
			private function hardDrop():void
			{
				var checkRow:uint = currentRow + 1;
				while(checkRow >= 0 && canFit(checkRow,currentColumn,currentRotation))
				{
					checkRow++;
				}
				
				currentRow = checkRow - 1;
				stopTetromino();
				makeTetromino();
			}
			
			
			private function canFit(row:int, column:int, rotation:int):Boolean
			{
				var thisTetromino:Array = tetrominoes[currentTetromino][rotation];
				
				for (var y:uint = 0; y < thisTetromino.length; y++)
				{
					for (var x:uint = 0; x < thisTetromino[y].length; x++)
					{
						if (thisTetromino[y][x] == 1)
						{
							if (column + x < 0)
							{
								return false;
							}
							if (column + x > FIELD_WIDTH/TILE_SIZE - 1)
							{
								return false;
							}
							if (row + y > FIELD_HEIGHT/TILE_SIZE - 1)
							{
								return false;
							}
							
							trace("column + x = " + (column + x));
							trace("row + y = " + (row + y));
							trace("fieldArray[0][0] = " + fieldArray[0][0]);
							trace("fieldArray[row+y][column+x] = " + fieldArray[row+y][column+x]);
							
							if (fieldArray[y + row][x + column] == 1)
							{
								return false;
							}
						}
					}
				}
				
				return true;
			}
			
			
			private function stopTetromino():void
			{
				var thisTetromino:Array = tetrominoes[currentTetromino][currentRotation];
				
				var stoppedTetromino:FlxGroup = new FlxGroup();
				
				for (var y:uint = 0; y < thisTetromino.length; y++)
				{
					for (var x:uint = 0; x < thisTetromino[y].length; x++)
					{
						if (thisTetromino[y][x] == 1)
						{
							fieldSprites[currentRow + y][currentColumn + x] = new FlxSprite(FIELD_X + (currentColumn*TILE_SIZE + x*TILE_SIZE),
								FIELD_Y + (currentRow*TILE_SIZE + y*TILE_SIZE)).makeGraphic(TILE_SIZE,TILE_SIZE,0xFF000000);
							
							stoppedTetrominoes.add(fieldSprites[currentRow + y][currentColumn + x]);
							
							fieldArray[currentRow + y][currentColumn + x] = 1;
						}
					}
				}
				
				checkCompletedLines();
			}
			
			
			private function checkCompletedLines():void
			{
				for (var y:int = 0; y < fieldArray.length; y++)
				{
					if (fieldArray[y].indexOf(0) == -1)
					{
						for (var x:int = 0; x < fieldArray[y].length; x++)
						{
							fieldArray[y][x] = 0;
							stoppedTetrominoes.remove(fieldSprites[y][x]);
						}
						
						trace("y = " + y + "     x = " + x);
						
						for (var yy:int = y; yy >= 0; yy--)
						{
							trace("yy = " + yy + "     x = " + x);
							
							for (var xx:int = 0; xx < fieldArray[yy].length; xx++)
							{							
								if (fieldArray[yy][xx] == 1)
								{
									fieldArray[yy][xx] = 0;
									fieldArray[yy + 1][xx] = 1;
									
									fieldSprites[yy][xx].y += TILE_SIZE;
									fieldSprites[yy + 1][xx] = fieldSprites[yy][xx];
									fieldSprites[yy][xx] = null;
								}
							}
						}					
					}
				}
			}
			
			
			private function endGame():void
			{
				trace("Game over.");
				
				movementTimer.stop();
				gameOver = true;
				
				Cookie.load();
				//Cookie.erase();
				//			Cookie.flush();
				//			Cookie.load();
				
				Cookie.studioSaveObject.type = Globals.TETRIS;
				
				var tetrisSave:TetrisSave = new TetrisSave();
				var date:Date = new Date();
				tetrisSave.save("UNTITLED",date.fullYear.toString(),TILE_SIZE,fieldArray);
				
				Cookie.studioSaveObject.latest = tetrisSave;
				Cookie.state = Globals.DECISION_STATE; //DECISION;
				
				Cookie.flush();	
				
				tetrisSave.print();
				
				FlxG.fade(0xFF000000,1,goToStudio);
			}
			
			private function goToStudio():void
			{
				FlxG.switchState(new TetrisStudioState);	
			}
			
			
			override public function destroy():void
			{
				super.destroy();
				
				fieldSprite.destroy();
				for (var i:int = 0; i < fieldSprites.length; i++)
				{
					for (var j:int = 0; j < fieldSprites[j].length; j++)
					{
						if (fieldSprites[i][j] != null)
						{
							fieldSprites[i][j].destroy();
						}
					}
				}
				
				tetromino.destroy();
				stoppedTetrominoes.destroy();
				
				movementTimer.destroy();
				
				help.destroy();
				if (helpTimer != null) helpTimer.destroy();
			}
		}
}
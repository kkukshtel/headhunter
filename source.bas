splashscreen

 rem TITLE SCREEN
 rem PRESS PLAYER 0 FIRE TO START
 
 rem set score color to black
 scorecolor = 0
 COLUPF = $1E
 
 playfield:
 ................................
 ..X.X.XXX..XX..XX...............
 ..XXX.X...X..X.X.X..............
 ..X.X.XXX.XXXX.X..X.............
 ..X.X.X...X..X.X.X..............
 ..X.X.XXX.X..X.XX...............
 ..X.X.X..X.X..X.XXX.XXX.XX......
 ..XXX.X..X.X..X..X..X...X.X.....
 ..X.X.X..X.XX.X..X..XXX.XX......
 ..X.X.X..X.X.XX..X..X...X.X.....
 ..X.X..XX..X..X..X..XXX.X..X....
end
 drawscreen
 
  rem PLAYFIELD VARIABLE
 p = 1
 
  rem SCORE
 score = 0
 d = 0
 b = 0
 
 rem once player 1 fire is pressed, splash screen is left
 if !joy0fire then splashscreen
 
 rem ---------------------------------------------------------------------
 rem INITIALIZER - SETS THE INITIAL VALUES OF VARIABLES, COLORS, POSITIONS
 rem ---------------------------------------------------------------------

init 

 rem SCORE COLOR
 scorecolor = $1E
 
 rem SMART BRANCHING
 set smartbranching on
 
 rem DROPPED BALL COLOR
 COLUPF = $1E
 CTRLPF = $33
 
 
 rem INITIALIZES VARIABLES.  ALWAYS START AT 0, SO NOT NEEDED FOR EVERY VARIABLE
 
  rem BALL DOWN
 f = 0
 ballx = 0
 bally = 0 
 
 rem PLAYER 0 STATE VARIABLE IS A, is able to drop ball
 a = 0
 a{6} = 1
 a{1} = 0
 a{5} = 0
 rem PLAYER 0 SCORE VARIALBE IS B
 rem PLAYER 0 (X,Y) IS (X,Y)
 x = 12 : y = 40 
 
 rem PLAYER 1 STATE VARIABLE IS C, is able to drop ball
 c = 0
 c{6} = 1
 c{0} = 1
 c{1} = 0
 c{5} = 0
 rem PLAYER 1 SCORE VARIALBE IS D
 rem PLAYER 1 (X,Y) IS (V,W)
 v = 140 : w = 40
 
 rem PLAYER DIRECTIONS
 rem RED's DIRECTION
 m = 2
 o = 2
 rem BLUE's DIRECTION
 n = 3
 q = 3
 
 rem BALL (X,Y) IS (T,U)
 
 rem player states
 rem 00000000 - normal movement (no fall as of yet)
 rem 10000000 - player is dead, invisible 7
 rem 01000000 - player can drop ball 6 
 rem 00100000 - player can score 5
 rem 00010000 - movement not allowed from spawn 4
 rem 00001000 - relloading fireball 3
 rem 00000100 - needs to be flipped 2
 rem 00000010 - can pick up ball 1
 rem 00000001 - player connotation, a 1 here is player1, and a 0 here is player2 0
 

 
  rem MISSILE DIRS
 g = 0
 
  rem SCREEN COUNTERS
 e = 0
 h = 0
 
  rem ZERO
 i = 0

 rem VARIABLE NAMES
 dim redState = a
 dim redScore = b
 dim redDir = m
 dim redPrevDir = o
 dim blueState = c
 dim blueScore = d
 dim blueDir = n
 dim bluePrevDir = q
 dim redXPos = x
 dim redYPos = y
 dim blueXPos = v
 dim blueYPos = w
 dim thePlayfield = p
 dim ballDown = f
 dim missileDIRS = g
 dim screenCounterRED = e
 dim screenCounterBLUE = h
 
 rem i,t,u,j,k,l,r,s,z
 
 rem -------------
 rem THE MAIN LOOP
 rem -------------

mainloop
 
 if redScore = 3 then goto redWin
 if blueScore = 3 then goto blueWin
 
  rem MAP CHANGE CODE
 if thePlayfield=3 then thePlayfield = 1 
 if thePlayfield=1 then gosub map1
 if thePlayfield=2 then gosub map2 
 
  rem SETS PLAYER0'S X AND Y TO x AND y AND PLAYER1'S X AND Y TO v AND w
 player0x = redXPos : player0y = redYPos
 player1x = blueXPos : player1y = blueYPos
 
 rem SET PLAYER COLORS
 COLUP0 = $42
 COLUP1 = $82
 
  rem CHANGES RED'S SPRITE ANIMATION
 redPrevDir = redDir
 if redDir=0 then gosub redshipup
 if redDir=1 then gosub redshipdown
 if redDir=2 then gosub redshipright
 if redDir=3 then gosub redshipright
 
  rem CHANGES BLUE'S SPRITE ANIMATION up,down,left,right
 bluePrevDir = blueDir
 if blueDir=0 then gosub blueshipup
 if blueDir=1 then gosub blueshipdown
 if blueDir=2 then gosub blueshipright
 if blueDir=3 then gosub blueshipright
 
  rem RED MOVEMENT
 if !a{7} && joy0left && !joy0right && !joy0up && !joy0down && !redState{2} then redXPos = redXPos - 1 : redState{2} = !redState{2} : redDir = 2 : goto branch 
 if !a{7} && joy0left && !joy0right && !joy0up && !joy0down && redState{2} then redXPos = redXPos - 1 : redDir = 2 : goto branch 
 if !a{7} && joy0right && !joy0left && !joy0up && !joy0down && redState{2} then redXPos = redXPos + 1 : redState{2} = !redState{2} : redDir = 3 : goto branch
 if !a{7} && joy0right && !joy0left && !joy0up && !joy0down && !redState{2} then redXPos = redXPos + 1 : redDir = 3 : goto branch
 if !a{7} && joy0up && !joy0right && !joy0left && !joy0down then redYPos = redYPos - 1 : redDir = 0 : goto branch
 if !a{7} && joy0down && !joy0right && !joy0up && !joy0left then redYPos = redYPos + 1 : redDir = 1 : goto branch

 rem PREVENTS WALKING THROUGH WALLS, P0 
branch on redDir goto 10 11 12 13

10 if collision(playfield,player0) then redYPos = redYPos+1 : goto 14
11 if collision(playfield,player0) then redYPos = redYPos-1 : goto 14
12 if collision(playfield,player0) then redXPos = redXPos+1 : goto 14
13 if collision(playfield,player0) then redXPos = redXPos-1 : goto 14


14 player0x = redXPos : player0y = redYPos
 
  rem BLUE MOVEMENT
 if !c{7} && joy1left && !joy1right && !joy1up && !joy1down && !blueState{2} then blueXPos = blueXPos - 1 : blueState{2} = !blueState{2} : blueDir = 2 : goto branchb 
 if !c{7} && joy1left && !joy1right && !joy1up && !joy1down && blueState{2} then blueXPos = blueXPos - 1 : blueDir = 2 : goto branchb 
 if !c{7} && joy1right && !joy1left && !joy1up && !joy1down && blueState{2} then blueXPos = blueXPos + 1 : blueState{2} = !blueState{2} : blueDir = 3 : goto branchb
 if !c{7} && joy1right && !joy1left && !joy1up && !joy1down && !blueState{2} then blueXPos = blueXPos + 1 : blueDir = 3 : goto branchb
 if !c{7} && joy1up && !joy1right && !joy1left && !joy1down then blueYPos = blueYPos - 1 : blueDir = 0 : goto branchb
 if !c{7} && joy1down && !joy1right && !joy1up && !joy1left then blueYPos = blueYPos + 1 : blueDir = 1 : goto branchb

 rem PREVENTS WALKING THROUGH WALLS, P0 
branchb on blueDir goto 15 16 17 18

15 if collision(playfield,player1) then blueYPos = blueYPos+1 : goto 19
16 if collision(playfield,player1) then blueYPos = blueYPos-1 : goto 19
17 if collision(playfield,player1) then blueXPos = blueXPos+1 : goto 19
18 if collision(playfield,player1) then blueXPos = blueXPos-1 : goto 19

19 player1x = blueXPos : player1y = blueYPos

 rem PREVENTS PASSING THROUGH SCREEN BOUNDARIES
 if redXPos <= 0 then redXPos = 2
 if redYPos <= 8 then redYPos = 10
 if blueXPos <= 0 then blueXPos = 2
 if blueYPos <= 8 then blueYPos = 10
 if redXPos >= 154 then redXPos = 153
 if redYPos >= 88 then redYPos = 86
 if blueXPos >= 154 then blueXPos = 153
 if blueYPos >= 88 then blueYPos = 86
 
 rem COLLISION CODE
 if joy0fire && !a{3} && !a{7} then gosub player0missile
 if joy1fire && !c{3} && !c{7} then gosub player1missile 
 
 if collision(missile0, player1) && !a{7} then gosub redkilledblue
 if collision(missile1, player0) && !c{7} then gosub bluekilledred
 
 if collision(player0, ball) && a{1} then gosub redpickup
 if collision(player1, ball) && c{1} then gosub bluepickup
 
 if collision(missile0, playfield) then gosub missile0wall
 if collision(missile1, playfield) then gosub missile1wall
 
 rem BALL UPDATE CODE
 if ballDown = 1 then ballx = ballx : bally = bally
 if a{5} then ballx = redXPos : bally = redYPos
 if c{5} then ballx = blueXPos : bally = blueYPos
 
 drawscreen
 
 if a{3} && !a{7} then gosub movemissile0
 if c{3} && !c{7} then gosub movemissile1
  
  rem red respawn code
 if !a{7} && a{1} then screenCounterRED = 0
 if a{7} || !a{1} then screenCounterRED = screenCounterRED + 1
 if screenCounterRED = 40 then a{7} = 0
 if screenCounterRED = 60 then a{1} = 1
 
  rem blue respawn code
 if !c{7} && c{1} then screenCounterBLUE = 0
 if c{7} || !c{1} then screenCounterBLUE = screenCounterBLUE + 1
 if screenCounterBLUE = 40 then c{7} = 0
 if screenCounterBLUE = 60 then c{1} = 1
 
  rem CHECK SCORE GET
 if a{5} && redXPos >= 15 && redXPos <= 20 && redYPos >= 46 && redYPos <= 50 then redScore = redScore + 1 : score = score + 100000 : thePlayfield = thePlayfield + 1 : goto init
 if c{5} && blueXPos >= 135 && blueXPos <= 145 && blueYPos >= 30 && blueYPos <= 40 then blueScore = blueScore + 1 : score = score + 1 : thePlayfield = thePlayfield + 1 : goto init
 
 
 
 goto mainloop
 
 rem ---------------
 rem THE SUBROUTINES
 rem ---------------
 
 rem PLAYER0 PICKS UP BALL
redpickup
 if !a{6} then ballDown = 0
 a{5} = 1
 a{6} = 1
 c{6} = 0
 c{1} = 0
 return
 
 rem PLAYER1 PICKS UP BALL
bluepickup
 if !c{6} then ballDown = 0
 c{5} = 1
 c{6} = 1
 a{6} = 0
 a{1} = 0
 return
 
player0missile
 if !a{3} then a{3} = 1
 if redDir = 0 then missile0x = redXPos + 7 : missile0y = redYPos - 3 : missileDIRS{7} = 1
 if redDir = 1 then missile0x = redXPos + 7 : missile0y = redYPos : missileDIRS{6} = 1
 if redDir = 2 then missile0x = redXPos + 1 : missile0y = redYPos - 5 : missileDIRS{5} = 1
 if redDir = 3 then missile0x = redXPos + 8 : missile0y = redYPos - 5 : missileDIRS{4} = 1
 return
 
player1missile
 if !c{3} then c{3} = 1
 if blueDir = 0 then missile1x = blueXPos + 7 : missile1y = blueYPos - 3 : missileDIRS{3} = 1
 if blueDir = 1 then missile1x = blueXPos + 7 : missile1y = blueYPos : missileDIRS{2} = 1
 if blueDir = 2 then missile1x = blueXPos + 1 : missile1y = blueYPos - 5 : missileDIRS{1} = 1
 if blueDir = 3 then missile1x = blueXPos + 8 : missile1y = blueYPos - 5 : missileDIRS{0} = 1
 return
 
 rem REDS MISSILE UPDATE
movemissile0
 if missileDIRS{4} then missile0x = missile0x + 2
 if missileDIRS{5} then missile0x = missile0x - 2
 if missileDIRS{7} then missile0y = missile0y - 2
 if missileDIRS{6} then missile0y = missile0y + 2
 if missile0y <= 0 then gosub missile0wall  
 if missile0y >= 90 then gosub missile0wall 
 if missile0x <= 0 then gosub missile0wall 
 if missile0x >= 160 then gosub missile0wall 
 return
 
 rem BLUES MISSILE UPDATE
movemissile1
 if missileDIRS{0} then missile1x = missile1x + 2
 if missileDIRS{1} then missile1x = missile1x - 2
 if missileDIRS{3} then missile1y = missile1y - 2
 if missileDIRS{2} then missile1y = missile1y + 2
 if missile1y <= 0 then gosub missile1wall  
 if missile1y >= 90 then gosub missile1wall 
 if missile1x <= 0 then gosub missile1wall 
 if missile1x >= 160 then gosub missile1wall 
 return 
 
missile0wall
 missile0x = 0 : missile0y = 0
  rem set player0 missle dirs to 0
 missileDIRS = missileDIRS | %11110000
 missileDIRS = missileDIRS ^ %11110000
 a{3} = 0
 return 
 
missile1wall
 missile1x = 0 : missile1y = 0
  rem set player1 missile dirs to 0
 missileDIRS = missileDIRS | %00001111
 missileDIRS = missileDIRS ^ %00001111
 c{3} = 0
 return
 
redkilledblue
 missile0x = 0 : missile0y = 0
 missileDIRS = missileDIRS | %11110000
 missileDIRS = missileDIRS ^ %11110000
 c{7} = 1
 if c{6} then c{6} = 0 : c{1} = 0 : gosub balldropped
 c{5} = 0
 a{3} = 0
 blueXPos = 140
 blueYPos = 40
 player1x = blueXPos
 player1y = blueYPos
 return 
 
bluekilledred
 missile1x = 0 : missile1y = 0
 missileDIRS = missileDIRS | %00001111
 missileDIRS = missileDIRS ^ %00001111
 a{7} = 1
 if a{6} then a{6} = 0 : a{1} = 0 : gosub balldropped
 a{5} = 0
 c{3} = 0
 redXPos = 12
 redYPos = 40
 player0x = redXPos
 player0y = redYPos
 return 

balldropped
 ballDown = 1
 if c{7} then ballx = blueXPos : bally = blueYPos : a{1} = 1
 if a{7} then ballx = redXPos : bally = redYPos : c{1} = 1
 rem NUSIZ0 = $10
 rem NUSIZ1 = $10
 ballheight = 5 
 return
 
 rem ------------------------------
 rem SPRITES, PLAYFIELDS
 rem ------------------------------
 
 rem SPRITE ANIMATIONS
redshipup
 player0:
 %00101000
 %00101000
 %00010000
 %01111110
 %00111010
 %00010000
 %00111000
 %00111000
end
 return

blueshipup
 player1:
 %00101000
 %00101000
 %00010000
 %01111110
 %00111010
 %00010000
 %00111000
 %00111000
end
 return
 
 
redshipdown
 player0:
 %00101000
 %00101000
 %00010010
 %01111110
 %00111000
 %00010000
 %00111000
 %00111000
end
 return

blueshipdown
 player1:
 %00101000
 %00101000
 %00010010
 %01111110
 %00111000
 %00010000
 %00111000
 %00111000
end
 return

redshipright
 player0:
 %01001100
 %00101000
 %00010000
 %01011100
 %00110110
 %00110000
 %00011000
 %00011000
end
 if redState{2} then REFP0 = 8
 return
 
blueshipright
 player1:
 %01001100
 %00101000
 %00010000
 %01011100
 %00110110
 %00110000
 %00011000
 %00011000
end
 if blueState{2} then REFP1 = 8
 return

redWin
 score = 0
 blueScore = 0
 redScore = 0
 COLUPF = $1E
 player0x = 0
 player0y = 0
 player1x = 0
 player1y = 0
 playfield:
 .......XXXXX.XXXX.XX............
 .......X...X.X....X.X...........
 .......XXXX..XXXX.X..X..........
 .......X.X...X....X..X..........
 .......X..X..X....X.X...........
 .......X...X.XXXX.XX............
 .....X...X.XXX.X..X..XX.........
 .....X.X.X..X..XX.X.X...........
 .....X.X.X..X..X.XX..XX.........
 .....X.X.X..X..X.XX....X........
 ......X.X..XXX.X..X..XX.........
end
 drawscreen
 if !joy1fire goto redWin
 goto init

blueWin
 score = 0
 blueScore = 0
 redScore = 0
 COLUPF = $1E
 player0x = 0
 player0y = 0
 player1x = 0
 player1y = 0
 playfield:
 .....XXX..X...X...X.XXXX........
 .....X..X.X...X...X.X...........
 .....X..X.X...X...X.XXXX........
 .....XXX..X...X...X.X...........
 .....X..X.X...X...X.X...........
 .....XXX..XXX..XXX..XXXX........
 .....X...X.XXX.X..X..XX.........
 .....X.X.X..X..XX.X.X...........
 .....X.X.X..X..X.XX..XX.........
 .....X.X.X..X..X.XX....X........
 ......X.X..XXX.X..X..XX.........
end
 drawscreen
 if !joy1fire goto blueWin
 goto init


 
map1
 playfield:
 ....X..........X...........X....
 ................................
 ........XXXXXXXXXXXXXXXX.....XXX
 ..X........X.................X..
 ..X..........................X..
 ..X.................X........X..
 XXX.....XXXXXXXXXXXXXXXX........ 
 ................................
 ....X......................X....
 ...............X................
 ...............X................
end
 return
 
map2
 playfield:
 ...............X................
 .........X......................
 ........XX...........X.......XXX
 ..X..................X.......X..
 ..X...............X..X.......X..
 ..X..........................X..
 XXX.......X..X.................. 
 ..........X.....................
 ..........X...........XX........
 ......................X.........
 ...............X................
end
 return
 

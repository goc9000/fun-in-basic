   1 GO TO 5000
   2 REM Update piece on screen
   3 PRINT AT o(1,1),o(1,2);"\c";AT o(2,1),o(2,2);"\c";AT o(3,1),o(3,2);"\c";AT o(4,1),o(4,2);"\c"
   4 FOR i=1 TO 4: LET o(i,1)=l+b(i,1): LET o(i,2)=c+b(i,2): NEXT i
   5 PRINT PAPER t;AT o(1,1),o(1,2);"\a";AT o(2,1),o(2,2);"\a";AT o(3,1),o(3,2);"\a";AT o(4,1),o(4,2);"\a"
   6 RETURN
  10 REM Main loop
  20 LET g=g-1: IF g<0 THEN GO TO 40
  30 LET k= CODE INKEY$: IF k=0 THEN GO TO 20
  31 IF k=8 OR k=9 THEN GO TO 100
  32 IF k=10 OR k=11 THEN GO TO 150
  33 IF k=32 THEN GO TO 250
  34 IF k>=49 AND k<=57 THEN GO SUB 7800
  35 GO TO 20
  40 REM Gravity
  41 LET l=l+1: GO SUB 50
  42 IF f=0 THEN LET l=l-1: GO TO 300: REM Piece down
  43 GO SUB 2
  44 LET g=sp
  45 GO TO 10
  50 REM Collision check
  51 REM Inp.l,c,b, Out.f
  52 REM If failed, f=0
  55 LET f=1: FOR i=1 TO 4: IF b$(1+l+b(i,1),7+3*(c+b(i,2)))<>"\c" THEN LET f=0
  56 NEXT i
  57 RETURN
 100 REM Go left/right
 110 LET dx=-1+2*(k=9)
 120 LET c=c+dx: GO SUB 50
 130 IF f=0 THEN LET c=c-dx: GO TO 10
 140 GO SUB 2: GO TO 10
 150 REM Rotate
 151 BEEP .005,40
 155 LET s=p(t,9)
 160 IF s=2 THEN GO TO 10
 161 LET ix=1+(k=11)
 165 FOR i=1 TO 4: LET r(i,1)=b(i,1): LET r(i,2)=b(i,2)
 166 LET b(i,ix)=b(i,3-ix): LET b(i,3-ix)=s-1-r(i,ix)
 169 NEXT i
 170 GO SUB 50: IF f=0 THEN FOR i=1 TO 4: LET b(i,1)=r(i,1): LET b(i,2)=r(i,2): NEXT i: GO TO 10
 180 GO SUB 2: GO TO 10
 250 REM Drop piece
 251 BEEP .01,0: BEEP .01,-5
 252 LET di=100
 255 FOR i=1 TO 4: LET tl=l+b(i,1)+2: LET tc=7+3*(c+b(i,2))
 257 IF b$(tl,tc)="\c" THEN LET tl=tl+1: GO TO 257
 258 LET d=tl-l-b(i,1)-2: IF d<di THEN LET di=d
 259 NEXT i
 260 LET l=l+di
 265 LET sc=sc+di: GO SUB 7500
 266 GO SUB 2
 300 REM Piece down
 305 BEEP .1,-32
 310 REM Commit to shadow board. f=1 if lines were filled
 311 LET f=0
 312 FOR i=1 TO 4: LET y=1+l+b(i,1): LET x=6+3*(c+b(i,2))
 315 LET b$(y,x TO x+1)=CHR$ t+"\a"
 316 LET t(y)=t(y)+1: IF t(y)=10 THEN LET f=1
 317 NEXT i
 320 IF f=1 THEN GO SUB 2000
 350 GO SUB 500
 355 IF f=0 THEN GO TO 6000
 360 GO SUB 4000
 370 GO TO 10
 499 PAUSE 0: STOP
 500 REM Spawn piece
 501 REM Inp.nx, Out.t,l,c,b,f
 502 REM f=0 if failed
 510 LET t=nx
 515 LET l=0: LET c=4
 520 FOR i=1 TO 4: LET b(i,1)=p(t,i*2-1): LET b(i,2)=p(t,i*2): LET o(i,1)=l+b(i,1): LET o(i,2)=c+b(i,2): NEXT i
 525 GO SUB 50
 530 IF f=1 THEN GO SUB 2
 540 LET g=sp
 550 RETURN
2000 REM Highlight & score filled lines
2005 LET mu=1
2010 FOR i=22 TO 1 STEP -1: IF t(i)=10 THEN PRINT AT i-1,1; PAPER 7; BRIGHT 1;"\a\a\a\a\a\a\a\a\a\a": BEEP .02,30: LET sc=sc+INT (100*mu): LET mu=mu*1.5
2015 NEXT i
2020 GO SUB 7000
2025 REM Clear lines
2030 LET wr=22: FOR i=22 TO 1 STEP -1: IF t(i)<10 THEN LET b$(wr)=b$(i): LET t(wr)=t(i): LET wr=wr-1: PRINT AT wr,0;b$(i)
2035 NEXT i
2040 FOR i=wr TO 1 STEP -1: LET b$(wr)=l$: LET t(wr)=0: LET wr=wr-1: PRINT AT wr,0;l$
2045 NEXT i
2100 RETURN
4000 REM Pick next piece and update UI
4010 IF nx>0 THEN FOR i=1 TO 8 STEP 2: PRINT AT 18+p(nx,i),16+p(nx,i+1);" ": NEXT i
4020 LET nx=1+INT (RND*7)
4030 PAPER nx
4040 FOR i=1 TO 8 STEP 2: PRINT AT 18+p(nx,i),16+p(nx,i+1);"\a": NEXT i
4050 PAPER 7
4060 RETURN
5000 REM Actual program start
5010 GO SUB 9500: REM Set up game data
5020 GO SUB 9900: REM Set up UDGs
5030 GO SUB 9000: REM Draw UI
5040 GO SUB 8000: REM New game
5100 GO TO 10: REM Enter main
6000 REM Game over
6010 PAPER 2: INK 6
6011 PRINT AT 9,1;"          "
6012 PRINT AT 10,1;" \{f1}GAME\{f0}     "
6013 PRINT AT 11,1;"     \{f1vi}OVER\{vnf0} "
6014 PRINT AT 12,1;"          "
6015 PAPER 7: INK 0
6016 BEEP .1,15: BEEP .1,14: BEEP .2,12: BEEP .2,7: BEEP .2,3: BEEP .2,0: BEEP .2,-5: BEEP .2,-9: BEEP .7,-12: REM Lifted from Magnetron :)
6020 PAUSE 0
6030 GO TO 5040
7500 REM Update score UI
7510 LET x=6-(LEN STR$ sc): PRINT INK 2;AT 17,24;"000000"( TO x);sc
7515 IF sc>hi THEN LET hi=sc: LET x=6-(LEN STR$ hi): PRINT #0; INK 2;AT 0,24;"000000"( TO x);hi
7550 RETURN
7800 REM Set speed
7810 LET sp=100-11*(k-48)
7820 BEEP .03,16
7830 PRINT AT 12,29; INK 4;k-48
7850 RETURN
8000 REM Init new game
8010 FOR i=0 TO 21: LET b$(i+1)=l$: LET t(i+1)=0: PRINT AT i,0;l$: NEXT i: REM Clear playing field
8020 FOR i=18 TO 21: PRINT AT i,16;"    ": NEXT i: REM Next piece
8110 LET nx=1+INT (RND*7): GO SUB 500: REM 1st spawn
8120 LET nx=0: GO SUB 4000
8130 LET sc=0: GO SUB 7500
8900 RETURN
9000 REM Draw user interface
9010 BORDER 7: PAPER 7: INK 0: BRIGHT 0: CLS : REM Reset screen
9020 REM Draw playing field
9030 FOR i=0 TO 21: PRINT AT i,0;b$(i+1): NEXT i
9040 PRINT #0;AT 0,0;b$(23)
9050 REM Draw rest of UI
9055 PRINT AT 0,17;"\{i3}\':\' \{i2}\:'\' \{i6}\':\' \{i4}\:'\:'\{i5}\ '\{i1}\ :\''\{i0}"
9056 PRINT AT 1,17;"\{i3}\ : \{i2}\:' \{i6}\ : \{i4}\:'\. \{i5}\ :\{i1} \'.\{i0}"
9057 PRINT AT 2,17;"\{i3}\ : \{i2}\:.\..\{i6}\ : \{i4}\: \ :\{i5}\ :\{i1}\ .\.:\{i0}"
9060 PRINT AT 4,14;"For Sinclair BASIC"
9070 PRINT AT 6,14; INK 1;"By atmfjstc";AT 7,17;"\@protonmail.com"
9080 PRINT AT 9,14; INK 4;"Use arrows to move";AT 10,14;"Up/down to rotate";AT 11,17;"Space to drop";AT 12,14;"1-9 set speed (";INT ((100-sp)/11);")"
9090 PRINT AT 15,16;"NEXT": PRINT AT 17,15; INK 2;"\:'\''\''\''\''\':": PRINT #0;AT 0,15; INK 2;"\:.\..\..\..\..\.:"
9100 FOR i=18 TO 21: PRINT INK 2;AT i,15;"\:     \ :": NEXT i
9110 PRINT AT 15,24;"SCORE"; INK 2;AT 17,24;"000000"
9120 PRINT AT 20,24;"HIGH";#0; INK 2;AT 0,24;"000000"
9130 RETURN
9500 REM Set up game data
9510 DIM p(7,9): REM For each piece, the line,col coordinates of its 4 blocks, relative to a 4x4 containing square. Plus a finall value indicating the size of the piece (2,3 or 4)
9515 FOR i=1 TO 7: FOR j=1 TO 9: READ p(i,j): NEXT j: NEXT i
9520 DATA 0,1,1,1,2,1,2,0,3
9530 DATA 0,0,0,1,1,1,1,2,3
9540 DATA 1,1,1,0,0,1,1,2,3
9550 DATA 0,2,0,1,1,1,1,0,3
9560 DATA 0,1,1,1,2,1,3,1,4
9570 DATA 0,1,1,1,2,1,2,2,3
9580 DATA 0,1,0,2,1,1,1,2,2
9590 LET f=0: REM General purp. flag
9600 LET nx=0: REM Next piece type (1-7)
9605 LET t=0: REM Curr piece type
9610 LET l=0: LET c=0: REM Line, col for curr piece 4x4 container
9615 DIM b(4,2): REM Curr. piece. blocks line,col relative to y,x
9616 DIM r(4,2): REM Backup of above when rotating
9620 DIM o(4,2): REM Backup curr piece position
9630 LET g=0: REM Ticks till gravity ensues
9640 LET sp=100-5*11: REM Speed (lower=faster)
9650 LET sc=0: LET hi=0: REM Score and Hi-score
9660 DIM b$(23,42): REM Lines in the board, as chars preceded by 2 control chars for setting ink
9670 DIM l$(42): REM Template for an empty line
9680 LET l$(1 TO 7)=CHR$ 17+CHR$ 2+CHR$ 16+CHR$ 6+"\b"+CHR$ 16+CHR$ 0
9685 FOR i=0 TO 9: LET l$(8+i*3 TO 10+i*3)=CHR$ 17+CHR$ 7+"\c": NEXT i
9688 LET l$(38 TO 42)=CHR$ 17+CHR$ 2+CHR$ 16+CHR$ 6+"\b"
9690 FOR i=1 TO 23: LET b$(i)=l$: NEXT i
9700 REM Special treatment for bottom
9710 LET b$(23,7)=CHR$ 6: FOR i=0 TO 9: LET b$(23,9+i*3 TO 10+i*3)=CHR$ 2+"\b": NEXT i
9720 DIM t(22): REM Total no of blocks on each line
9899 RETURN
9900 REM Set up UDGs
9910 FOR i=USR "a" TO USR "c"+7: READ v: POKE i,v: NEXT i
9920 DATA 1,3,59,35,35,3,127,255
9930 DATA 1,255,16,16,16,255,1,1
9940 DATA 128,0,0,0,0,0,0,0
9990 RETURN

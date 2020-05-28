   1 GO TO 9000
# Main game loop. Can't put REMs here, must be absolutely super fast
   5 LET a=PEEK 23560: IF a>=8 AND a<=11 THEN LET dx=(a=9)-(a=8): LET dy=(a=10)-(a=11)
# ^ It's more pure to use LET a=CODE INKEY$, but the PEEK variant catches more keystrokes
  10 LET nx=x+dx: LET ny=y+dy: LET nx=nx+17*(y=10)*((nx=0)-(nx=18)): LET a=ATTR (ny,nx)
  15 IF a<>1 THEN LET pm=1-pm: PRINT AT y,x;" ";AT ny,nx; INK 6;CHR$ (144+pm*((dx<>0)+dx+dy+2)): LET x=nx: LET y=ny: IF a<5 THEN LET gi=a-1: GO TO 1000
  20 IF a=1 THEN PRINT AT y,x; INK 6;CHR$ (144+pm*((dx<>0)+dx+dy+2))
# Eat dot
  25 IF p(x,y)=1 THEN LET p(x,y)=0: BEEP .001,40: LET pts=pts-1: IF pts=0 THEN GO TO 3000
# Move ghost
  30 LET gx=g(gi,1): LET gy=g(gi,2): LET gdx=-g(gi,3): LET gdy=-g(gi,4): LET b=9999: LET c=gdx*10+gdy
# c=forbidden direction (ghosts can't turn 180 degrees unless absolutely necessary)
  35 IF c<>10 THEN IF ATTR (gy,gx+1)<>1 THEN LET a=ABS (x-gx-1)+ABS (y-gy): IF a<b THEN LET b=a: LET gdx=1: LET gdy=0
  40 IF c<>-10 THEN IF ATTR (gy,gx-1)<>1 THEN LET a=ABS (x-gx+1)+ABS (y-gy): IF a<b THEN LET b=a: LET gdx=-1: LET gdy=0
  45 IF c<>1 THEN IF ATTR (gy+1,gx)<>1 THEN LET a=ABS (x-gx)+ABS (y-gy-1): IF a<b THEN LET b=a: LET gdx=0: LET gdy=1
  50 IF c<>-1 THEN IF ATTR (gy-1,gx)<>1 THEN LET a=ABS (x-gx)+ABS (y-gy+1): IF a<b THEN LET b=a: LET gdx=0: LET gdy=-1
  55 LET nx=gx+gdx: LET ny=gy+gdy: LET a=ATTR (ny,nx)
# Try double movement
  60 IF (a=5) AND f(nx+1,ny+1) THEN IF ATTR (ny+gdy,nx+gdx)>=5 THEN LET nx=nx+gdx: LET ny=ny+gdy: LET a=ATTR (ny,nx)
# Move
  65 IF a>=5 THEN PRINT AT gy,gx;CHR$ (32+118*p(gx,gy));AT ny,nx; INK gi+1;"\f": LET g(gi,1)=nx: LET g(gi,2)=ny: IF a=6 THEN GO TO 1000
  70 IF a<5 THEN LET gdx=-gdx: LET gdy=-gdy
  75 LET g(gi,3)=gdx: LET g(gi,4)=gdy
  80 LET gi=gi+1: IF gi>3 THEN LET gi=1
  85 GO TO 5
1000 REM Caught by ghost @gi
1005 FOR i=0 TO 20 STEP 2
1010 PRINT AT y,x; INK 6;CHR$ (145+i/2-4*INT (i/8)): BEEP .05,6*INT (i/3)-3*i
1015 PRINT AT y,x; INK gi+1;"\f": BEEP .05,6*INT ((i+1)/3)-3*(i+1)
1020 NEXT i
1025 BEEP 1,-24
1030 PAUSE 1: PAUSE 100
1035 LET liv=liv-1: PRINT AT 10,23+liv*2;" "
1040 IF liv=0 THEN GO TO 2000
1045 GO SUB 8100
1050 GO TO 7025
2000 REM Game over
2005 PRINT AT 9,22; INK 7; FLASH 1;"G A M E"; AT 11,23;"O V E R"
2010 PAUSE 1: PAUSE 300
2015 PRINT AT 9,22;"       "; AT 11,23;"       "
2020 GO TO 6900
3000 REM Victory
3005 FOR i=1 TO 3: PRINT AT g(i,2),g(i,1);" ": NEXT i
3010 GO SUB 7100
3015 PRINT AT 10,23; "     "
3020 PRINT AT 9,22; INK 7; FLASH 1;"W E L L"; AT 11,23;"D O N E"
3025 GO TO 2010
6900 REM Reset game
6905 GO SUB 9600
6910 PRINT AT 10,20; INK 7; "Please wait"
6915 LET b=0
6920 FOR y=1 TO 20: FOR x=1 TO 17: LET a=ATTR (y,x): IF a<>1 THEN LET p(x,y)=(a=5): LET b=b+(a=5)
6925 NEXT x: NEXT y
6930 LET pts=b
6935 PRINT AT 10,20;"           "
7000 REM Wait for game start
7005 PRINT AT 9,21; INK 7;"Press any"; AT 11,20;"key to start"
7010 PAUSE 0
7015 PRINT AT 9,20;"            "; AT 11,20;"            "
7020 LET liv=3: PRINT AT 10,23; INK 6;"\e \e \e"
7025 GO SUB 8000
7030 GO SUB 7050
7035 POKE 23560,0: REM Clear keystroke
7040 GOTO 5
7050 REM Play start tune
7055 LET a=0.05: LET b=2
7060 FOR i=0 TO 2: LET c=(i=1): BEEP a,0+c: PAUSE b: BEEP a,12+c: PAUSE b: BEEP a,7+c: PAUSE b: BEEP a,4+c: PAUSE b: BEEP a,12+c: BEEP a,7+c: PAUSE 2*b: BEEP 2*a,4+c: PAUSE 2*b: NEXT i
7065 FOR i=0 TO 2: BEEP a,3+i*2: BEEP a,4+i*2: BEEP a,5+i*2: PAUSE b: NEXT i
7070 BEEP a*4,12: PAUSE 4*b
7075 RETURN
7100 REM Play victory tune
7105 LET a=0.05
7110 BEEP a,-5: BEEP a,-3: BEEP a,-1: BEEP 4*a,0: BEEP 4*a,4: BEEP 4*a,2: BEEP 4*a,5
7115 BEEP 2*a,4: BEEP 2*a,5: BEEP 2*a,7: BEEP 2*a,4: BEEP 4*a,2: BEEP 4*a,5
7120 BEEP 2*a,4: BEEP 2*a,5: BEEP 2*a,7: BEEP 2*a,4: BEEP 2*a,5: BEEP 2*a,7: BEEP 2*a,9: BEEP 2*a,11
7125 BEEP 4*a,12: BEEP 4*a,11: BEEP 6*a,12
7130 RETURN
8000 REM Place Pac&ghosts at start positions
8005 FOR i=1 TO 3: LET g(i,1)=7+i: LET g(i,2)=8: LET g(i,3)=0: LET g(i,4)=0: NEXT i
8010 LET g(1,3)=-1: LET g(2,3)=1: LET g(3,4)=-1
8015 FOR i=1 TO 3: PRINT AT g(i,2),g(i,1); INK i+1;"\f": NEXT i
8020 LET x=9: LET y=12: LET dx=1: LET dy=0: PRINT AT y,x; INK 6;"\e"
8025 RETURN
8100 REM Remove Pac&ghosts from board
8105 PRINT AT y,x;CHR$ (32+118*p(x,y))
8110 FOR i=1 TO 3: PRINT AT g(i,2),g(i,1);CHR$ (32+118*p(g(i,1),g(i,2))): NEXT i
8115 RETURN
9000 REM Init program
9004 REM Pre-define all variables for speed
9005 LET a=0: DIM g(3,4): LET gi=1: LET b=0: LET c=0: LET gx=0: LET gy=0: LET nx=0: LET ny=0: LET gdx=0: LET gdy=0: LET x=0: LET y=0: LET dx=1: LET dy=0: DIM f(19,22): DIM p(19,22): LET pm=0: LET liv=0: LET pts=0
9010 BORDER 0: PAPER 0: INK 5: CLS
9015 GO SUB 9800: GO SUB 9600
9020 GO SUB 9500
9025 PRINT AT 1,22; BRIGHT 1; INK 6;"PAC-MAN"
9030 PRINT AT 4,20; INK 5;"For ZX BASIC"
9035 PRINT AT 18,20; INK 1;"By atmfjstc\@"
9040 PRINT AT 19,20; INK 1;"protonmail"
9045 PRINT AT 20,20; INK 1;".com   \*2020"
9050 GO TO 7000
9500 REM Init tables
9505 PRINT AT 8,20; INK 7; FLASH 1;"PLEASE WAIT!": PRINT AT 12,20; INK 1;"\::\::\::\::\::\::\::\::\::\::\::\::"
9510 LET b=0
9515 FOR y=1 TO 20: FOR x=1 TO 17: LET a=ATTR (y,x): IF a<>1 THEN LET p(x,y)=(a=5): LET b=b+(a=5): LET f(x+1,y+1)=(((ATTR (y+1,x)<>1)+(ATTR (y-1,x)<>1)+(ATTR (y,x+1)<>1)+(ATTR (y,x-1)<>1))=2)
9520 NEXT x: PRINT AT 12,20+INT ((y-1)*11/19); INK 6;"\::": NEXT y
9525 LET pts=b
9530 PRINT AT 8,20;"            ";AT 12,20;"            "
9535 RETURN
9600 REM Draw playing field
9605 PRINT AT 0,0;
9610 PRINT "\{i1}\n\h\h\h\h\h\h\h\h\r\h\h\h\h\h\h\h\h\o"
9615 PRINT "\{i1}\i\{i5}\g\g\g\g\g\g\g\g\{i1}\i\{i5}\g\g\g\g\g\g\g\g\{i1}\i"
9620 PRINT "\{i1}\i\{i5}\g\{i1}\s\o\{i5}\g\{i1}\s\::\o\{i5}\g\{i1}\i\{i5}\g\{i1}\s\::\o\{i5}\g\{i1}\s\o\{i5}\g\{i1}\i"
9625 PRINT "\{i1}\i\{i5}\g\{i1}\p\q\{i5}\g\{i1}\p\h\q\{i5}\g\{i1}\l\{i5}\g\{i1}\p\h\q\{i5}\g\{i1}\p\q\{i5}\g\{i1}\i"
9630 PRINT "\{i1}\i\{i5}\g\g\g\g\g\g\g\g\g\g\g\g\g\g\g\g\g\{i1}\i"
9635 PRINT "\{i1}\i\{i5}\g\{i1}\k\m\{i5}\g\{i1}\j\{i5}\g\{i1}\k\h\r\h\m\{i5}\g\{i1}\j\{i5}\g\{i1}\k\m\{i5}\g\{i1}\i"
9640 PRINT "\{i1}\i\{i5}\g\g\g\g\{i1}\i\{i5}\g\g\g\{i1}\i\{i5}\g\g\g\{i1}\i\{i5}\g\g\g\g\{i1}\i"
9645 PRINT "\{i1}\p\h\h\o\{i5}\g\{i1}\r\h\m\{i5}\g\{i1}\l\{i5}\g\{i1}\k\h\i\{i5}\g\{i1}\n\h\h\q"
9650 PRINT "\{i1}   \i\{i5}\g\{i1}\i\{i5}\g\g\g\g\g\g\g\{i1}\i\{i5}\g\{i1}\i   "
9655 PRINT "\{i1} \k\h\q\{i5}\g\{i1}\l\{i5}\g\{i1}\n\h\h\h\o\{i5}\g\{i1}\l\{i5}\g\{i1}\p\h\m "
9660 PRINT "\{i1} \{i5}\g\g\g\g\g\g\{i1}\i   \i\{i5}\g\g\g\g\g\g\{i1} "
9665 PRINT "\{i1} \k\h\o\{i5}\g\{i1}\j\{i5}\g\{i1}\p\h\h\h\q\{i5}\g\{i1}\j\{i5}\g\{i1}\n\h\m "
9670 PRINT "\{i1}   \i\{i5}\g\{i1}\i\{i5}\g\g\g\{i7} \{i5}\g\g\g\{i1}\i\{i5}\g\{i1}\i   "
9675 PRINT "\{i1}\n\h\h\q\{i5}\g\{i1}\l\{i5}\g\{i1}\k\h\r\h\m\{i5}\g\{i1}\l\{i5}\g\{i1}\p\h\h\o"
9680 PRINT "\{i1}\i\{i5}\g\g\g\g\g\g\g\g\{i1}\i\{i5}\g\g\g\g\g\g\g\g\{i1}\i"
9685 PRINT "\{i1}\i\{i5}\g\{i1}\k\o\{i5}\g\{i1}\k\h\m\{i5}\g\{i1}\l\{i5}\g\{i1}\k\h\m\{i5}\g\{i1}\n\m\{i5}\g\{i1}\i"
9690 PRINT "\{i1}\i\{i5}\g\g\{i1}\i\{i5}\g\g\g\g\g\g\g\g\g\g\g\{i1}\i\{i5}\g\g\{i1}\i"
9695 PRINT "\{i1}\r\m\{i5}\g\{i1}\l\{i5}\g\{i1}\j\{i5}\g\{i1}\k\h\r\h\m\{i5}\g\{i1}\j\{i5}\g\{i1}\l\{i5}\g\{i1}\k\i"
9700 PRINT "\{i1}\i\{i5}\g\g\g\g\{i1}\i\{i5}\g\g\g\{i1}\i\{i5}\g\g\g\{i1}\i\{i5}\g\g\g\g\{i1}\i"
9705 PRINT "\{i1}\i\{i5}\g\{i1}\k\h\h\h\h\m\{i5}\g\{i1}\l\{i5}\g\{i1}\k\h\h\h\h\m\{i5}\g\{i1}\i"
9710 PRINT "\{i1}\i\{i5}\g\g\g\g\g\g\g\g\g\g\g\g\g\g\g\g\g\{i1}\i"
9715 PRINT "\{i1}\p\h\h\h\h\h\h\h\h\h\h\h\h\h\h\h\h\h\q\{i7}"
9720 RETURN
9800 REM Define UDGs
9805 RESTORE 9810: FOR i=USR "a" TO USR "s"+7: READ a: POKE i,a: NEXT i
9810 DATA 56,124,254,254,254,124,56,0
9815 DATA 0,68,238,254,254,124,56,0
9820 DATA 56,124,62,30,62,124,56,0
9825 DATA 56,124,254,254,238,68,0,0
9830 DATA 56,124,248,240,248,124,56,0
9835 DATA 56,124,254,146,146,254,170,0
9840 DATA 0,0,16,56,16,0,0,0
9845 DATA 255,255,255,255,255,255,255,0
9850 DATA 254,254,254,254,254,254,254,254
9855 DATA 56,124,254,254,254,254,254,254
9860 DATA 63,127,255,255,255,127,63,0
9875 DATA 254,254,254,254,254,124,56,0
9880 DATA 248,252,254,254,254,252,248,0
9885 DATA 63,127,255,255,255,255,255,254
9890 DATA 248,252,254,254,254,254,254,254
9900 DATA 255,255,255,255,255,127,63,0
9905 DATA 254,254,254,254,254,252,248,0
9910 DATA 255,255,255,255,255,255,255,254
9915 DATA 63,127,255,255,255,255,255,255
9990 RETURN
9999 REM Developed in early May 2020
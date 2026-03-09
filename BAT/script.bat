@echo off
rem Ceci est un script 
chcp > null
MODE con cols=160 lines=30
COLOR 2
rem ******************
echo bonjour tout le monde
rem ********************
dir > liste.txt
pause
PROMPT N$D-$T$G
sfc /scannow
cls
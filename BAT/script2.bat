@ECHO OFF
MKDIR fifi
COPY C:\fichier.txt C:\fifi
DEL C:\fifi\fichier.txt
DEL C:\fifi
start C:\Windows\explorer.exe

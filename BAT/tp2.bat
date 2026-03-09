@ECHO OFF
cd C:\VMWin11

REM Vérifiez si le dossier Backups existe deja, et supprimez-le si c'est le cas
IF EXIST Backups (
    RMDIR /S /Q Backups
)

MKDIR Backups 
COPY script Backups 
COPY toto Backups 
COPY travail Backups 

REM Utilisation de PowerShell pour créer l'archive zip
powershell -command "Compress-Archive -Path Backups -DestinationPath Backups/Backups.zip"
set SOURCE_FILE=C:\VMWin11\Backup\Backups.zip
COPY "C:\VMWin11\Backups\Backups.zip" "D:\OneDrive - EPNAK - ESRP RENNES\Backups"

DEL C:\VMWin11\Backups\*.zip
DEL C:\VMWin11\Backups\*.txt
DEL C:\VMWin11\Backups\*.bat
DEL C:\VMWin11\Backups\*.exe
DEL C:\VMWin11\Backups\*null


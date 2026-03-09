@ECHO OFF
:DEBUT
CLS
ECHO ***********************
ECHO Veuillez choisir une option 
ECHO 1 - Firefox
ECHO 2 - Google Chrome
ECHO 3 - Winzip 
ECHO 4 - Google Earth Pro
ECHO 5 - VMware
ECHO 6 - AnyDesk
ECHO 7 - VncViewer
ECHO 8 - Advanced IP Scanner
ECHO 9 - OneDrive
ECHO 10 - Word
ECHO 11 - Excel 
ECHO 12 - PowerPoint
ECHO 13 - Outlook
ECHO 14 - Skype Entreprise
ECHO 15 - Skype
ECHO 16 - Access
ECHO 17 - Exit
ECHO ***********************

set choix=0 

set /p choix=Votre choix:

if %choix%==1 (
   "C:\Program Files\Mozilla Firefox\firefox.exe"
)

if %choix%==2 (
   "C:\Program Files\Google\Chrome\Application\chrome.exe"
    GOTO DEBUT 
)
if %choix%==3 (
   "C:\Program Files\7-Zip\7zFM.exe"
    GOTO DEBUT 
)
if %choix%==4 (
   "C:\Program Files\Google\Google Earth Pro\client\googleearth.exe"
     GOTO DEBUT 
)
if %choix%==5 (
  "C:\Program Files (x86)\VMware\VMware Workstation\vmware.exe"

)
if %choix%==6 (
  "C:\Program Files (x86)\AnyDesk\AnyDesk.exe"
    GOTO DEBUT 
)

if %choix%==7 (
   "C:\Program Files\RealVNC\VNC Viewer\vncviewer.exe"
    GOTO DEBUT 
)
if %choix%==8 (
   "C:\Program Files (x86)\Advanced IP Scanner\advanced_ip_scanner.exe"
    GOTO DEBUT 
)
if %choix%==9 (
   "C:\Program Files\Microsoft OneDrive\OneDrive.exe"
    GOTO DEBUT 
)
if %choix%==10 (
   "C:\Program Files\Microsoft Office\root\Office16\WINWORD.exe"
    GOTO DEBUT 
)
if %choix%==11 (
   "C:\Program Files\Microsoft Office\root\Office16\EXCEL.exe"
    GOTO DEBUT 
)
if %choix%==12 (
   "C:\Program Files\Microsoft Office\root\Office16\POWERPNT.exe"
    GOTO DEBUT 
)
if %choix%==13 (
   "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.exe"
    GOTO DEBUT 
)
if %choix%==14 (
   "C:\Program Files\Microsoft Office\root\Office16\lync.exe"
    GOTO DEBUT 
)
if %choix%==15 (
   "C:\Program Files\Microsoft Office\root\Office16\lync99.exe"
    GOTO DEBUT 
)
if %choix%==15 (
   "C:\Program Files\Microsoft Office\root\Office16\MSACCESS.exe"
    GOTO DEBUT 
)
if %choix%==17 (
    ECHO bye bye
)


    

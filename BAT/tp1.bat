@ECHO OFF
:DEBUT
CLS
ECHO ***********************
ECHO Veuillez choisir une option 
ECHO 1 - VmWare
ECHO 2 - Winzip 
ECHO 3 - Sublime text
ECHO 4 - Word
ECHO 5 - Excel 
ECHO 6 - Exit
ECHO ***********************

set choix=0 

set /p choix=Votre choix:

if %choix%==1 (
   "C:\Program Files (x86)\VMware\VMware Workstation\vmware.exe"
)

if %choix%==2 (
   "C:\Program Files\7-Zip\7zFM.exe"
    GOTO DEBUT 
)
if %choix%==3 (
   "C:\Program Files\Sublime Text\sublime_text.exe"
    GOTO DEBUT 
)
if %choix%==4 (
   "C:\Program Files\Microsoft Office\root\Office16\WINWORD.exe"
     GOTO DEBUT 
)
if %choix%==5 (
   "C:\Program Files\Microsoft Office\root\Office16\EXCEL.exe"
)

if %choix%==6 (
    ECHO bye bye
)


    

@echo off
setlocal enabledelayedexpansion

:: -------------------------
:: Configuration
:: -------------------------
set DOMAIN=ads.tssr.local
set PASSWORD=p@ssw0rd
set USERFILE=users.txt
set LOGFILE=creation_users.log

:: Nettoyer le fichier log
if exist "%LOGFILE%" del "%LOGFILE%"

:: -------------------------
:: Vérifier si le fichier users.txt existe
:: -------------------------
if not exist "%USERFILE%" (
    echo ERREUR : Le fichier %USERFILE% est introuvable.
    exit /b
)

:: -------------------------
:: Créer l'OU parent "Utilisateurs"
:: -------------------------
dsquery ou "OU=Utilisateurs,DC=ads,DC=tssr,DC=local" >nul 2>&1
if errorlevel 1 (
    echo Création de l'OU parent Utilisateurs...
    dsadd ou "OU=Utilisateurs,DC=ads,DC=tssr,DC=local" >>"%LOGFILE%" 2>&1
)

:: -------------------------
:: Créer les OU listées dans users.txt
:: -------------------------
for /f "tokens=3 delims=," %%O in (%USERFILE%) do (
    set OU=%%O
    dsquery ou "OU=!OU!,OU=Utilisateurs,DC=ads,DC=tssr,DC=local" >nul 2>&1
    if errorlevel 1 (
        echo Création de l'OU !OU!...
        dsadd ou "OU=!OU!,OU=Utilisateurs,DC=ads,DC=tssr,DC=local" >>"%LOGFILE%" 2>&1
    )
)

:: -------------------------
:: Créer les utilisateurs
:: -------------------------
for /f "tokens=1,2,3 delims=," %%A in (%USERFILE%) do (
    set FIRSTNAME=%%A
    set LASTNAME=%%B
    set OU=%%C
    set USERNAME=!FIRSTNAME!.!LASTNAME!

    :: Vérifier que l'OU existe
    dsquery ou "OU=!OU!,OU=Utilisateurs,DC=ads,DC=tssr,DC=local" >nul 2>&1
    if errorlevel 1 (
        echo ERREUR : L'OU !OU! n'existe pas, impossible de créer !USERNAME! >> "%LOGFILE%"
    ) else (
        echo Création de l'utilisateur !USERNAME! dans l'OU !OU!...
        dsadd user "CN=!USERNAME!,OU=!OU!,OU=Utilisateurs,DC=ads,DC=tssr,DC=local" -samid !USERNAME! -upn !USERNAME!@%DOMAIN% -pwd %PASSWORD% -desc "Affectation: !OU!" -mustchpwd yes >>"%LOGFILE%" 2>&1
        if errorlevel 1 (
            echo ERREUR : Impossible de créer !USERNAME! >> "%LOGFILE%"
        )
    )
)

echo Tous les utilisateurs ont été traités. Voir %LOGFILE% pour les détails.
pause
@echo off
setlocal enabledelayedexpansion

:: Définition du domaine
set DOMAIN=ads.domaine.local

:: Mot de passe par défaut pour les utilisateurs
set PASSWORD=p@ssw0rd

:: Fichier contenant la liste des utilisateurs (Prénom,Nom,OU)
set USERFILE=users.txt

:: Vérifier si le fichier users.txt existe
if not exist "%USERFILE%" (
    echo ERREUR : Le fichier %USERFILE% est introuvable.
    exit /b
)

:: Lire le fichier et ajouter les utilisateurs
for /f "tokens=1,2,3 delims=," %%A in (%USERFILE%) do (
    set FIRSTNAME=%%A
    set LASTNAME=%%B
    set OU=%%C
    set USERNAME=!FIRSTNAME!.!LASTNAME!

    echo Creation de l'utilisateur !USERNAME!...
    
    dsadd user "CN=!USERNAME!,OU=!OU!,DC=ads,DC=domaine,DC=local" -samid !USERNAME! -upn !USERNAME!@%DOMAIN% -pwd %PASSWORD% -desc "Affectation: !OU!" -mustchpwd yes
)

echo Creation des utilisateurs terminee.
pause
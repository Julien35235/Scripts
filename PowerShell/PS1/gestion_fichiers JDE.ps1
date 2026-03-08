#se déplacer dans la racine 
cd \

# Lister les dossiers et les fichiers 
Get-ChildItem 

#Creation du dossier c:\sauvegarde 
New-Item -Name "sauvegarde" -ItemType Directory
Get-ChildItem 

#se déplacer dans le dossier sauvegarde
cd C:\sauvegarde

# Creation du fichier txt dans ce dossier
New-Item -Name users.txt -ItemType File

# Copier ce fichier txt dans un autre fichier
Copy-Item -Path .\users.txt  -Destination autres.txt

#Renommer l'autre fichier txt
Rename-Item -Path autres.txt -NewName lesautres.txt

#Creation du dossier c:\save
New-Item  -Path "C:\save" -ItemType Directory

#Copier le dossier de sauvegarde dans le dossier c:\save de manière récursive 
Copy-Item -Path C:\sauvegarde\*.* -Destination C:\save\ -Recurse
Get-ChildItem 

#se déplacer dans la racine 
cd \

# Supprimer les dossier de sauvegarde et save et leurs contenu de manière récursive 
Remove-Item C:\sauvegarde -Recurse -Force
Remove-Item C:\save -Recurse -Force



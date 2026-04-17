#Installation du module PoshKeePass
Install-Module -Name PoshKeePass
# l'importer le module PoshKeePass
Import-Module PoShKeePass
Get-Command -Module PoShKeePass
# Enregistrer une base KeePass
Get-KeePassDatabaseConfiguration
#Creation de la nouvelle base de données Keepass
New-KeePassDatabaseConfiguration -DatabaseProfileName "TSSR Databasse" -DatabasePath "C:\Users\TSSR-Julien\Documents\KBX" -UseMasterKey

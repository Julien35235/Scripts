#Montage du lecteur réseaux virtuelle 
New-PSDrive -Name P -Root \\SRV01.tssr.local\Partage -PSProvider FileSystem -Persist -Credential Administrateur@ads.tssr.local
#On peut lister son contenu pour vérifier que notre fichier
Get-ChildItem P:

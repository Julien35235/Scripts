#Recuperation de l'heure actuelle
$heure = (Get-Date -Format HH:mm:ss)

#Affichage du message de bienvenue
Write-Host "Bienvenue sur le système, $nomutilisateur@$domaine !"
Write-host "Il est $heure."

# Exécution de la commande pour obtenir l'adresse IP
$adresse_ip = (Get-NetAdapter | Where-Object {$_.Status -eq "Up"}). IPv4Address
write-Host "Adresse IP: $adresse_ip"
if ($adresse_ip) {
# Enregistrement de l'adresse IP dans le fichier ip.txt sur le bureau
$fichier_ip = "$env:USERPROFILE\Desktop\ip.txt"
Add-Content -Path $fichier_ip -Value "Adresse IP: $adresse_ip"
} else {
 write-Host "Impossible de récupérer l'adresse IP."
 }


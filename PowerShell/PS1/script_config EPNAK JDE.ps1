# vider le cache DNS 
ipconfig /flushdns

# afficher les configurations réseaux
ipconfig 
ipconfig /all
Get-NetAdapter
Get-NetTCPConnection
#Recuperation de notre IPV4 publique 
Invoke-RestMethod -Uri ('https://ipinfo.io/')

# Testes en utiliant la commande ping et Test-Connection  
ping 10.235.95.253
ping 10.235.95.248
ping 10.235.95.7
ping 10.235.95.1
ping google.fr
ping pad-epnak.com
Test-Connection 10.235.95.248


# Voir les DNS en IPV4 en utilisant la commande nslookup
nslookup google.fr
nslookup pad-epnak.com

# Il permet de suivre le chemin emprunté par un paquet IP (Internet Protocol) pour arriver à sa destination
Tracert pad-epnak.com
Tracert google.fr




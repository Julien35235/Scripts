#Recuperation de notre IPV4 publique 
Invoke-RestMethod -Uri ('https://ipinfo.io/')
Invoke-WebRequest -uri "http://ifconfig.me/ip"
(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
$MyIP = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content

#Affichage des interfaces réseaux avec netsh
netsh interface ipv4 show interfaces
#Configuration d'une adresse IPV4 statique
netsh interface ipv4 set address name="Ethernet0" static 192.168.100.10 255.255.255.0 192.168.100.1
#Configuration du serveurs de DNS
netsh interface ipv4 set dns name="Ethernet0" static 1.1.1.1
netsh interface ipv4 add dns name="Ethernet0" 8.8.4.4 index=2
#Affichage de la configuration TCP/IP
netsh interface ip show config
#Activation des interfaces réseau
netsh interface set interface "Ethernet0" admin=enable
#Deactivation de l'interface réseau
netsh interface set interface "Ethernet0" admin=disable
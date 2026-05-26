#Affichage de la table de routage 
route print
#Ajouter une route statique à Windows
route add 192.168.100.0 MASK 255.255.255.0 10.10.20.1
#Ajouter une route persistante
route add -p 192.168.100.0 MASK 255.255.255.0 10.10.20.1
#Affichage de la table de routage 
route print


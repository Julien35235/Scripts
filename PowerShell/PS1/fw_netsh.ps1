#Gestion du firewall de Windows avec netsh
#Affichage des règles du pare-feu
netsh advfirewall firewall show rule name=all
#Ajouter des nouvelles règles aux pare-feu
netsh advfirewall firewall add rule name="Autoriser RDP (In-23389)" protocol=TCP dir=in localport=23389 action=allow
netsh advfirewall firewall add rule name="Autoriser Ping (In-ICMP)" protocol=icmpv4 dir=in action=allow
#Désactiver le pare-feu
netsh advfirewall set allprofiles state off
#Activation du firewall
netsh advfirewall set allprofiles state on
#Bloquer une adresse IP
netsh advfirewall firewall add rule name="Bloquer adresse IP suspecte" protocol=any dir=in interface=any action=block remoteip=192.168.100.100
#Réinitialiser les paramètres du firewall
#netsh advfirewall reset


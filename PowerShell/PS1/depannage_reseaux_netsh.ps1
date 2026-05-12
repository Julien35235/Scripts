#Dépannage réseau avec Netsh
netsh trace show scenarios
#Engistrements des trames réseaux
netsh trace start scenario=NetConnection capture=yes tracefile=C:\netsh\NetshNetConnection.etl
netsh trace stop

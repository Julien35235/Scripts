#Montez l'image WinRE sur l'appareil
mkdir C:\mount reagentc /mountre /path C:\mount
#Montez la ruche de registre système de l'image WinRE
reg load HKLM\WinREHive C:\mount\Windows\System32\config\SYSTEM
#Enregistrez et déchargez la ruche de registre
reg unload HKLM\WinREHive
#Appliquez les changements et fermez l'image 
reagentc /unmountre /path C:\mount /commit
#Rétablir la relation de confiance de BitLocker pour votre WinRE
reagentc /disable reagentc /enable

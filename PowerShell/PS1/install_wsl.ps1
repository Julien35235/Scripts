#Installation de WSL dans des posts clients
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux, VirtualMachinePlatform
wsl --install
#Redermarrage du posts client pour finaliser l'installation de WSL
Restart-Computer
#Installation du système Debian dans WSL
wsl --install -d Debian
#Installation du système Ubuntu dans WSL
wsl --install -d Ubuntu
#Installation du système Fedora dans WSL
wsl --install -d Fedora 
#Installation du système Kali dans WSL
wsl --install -d Kali
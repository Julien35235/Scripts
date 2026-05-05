#Activation de Virtual Machine Platform 
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
#Activation de Windows Subsystem for Linux
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
#Installation de WSL 
wsl.exe --install
wsl.exe --set-default-version 2
wsl --set-version kali-linux 2
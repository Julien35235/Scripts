#Activation de la fonctionnalité dans le Registre Windows pour passer sous Windows Server 2025
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AllowWindowsServerFeatureUpdate"
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AllowWindowsServerFeatureUpdate" -Name "AllowWindowsServerFeatureUpdate" -PropertyType DWord -Value 1
#Cette commande affiche les informations de licence de Windows et montre si Windows est activé et le type de licence utilisé.
slmgr /dli

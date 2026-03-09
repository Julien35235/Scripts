#Creation de la nouvelle VMSERVERSWDS dans Hyper-v
New-VM -Name VMSERVERSWDS -MemoryStartupBytes 16GB -BootDevice VHD -NewVHDPath 
C:\Users\TSSR-Julien\Documents\VMS\Hyper-V\VMSERVERS\wds.vhdx -Path C:\Users\TSSR-Julien\Documents\VMS\Hyper-V\VMCLIENTS 40GB -Generation 2 -Switch 
#Montage du lecteur reseaux virtuel pour le posts d'installation de la VM Server
Add-VMDvdDrive -VMName VMCLIENT -Path C:\Users\TSSR-Julien\Documents\iso\fr-fr_windows_server_2022_x64_dvd_9f7d1adb.iso
#Demarrage de la VM Servers
Start-VM -Name VMSERVERSWDS 
Get-ExecutionPolicy
Set-ExecutionPolicy Unrestricted
Get-ADUser -Filter * -Properties * | Select-Object Name, SamAccountName, Enabled, EmailAddress | Export-Csv C:\Rapports\Utilisateurs.csv -NoTypeInformation
Get-ADComputer -Filter * | Select-Object Name, DNSHostName, Enabled | Export-Csv C:\Rapports\Ordinateurs.csv -NoTypeInformation
Get-ADComputer -Filter * | Select-Object Name, DNSHostName, Enabled | Export-Csv C:\Rapports\Ordinateurs.csv -NoTypeInformation
dcdiag /v
dcdiag /test:replications
dcdiag /test:dns
dcdiag /test:advertising
Enable-ADOptionalFeature -Identity "Recycle Bin Feature" -Scope ForestOrConfigurationSet -Target "ads.local"
Search-ADAccount -UsersOnly -AccountInactive -TimeSpan 00.02:00:00
# Définir la lettre du lecteur réseau et son chemin réseau
$DriveLetter = "Y:"  # Choisir une lettre de lecteur valide
$DrivePath = "xxxxx"  # Chemin réseau du lecteur
# Mappe le lecteur réseau de manière persistante avec une lettre de lecteur valide
New-PSDrive -Name "Commercial" -PSProvider FileSystem -Root $DrivePath -Persist
# Masque le lecteur dans l'explorateur de fichiers
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideDrivesWithNoMedia" -Value 1
# Masquer la lettre de lecteur spécifique (par exemple Z:) dans l'explorateur de fichiers
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideDrivesWithNoMedia" -Value 1
# Optionnel : Définir la clé du registre pour masquer spécifiquement un lecteur réseau
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "NoDrives" -Value 128 -PropertyType DWord -Force
 NoDrives     : 128
PSPath       : Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
PSParentPath : Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer
PSChildName  : Advanced
PSDrive      : HKCU
Get-ADDomain | Select-Object -ExpandProperty DistinguishedName | Get-ADObject -Properties 'ms-DS-MachineAccountQuota' | Select-Object -ExpandProperty ms-DS-MachineAccountQuota
Get-ADDomain | Select-Object -ExpandProperty DistinguishedName | Get-ADObject -Properties 'ms-DS-MachineAccountQuota' | Select-Object -ExpandProperty ms-DS-MachineAccountQuota

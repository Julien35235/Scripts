#Récupérations des SID des utilisateurs
Get-WmiObject -Class win32_UserAccount | Format-Table Name,SID
(Get-WmiObject -Class win32_UserAccount -Filter "name='usertssr' and domain='$env:ComputerName'").SID
Get-CimInstance -Class win32_UserAccount | Format-Table Name,SID
Get-LocalUser | Select-Object Name, SID
Get-ADUser -Filter * | Select-Object Name, SID
wmic useraccount get name,sid
whoami /user
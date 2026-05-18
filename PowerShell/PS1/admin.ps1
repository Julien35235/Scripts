#Exécuter un script PowerShell en tant qu’administrateur
powershell.exe Start-Process powershell -Verb runAs
pwsh.exe -Command Start-Process pwsh -Verb runAs
Start-Process powershell -Verb runAs
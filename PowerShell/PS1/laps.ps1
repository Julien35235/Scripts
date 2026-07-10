#Installation de LAPS
Import-Module LAPS
Update-LapsADSchema -Verbose
#Rest MDP de Windows LAPS
Reset-LapsPassword
Get-LapsADPassword "PC-TSSR" -AsPlainText -IncludeHistory
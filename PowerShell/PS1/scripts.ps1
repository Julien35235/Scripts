Write-Output "bonjour $env:username nous somme le $(Get-Date)"
Write-Output "Votre ordinateur est $env:COMPUTERNAME, bienvenue sur le domaine $env:userDomain"
ipconfig  /all >  C:\Scripts\PS1\ip.txt
Get-NetAdapter -Name "*" -Physical > C:\Scripts\PS1\ip.txt
pause
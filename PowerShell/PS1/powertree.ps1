#Installation du Module de PowerTree
Install-Module -Name PowerTree -Scope CurrentUser
Get-Command -Module PowerTree
#Affichage de l'arborescence d'un répertoire spécifique
Show-PowerTree
Show-PowerTree -LiteralPath "C:\Windows\System32\WindowsPowerShell"
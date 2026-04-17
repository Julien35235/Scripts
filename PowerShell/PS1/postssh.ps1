#Installation du module Posh-SSH
Install-Module -Name Posh-SSH
$env:PSModulePath
#Pour lister les commandes intégrées au module Posh-SSH
Get-Command -Module Posh-SSH
# Pour obtenir de l'aide quant à l'utilisation d'une de ces commandes
help New-SSHSession
# Importation du module Posh-SSH
Import-Module Posh-SSH
# Pour créer une connexion SSH, on s'appuiera sur la commande "New-SSHSession"
#New-SSHSession -ComputerName "<ip>" -Port <port-ssh>


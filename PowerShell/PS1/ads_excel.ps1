#Manipuler des fichiers Excel avec PowerShell 
Install-Module -Name ImportExcel
#Install-Module -Name ImportExcel -Scope CurrentUser
Get-Command -Module ImportExcel
Get-ADUser -Filter * | Export-Excel -Path './AD-utilisateurs.xlsx'
Get-ADUser -Filter * | Export-Excel -Path './AD-utilisateurs.xlsx' -AutoSize -WorksheetName "Domaine ads.tssr.local"
Get-ADUser -Filter * | Select-Object SamAccountName,Enabled | Export-Excel -Path './AD-utilisateursBis.xlsx' -AutoSize -WorksheetName "Domaine ads.tssr.local"
#Installation du module de PSWriteHTML
Install-Module -Name PSWriteHTML
Get-Process | ConvertTo-Html | Out-File "C:\HTML\Rapport.html"
Get-Process | ConvertTo-Html -Title "Liste des processus" | Out-File "C:\HTML\Rapport2.html"
New-HTML -Title "Rapport PowerShell" -FilePath "C:\HTML\Rapport.html" {
    New-HTMLSection -HeaderText "Liste des processus" {
        New-HTMLTable -DataTable (Get-Process)
    }
}
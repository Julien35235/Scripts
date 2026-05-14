# Chemin de la clé de Registre à modifier
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"

# Modifier les valeurs avec les nouvelles informations
Set-ItemProperty -Path $regPath -Name EditionID -Value "EnterpriseS"
Set-ItemProperty -Path $regPath -Name ProductName -Value "Windows 10 Enterprise LTSC"
Set-ItemProperty -Path $regPath -Name ReleaseID -Value "21H2"
Set-ItemProperty -Path $regPath -Name DisplayVersion -Value "21H2"
Set-ItemProperty -Path $regPath -Name CurrentBuild -Value "19044"
Set-ItemProperty -Path $regPath -Name CurrentBuildNumber -Value "19044"

Write-Host "Modifications du registre effectuées. Ne redémarrez pas la machine avant d'avoir lancé l'installation." -ForegroundColor Green
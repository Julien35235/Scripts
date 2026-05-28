#Desinstallation de Copilot pour tous les utilisateurs
Get-AppxPackage -AllUsers -Name "Microsoft.Windows Ai.Copilot Provider" | Remove-AppxPackage
New-HTML -Title "Répartition des OS" -FilePath "C:\Scripts\HTML\RapportOS-2.html" -ShowHTML:$true {
    
    # En-tête du rapport avec le nom du domaine et la date
    New-HTMLHeader {
        New-HTMLSection -Invisible  {            
            New-HTMLPanel -Invisible {
                New-HTMLText -Text "Domaine : $($env:USERDNSDOMAIN)" -FontSize 18 -FontWeight 100
                New-HTMLText -Text "Date : $(Get-Date -Format "dd/MM/yyyy")" -FontSize 12
            } -AlignContentText left
        }
    }

    # Section 1 - Graphes
    New-HTMLSection -HeaderText "Distribution des OS dans Active Directory" -HeaderBackGroundColor "#00698e" {
        New-HTMLChart -Title "Répartition par OS" -Gradient {
            foreach ($Line in $ComputersOSName) {
                New-ChartDonut -Name  $Line.Name -Value $Line.Count
            }
        }
        New-HTMLChart -Title "Répartition Desktop / Server" -Gradient {
            foreach ($Line in $ComputersOSType) {
                New-ChartDonut -Name $Line.Name -Value $Line.Count
            }
        }
    }

    # Section 2 - Tableaux avec la liste des ordinateurs
    New-HTMLSection -HeaderText "Liste des machines inscrites dans l'Active Directory" -HeaderBackGroundColor "#00698e"  {
            New-HTMLPanel {
                New-HTMLTable -DataTable $ComputersOSDesktop -HideFooter -AutoSize
            }
            New-HTMLPanel {
                New-HTMLTable -Title "Liste des postes des serveurs" -DataTable $ComputersOSServer -HideFooter -AutoSize
            }
    }
}
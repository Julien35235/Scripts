# ================================
# RAPPORT DE LA DATE
# ================================

# Récupération de la date actuelle
$maDate = Get-Date

# Extraction des informations
$jourAnnee = $maDate.DayOfYear
$nomJour   = $maDate.ToString("dddd")
$annee     = $maDate.Year

# Calculs complémentaires
$joursRestants  = 365 - $jourAnnee
$anneeSuivante  = $annee + 1

# Affichage du rapport
Write-Host "---- RAPPORT DE LA DATE ----" -ForegroundColor Cyan
Write-Host "Aujourd'hui, nous sommes un $nomJour."
Write-Host "C'est le jour numéro $jourAnnee de l'année $annee."
Write-Host "Il reste environ $joursRestants jours avant $anneeSuivante." -ForegroundColor Yellow

# Pause du script
Pause
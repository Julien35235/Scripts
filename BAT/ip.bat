ECHO "BIENVENU mr. $env:USERNAME sous le domaine $env:USERDOMAIN "
$heure = Get-Date -Format "HH:mm:ss"
ECHO " l'heur c'est $heure "
repertoire = [system.Environment]: :GetFolderPath("'Desktop")
cd $repertoire
ipconfig /all > ip.txt
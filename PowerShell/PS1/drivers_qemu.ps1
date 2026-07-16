<#
.SYNOPSIS
    Désinstallation propre de VMware Tools + Installation VirtIO.
    Exécuter dans une console PowerShell en Administrateur.
#>

# Forcer TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ==========================================
# ETAPE 1 : Désinstallation de VMware Tools
# ==========================================
Write-Host "[*] Phase 1 : Recherche et désinstallation de VMware Tools..." -ForegroundColor Cyan

# Chemins de registre pour chercher les logiciels installés
$regPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$vmwareProduct = Get-ItemProperty $regPaths -ErrorAction SilentlyContinue | 
                 Where-Object { $_.DisplayName -like "*VMware Tools*" }

if ($vmwareProduct) {
    $localCode = $vmwareProduct.PSChildName
    Write-Host "[+] VMware Tools trouvé (Code: $localCode). Désinstallation silencieuse en cours..." -ForegroundColor Yellow
    
    # Commande MSIEXEC pour désinstaller sans interface (/qn) et sans forcer le reboot immédiat (/norestart)
    $uninstallProcess = Start-Process msiexec.exe -ArgumentList "/x $localCode /qn /norestart" -Wait -PassThru
    
    if ($uninstallProcess.ExitCode -eq 0 -or $uninstallProcess.ExitCode -eq 3010) {
        Write-Host "[+] VMware Tools a été désinstallé avec succès." -ForegroundColor Green
    } else {
        Write-Host "[-] Échec ou avertissement lors de la désinstallation (Code de sortie: $($uninstallProcess.ExitCode))." -ForegroundColor Red
    }
} else {
    Write-Host "[*] VMware Tools n'a pas été détecté sur ce système." -ForegroundColor Gray
}

# ==========================================
# ETAPE 2 : Installation des Drivers VirtIO
# ==========================================
Write-Host "`n[*] Phase 2 : Téléchargement et installation de VirtIO..." -ForegroundColor Cyan

$isoUrl = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
$tempIsoPath = "$env:TEMP\virtio-win.iso"

Write-Host "[*] Téléchargement de l'ISO stable..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $isoUrl -OutFile $tempIsoPath

Write-Host "[*] Montage de l'ISO..." -ForegroundColor Cyan
$mountResult = Mount-DiskImage -ImagePath $tempIsoPath -PassThru
$driveLetter = ($mountResult | Get-Volume).DriveLetter

if (-not $driveLetter) {
    Write-Error "[-] Impossible de monter l'image ISO."
    exit 1
}

$drivePath = "${driveLetter}:"

# Injection globale des drivers .inf
Write-Host "[*] Injection des pilotes VirtIO (.inf)..." -ForegroundColor Cyan
pnputil.exe /add-driver "$drivePath\*.inf" /subdirs /install

# Choix de l'architecture pour les MSI
$osType = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
if ($osType -like "*64*") {
    $guestAgentInstaller = "$drivePath\guest-agent\qemu-ga-x86_64.msi"
    $virtioInstaller = "$drivePath\virtio-win-gt-x64.msi"
} else {
    $guestAgentInstaller = "$drivePath\guest-agent\qemu-ga-i386.msi"
    $virtioInstaller = "$drivePath\virtio-win-gt-x86.msi"
}

# Installation des MSI (Agent + Services)
if (Test-Path $guestAgentInstaller) {
    Write-Host "[*] Installation du QEMU Guest Agent..." -ForegroundColor Cyan
    Start-Process msiexec.exe -ArgumentList "/i `"$guestAgentInstaller`" /qn /norestart" -Wait
}
if (Test-Path $virtioInstaller) {
    Write-Host "[*] Installation des services additionnels VirtIO..." -ForegroundColor Cyan
    Start-Process msiexec.exe -ArgumentList "/i `"$virtioInstaller`" /qn /norestart" -Wait
}

# ==========================================
# ETAPE 3 : Nettoyage final
# ==========================================
Write-Host "[*] Démontage de l'ISO et nettoyage..." -ForegroundColor Cyan
Dismount-DiskImage -ImagePath $tempIsoPath
Remove-Item -Path $tempIsoPath -Force

Write-Host "`n[+] Opération terminée !" -ForegroundColor Green
Write-Host Un REDÉMARRAGE complet de la VM est fortement recommandé pour appliquer les changements." -ForegroundColor Yellow
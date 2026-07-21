#!/bin/bash

# ==============================================================================
# Rapport HTML Proxmox VE Avancé (Mise en forme originale Script 1)
# Compatible Proxmox VE 7 / 8 / 9
# ==============================================================================

OUTPUT="/root/proxmox-report.html"

DATE=$(date '+%d/%m/%Y %H:%M:%S')
HOST=$(hostname)

# ==========
# HTML HEADER (STYLE DU SCRIPT 1)
# ==========

cat <<EOF > "$OUTPUT"
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>Rapport Proxmox VE</title>

<style>

body{
    background:#f5f7fa;
    font-family:Arial, Helvetica, sans-serif;
    margin:20px;
    color:#333;
}

h1{
    background:#e57000;
    color:white;
    padding:15px;
    border-radius:8px;
}

h2{
    background:#2d3436;
    color:white;
    padding:10px;
    border-radius:5px;
    margin-top:30px;
}

.card{
    background:white;
    padding:15px;
    border-radius:8px;
    box-shadow:0 2px 5px rgba(0,0,0,0.1);
    margin-bottom:20px;
}

pre{
    white-space:pre-wrap;
    word-wrap:break-word;
    font-size:14px;
}

.info{
    display:flex;
    gap:20px;
    flex-wrap:wrap;
}

.box{
    background:#ffffff;
    border-left:5px solid #e57000;
    padding:10px;
    border-radius:5px;
    min-width:220px;
    box-shadow:0 1px 3px rgba(0,0,0,0.1);
}

footer{
    margin-top:40px;
    font-size:12px;
    color:#777;
}

</style>

</head>
<body>

<h1>Rapport Proxmox VE</h1>

<div class="info">

<div class="box">
<b>Serveur :</b><br>
$HOST
</div>

<div class="box">
<b>Date :</b><br>
$DATE
</div>

<div class="box">
<b>Kernel :</b><br>
$(uname -r)
</div>

<div class="box">
<b>Version PVE :</b><br>
$(pveversion 2>/dev/null || echo "N/A")
</div>

</div>

EOF

# ==========
# FONCTION
# ==========

add_section() {

    TITLE="$1"
    CMD="$2"

    echo "<div class=\"card\">" >> "$OUTPUT"
    echo "<h2>$TITLE</h2>" >> "$OUTPUT"
    echo "<pre>" >> "$OUTPUT"

    eval "$CMD" >> "$OUTPUT" 2>&1

    echo "</pre>" >> "$OUTPUT"
    echo "</div>" >> "$OUTPUT"
}

# ==========
# SYSTEME ET RESSOURCES
# ==========

add_section "Uptime et charge système" "
uptime
"

add_section "Mémoire RAM et Swap" "
free -h
"

add_section "Utilisation de l'espace disque" "
df -h -x devtmpfs -x tmpfs
"

# ==========
# PROXMOX & VIRTUALISATION
# ==========

add_section "Version Proxmox VE" "
pveversion
"

add_section "Statut des Pools de Stockage Proxmox" "
pvesm status
"

if pvecm status >/dev/null 2>&1; then
    add_section "Cluster Proxmox" "
    pvecm status
    "
fi

add_section "Machines Virtuelles (QEMU/KVM)" "
qm list
"

add_section "Conteneurs LXC" "
pct list
"

# ==========
# IMAGES ISO ET TEMPLATES LXC (LOCAL)
# ==========

add_section "Images ISO disponibles (local)" "
pvesm list local --content iso 2>/dev/null || echo 'Aucune image ISO trouvée dans local'
"

add_section "Templates de conteneurs LXC (local)" "
pvesm list local --content vztmpl 2>/dev/null || echo 'Aucun template LXC trouvé dans local'
"

get_all_snapshots() {
    echo "--- SNAPSHOTS MACHINES VIRTUELLES (VM) ---"
    for vmid in $(qm list 2>/dev/null | awk 'NR>1 {print $1}'); do
        echo -e "\n[ VM ID : $vmid ]"
        qm listsnapshot "$vmid" 2>&1
    done

    echo -e "\n--- SNAPSHOTS CONTENEURS (LXC) ---"
    for ctid in $(pct list 2>/dev/null | awk 'NR>1 {print $1}'); do
        echo -e "\n[ LXC ID : $ctid ]"
        pct listsnapshot "$ctid" 2>&1
    done
}

add_section "Snapshots (VMs & LXC)" "
get_all_snapshots
"

# ==========
# MATERIEL, TEMPERATURES & CONSOMMATION
# ==========

get_cpu_power() {
    local rapl_file="/sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj"
    if [ -f "$rapl_file" ]; then
        local e1=$(cat "$rapl_file")
        sleep 1
        local e2=$(cat "$rapl_file")
        awk -v e1="$e1" -v e2="$e2" 'BEGIN { printf "Puissance instantanée du CPU (Package 0) : %.2f Watts\n", (e2 - e1) / 1000000 }'
    else
        echo "Intel RAPL non disponible ou non supporté sur ce processeur."
    fi
}

add_section "Consommation électrique CPU" "
get_cpu_power
"

if command -v sensors >/dev/null 2>&1; then
    add_section "Températures système (lm-sensors)" "
    sensors
    "
fi

get_disks_health() {
    echo "--- DISQUES NVMe ---"
    for dev in /dev/nvme?n1; do
        if [ -e "$dev" ]; then
            echo -e "\n=== Disque : $dev ==="
            if command -v nvme >/dev/null 2>&1; then
                nvme smart-log "$dev" | grep -Ei "temperature|critical_warning|percentage_used"
            else
                smartctl -A "$dev" 2>/dev/null | grep -Ei "temperature|critical"
            fi
        fi
    done

    echo -e "\n--- DISQUES SATA / SAS (HDD & SSD) ---"
    for dev in /dev/sd[a-z]; do
        if [ -e "$dev" ]; then
            echo -n "$dev : "
            local temp=$(smartctl -A "$dev" 2>/dev/null | awk '/Temperature_Celsius|Airflow_Temperature/ {print $10}')
            local health=$(smartctl -H "$dev" 2>/dev/null | grep -i "result" | awk -F: '{print $2}')

            [ -z "$temp" ] && temp="N/A"
            [ -z "$health" ] && health="Inconnu"

            echo "Température = ${temp}°C | Santé SMART =$health"
        fi
    done
}

add_section "État et Températures des Disques" "
get_disks_health
"

# ==========
# RESEAU ET SERVICES
# ==========

add_section "Interfaces réseau" "
ip -br addr
"

add_section "Services Proxmox & Corosync" "
systemctl list-units --type=service --state=running | grep -E 'pve|corosync'
"

# ==========
# FIN HTML
# ==========

cat <<EOF >> "$OUTPUT"

<footer>
Rapport généré automatiquement par Proxmox VE
</footer>

</body>
</html>
EOF

# ==========
# END
# ==========

echo ""
echo "========================================="
echo " Rapport généré avec succès"
echo "========================================="
echo ""
echo "Fichier : $OUTPUT"
echo ""
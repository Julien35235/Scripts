=========================================
 Rapport généré avec succès
=========================================

Fichier : /root/proxmox-report.html

#!/bin/bash

#
# Rapport HTML Proxmox VE avancé
# Compatible Proxmox VE 7 / 8
# Ajouts :
# - Températures NVMe
# - Snapshots VM
# - Consommation électrique CPU
#

OUTPUT="/root/proxmox-report.html"

DATE=$(date '+%d/%m/%Y %H:%M:%S')
HOST=$(hostname)

# ==========
# HTML HEADER
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

</div>

EOF

# ==========
# FUNCTION
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
# SYSTEM
# ==========

add_section "Informations système" "
hostnamectl
"

add_section "Uptime et charge système" "
uptime
"

add_section "CPU" "
lscpu
"

add_section "Mémoire RAM" "
free -h
"

# ==========
# NETWORK
# ==========

add_section "Interfaces réseau" "
ip -br addr
"

add_section "Bridges Proxmox" "
bridge link
"

# ==========
# PROXMOX
# ==========

add_section "Version Proxmox VE" "
pveversion
"

add_section "Cluster Proxmox" "
pvecm status
"

add_section "Machines Virtuelles (QEMU/KVM)" "
qm list
"

add_section "Containers LXC" "
pct list
"

# ==========
# SNAPSHOTS VM
# ==========

SNAPSHOT_FILE="/tmp/proxmox_snapshots.txt"

echo "" > "$SNAPSHOT_FILE"

for VMID in $(qm list | awk 'NR>1 {print $1}'); do
    echo "===== VM ID : $VMID =====" >> "$SNAPSHOT_FILE"
    qm listsnapshot "$VMID" >> "$SNAPSHOT_FILE" 2>&1
    echo "" >> "$SNAPSHOT_FILE"
done

add_section "Snapshots des Machines Virtuelles" "
cat $SNAPSHOT_FILE
"

# ==========
# SERVICES
# ==========

add_section "Services Proxmox" "
systemctl --no-pager --type=service | grep -E 'pve|corosync'
"

# ==========
# TEMPERATURES SYSTEME
# ==========

if command -v sensors >/dev/null 2>&1; then

add_section "Températures système" "
sensors
"

fi

# ==========
# TEMPERATURES NVME
# ==========

NVME_TEMP="/tmp/nvme_temp.txt"

echo "" > "$NVME_TEMP"

if command -v nvme >/dev/null 2>&1; then

for DEV in /dev/nvme*n1; do

    if [ -e "$DEV" ]; then

        echo "===== $DEV =====" >> "$NVME_TEMP"

        nvme smart-log "$DEV" | grep -Ei "temperature|critical_warning" >> "$NVME_TEMP"

        echo "" >> "$NVME_TEMP"

    fi

done

add_section "Températures NVMe" "
cat $NVME_TEMP
"

fi

# ==========
# CONSOMMATION ELECTRIQUE CPU
# ==========

POWER_FILE="/tmp/power_usage.txt"

echo "" > "$POWER_FILE"

if command -d /sys/class/powercap/intel-rapl; then

echo "Consommation électrique Intel RAPL :" >> "$POWER_FILE"

find /sys/class/powercap/intel-rapl/ -name energy_uj | while read RAPL; do

    NAME=$(dirname "$RAPL")

    ENERGY=$(cat "$RAPL")

    echo "$NAME : $ENERGY µJ" >> "$POWER_FILE"

done

else

echo "Intel RAPL non disponible sur ce serveur." >> "$POWER_FILE"

fi

add_section "Consommation électrique CPU" "
cat $POWER_FILE
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
# CLEAN
# ==========

rm -f /tmp/proxmox_snapshots.txt
rm -f /tmp/nvme_temp.txt
rm -f /tmp/power_usage.txt

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

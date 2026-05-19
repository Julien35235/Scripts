#!/bin/sh

# =========================================================
# Rapport Système OPNsense en HTML
# Auteur : Julien Despagne
# Version : OPNsense / FreeBSD
# Description :
# Génère un rapport HTML complet du firewall OPNsense
# =========================================================

OUTPUT="/root/rapport_opnsense.html"

# =========================================================
# Informations générales
# =========================================================

DATE=$(date "+%d/%m/%Y %H:%M:%S")
HOSTNAME=$(hostname)
OS=$(cat /etc/version 2>/dev/null)
FIRMWARE=$(opnsense-version 2>/dev/null)
KERNEL=$(uname -r)

UPTIME=$(uptime | sed 's/.*up \([^,]*\), .*/\1/')

IP=$(ifconfig \
| grep "inet " \
| grep -v 127.0.0.1 \
| head -1 \
| awk '{print $2}')

CPU=$(sysctl -n hw.model 2>/dev/null)

CPU_USAGE=$(top -aSH -d1 | grep "CPU:" | head -1)

RAM_TOTAL=$(sysctl -n hw.physmem 2>/dev/null \
| awk '{printf "%.2f GB", $1/1024/1024/1024}')

RAM_USAGE=$(top -aSH -d1 | grep "Mem:" | head -1)

DISK_USAGE=$(df -h /)

# =========================================================
# Interfaces réseau détaillées
# =========================================================

INTERFACES=$(ifconfig | awk '

/^[a-zA-Z0-9]/ {
    iface=$1
    sub(":", "", iface)
    print "========================================"
    print "Interface : " iface
}

/inet / && $2 != "127.0.0.1" {
    print "IPv4      : " $2
}

/inet6 / {
    print "IPv6      : " $2
}

/ether / {
    print "MAC       : " $2
}

/status: / {
    print "Status    : " $2
}

')

# =========================================================
# Services
# =========================================================

SERVICES=$(service -e)

# =========================================================
# VPN
# =========================================================

# OpenVPN
OPENVPN=$(ps aux | grep openvpn | grep -v grep)

[ -z "$OPENVPN" ] && OPENVPN="Aucun processus OpenVPN détecté"

# IPSec
IPSEC=$(ps aux | grep charon | grep -v grep)

[ -z "$IPSEC" ] && IPSEC="Aucun tunnel IPSec détecté"

# WireGuard
if command -v wg >/dev/null 2>&1; then
    WIREGUARD=$(wg show 2>/dev/null)
else
    WIREGUARD=$(ifconfig | awk '/^wg/ {print $1}' | while read i; do
        echo "========== $i =========="
        ifconfig $i
        echo
    done)
fi

[ -z "$WIREGUARD" ] && WIREGUARD="Aucun tunnel WireGuard détecté"

# =========================================================
# Firewall PF
# =========================================================

PF_INFO=$(pfctl -si 2>/dev/null)

PF_RULES=$(pfctl -sr 2>/dev/null | head -100)

PF_STATES=$(pfctl -s state 2>/dev/null | head -50)

# =========================================================
# Gateways
# =========================================================

GATEWAYS=$(route -n get default 2>/dev/null)

# =========================================================
# Certificats
# =========================================================

CERTS=$(grep "<descr>" /conf/config.xml 2>/dev/null \
| sed 's/<[^>]*>//g' \
| sort \
| uniq)

[ -z "$CERTS" ] && CERTS="Aucun certificat détecté"

# =========================================================
# Mises à jour
# =========================================================

UPDATES=$(pkg upgrade -n 2>/dev/null)

[ -z "$UPDATES" ] && UPDATES="Aucune mise à jour disponible"

# =========================================================
# Utilisation disque / mémoire
# =========================================================

DISKS=$(df -h)

MEMORY=$(top -aSH -d1 | head -15)

# =========================================================
# Top Processus
# =========================================================

TOP_CPU=$(ps aux | sort -rk 3 | head -10)

TOP_RAM=$(ps aux | sort -rk 4 | head -10)

# =========================================================
# Température CPU
# =========================================================

TEMP=$(sysctl dev.cpu 2>/dev/null | grep temperature)

[ -z "$TEMP" ] && TEMP="Température non disponible"

# =========================================================
# Génération HTML
# =========================================================

cat <<EOF > $OUTPUT

<!DOCTYPE html>
<html lang="fr">

<head>

<meta charset="UTF-8">

<title>Rapport OPNsense</title>

<style>

body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 20px;
    color: #333;
}

h1 {
    background: #d32f2f;
    color: white;
    padding: 15px;
    border-radius: 10px;
}

h2 {
    color: #d32f2f;
    border-bottom: 2px solid #d32f2f;
    padding-bottom: 5px;
}

.section {
    background: white;
    padding: 15px;
    margin-bottom: 20px;
    border-radius: 10px;
    box-shadow: 0px 2px 5px rgba(0,0,0,0.1);
}

table {
    width: 100%;
    border-collapse: collapse;
}

table, th, td {
    border: 1px solid #ccc;
}

th {
    background: #d32f2f;
    color: white;
    padding: 10px;
}

td {
    padding: 8px;
}

pre {
    background: #eeeeee;
    padding: 10px;
    overflow-x: auto;
    border-radius: 5px;
    font-size: 12px;
}

.footer {
    text-align: center;
    margin-top: 20px;
    color: #777;
}

</style>

</head>

<body>

<h1>Rapport Firewall OPNsense</h1>

<div class="section">

<h2>Informations Système</h2>

<table>

<tr>
<th>Élément</th>
<th>Valeur</th>
</tr>

<tr>
<td>Nom d'hôte</td>
<td>$HOSTNAME</td>
</tr>

<tr>
<td>Version OPNsense</td>
<td>$FIRMWARE</td>
</tr>

<tr>
<td>Système</td>
<td>$OS</td>
</tr>

<tr>
<td>Kernel</td>
<td>$KERNEL</td>
</tr>

<tr>
<td>Uptime</td>
<td>$UPTIME</td>
</tr>

<tr>
<td>Adresse IP</td>
<td>$IP</td>
</tr>

<tr>
<td>CPU</td>
<td>$CPU</td>
</tr>

<tr>
<td>Charge CPU</td>
<td><pre>$CPU_USAGE</pre></td>
</tr>

<tr>
<td>RAM Totale</td>
<td>$RAM_TOTAL</td>
</tr>

<tr>
<td>RAM Utilisation</td>
<td><pre>$RAM_USAGE</pre></td>
</tr>

<tr>
<td>Température CPU</td>
<td><pre>$TEMP</pre></td>
</tr>

<tr>
<td>Stockage</td>
<td><pre>$DISK_USAGE</pre></td>
</tr>

<tr>
<td>Date du rapport</td>
<td>$DATE</td>
</tr>

</table>

</div>

<div class="section">
<h2>Interfaces Réseau</h2>
<pre>$INTERFACES</pre>
</div>

<div class="section">
<h2>Services Actifs</h2>
<pre>$SERVICES</pre>
</div>

<div class="section">
<h2>Gateways</h2>
<pre>$GATEWAYS</pre>
</div>

<div class="section">
<h2>VPN - OpenVPN</h2>
<pre>$OPENVPN</pre>
</div>

<div class="section">
<h2>VPN - IPSec</h2>
<pre>$IPSEC</pre>
</div>

<div class="section">
<h2>VPN - WireGuard</h2>
<pre>$WIREGUARD</pre>
</div>

<div class="section">
<h2>Informations PF Firewall</h2>
<pre>$PF_INFO</pre>
</div>

<div class="section">
<h2>Règles Firewall PF</h2>
<pre>$PF_RULES</pre>
</div>

<div class="section">
<h2>États Firewall PF</h2>
<pre>$PF_STATES</pre>
</div>

<div class="section">
<h2>Certificats</h2>
<pre>$CERTS</pre>
</div>

<div class="section">
<h2>Mises à jour disponibles</h2>
<pre>$UPDATES</pre>
</div>

<div class="section">
<h2>Utilisation des disques</h2>
<pre>$DISKS</pre>
</div>

<div class="section">
<h2>Utilisation mémoire</h2>
<pre>$MEMORY</pre>
</div>

<div class="section">
<h2>Top Processus CPU</h2>
<pre>$TOP_CPU</pre>
</div>

<div class="section">
<h2>Top Processus RAM</h2>
<pre>$TOP_RAM</pre>
</div>

<div class="footer">
Rapport généré automatiquement le $DATE
</div>

</body>
</html>

EOF

echo "====================================="
echo " Rapport généré : $OUTPUT"
echo "====================================="

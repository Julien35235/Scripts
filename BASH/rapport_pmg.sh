#!/bin/bash

REPORT_DIR="/root/pmg-report"
REPORT_FILE="$REPORT_DIR/index.html"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
HOST=$(hostname)

mkdir -p $REPORT_DIR

# Récupération des données
UPTIME=$(uptime -p)
LOAD=$(uptime | awk -F'load average:' '{ print $2 }')

MEMORY=$(free -h)

DISK=$(df -h /)

SERVICES=$(systemctl status pmg-smtp-filter postfix clamav-daemon pmgdaemon 2>/dev/null)

QUEUE=$(postqueue -p 2>/dev/null)

NETWORK=$(ip addr show)

# Statistiques PMG
SPAM=$(grep -i "spam" /var/log/mail.log | tail -20)
VIRUS=$(grep -i "virus" /var/log/mail.log | tail -20)

# Génération HTML
cat <<EOF > $REPORT_FILE
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>Rapport Proxmox Mail Gateway</title>
<style>
body {
    font-family: Arial, sans-serif;
    background: #f5f5f5;
    margin: 20px;
}
.container {
    background: white;
    padding: 20px;
    border-radius: 10px;
}
h1 {
    color: #e57000;
}
pre {
    background: #222;
    color: #0f0;
    padding: 10px;
    overflow-x: auto;
}
.section {
    margin-bottom: 30px;
}
</style>
</head>
<body>
<div class="container">

<h1>Rapport Proxmox Mail Gateway</h1>
<p><strong>Serveur :</strong> $HOST</p>
<p><strong>Date :</strong> $DATE</p>

<div class="section">
<h2>Uptime</h2>
<pre>$UPTIME</pre>
</div>

<div class="section">
<h2>Charge système</h2>
<pre>$LOAD</pre>
</div>

<div class="section">
<h2>Mémoire</h2>
<pre>$MEMORY</pre>
</div>

<div class="section">
<h2>Disque</h2>
<pre>$DISK</pre>
</div>

<div class="section">
<h2>Services PMG</h2>
<pre>$SERVICES</pre>
</div>

<div class="section">
<h2>File Postfix</h2>
<pre>$QUEUE</pre>
</div>

<div class="section">
<h2>Réseau</h2>
<pre>$NETWORK</pre>
</div>

<div class="section">
<h2>Derniers SPAM détectés</h2>
<pre>$SPAM</pre>
</div>

<div class="section">
<h2>Derniers VIRUS détectés</h2>
<pre>$VIRUS</pre>
</div>

</div>
</body>
</html>
EOF

echo "Rapport généré : $REPORT_FILE"
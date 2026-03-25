#!/bin/bash

LOGFILE="/var/log/join_ad_linux.log"
DOMAIN="ads.tssr.local"
AD_USER="Administrateur@ads.tssr.local"

echo "===== Début du script d'intégration AD =====" | tee -a "$LOGFILE"
date | tee -a "$LOGFILE"

#############################################
# 1) Configuration DNS dans /etc/resolv.conf
#############################################

echo "[INFO] Mise à jour de /etc/resolv.conf ..." | tee -a "$LOGFILE"

# Sauvegarde
cp /etc/resolv.conf /etc/resolv.conf.bak

# Modification via sed
sed -i 's/^nameserver .*/nameserver 192.168.0.1/' /etc/resolv.conf
grep -q "search $DOMAIN" /etc/resolv.conf || echo "search $DOMAIN" >> /etc/resolv.conf

echo "[OK] resolv.conf mis à jour :" | tee -a "$LOGFILE"
cat /etc/resolv.conf | tee -a "$LOGFILE"


#############################################
# 2) Installation des paquets requis
#############################################

echo "[INFO] Installation des paquets nécessaires..." | tee -a "$LOGFILE"

apt update 2>&1 | tee -a "$LOGFILE"
apt install -y \
    packagekit samba-common-bin sssd-tools sssd \
    libnss-sss libpam-sss polkitd pkexec \
    ntpsec-ntpdate ntpsec realmd oddjob oddjob-mkhomedir \
    2>&1 | tee -a "$LOGFILE"

if [ $? -ne 0 ]; then
    echo "[ERREUR] L'installation des paquets a échoué." | tee -a "$LOGFILE"
    exit 1
fi

echo "[OK] Paquets installés." | tee -a "$LOGFILE"


#############################################
# 3) Découverte du domaine
#############################################

echo "[INFO] Découverte du domaine AD..." | tee -a "$LOGFILE"
realm discover "$DOMAIN" 2>&1 | tee -a "$LOGFILE"

if [ $? -ne 0 ]; then
    echo "[ERREUR] Aucun domaine détecté." | tee -a "$LOGFILE"
    exit 2
fi


#############################################
# 4) Join du domaine AD
#############################################

echo "[INFO] Tentative de join au domaine..." | tee -a "$LOGFILE"

echo "[ACTION REQUISE] Mot de passe pour $AD_USER :" | tee -a "$LOGFILE"

realm join --user="$AD_USER" "$DOMAIN" 2>&1 | tee -a "$LOGFILE"

if [ $? -ne 0 ]; then
    echo "[ERREUR] Échec du join au domaine." | tee -a "$LOGFILE"
    exit 3
fi

echo "[OK] La machine a rejoint le domaine AD." | tee -a "$LOGFILE"


#############################################
# 5) Fin
#############################################

echo "===== Script terminé avec succès =====" | tee -a "$LOGFILE"
date | tee -a "$LOGFILE"
exit 0
#!/bin/bash

LOGFILE="/var/log/rpi-upgrade-to-trixie.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "=============================================="
echo "  UPGRADE RASPBERRY PI : DEBIAN 12 → DEBIAN 13"
echo "  Log : $LOGFILE"
echo "=============================================="
sleep 2

#############################################
# 1. Vérification de la version existante
#############################################
if ! grep -qi "bookworm" /etc/os-release; then
    echo "ERREUR : Ce système n'est pas Debian 12 Bookworm."
    exit 1
fi
echo "[OK] Système Bookworm détecté."

#############################################
# 2. Mise à jour préalable
#############################################
echo "== Mise à jour initiale du système =="
sudo apt update
sudo apt full-upgrade -y

#############################################
# 3. Sauvegarde des sources
#############################################
echo "== Sauvegarde des fichiers de dépôts APT =="
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo cp -r /etc/apt/sources.list.d /etc/apt/sources.list.d.bak

#############################################
# 4. Remplacement bookworm → trixie
#############################################
echo "== Modification des dépôts vers Trixie =="

sudo sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
sudo sed -i 's/bookworm/trixie/g' /etc/apt/sources.list.d/*.list 2>/dev/null

#############################################
# 5. Mise à jour des index
#############################################
echo "== Mise à jour APT =="
sudo apt update

#############################################
# 6. Mise à niveau complète
#############################################
echo "== Mise à niveau complète vers Debian 13 =="

sudo apt full-upgrade -y \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confnew" \
  --purge --auto-remove rpd-wayland-all+ rpd-x-all+

#############################################
# 7. Nettoyage
#############################################
echo "== Nettoyage des paquets inutiles =="
sudo apt autoremove -y
sudo apt clean -y

#############################################
# 8. Fin et reboot
#############################################
echo "=============================================="
echo "  Mise à niveau terminée avec succès."
echo "  Redémarrage dans 5 secondes..."
echo "=============================================="
sleep 5
sudo reboot
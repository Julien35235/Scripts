#!/bin/bash

set -e

# ====================================
# CONFIGURATION
# ====================================

OPNSENSE_HOST="192.168.1.1"
OPNSENSE_USER="root"

NETWORK_SHARE="//192.168.1.10/Backups"
MOUNT_POINT="/mnt/opnsense-backup"

CREDENTIALS="/root/.smbcredentials"

BACKUP_FOLDER="$MOUNT_POINT/opnsense"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

TMP_DIR="/tmp/opnsense-$DATE"

LOGFILE="/var/log/opnsense-backup.log"

# ====================================
# LOGGING
# ====================================

exec >> "$LOGFILE" 2>&1

echo "===================================="
echo "Backup started : $(date)"
echo "===================================="

# ====================================
# MOUNT NETWORK SHARE
# ====================================

if ! mountpoint -q "$MOUNT_POINT"; then
    echo "[+] Mounting network share..."

    mount -t cifs "$NETWORK_SHARE" "$MOUNT_POINT" \
        -o credentials="$CREDENTIALS",iocharset=utf8,vers=3.0
fi

# ====================================
# CREATE DIRECTORIES
# ====================================

mkdir -p "$BACKUP_FOLDER"
mkdir -p "$TMP_DIR"

# ====================================
# DOWNLOAD CONFIG
# ====================================

echo "[+] Downloading config.xml"

scp ${OPNSENSE_USER}@${OPNSENSE_HOST}:/conf/config.xml \
    "$TMP_DIR/config.xml"

# ====================================
# SYSTEM INFOS
# ====================================

echo "[+] Exporting system infos"

ssh ${OPNSENSE_USER}@${OPNSENSE_HOST} "uname -a" \
    > "$TMP_DIR/system.txt"

ssh ${OPNSENSE_USER}@${OPNSENSE_HOST} "pkg info" \
    > "$TMP_DIR/packages.txt"

ssh ${OPNSENSE_USER}@${OPNSENSE_HOST} "ifconfig" \
    > "$TMP_DIR/network.txt"

# ====================================
# CREATE ARCHIVE
# ====================================

ARCHIVE="opnsense-backup-$DATE.tar.gz"

echo "[+] Creating archive"

tar -czf "$BACKUP_FOLDER/$ARCHIVE" -C "$TMP_DIR" .

# ====================================
# CLEANUP
# ====================================

rm -rf "$TMP_DIR"

# ====================================
# DELETE OLD BACKUPS
# ====================================

echo "[+] Removing backups older than 30 days"

find "$BACKUP_FOLDER" -name "*.tar.gz" -mtime +30 -delete

# ====================================
# FINISHED
# ====================================

echo "[+] Backup completed :"
echo "$BACKUP_FOLDER/$ARCHIVE"

echo "Finished : $(date)"
echo ""
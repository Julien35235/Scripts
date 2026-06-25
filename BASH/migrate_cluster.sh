#!/bin/bash

# ==============================================================================
# CONFIGURATION
# ==============================================================================
TARGET_NODE="pve3"      # Le gros serveur de destination
TARGET_STORAGE="VMS2"    # Votre pool RAID ZFS cible sur pve3

# Couleurs pour l'affichage
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}=== CENTRALISATION DES VMS DU CLUSTER VERS $TARGET_NODE ===${NC}"
echo -e "${BLUE}============================================================${NC}\n"

# Extraction propre des données en JSON pour éviter les caractères graphiques "│"
pvesh get /cluster/resources --type vm --output-format json | tr -d '\n' | sed 's/},{/\n/g' | while read -r line; do

    # Extraction des variables depuis la ligne JSON
    vmid=$(echo "$line" | grep -o '"vmid":[0-9]*' | cut -d':' -f2)
    source_node=$(echo "$line" | grep -o '"node":"[^"]*' | cut -d'"' -f4)
    status=$(echo "$line" | grep -o '"status":"[^"]*' | cut -d'"' -f4)

    # Si la VM est déjà sur la cible, ou si les données sont incomplètes, on passe à la suivante
    if [ -z "$vmid" ] || [ -z "$source_node" ] || [ "$source_node" = "$TARGET_NODE" ]; then
        continue
    fi

    echo -e "\n${YELLOW}------------------------------------------------------------${NC}"
    echo -e "${YELLOW}[*] VM ID: $vmid | Située sur: $source_node | Statut: $status${NC}"
    echo -e "${YELLOW}------------------------------------------------------------${NC}"

    was_running=false

    # 1. Gestion de l'arrêt propre si la machine est allumée
    if [ "$status" = "running" ]; then
        echo -e "[+] La VM est allumée. Envoi du signal d'arrêt propre..."
        was_running=true

        pvesh create /nodes/$source_node/qemu/$vmid/status/shutdown >/dev/null 2>&1

        echo -n "[+] Attente de l'extinction complète "
        for i in {1..36}; do
            current_status=$(pvesh get /nodes/$source_node/qemu/$vmid/status/current --output-format json | grep -o '"status":"[^"]*' | cut -d'"' -f4)
            if [ "$current_status" != "running" ]; then
                echo -e "\n[+] Machine éteinte proprement."
                break
            fi
            echo -n "."
            sleep 5
        done

        current_status=$(pvesh get /nodes/$source_node/qemu/$vmid/status/current --output-format json | grep -o '"status":"[^"]*' | cut -d'"' -f4)
        if [ "$current_status" = "running" ]; then
            echo -e "\n${RED}[!] L'OS ne répond pas. Arrêt forcé en cours...${NC}"
            ssh -o StrictHostKeyChecking=no root@$source_node "qm stop $vmid" >/dev/null 2>&1
            sleep 2
        fi
    fi

    # 2. Déclenchement de la migration trans-nœud avec conversion du stockage vers le ZFS
    echo -e "[+] Migration du disque (LVM-Thin -> ZFS) et transfert vers $TARGET_NODE..."

    if ssh -o StrictHostKeyChecking=no root@$source_node "qm migrate $vmid $TARGET_NODE --targetstorage $TARGET_STORAGE --online 0"; then
        echo -e "${GREEN}[✔] Succès ! La VM $vmid est maintenant sur $TARGET_NODE.${NC}"

        # 3. Relance automatique de la machine sur pve3 si elle était active au départ
        if [ "$was_running" = true ]; then
            echo -e "[+] Relance automatique de la VM sur le RAID ZFS de $TARGET_NODE..."
            pvesh create /nodes/$TARGET_NODE/qemu/$vmid/status/start >/dev/null 2>&1
        fi
    else
        echo -e "${RED}[✘] ÉCHEC critique lors de la migration de la VM $vmid depuis $source_node.${NC}"
    fi
done

echo -e "\n${GREEN}============================================================${NC}"
echo -e "${GREEN}===        TOUTES LES OPÉRATIONS SONT TERMINÉES          ===${NC}"
echo -e "${GREEN}============================================================${NC}"
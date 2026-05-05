#!/bin/bash
#Recuperation de URL
BASE_URL="https://www.fullcirclemag.fr/dotclear/public/Numeros"
DEST_DIR="FullCircle_Magazines_FR"

mkdir -p "$DEST_DIR"
cd "$DEST_DIR" || exit 1

wget \
  --recursive \
  --no-parent \
  --no-directories \
  --accept pdf \
  --level=1 \
  --wait=1 \
  --random-wait \
  --user-agent="Mozilla/5.0" \
  "$BASE_URL/"

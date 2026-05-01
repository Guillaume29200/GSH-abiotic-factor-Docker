#!/usr/bin/env bash
set -euo pipefail

SERVER_DIR="/opt/games/server"
CONFIG_ROOT="/opt/games/config"

SAVED_DIR="${SERVER_DIR}/AbioticFactor/Saved"
ADMIN_DIR="${SAVED_DIR}/SaveGames/Server"
ADMIN_INI="${ADMIN_DIR}/Admin.ini"

mkdir -p "${CONFIG_ROOT}"
mkdir -p "${ADMIN_DIR}"

echo "--------------------------------------------------"
echo " Preparing Abiotic Factor config"
echo " Config root: ${CONFIG_ROOT}"
echo "--------------------------------------------------"

# If user provides an Admin.ini in /opt/games/config, sync it to game location.
if [ -f "${CONFIG_ROOT}/Admin.ini" ]; then
    cp "${CONFIG_ROOT}/Admin.ini" "${ADMIN_INI}"
fi

# If game generated Admin.ini, keep a copy visible to GSH.
if [ -f "${ADMIN_INI}" ]; then
    cp "${ADMIN_INI}" "${CONFIG_ROOT}/Admin.ini" || true
fi

# Optional sandbox/admin ini paths are handled as launch args.
echo "Config ready."

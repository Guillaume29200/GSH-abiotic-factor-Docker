#!/usr/bin/env bash
set -euo pipefail

SERVER_DIR="/opt/games/server"
EXE_PATH="${SERVER_DIR}/AbioticFactor/Binaries/Win64/${GSH_SERVER_EXE}"

export WINEPREFIX="${GSH_WINEPREFIX}"
export WINEARCH="${GSH_WINEARCH}"
export DISPLAY="${GSH_DISPLAY}"

echo "--------------------------------------------------"
echo " Starting Abiotic Factor Dedicated Server"
echo " Server dir: ${SERVER_DIR}"
echo " Exe: ${EXE_PATH}"
echo " Wine prefix: ${WINEPREFIX}"
echo " Display: ${DISPLAY}"
echo "--------------------------------------------------"

mkdir -p "${WINEPREFIX}"

wineboot --init || true

Xvfb "${DISPLAY}" -screen 0 "${GSH_XVFB_RESOLUTION}" &
XVFB_PID=$!

cleanup() {
    echo "Stopping Abiotic Factor..."
    kill "${XVFB_PID}" >/dev/null 2>&1 || true
}
trap cleanup EXIT INT TERM

if [ ! -f "${EXE_PATH}" ]; then
    echo "ERROR: Cannot find ${EXE_PATH}"
    echo "Steam update may have failed or Abiotic Factor server structure changed."
    find "${SERVER_DIR}" -maxdepth 6 -type f -iname "*.exe" | sort || true
    exit 1
fi

ARGS=()
ARGS+=("-log")
ARGS+=("-newconsole")

if [ "${GSH_USE_PERF_THREADS}" = "true" ]; then
    ARGS+=("-useperfthreads")
fi

if [ "${GSH_NO_ASYNC_LOADING_THREAD}" = "true" ]; then
    ARGS+=("-NoAsyncLoadingThread")
fi

if [ "${GSH_LAN_ONLY}" = "true" ]; then
    ARGS+=("-LANOnly")
fi

if [ "${GSH_USE_LOCAL_IPS}" = "true" ]; then
    ARGS+=("-UseLocalIPs")
fi

if [ -n "${GSH_PLATFORM_LIMITED}" ]; then
    ARGS+=("-PlatformLimited=${GSH_PLATFORM_LIMITED}")
fi

if [ -n "${GSH_MULTIHOME}" ]; then
    ARGS+=("-MultiHome=${GSH_MULTIHOME}")
fi

ARGS+=("-MaxServerPlayers=${GSH_MAX_PLAYERS}")
ARGS+=("-PORT=${GSH_GAME_PORT}")
ARGS+=("-QueryPort=${GSH_QUERY_PORT}")

if [ -n "${GSH_SERVER_PASSWORD}" ]; then
    ARGS+=("-ServerPassword=${GSH_SERVER_PASSWORD}")
fi

if [ -n "${GSH_ADMIN_PASSWORD}" ]; then
    ARGS+=("-AdminPassword=${GSH_ADMIN_PASSWORD}")
fi

ARGS+=("-SteamServerName=${GSH_SERVER_NAME}")
ARGS+=("-WorldSaveName=${GSH_WORLD_SAVE_NAME}")

if [ -n "${GSH_SANDBOX_INI_PATH}" ]; then
    ARGS+=("-SandboxIniPath=${GSH_SANDBOX_INI_PATH}")
fi

if [ -n "${GSH_ADMIN_INI_PATH}" ]; then
    ARGS+=("-AdminIniPath=${GSH_ADMIN_INI_PATH}")
fi

# Community docker uses -tcp; keep it for compatibility.
ARGS+=("-tcp")

if [ -n "${GSH_START_ARGS}" ]; then
    # shellcheck disable=SC2206
    EXTRA_ARGS=( ${GSH_START_ARGS} )
    ARGS+=("${EXTRA_ARGS[@]}")
fi

cd "$(dirname "${EXE_PATH}")"

echo "Launch command:"
printf 'wine %q ' "${EXE_PATH}"
printf '%q ' "${ARGS[@]}"
echo

exec wine "${EXE_PATH}" "${ARGS[@]}"

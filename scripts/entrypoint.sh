#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo " GSH Abiotic Factor Dedicated Server"
echo " Standardized Docker Image"
echo "=================================================="

# Lowercase aliases for GSH if needed
export GSH_TZ="${GSH_TZ:-${gsh_tz:-Europe/Paris}}"
export GSH_PUID="${GSH_PUID:-${gsh_puid:-1000}}"
export GSH_PGID="${GSH_PGID:-${gsh_pgid:-1000}}"

export GSH_STEAM_APP_ID="${GSH_STEAM_APP_ID:-${gsh_steam_app_id:-2857200}}"
export GSH_STEAM_USER="${GSH_STEAM_USER:-${gsh_steam_user:-anonymous}}"
export GSH_STEAM_PASSWORD="${GSH_STEAM_PASSWORD:-${gsh_steam_password:-}}"
export GSH_GAME_UPDATE="${GSH_GAME_UPDATE:-${gsh_game_update:-true}}"
export GSH_VALIDATE_FILES="${GSH_VALIDATE_FILES:-${gsh_validate_files:-true}}"
export GSH_STEAM_FORCE_PLATFORM="${GSH_STEAM_FORCE_PLATFORM:-${gsh_steam_force_platform:-windows}}"

export GSH_SERVER_NAME="${GSH_SERVER_NAME:-${gsh_server_name:-GSH Abiotic Factor Server}}"
export GSH_SERVER_PASSWORD="${GSH_SERVER_PASSWORD:-${gsh_server_password:-password}}"
export GSH_ADMIN_PASSWORD="${GSH_ADMIN_PASSWORD:-${gsh_admin_password:-}}"
export GSH_MAX_PLAYERS="${GSH_MAX_PLAYERS:-${gsh_max_players:-6}}"
export GSH_WORLD_SAVE_NAME="${GSH_WORLD_SAVE_NAME:-${gsh_world_save_name:-Cascade}}"

export GSH_GAME_PORT="${GSH_GAME_PORT:-${gsh_game_port:-7777}}"
export GSH_QUERY_PORT="${GSH_QUERY_PORT:-${gsh_query_port:-27015}}"

export GSH_USE_PERF_THREADS="${GSH_USE_PERF_THREADS:-${gsh_use_perf_threads:-true}}"
export GSH_NO_ASYNC_LOADING_THREAD="${GSH_NO_ASYNC_LOADING_THREAD:-${gsh_no_async_loading_thread:-true}}"
export GSH_LAN_ONLY="${GSH_LAN_ONLY:-${gsh_lan_only:-false}}"
export GSH_PLATFORM_LIMITED="${GSH_PLATFORM_LIMITED:-${gsh_platform_limited:-}}"
export GSH_MULTIHOME="${GSH_MULTIHOME:-${gsh_multihome:-}}"
export GSH_USE_LOCAL_IPS="${GSH_USE_LOCAL_IPS:-${gsh_use_local_ips:-false}}"
export GSH_SANDBOX_INI_PATH="${GSH_SANDBOX_INI_PATH:-${gsh_sandbox_ini_path:-}}"
export GSH_ADMIN_INI_PATH="${GSH_ADMIN_INI_PATH:-${gsh_admin_ini_path:-}}"

export GSH_USE_WINE="${GSH_USE_WINE:-${gsh_use_wine:-true}}"
export GSH_WINEPREFIX="${GSH_WINEPREFIX:-${gsh_wineprefix:-/opt/wine/abiotic-factor}}"
export GSH_WINEARCH="${GSH_WINEARCH:-${gsh_winearch:-win64}}"
export GSH_DISPLAY="${GSH_DISPLAY:-${gsh_display:-:99}}"
export GSH_XVFB_RESOLUTION="${GSH_XVFB_RESOLUTION:-${gsh_xvfb_resolution:-1024x768x16}}"

export GSH_SERVER_EXE="${GSH_SERVER_EXE:-${gsh_server_exe:-AbioticFactorServer-Win64-Shipping.exe}}"
export GSH_START_ARGS="${GSH_START_ARGS:-${gsh_start_args:-}}"

ln -snf "/usr/share/zoneinfo/${GSH_TZ}" /etc/localtime || true
echo "${GSH_TZ}" > /etc/timezone || true

if [ "$(id -u gsh)" != "${GSH_PUID}" ]; then
    usermod -u "${GSH_PUID}" gsh
fi

if [ "$(id -g gsh)" != "${GSH_PGID}" ]; then
    groupmod -g "${GSH_PGID}" gsh
fi

chown -R gsh:gsh /opt/steam /opt/games /opt/wine

if [ "${GSH_GAME_UPDATE}" = "true" ]; then
    gosu gsh /scripts/steam-update.sh
fi

gosu gsh /scripts/write-config.sh

exec gosu gsh /scripts/start-server.sh

FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        tar \
        unzip \
        jq \
        xvfb \
        xauth \
        procps \
        gosu \
        wine \
        wine32 \
        wine64 \
        winbind \
        cabextract \
        lib32gcc-s1 \
        lib32stdc++6 \
        libcurl4-gnutls-dev:i386 \
        libsdl2-2.0-0:i386 \
        libtinfo6:i386 \
        libncurses6:i386 \
        libstdc++6:i386 \
        zlib1g:i386 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/steam /opt/games/server /opt/games/config /opt/wine && \
    useradd -m -u 1000 -s /bin/bash gsh && \
    chown -R gsh:gsh /opt/steam /opt/games /opt/wine

USER gsh
WORKDIR /opt/steam

RUN wget -q https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

USER root

COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

# ----------------------------
# GSH Standard Variables
# ----------------------------
ENV GSH_TZ="Europe/Paris"
ENV GSH_PUID="1000"
ENV GSH_PGID="1000"

ENV GSH_STEAM_APP_ID="2857200"
ENV GSH_STEAM_USER="anonymous"
ENV GSH_STEAM_PASSWORD=""
ENV GSH_GAME_UPDATE="true"
ENV GSH_VALIDATE_FILES="true"
ENV GSH_STEAM_FORCE_PLATFORM="windows"

ENV GSH_SERVER_NAME="GSH Abiotic Factor Server"
ENV GSH_SERVER_PASSWORD="password"
ENV GSH_ADMIN_PASSWORD=""
ENV GSH_MAX_PLAYERS="6"
ENV GSH_WORLD_SAVE_NAME="Cascade"

ENV GSH_GAME_PORT="7777"
ENV GSH_QUERY_PORT="27015"

ENV GSH_USE_PERF_THREADS="true"
ENV GSH_NO_ASYNC_LOADING_THREAD="true"
ENV GSH_LAN_ONLY="false"
ENV GSH_PLATFORM_LIMITED=""
ENV GSH_MULTIHOME=""
ENV GSH_USE_LOCAL_IPS="false"
ENV GSH_SANDBOX_INI_PATH=""
ENV GSH_ADMIN_INI_PATH=""

ENV GSH_USE_WINE="true"
ENV GSH_WINEPREFIX="/opt/wine/abiotic-factor"
ENV GSH_WINEARCH="win64"
ENV GSH_DISPLAY=":99"
ENV GSH_XVFB_RESOLUTION="1024x768x16"

ENV GSH_SERVER_EXE="AbioticFactorServer-Win64-Shipping.exe"
ENV GSH_START_ARGS=""

WORKDIR /opt/games/server

EXPOSE 7777/udp
EXPOSE 27015/udp

HEALTHCHECK --interval=30s --timeout=10s --start-period=180s --retries=3 CMD /scripts/healthcheck.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]

# 🐳 Abiotic Factor Dedicated Server - GSH Standard

## 📌 Description

Image Docker dédiée au serveur Abiotic Factor, entièrement standardisée pour l’écosystème GameServer-Hub (GSH).

Cette image permet de déployer facilement un serveur Abiotic Factor sous Linux via Wine + SteamCMD, avec gestion automatique de l'installation, des mises à jour et des paramètres de lancement avancés.

---

## 🚀 Features

- Installation automatique via SteamCMD
- Support Wine + Xvfb (serveur Windows sous Linux)
- Mise à jour automatique du serveur
- Paramètres de lancement avancés (officiels)
- Variables GSH unifiées (`GSH_*`)
- Structure standard pour tous les jeux GSH
- Compatible Docker, VPS et serveur dédié

---

## 📁 Structure GSH

```txt
/opt/steam            -> SteamCMD (persistant)
/opt/games/server     -> Fichiers du serveur
/opt/games/config     -> Configuration externe
/opt/wine             -> Environnement Wine
```

---

## ⚙️ Variables d’environnement (GSH)

### 🔧 Général

```env
GSH_TZ=Europe/Paris
GSH_PUID=1000
GSH_PGID=1000
```

---

### 📦 Steam

```env
GSH_STEAM_APP_ID=2857200
GSH_STEAM_USER=anonymous
GSH_STEAM_PASSWORD=

GSH_GAME_UPDATE=true
GSH_VALIDATE_FILES=true
GSH_STEAM_FORCE_PLATFORM=windows
```

---

### 🎮 Serveur Abiotic Factor

```env
GSH_SERVER_NAME=GSH Abiotic Factor Server
GSH_SERVER_PASSWORD=password
GSH_ADMIN_PASSWORD=changeme
GSH_MAX_PLAYERS=6
GSH_WORLD_SAVE_NAME=Cascade
```

---

### 🌐 Réseau

```env
GSH_GAME_PORT=7777
GSH_QUERY_PORT=27015
```

---

### ⚙️ Paramètres avancés (launch options)

```env
GSH_USE_PERF_THREADS=true
GSH_NO_ASYNC_LOADING_THREAD=true
GSH_LAN_ONLY=false

GSH_PLATFORM_LIMITED=
GSH_MULTIHOME=
GSH_USE_LOCAL_IPS=false

GSH_SANDBOX_INI_PATH=
GSH_ADMIN_INI_PATH=
GSH_START_ARGS=
```

---

### 🧠 Wine / Display

```env
GSH_USE_WINE=true
GSH_WINEPREFIX=/opt/wine/abiotic-factor
GSH_WINEARCH=win64
GSH_DISPLAY=:99
GSH_XVFB_RESOLUTION=1024x768x16
```

---

### ⚙️ Exécution

```env
GSH_SERVER_EXE=AbioticFactorServer-Win64-Shipping.exe
```

---

## 🔌 Ports

- `7777/udp` → Game Port
- `27015/udp` → Query Port

---

## 💾 Volumes

```yaml
volumes:
  - ./data/server:/opt/games/server
  - ./data/config:/opt/games/config
  - ./data/wine:/opt/wine
  - ./data/steam:/opt/steam
```

---

## ▶️ Exemple docker-compose

```yaml
version: "3.8"

services:
  abiotic-factor:
    image: slymer29/gsh-abiotic-factor:latest
    container_name: gsh-abiotic-factor
    restart: unless-stopped

    ports:
      - "7777:7777/udp"
      - "27015:27015/udp"

    environment:
      GSH_SERVER_NAME: "Mon serveur Abiotic Factor"
      GSH_SERVER_PASSWORD: "password"
      GSH_ADMIN_PASSWORD: "changeme"
      GSH_MAX_PLAYERS: 6

    volumes:
      - ./data/server:/opt/games/server
      - ./data/config:/opt/games/config
      - ./data/wine:/opt/wine
      - ./data/steam:/opt/steam
```

---

## ⚠️ Important

- Abiotic Factor Dedicated Server est une application Windows exécutée via Wine
- Le premier démarrage peut être long (téléchargement SteamCMD)
- L’image ne contient pas les fichiers du jeu
- Les fichiers sont téléchargés automatiquement au premier lancement
- Les paramètres de lancement sont appliqués dynamiquement via variables GSH

---

## 🎯 Intégration GameServer-Hub

Cette image suit le standard GSH :

- Variables unifiées (`GSH_*`)
- Structure identique pour tous les jeux
- Déploiement automatisé
- Gestion simplifiée côté panel

---

## 🔥 Auteur

Image maintenue par **slymer29**

Optimisée pour l’écosystème **GameServer-Hub (GSH)**

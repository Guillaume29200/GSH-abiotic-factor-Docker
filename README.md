# GSH Abiotic Factor Docker - Standardized

Docker image for Abiotic Factor Dedicated Server, optimized for GameServer-Hub (GSH).

## Standard GSH paths

```txt
/opt/steam           -> SteamCMD persistent directory
/opt/games/server    -> Game server files
/opt/games/config    -> External readable config
/opt/wine            -> Wine prefix storage
```

## Volumes

```yaml
volumes:
  - ./data/server:/opt/games/server
  - ./data/config:/opt/games/config
  - ./data/wine:/opt/wine
  - ./data/steam:/opt/steam
```

## Build

```bash
docker build -t slymer29/gsh-abiotic-factor:latest .
```

## Push

```bash
docker push slymer29/gsh-abiotic-factor:latest
```

## Run

```bash
docker compose up -d
```

## AppID

```env
GSH_STEAM_APP_ID=2857200
```

## Main ports

```txt
7777/udp
27015/udp
```

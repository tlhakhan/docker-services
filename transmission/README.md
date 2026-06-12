# transmission

Docker Compose setup for [Transmission](https://transmissionbt.com/) daemon with a persistent WebUI, running on Ubuntu 26.04.

## Structure

```
transmission/
├── build/
│   ├── Dockerfile       # Ubuntu 26.04 base image
│   └── entrypoint.sh    # Writes initial config from env vars on first start
├── data/                # Gitignored — created at runtime
│   ├── config/          # Persisted settings.json and state
│   └── downloads/
│       ├── complete/
│       └── incomplete/
├── .env                 # Gitignored — your local secrets
├── .env.example         # Committed template
└── docker-compose.yaml
```

## Getting started

**1. Configure your environment**

```bash
cp .env.example .env
```

Edit `.env` and set your credentials and paths before the first start — once the container runs, credentials are persisted in the config volume and changes to `.env` won't take effect without manually editing `data/config/settings.json`.

| Variable               | Default             | Description                                  |
|------------------------|---------------------|----------------------------------------------|
| `WEBUI_PORT`           | `9091`              | Host port for the WebUI                      |
| `PEER_PORT`            | `51413`             | BitTorrent peer port (TCP + UDP)             |
| `TRANSMISSION_USERNAME`| `admin`             | WebUI login username                         |
| `TRANSMISSION_PASSWORD`| `changeme`          | WebUI login password                         |
| `DOWNLOADS_PATH`       | `./data/downloads`  | Host path for completed and in-progress downloads |
| `CONFIG_PATH`          | `./data/config`     | Host path for Transmission config and state  |

**2. Build and start**

```bash
docker compose up -d --build
```

The WebUI will be available at `http://localhost:9091/transmission/web/`.

**3. Stop**

```bash
docker compose down
```

## Downloads path

By default downloads land in `./data/downloads` (relative to this directory), which is gitignored. If you're expecting large downloads, point `DOWNLOADS_PATH` in `.env` at a volume with enough space:

```
DOWNLOADS_PATH=/mnt/nas/downloads
```

## Peer port forwarding

For best connectivity, forward `PEER_PORT` (default `51413`) on your router to the host machine for both TCP and UDP. Without this, Transmission will still work but peers may have trouble connecting to you.

## Changing credentials after first start

Transmission owns `settings.json` after the first run. To update credentials:

1. `docker compose down`
2. Edit `data/config/settings.json` — set `rpc-username` and `rpc-password` (plain text is accepted; Transmission will hash it on next start)
3. `docker compose up -d`

# docker-services

A collection of self-hosted services, each managed independently with Docker Compose.

## Services

| Service | Description | WebUI |
|---------|-------------|-------|
| [transmission](./transmission/) | BitTorrent client (transmission-daemon) | `http://localhost:9091/transmission/web/` |

## Structure

Each service lives in its own subdirectory and is fully self-contained:

```
docker-services/
└── <service>/
    ├── build/            # Dockerfile and supporting build files
    ├── data/             # Runtime data — gitignored
    ├── .env              # Local secrets — gitignored
    ├── .env.example      # Committed env template
    ├── docker-compose.yaml
    └── README.md
```

## Usage

All commands run from inside the service directory:

```bash
cd <service>
cp .env.example .env     # configure on first use
docker compose up -d --build
docker compose down
docker compose logs -f
```

Refer to each service's `README.md` for service-specific configuration.

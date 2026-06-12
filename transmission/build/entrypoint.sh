#!/bin/bash
set -e

PUID=${PUID:-1000}
PGID=${PGID:-1000}

# Remap debian-transmission's UID/GID to match the host user so that files
# written to bind-mounted volumes appear with the correct ownership on the host.
# -o allows non-unique IDs in case the target UID/GID is already taken in the container.
groupmod -og "$PGID" debian-transmission
usermod -ou "$PUID" debian-transmission

mkdir -p /downloads/complete /downloads/incomplete /config
chown -R debian-transmission:debian-transmission /downloads /config

CONFIG_FILE="/config/settings.json"

# Write initial config only on first start; transmission rewrites this file on shutdown,
# so subsequent starts will use whatever settings are persisted in the config volume.
if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" <<EOF
{
    "download-dir": "/downloads/complete",
    "incomplete-dir": "/downloads/incomplete",
    "incomplete-dir-enabled": true,
    "rpc-authentication-required": true,
    "rpc-username": "${TRANSMISSION_USERNAME:-admin}",
    "rpc-password": "${TRANSMISSION_PASSWORD:-changeme}",
    "rpc-whitelist-enabled": false,
    "rpc-host-whitelist-enabled": false,
    "rpc-port": 9091,
    "peer-port": ${PEER_PORT:-51413},
    "umask": 2
}
EOF
    chown debian-transmission:debian-transmission "$CONFIG_FILE"
fi

exec runuser -u debian-transmission -- transmission-daemon --foreground --config-dir /config

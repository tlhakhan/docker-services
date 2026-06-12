#!/bin/bash
set -e

CONFIG_FILE="/config/settings.json"

mkdir -p /downloads/complete /downloads/incomplete /config

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
fi

exec transmission-daemon --foreground --config-dir /config

FROM ubuntu:26.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        transmission-daemon \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /downloads/complete /downloads/incomplete /config

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9091 51413 51413/udp

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

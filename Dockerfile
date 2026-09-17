FROM lscr.io/linuxserver/webtop:ubuntu-xfce

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        dbus-x11 \
        fonts-dejavu \
        fonts-liberation \
        fonts-noto-core \
        wget \
    && (apt-get install -y --no-install-recommends firefox-esr || true) \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY start.sh /custom-cont-init.d/99-remote-desktop.sh
RUN chmod 0755 /custom-cont-init.d/99-remote-desktop.sh

# LinuxServer's /init remains PID 1 and starts Webtop/KasmVNC.
ENTRYPOINT ["/init"]

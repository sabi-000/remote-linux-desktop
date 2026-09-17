FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive DISPLAY=:1 HOME=/root

RUN apt-get update \
    && apt-get install -y --no-install-recommends xfce4 xfce4-goodies tigervnc-standalone-server novnc websockify dbus-x11 xterm curl wget ca-certificates openssl sudo firefox xubuntu-icon-theme \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY start.sh /usr/local/bin/start-remote-desktop
RUN chmod 0755 /usr/local/bin/start-remote-desktop

EXPOSE 6080
CMD ["/usr/local/bin/start-remote-desktop"]

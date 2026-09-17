FROM --platform=linux/amd64 ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install --no-install-recommends -y xfce4 tigervnc-standalone-server novnc websockify sudo xterm init systemd snapd vim net-tools curl wget git tzdata
RUN apt-get update -y && apt-get install -y dbus-x11 x11-utils x11-xserver-utils x11-apps
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:mozillateam/ppa -y
RUN echo 'Package: *' >> /etc/apt/preferences.d/mozilla-firefox
RUN echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox
RUN echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox
RUN apt-get update -y && apt-get install -y firefox
RUN apt-get purge -y snapd vim net-tools curl wget git x11-apps software-properties-common && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
RUN apt-get update -y && apt-get install -y xubuntu-icon-theme
RUN touch /root/.Xauthority

COPY start.sh /usr/local/bin/start-remote-desktop
RUN chmod 0755 /usr/local/bin/start-remote-desktop

EXPOSE 5901
EXPOSE 6080
CMD ["/usr/local/bin/start-remote-desktop"]

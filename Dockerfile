FROM --platform=linux/amd64 ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install --no-install-recommends -y xfce4 xfce4-goodies tigervnc-standalone-server novnc websockify sudo xterm netsurf-gtk falkon epiphany-browser init systemd snapd vim net-tools curl wget git tzdata
RUN apt-get update -y && apt-get install -y dbus-x11 x11-utils x11-xserver-utils x11-apps
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:mozillateam/ppa -y
RUN echo 'Package: *' >> /etc/apt/preferences.d/mozilla-firefox
RUN echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox
RUN echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox
RUN apt-get update -y && apt-get install -y firefox
RUN apt-get update -y && apt-get install -y xubuntu-icon-theme
RUN printf '%s\n' '[Desktop Entry]' 'Name=NetSurf' 'Comment=Lightweight web browser' 'Exec=netsurf-gtk %u' 'Terminal=false' 'Type=Application' 'Categories=Network;WebBrowser;' > /usr/share/applications/netsurf.desktop
RUN wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt-get install -y /tmp/google-chrome.deb && rm -f /tmp/google-chrome.deb
RUN touch /root/.Xauthority

COPY start.sh /usr/local/bin/start-remote-desktop
RUN chmod 0755 /usr/local/bin/start-remote-desktop

EXPOSE 5901
EXPOSE 6080
CMD ["/usr/local/bin/start-remote-desktop"]

#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG_DIR="/config"
DESKTOP_DIR="${CONFIG_DIR}/Desktop"
DOWNLOADS_DIR="${CONFIG_DIR}/Downloads"
AUTOSTART_DIR="${CONFIG_DIR}/.config/autostart"
LAUNCHER="${DESKTOP_DIR}/Firefox.desktop"
AUTOSTART_FILE="${AUTOSTART_DIR}/firefox.desktop"

log() { printf '[remote-desktop] %s\n' "$*"; }

install -d -m 0755 "$DESKTOP_DIR" "$DOWNLOADS_DIR" "$AUTOSTART_DIR"
chown -R abc:abc "$DESKTOP_DIR" "$DOWNLOADS_DIR" "${CONFIG_DIR}/.config"

FIREFOX_BIN=""
if command -v firefox-esr >/dev/null 2>&1; then
  FIREFOX_BIN="firefox-esr"
elif command -v firefox >/dev/null 2>&1; then
  FIREFOX_BIN="firefox"
fi

if [[ -z "$FIREFOX_BIN" ]]; then
  log 'هشدار: Firefox در image پیدا نشد؛ launcher ساخته نشد.'
  exit 0
fi

cat > "$LAUNCHER" <<EOF
[Desktop Entry]
Type=Application
Name=Firefox
Comment=Open Firefox in the remote desktop
Exec=${FIREFOX_BIN}
Icon=firefox
Terminal=false
Categories=Network;WebBrowser;
EOF

cat > "$AUTOSTART_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=Firefox (Remote Desktop)
Comment=Start Firefox once when XFCE starts
Exec=${FIREFOX_BIN}
OnlyShowIn=XFCE;
X-GNOME-Autostart-enabled=true
EOF

chown abc:abc "$LAUNCHER" "$AUTOSTART_FILE"
chmod 0644 "$LAUNCHER" "$AUTOSTART_FILE"
log "پیکربندی Firefox با ${FIREFOX_BIN} آماده شد. اجرای خودکار برای هر session فقط یک‌بار است."

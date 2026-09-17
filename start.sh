#!/usr/bin/env bash
set -Eeuo pipefail

DISPLAY_NUM="${DISPLAY_NUM:-1}"
GEOMETRY="${GEOMETRY:-1280x800}"
PORT="${PORT:-6080}"
export DISPLAY=":${DISPLAY_NUM}"

mkdir -p /root/.vnc
printf '%s\n' '#!/bin/sh' 'unset SESSION_MANAGER' 'unset DBUS_SESSION_BUS_ADDRESS' 'exec dbus-run-session -- startxfce4' > /root/.vnc/xstartup
chmod 0755 /root/.vnc/xstartup

vncserver "${DISPLAY}" -localhost no -SecurityTypes None -geometry "${GEOMETRY}" -depth 24 --I-KNOW-THIS-IS-INSECURE
exec websockify --web=/usr/share/novnc/ "0.0.0.0:${PORT}" "localhost:$((5900 + DISPLAY_NUM))"

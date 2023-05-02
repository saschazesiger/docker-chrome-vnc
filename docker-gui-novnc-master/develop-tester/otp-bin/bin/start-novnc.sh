#!/usr/bin/env bash

websockify --web=/usr/share/novnc/ ${WEBSOCKIFY_PORT:-6900} localhost:${VNC_PORT:-5900}

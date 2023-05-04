#!/usr/bin/env bash

websockify --web=/usr/share/novnc/ 6900 localhost:${VNC_PORT:-5900}

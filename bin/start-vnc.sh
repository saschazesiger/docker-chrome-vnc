#!/usr/bin/env bash

if [ ! -z $VNC_PASSWD ]; then
    mkdir $HOME/.vnc
    x11vnc -storepasswd $VNC_PASSWD $HOME/.vnc/passwd
    X11VNC_OPTS=-usepw
else
    echo "Starting VNC server without password authentication"
    X11VNC_OPTS=
fi



tigervncserver -rfbport ${VNC_PORT:-5900} -geometry ${SCREEN_WIDTH}x${SCREEN_HEIGHT} -depth ${SCREEN_DEPTH}
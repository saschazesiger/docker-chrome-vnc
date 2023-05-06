#!/bin/bash
export DISPLAY=:99
export XAUTHORITY=${DATA_DIR}/.Xauthority

echo "---Checking for old logfiles---"
find $DATA_DIR -name "XvfbLog.*" -exec rm -f {} \;
find $DATA_DIR -name "x11vncLog.*" -exec rm -f {} \;
echo "---Checking for old display lock files---"
rm -rf /tmp/.X99*
rm -rf /tmp/.X11*
rm -rf ${DATA_DIR}/.vnc/*.log ${DATA_DIR}/.vnc/*.pid ${DATA_DIR}/Singleton*
chmod -R ${DATA_PERM} ${DATA_DIR}
if [ -f ${DATA_DIR}/.vnc/passwd ]; then
	chmod 600 ${DATA_DIR}/.vnc/passwd
fi
screen -wipe 2&>/dev/null

echo "---Starting Pulseaudio server---"
pulseaudio -D -vvvvvvv --exit-idle-time=-1
ffmpeg -f alsa -i pulse -f mpegts -codec:a mp2 -ar 44100 -ac 2 -b:a 128k udp://localhost:10000 &


echo "---Starting TurboVNC server---"
vncserver -geometry 1024x768 -depth 16 :99 -rfbport 5900 -noxstartup ${TURBOVNC_PARAMS} 2>/dev/null

echo "---Starting Fluxbox---"
screen -d -m env HOME=/etc /usr/bin/fluxbox


echo "---Starting Chrome---"
cd ${DATA_DIR}
/usr/bin/chromium --user-data-dir=${DATA_DIR} --disable-accelerated-video --disable-gpu --no-sandbox --disable-dev-shm-usage --test-type --dbus-stub ${EXTRA_PARAMETERS} 2>/dev/null
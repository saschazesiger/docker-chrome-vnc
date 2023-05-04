#!/usr/bin/env bash

#==============================================
# OpenShift or non-sudo environments support
# https://docs.openshift.com/container-platform/3.11/creating_images/guidelines.html#openshift-specific-guidelines
#==============================================

if ! whoami &> /dev/null; then
    if [ -w /etc/passwd ]; then
        CURR_ID=$(id -u)
        echo ubuntu | su ubuntu -c \
        "sudo useradd ${USER_NAME:-ubuntu} \
            --create-home \
            --gid 1001 \
            --shell /bin/bash \
            --uid $CURR_ID"
        echo ubuntu | su ubuntu -c "sudo usermod -a -G sudo ${USER_NAME:-ubuntu}"
        HOME=/home/${USER_NAME:-ubuntu}
        cd $HOME
        echo "cd $HOME" >> $HOME/.bashrc
    fi
fi

export GEOMETRY="${SCREEN_WIDTH}""x""${SCREEN_HEIGHT}""x""${SCREEN_DEPTH}" &
Xvfb $DISPLAY -screen 0 ${GEOMETRY} -fbdir /var/tmp -dpi ${SCREEN_DPI} -listen tcp -noreset -ac +extension RANDR &
/usr/bin/startxfce4 &
tigervncserver -rfbport ${VNC_PORT:-5900} -geometry ${SCREEN_WIDTH}x${SCREEN_HEIGHT} -depth ${SCREEN_DEPTH} &
/opt/bin/server -audio-port ${FFMPEG_UDP_PORT:-10000} -port ${AUDIO_SERVER:-1699} &
envsubst '\$PORT,\$WEBSOCKIFY_PORT,\$AUDIO_SERVER' < /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/nginx.conf
sudo nginx -g 'daemon off; master_process on;' &
pulseaudio -vvvvvvv --exit-idle-time=-1 &
ffmpeg -f alsa -i pulse -f mpegts -codec:a mp2 -ar 44100 -ac 2 -b:a 128k udp://localhost:${FFMPEG_UDP_PORT:-10000} &

SUPERVISOR_PID=$!

function shutdown {
    echo "Trapped SIGTERM/SIGINT/x so shutting down supervisord..."
    kill -s SIGTERM ${SUPERVISOR_PID}
    wait ${SUPERVISOR_PID}
    echo "Shutdown complete"
}

trap shutdown SIGTERM SIGINT
wait ${SUPERVISOR_PID}

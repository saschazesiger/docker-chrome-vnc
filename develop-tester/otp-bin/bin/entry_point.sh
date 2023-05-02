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

/usr/bin/supervisord --configuration /etc/supervisor/supervisord.conf &

SUPERVISOR_PID=$!

function shutdown {
    echo "Trapped SIGTERM/SIGINT/x so shutting down supervisord..."
    kill -s SIGTERM ${SUPERVISOR_PID}
    wait ${SUPERVISOR_PID}
    echo "Shutdown complete"
}

trap shutdown SIGTERM SIGINT
wait ${SUPERVISOR_PID}

#/bin/bash

# Relaxing permissions for other non-sudo environments

FOLDERS="/opt/bin/ /var/run/supervisor /var/log/supervisor /etc/nginx /usr/share/novnc"

mkdir -p $FOLDERS

chmod -R 777 $FOLDERS /etc/passwd
chgrp -R 0 $FOLDERS
chmod -R g=u $FOLDERS

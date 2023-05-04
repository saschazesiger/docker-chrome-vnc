#/bin/bash

if [ "${GUI}" == "xfce" ]
then
    bash /bin/apt_install.sh \
        xfce4 \
    && bash /bin/apt_clean.sh

    cat <<EOT >> /bin/start-ui.sh
#!/usr/bin/env bash
/usr/bin/startxfce4
EOT

fi

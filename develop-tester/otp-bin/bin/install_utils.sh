#/bin/bash

bash /opt/bin/apt_install.sh \
    htop terminator software-properties-common gpg-agent

add-apt-repository -y ppa:mozillateam/ppa
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | tee /etc/apt/preferences.d/mozilla-firefox

bash /opt/bin/apt_install.sh firefox

bash /opt/bin/apt_clean.sh

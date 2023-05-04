#/bin/bash

bash /bin/apt_install.sh \
    htop terminator software-properties-common gpg-agent

add-apt-repository -y ppa:mozillateam/ppa
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | tee /etc/apt/preferences.d/mozilla-firefox

bash /bin/apt_install.sh firefox

bash /bin/apt_clean.sh

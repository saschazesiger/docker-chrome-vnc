FROM debian:bullseye-slim

LABEL org.opencontainers.image.authors="janis@js0.ch"
LABEL org.opencontainers.image.source="https://github.com/saschazesiger/"

RUN  echo "deb http://deb.debian.org/debian bullseye contrib non-free" >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get -y install --no-install-recommends wget locales procps && \
	touch /etc/locale.gen && \
	echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
	locale-gen && \
	apt-get -y install --reinstall ca-certificates && \
	rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
	apt-get -y install --no-install-recommends xvfb wmctrl x11vnc fluxbox screen libxcomposite-dev libxcursor1 xauth && \
	rm -rf /var/lib/apt/lists/*

ENV TURBOVNC_V=3.0.3

RUN cd /tmp && \
	wget -O /tmp/turbovnc.deb https://sourceforge.net/projects/turbovnc/files/${TURBOVNC_V}/turbovnc_${TURBOVNC_V}_amd64.deb/download && \
	dpkg -i /tmp/turbovnc.deb && \
	rm -rf /opt/TurboVNC/java /opt/TurboVNC/README.txt && \
	cp -R /opt/TurboVNC/bin/* /bin/ && \
	rm -rf /opt/TurboVNC /tmp/turbovnc.deb && \
	sed -i '/# $enableHTTP = 1;/c\$enableHTTP = 0;' /etc/turbovncserver.conf

COPY /x11vnc /usr/bin/x11vnc
RUN chmod 751 /usr/bin/x11vnc

ENV DATA_DIR=/chrome
ENV CUSTOM_RES_W=1024
ENV CUSTOM_RES_H=768
ENV CUSTOM_DEPTH=16
ENV NOVNC_PORT=8080
ENV RFB_PORT=5900
ENV TURBOVNC_PARAMS="-securitytypes none"
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="chrome"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
COPY /conf/ /etc/.fluxbox/
RUN chmod -R 770 /opt/scripts/

RUN apt-get update && \
	apt-get -qqy --no-install-recommends install sudo supervisor dbus-x11 xvfb x11vnc x11-xserver-utils wget curl unzip gettext && \
	apt-get -qqy --no-install-recommends install pulseaudio pavucontrol ffmpeg dbus-x11


RUN export TZ=Europe/Rome && \
	apt-get update && \
	apt-get -y install --no-install-recommends chromium fonts-takao fonts-arphic-uming libgtk-3-0 && \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone && \
	echo "ko_KR.UTF-8 UTF-8" >> /etc/locale.gen && \ 
	echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen && \
	locale-gen && \
	rm -rf /var/lib/apt/lists/*


COPY default.pa /etc/pulse/default.pa
RUN adduser root pulse-access
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu


EXPOSE 8080

#Server Start
CMD ["bash", "/opt/scripts/start.sh"]

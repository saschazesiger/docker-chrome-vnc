FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="janis@js0.ch"
LABEL org.opencontainers.image.source="https://github.com/saschazesiger/docker-base-vnc"

ARG NOVNC_V=1.4.0
ARG TURBOVNC_V=3.0.3


RUN apt-get update && \
	apt-get -y install --no-install-recommends xvfb wmctrl x11vnc websockify fluxbox screen libxcomposite-dev libxcursor1 xauth && \
	rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
	wget -O /tmp/turbovnc.deb https://sourceforge.net/projects/turbovnc/files/${TURBOVNC_V}/turbovnc_${TURBOVNC_V}_amd64.deb/download && \
	dpkg -i /tmp/turbovnc.deb && \
	rm -rf /opt/TurboVNC/java /opt/TurboVNC/README.txt && \
	cp -R /opt/TurboVNC/bin/* /bin/ && \
	rm -rf /opt/TurboVNC /tmp/turbovnc.deb && \
	sed -i '/# $enableHTTP = 1;/c\$enableHTTP = 0;' /etc/turbovncserver.conf

ENV CUSTOM_RES_W=640
ENV CUSTOM_RES_H=480

COPY /x11vnc /usr/bin/x11vnc
RUN chmod 751 /usr/bin/x11vnc
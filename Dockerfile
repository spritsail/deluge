FROM ubuntu:14.04

ADD start.sh /start.sh

RUN chmod +x /start.sh \
	&& apt-get install -y software-properties-common \
	&& add-apt-repository ppa:deluge-team/ppa \
	&& apt-get update \
	&& apt-get install -y deluged deluge-web \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& useradd --system -u 647 -M --shell /usr/sbin/nologin deluge

USER deluge
CMD /start.sh
VOLUME /config
VOLUME /media

EXPOSE 53160
EXPOSE 53160/udp
EXPOSE 8112
EXPOSE 58846

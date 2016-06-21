FROM alpine:3.4

ADD start.sh /start.sh

RUN chmod +x /start.sh \
	&& adduser -S -u 647 -H -s /usr/sbin/nologin deluge \
	&& echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
	&& apk add --no-cache deluge@testing build-base py-pip\
	&& pip install enum34 service_identity \
	&& apk del --no-cache build-base py-pip


USER deluge

VOLUME /config
VOLUME /media

EXPOSE 53160
EXPOSE 53160/udp
EXPOSE 8112
EXPOSE 58846

CMD ["/start.sh"]
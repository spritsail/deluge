FROM alpine:3.4
MAINTAINER Adam Dodman <adam.dodman@gmx.com>

ENV UID=647 UNAME=deluge GID=990 GNAME=media
ENV PYTHON_EGG_CACHE=/config/deluge/eggcache

ADD start.sh /start.sh

RUN chmod +x /start.sh \
 && addgroup -g $GID $GNAME \
 && adduser -SH -u $UID -G $GNAME -s /usr/sbin/nologin $UNAME \
 && echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk add --no-cache deluge@testing py-service_identity@testing

USER $UNAME



VOLUME ["/config", "/media"]
EXPOSE 53160
EXPOSE 53160/udp
EXPOSE 8112
EXPOSE 58846
CMD ["/start.sh"]

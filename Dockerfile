FROM alpine:3.4
MAINTAINER Adam Dodman <adam.dodman@gmx.com>

ENV UID=647 UNAME=deluge GID=990 GNAME=media
ENV PYTHON_EGG_CACHE=/config/deluge/eggcache

ADD start.sh /start.sh

RUN chmod +x /start.sh \
 && addgroup -g $GID $GNAME \
 && adduser -SH -u $UID -G $GNAME -s /usr/sbin/nologin $UNAME \
 && sed -i -e 's/v3\.4/edge/g' /etc/apk/repositories \
 && echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk add --no-cache deluge@testing py-pip \
 && pip install service_identity \
 && apk del --no-cache py-pip

USER $UNAME

VOLUME ["/config", "/media"]
EXPOSE 53160
EXPOSE 53160/udp
EXPOSE 8112
EXPOSE 58846
CMD ["/start.sh"]

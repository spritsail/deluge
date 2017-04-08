FROM alpine:3.5
MAINTAINER Adam Dodman <adam.dodman@gmx.com>

ENV UID=647 UNAME=deluge GID=990 GNAME=media
ENV PYTHON_EGG_CACHE=/config/eggcache

RUN addgroup -g $GID $GNAME \
 && adduser -SH -u $UID -G $GNAME -s /usr/sbin/nologin $UNAME \
 && echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk add --no-cache deluge@testing py2-pip \
 && pip install service_identity \
 && apk del --no-cache py2-pip

USER $UNAME

VOLUME ["/config", "/media"]
EXPOSE 53160
EXPOSE 53160/udp
EXPOSE 8112
EXPOSE 58846

COPY bin/* /usr/local/bin/

CMD ["start-deluge"]

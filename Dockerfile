FROM spritsail/alpine:3.8

ARG DELUGE_VER=1.3.15

LABEL maintainer="Spritsail <deluge@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Deluge" \
      org.label-schema.url="https://deluge-torrent.org/" \
      org.label-schema.description="Deluge Torrent client and web interface." \
      org.label-schema.version=${DELUGE_VER} \
      io.spritsail.version.deluge=${DELUGE_VER}

ENV UID=902 GID=900
ENV PYTHON_EGG_CACHE=/config/eggcache

COPY bin/* /usr/local/bin/

RUN apk --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
        --repository "http://dl-cdn.alpinelinux.org/alpine/edge/main" \
        --no-cache add deluge py2-pip \
 && pip2 --no-cache-dir install service_identity twisted \
 && apk --no-cache del py2-pip \
 && chmod +x /usr/local/bin/*

VOLUME ["/config", "/media"]
EXPOSE 53160
EXPOSE 53160/udp
EXPOSE 8112
EXPOSE 58846

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint"]
CMD ["start-deluge"]

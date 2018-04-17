FROM spritsail/alpine:edge

ARG DELUGE_VER

LABEL maintainer="Spritsail <deluge@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Deluge" \
      org.label-schema.url="https://deluge-torrent.org/" \
      org.label-schema.description="Deluge Torrent client and web interface." \
      org.label-schema.version=${DELUGE_VER}

ENV UID=902 GID=900
ENV PYTHON_EGG_CACHE=/config/eggcache

COPY bin/* /usr/local/bin/

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk add --no-cache deluge py2-pip \
 && pip install service_identity twisted \
 && apk del --no-cache py2-pip \
 && chmod +x /usr/local/bin/*

VOLUME ["/config", "/media"]
EXPOSE 53160
EXPOSE 53160/udp
EXPOSE 8112
EXPOSE 58846

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint"]
CMD ["start-deluge"]

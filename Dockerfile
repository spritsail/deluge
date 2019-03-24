FROM spritsail/alpine:3.9

ARG DELUGE_VER=1.3.15

LABEL maintainer="Spritsail <deluge@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Deluge" \
      org.label-schema.url="https://deluge-torrent.org/" \
      org.label-schema.description="Deluge Torrent client and web interface." \
      org.label-schema.version=${DELUGE_VER} \
      io.spritsail.version.deluge=${DELUGE_VER}

ENV SUID=902 SGID=900
ENV PYTHON_EGG_CACHE=/config/eggcache \
    LOGDIR=/config/logs

COPY bin/* /usr/local/bin/

RUN apk --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
        --repository "http://dl-cdn.alpinelinux.org/alpine/edge/main" \
        --no-cache add deluge py2-pip \
 && pip2 --no-cache-dir install service_identity twisted \
 && apk --no-cache del py2-pip \
 && chmod +x /usr/local/bin/*

HEALTHCHECK --start-period=10s --timeout=3s \
    CMD (if [ -p /tmp/deluge-web.log ]; then wget -qSO /dev/null http://0.0.0.0:8112/; fi) && \
        (if [ -p /tmp/deluged.log ]; then deluge-console "connect 0.0.0.0 $(sort /config/auth -k3,3 -nrt: | head -n1 | cut -d: -f1-2 | tr : ' ')" 2>&1 | wc -c | grep -qw 0; fi)

VOLUME /config
EXPOSE 8112
EXPOSE 53160
EXPOSE 53160/udp
EXPOSE 58846

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint"]
CMD ["start-deluge"]

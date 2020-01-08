FROM spritsail/alpine:edge AS build

ARG DELUGE_VER=2.0.3

RUN apk --no-cache add \
        gcc \
        git \
        jpeg-dev \
        libc-dev \
        python3-dev \
        zlib-dev

WORKDIR /tmp
# Do not shallow close as Deluge uses git information to generate a version
RUN git clone https://github.com/deluge-torrent/deluge.git . && \
    python3 version.py && \
    python3 setup.py install --root=/deluge --prefix=/usr && \
    \
    cd /deluge && \
    rm -rfv \
        $(find -type d -name __pycache__ -o -name .eggs) \
        usr/share \
        usr/bin/deluge-gtk \
        usr/lib/python*/*-packages/deluge/ui/gtk3/*

FROM spritsail/alpine:edge

LABEL maintainer="Spritsail <deluge@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Deluge" \
      org.label-schema.url="https://deluge-torrent.org/" \
      org.label-schema.description="Deluge Torrent client and web interface." \
      org.label-schema.version=${DELUGE_VER} \
      io.spritsail.version.deluge=${DELUGE_VER}

ENV SUID=902 SGID=900 \
    PYTHON_EGG_CACHE=/tmp/eggcache \
    LOGDIR=/config/logs

RUN apk --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" --no-cache add \
        #intltool \
        py3-chardet \
        py3-libtorrent-rasterbar \
        py3-mako \
        py3-openssl \
        py3-pillow \
        py3-rencode \
        py3-service_identity \
        py3-setproctitle \
        py3-twisted \
        py3-xdg

COPY bin/* /usr/local/bin/
COPY --from=build /deluge /

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

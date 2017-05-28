FROM alpine:3.6
MAINTAINER Adam Dodman <adam.dodman@gmx.com>

ENV UID=902 GID=900
ENV PYTHON_EGG_CACHE=/config/eggcache

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk add --no-cache deluge@testing py2-pip su-exec tini \
 && pip install service_identity twisted \
 && apk del --no-cache py2-pip

VOLUME ["/config", "/media"]
EXPOSE 53160
EXPOSE 53160/udp
EXPOSE 8112
EXPOSE 58846

COPY bin/* /usr/local/bin/

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint"]
CMD ["start-deluge"]

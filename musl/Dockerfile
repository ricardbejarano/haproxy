FROM alpine AS build

ARG PCRE_VERSION="8.43"
ARG PCRE_CHECKSUM="0b8e7465dc5e98c757cc3650a20a7843ee4c3edf50aaf60bb33fd879690d2c73"

ARG ZLIB_VERSION="1.2.11"
ARG ZLIB_CHECKSUM="c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"

ARG OPENSSL_VERSION="1.1.1c"
ARG OPENSSL_CHECKSUM="f6fb3079ad15076154eda9413fed42877d668e7069d9b87396d0804fdb3f4c90"

ARG LUA_VERSION="5.3.5"
ARG LUA_CHECKSUM="0c2eed3f960446e1a3e4b9a1ca2f3ff893b6ce41942cf54d5dd59ab4b3b058ac"

ARG HAPROXY_VERSION="2.0.0"
ARG HAPROXY_VERSION_SHORT="2.0"
ARG HAPROXY_CHECKSUM="fe0a0d69e1091066a91b8d39199c19af8748e0e872961c6fc43c91ec7a28ff20"
ARG HAPROXY_CONFIG="\
    -j 4 \
    TARGET=linux-glibc \
    USE_STATIC_PCRE=1 \
    USE_ZLIB=1 \
    USE_OPENSSL=1 \
    USE_LUA=1 \
    LUA_INC=/tmp/lua-$LUA_VERSION/src \
    LUA_SRC=/tmp/lua-$LUA_VERSION/src \
    LUA_LIB_NAME=lua \
    EXTRA_OBJS=contrib/prometheus-exporter/service-prometheus.o"

ADD https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERSION.tar.gz /tmp/pcre.tar.gz
ADD https://zlib.net/zlib-$ZLIB_VERSION.tar.gz /tmp/zlib.tar.gz
ADD https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz /tmp/openssl.tar.gz
ADD https://www.lua.org/ftp/lua-$LUA_VERSION.tar.gz /tmp/lua.tar.gz
ADD https://www.haproxy.org/download/$HAPROXY_VERSION_SHORT/src/haproxy-$HAPROXY_VERSION.tar.gz /tmp/haproxy.tar.gz

RUN if [ "$PCRE_CHECKSUM" != "$(sha256sum /tmp/pcre.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar -C /tmp -xf /tmp/pcre.tar.gz && \
    if [ "$ZLIB_CHECKSUM" != "$(sha256sum /tmp/zlib.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar -C /tmp -xf /tmp/zlib.tar.gz && \
    if [ "$OPENSSL_CHECKSUM" != "$(sha256sum /tmp/openssl.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar -C /tmp -xf /tmp/openssl.tar.gz && \
    if [ "$LUA_CHECKSUM" != "$(sha256sum /tmp/lua.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar -C /tmp -xf /tmp/lua.tar.gz && \
    if [ "$HAPROXY_CHECKSUM" != "$(sha256sum /tmp/haproxy.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar -C /tmp -xf /tmp/haproxy.tar.gz && \
    mv /tmp/haproxy-$HAPROXY_VERSION /tmp/haproxy

RUN apk add gcc g++ perl make readline-dev linux-headers && \
    cd /tmp/pcre-$PCRE_VERSION && \
      ./configure --disable-shared && \
      make && \
      make install && \
    cd /tmp/zlib-$ZLIB_VERSION && \
      ./configure --static && \
      make && \
      make install && \
    cd /tmp/openssl-$OPENSSL_VERSION && \
      ./config no-shared && \
      make && \
      make install && \
    cd /tmp/lua-$LUA_VERSION && \
      make linux install && \
    cd /tmp/haproxy && \
      make $HAPROXY_CONFIG


FROM scratch

COPY --from=build /lib/ld-musl-x86_64.so.1 /lib/
COPY --from=build /tmp/haproxy/haproxy /

COPY rootfs /

EXPOSE 80/tcp
STOPSIGNAL SIGUSR1
ENTRYPOINT ["/haproxy"]
CMD ["-f", "/etc/haproxy/haproxy.cfg"]

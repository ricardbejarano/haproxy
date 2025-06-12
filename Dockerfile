FROM docker.io/alpine:3 AS build-base
RUN apk add \
      build-base \
      linux-headers \
      perl

FROM build-base AS build-openssl
WORKDIR /tmp/openssl
ARG OPENSSL_VERSION='3.5.0'
ADD --checksum=sha256:344d0a79f1a9b08029b0744e2cc401a43f9c90acd1044d09a530b4885a8e9fc0 https://github.com/openssl/openssl/releases/download/openssl-$OPENSSL_VERSION/openssl-$OPENSSL_VERSION.tar.gz /tmp/openssl.tar.gz
RUN tar -xzvf /tmp/openssl.tar.gz --strip-components=1 \
    && ./config --prefix='/opt/openssl' --no-shared \
    && make -j"$(nproc)" \
    && make install

FROM build-base AS build-pcre
WORKDIR /tmp/pcre
ARG PCRE_VERSION='10.45'
ADD --checksum=sha256:0e138387df7835d7403b8351e2226c1377da804e0737db0e071b48f07c9d12ee https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$PCRE_VERSION/pcre2-$PCRE_VERSION.tar.gz /tmp/pcre.tar.gz
RUN tar -xzvf /tmp/pcre.tar.gz --strip-components=1 \
    && ./configure --prefix='/opt/pcre' --disable-shared --enable-static \
    && make -j"$(nproc)" \
    && make install

FROM build-base AS build-zlib
WORKDIR /tmp/zlib
ARG ZLIB_VERSION='1.3.1'
ADD --checksum=sha256:9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23 https://zlib.net/zlib-$ZLIB_VERSION.tar.gz /tmp/zlib.tar.gz
RUN tar -xzvf /tmp/zlib.tar.gz --strip-components=1 \
    && ./configure --prefix='/opt/zlib' --static \
    && make -j"$(nproc)" \
    && make install

FROM build-base AS build
RUN apk add \
      ca-certificates
WORKDIR /tmp/haproxy
ADD --checksum=sha256:f762ae31bca1b51feb89e4395e36e17f867c25372a10853c70d292c3dd17b7b0 https://www.haproxy.org/download/3.2/src/haproxy-3.2.1.tar.gz /tmp/haproxy.tar.gz
RUN tar -xzvf /tmp/haproxy.tar.gz --strip-components=1
COPY --from=build-openssl /opt/openssl ./openssl
COPY --from=build-pcre /opt/pcre ./pcre
COPY --from=build-zlib /opt/zlib ./zlib
RUN make \
      -j"$(nproc)" \
      TARGET='linux-musl' \
      LDFLAGS='-static' \
      USE_OPENSSL='1' SSL_INC='openssl/include' SSL_LIB='openssl/lib64' \
      USE_PCRE2='1' PCRE2_INC='pcre/include' PCRE2_LIB='pcre/lib' \
      USE_ZLIB='1' ZLIB_INC='zlib/include' ZLIB_LIB='zlib/lib'
RUN mkdir /rootfs \
    && mkdir /rootfs/bin \
      && cp /tmp/haproxy/haproxy /rootfs/bin/ \
    && mkdir /rootfs/etc \
      && echo 'nogroup:*:10000:nobody' > /rootfs/etc/group \
      && echo 'nobody:*:10000:10000:::' > /rootfs/etc/passwd \
    && mkdir -p /rootfs/etc/ssl/certs \
      && cp /etc/ssl/certs/ca-certificates.crt /rootfs/etc/ssl/certs/

FROM scratch
COPY --from=build --chown=10000:10000 /rootfs /
USER 10000:10000
STOPSIGNAL SIGUSR1
ENTRYPOINT ["/bin/haproxy"]
CMD ["-W", "-f", "/etc/haproxy/haproxy.cfg"]

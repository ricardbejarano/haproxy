FROM docker.io/alpine:3 AS build-base
RUN apk add \
      build-base \
      linux-headers \
      perl

FROM build-base AS build-openssl
WORKDIR /tmp/openssl
ARG OPENSSL_VERSION="4.0.0"
ADD --checksum=sha256:c32cf49a959c4f345f9606982dd36e7d28f7c58b19c2e25d75624d2b3d2f79ac https://github.com/openssl/openssl/releases/download/openssl-$OPENSSL_VERSION/openssl-$OPENSSL_VERSION.tar.gz /tmp/openssl.tar.gz
RUN tar -xzvf /tmp/openssl.tar.gz --strip-components=1 \
    && ./config --prefix=/opt/openssl --no-shared \
    && make -j"$(nproc)" \
    && make install

FROM build-base AS build-pcre
WORKDIR /tmp/pcre
ARG PCRE_VERSION="10.47"
ADD --checksum=sha256:c08ae2388ef333e8403e670ad70c0a11f1eed021fd88308d7e02f596fcd9dc16 https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$PCRE_VERSION/pcre2-$PCRE_VERSION.tar.gz /tmp/pcre.tar.gz
RUN tar -xzvf /tmp/pcre.tar.gz --strip-components=1 \
    && ./configure --prefix=/opt/pcre --disable-shared --enable-static \
    && make -j"$(nproc)" \
    && make install

FROM build-base AS build-zlib
WORKDIR /tmp/zlib
ARG ZLIB_VERSION="1.3.2"
ADD --checksum=sha256:bb329a0a2cd0274d05519d61c667c062e06990d72e125ee2dfa8de64f0119d16 https://zlib.net/zlib-$ZLIB_VERSION.tar.gz /tmp/zlib.tar.gz
RUN tar -xzvf /tmp/zlib.tar.gz --strip-components=1 \
    && ./configure --prefix=/opt/zlib --static \
    && make -j"$(nproc)" \
    && make install

FROM build-base AS build
RUN apk add \
      ca-certificates
WORKDIR /tmp/haproxy
ADD --checksum=sha256:c243e17281f79fa81a321e0b846ce67897315570de1b8ccff6ca6b7a312683fc https://www.haproxy.org/download/3.3/src/haproxy-3.3.7.tar.gz /tmp/haproxy.tar.gz
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

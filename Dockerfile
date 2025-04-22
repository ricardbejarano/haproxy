FROM alpine:3 AS build

ARG VERSION="3.0.10"
ARG VERSION_SHORT="3.0"
ARG CHECKSUM="d1508670b6fd5839c669a0a916842f0d3d3d0b578bb351a2a74a1de3d929ce26"

ADD https://www.haproxy.org/download/$VERSION_SHORT/src/haproxy-$VERSION.tar.gz /tmp/haproxy.tar.gz

RUN [ "$(sha256sum /tmp/haproxy.tar.gz | awk '{print $1}')" = "$CHECKSUM" ] && \
    apk add build-base ca-certificates linux-headers openssl-dev && \
    tar -C /tmp -xf /tmp/haproxy.tar.gz && \
    cd /tmp/haproxy-$VERSION && \
      make \
        -j 4 \
        TARGET="linux-musl" \
        USE_OPENSSL="1"

RUN ldd /tmp/haproxy-$VERSION/haproxy
RUN mkdir -p /rootfs/bin && \
      cp /tmp/haproxy-$VERSION/haproxy /rootfs/bin/ && \
    mkdir -p /rootfs/etc && \
      echo "nogroup:*:10000:nobody" > /rootfs/etc/group && \
      echo "nobody:*:10000:10000:::" > /rootfs/etc/passwd && \
    mkdir -p /rootfs/etc/ssl/certs && \
      cp /etc/ssl/certs/ca-certificates.crt /rootfs/etc/ssl/certs/ && \
    mkdir -p /rootfs/lib && \
      cp /lib/ld-musl-*.so.1 /rootfs/lib/ && \
    mkdir -p /rootfs/usr/lib && \
      cp /usr/lib/libssl.so.3 /rootfs/usr/lib/ && \
      cp /usr/lib/libcrypto.so.3 /rootfs/usr/lib/


FROM scratch

COPY --from=build --chown=10000:10000 /rootfs /

USER 10000:10000
STOPSIGNAL SIGUSR1
ENTRYPOINT ["/bin/haproxy"]
CMD ["-f", "/haproxy.cfg"]

FROM alpine:3 AS build

ARG VERSION="2.4.19"
ARG VERSION_SHORT="2.4"
ARG CHECKSUM="99bd348a2b0ec58ce99510c4b6a2316e1f88137e59c4d8e0f39a2ecb3415a682"

ADD https://www.haproxy.org/download/$VERSION_SHORT/src/haproxy-$VERSION.tar.gz /tmp/haproxy.tar.gz

RUN [ "$(sha256sum /tmp/haproxy.tar.gz | awk '{print $1}')" = "$CHECKSUM" ] && \
    apk add build-base ca-certificates linux-headers openssl-dev && \
    tar -C /tmp -xf /tmp/haproxy.tar.gz && \
    cd /tmp/haproxy-$VERSION && \
      make \
        -j 4 \
        TARGET="linux-musl" \
        USE_OPENSSL="1"

RUN mkdir -p /rootfs/bin && \
      cp /tmp/haproxy-$VERSION/haproxy /rootfs/bin/ && \
    mkdir -p /rootfs/etc && \
      echo "nogroup:*:10000:nobody" > /rootfs/etc/group && \
      echo "nobody:*:10000:10000:::" > /rootfs/etc/passwd && \
    mkdir -p /rootfs/etc/ssl/certs && \
      cp /etc/ssl/certs/ca-certificates.crt /rootfs/etc/ssl/certs/ && \
    mkdir -p /rootfs/lib && \
      cp /lib/libssl.so.1.1 /rootfs/lib/ && \
      cp /lib/libcrypto.so.1.1 /rootfs/lib/ && \
      cp /lib/ld-musl-*.so.1 /rootfs/lib/


FROM scratch

COPY --from=build --chown=10000:10000 /rootfs /

USER 10000:10000
STOPSIGNAL SIGUSR1
ENTRYPOINT ["/bin/haproxy"]
CMD ["-f", "/haproxy.cfg"]

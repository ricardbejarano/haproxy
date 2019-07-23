<p align=center><img src=https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/155/racing-car_1f3ce.png width=120px></p>
<h1 align=center>haproxy (container image)</h1>
<p align=center>Built-from-source container image of the <a href=https://www.haproxy.org/>haproxy HTTP server</a></p>


## Tags

### Docker Hub

Available on [Docker Hub](https://hub.docker.com) as [`ricardbejarano/haproxy`](https://hub.docker.com/r/ricardbejarano/haproxy):

- [`2.0.2-glibc`, `2.0.2`, `glibc`, `master`, `latest` *(Dockerfile.glibc)*](https://github.com/ricardbejarano/haproxy/blob/master/Dockerfile.glibc)
- [`2.0.2-musl`, `musl` *(Dockerfile.musl)*](https://github.com/ricardbejarano/haproxy/blob/master/Dockerfile.musl)

### Quay

Available on [Quay](https://quay.io) as:

- [`quay.io/ricardbejarano/haproxy-glibc`](https://quay.io/repository/ricardbejarano/haproxy-glibc), tags: [`2.0.2`, `master`, `latest` *(Dockerfile.glibc)*](https://github.com/ricardbejarano/haproxy/blob/master/Dockerfile.glibc)
- [`quay.io/ricardbejarano/haproxy-musl`](https://quay.io/repository/ricardbejarano/haproxy-musl), tags: [`2.0.2`, `master`, `latest` *(Dockerfile.musl)*](https://github.com/ricardbejarano/haproxy/blob/master/Dockerfile.musl)


## Features

* Super tiny (`glibc`-based is `~11.8MB` and `musl`-based is `~19.9MB`)
* Compiled from source during build time
* Built `FROM scratch`, see [Filesystem](#filesystem) for an exhaustive list of the image's contents
* Reduced attack surface (no shell, no UNIX tools, no package manager...)
* Built with binary exploit mitigations enabled
* Includes [official Prometheus exporter module](https://www.haproxy.com/blog/haproxy-exposes-a-prometheus-metrics-endpoint/)


## Configuration

### Volumes

- Bind your **configuration** at `/etc/haproxy/haproxy.cfg`.


## Building

- To build the `glibc`-based image: `$ docker build -t haproxy:glibc -f Dockerfile.glibc .`
- To build the `musl`-based image: `$ docker build -t haproxy:musl -f Dockerfile.musl .`


## Filesystem

The images' contents are:

### `glibc`

Based on the [glibc](https://www.gnu.org/software/libc/) implementation of `libc`. Dynamically linked.

```
/
├── etc/
│   ├── group
│   ├── haproxy/
│   │   └── haproxy.cfg
│   └── passwd
├── haproxy
├── lib/
│   └── x86_64-linux-gnu/
│       ├── libc.so.6
│       ├── libcrypt.so.1
│       ├── libcrypto.so.1.1
│       ├── libdl.so.2
│       ├── libm.so.6
│       ├── libnss_dns.so.2
│       ├── libnss_files.so.2
│       ├── libpcre.so.1
│       ├── libpcreposix.so.0
│       ├── libpthread.so.0
│       ├── libresolv.so.2
│       ├── librt.so.1
│       ├── libssl.so.1.1
│       └── libz.so.1
└── lib64/
    └── ld-linux-x86-64.so.2
```

### `musl`

Based on the [musl](https://www.musl-libc.org/) implementation of `libc`. Statically linked (with the exception of `ld-musl-x86_64.so.1`).

```
/
├── etc/
│   ├── group
│   ├── haproxy/
│   │   └── haproxy.cfg
│   └── passwd
├── haproxy
└── lib/
    └── ld-musl-x86_64.so.1
```


## License

See [LICENSE](https://github.com/ricardbejarano/haproxy/blob/master/LICENSE).

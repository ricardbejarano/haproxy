<p align="center"><img src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/155/racing-car_1f3ce.png" width="120px"></p>
<h1 align="center">haproxy (container image)</h1>
<p align="center">Built-from-source container image of the <a href="https://www.haproxy.org/">HAProxy proxy and load balancer</a></p>


## Tags

### Docker Hub

Available on [Docker Hub](https://hub.docker.com) as [`ricardbejarano/haproxy`](https://hub.docker.com/r/ricardbejarano/haproxy):

- [`2.1.0-glibc`, `2.1.0`, `glibc`, `master`, `latest` *(Dockerfile.glibc)*](https://github.com/ricardbejarano/haproxy/blob/master/Dockerfile.glibc) (about `12.5MB`)
- [`2.1.0-musl`, `musl` *(Dockerfile.musl)*](https://github.com/ricardbejarano/haproxy/blob/master/Dockerfile.musl) (about `19.9MB`)

### Quay

Available on [Quay](https://quay.io) as:

- [`quay.io/ricardbejarano/haproxy-glibc`](https://quay.io/repository/ricardbejarano/haproxy-glibc), tags: [`2.1.0`, `master`, `latest` *(Dockerfile.glibc)*](https://github.com/ricardbejarano/haproxy/blob/master/Dockerfile.glibc) (about `12.5MB`)
- [`quay.io/ricardbejarano/haproxy-musl`](https://quay.io/repository/ricardbejarano/haproxy-musl), tags: [`2.1.0`, `master`, `latest` *(Dockerfile.musl)*](https://github.com/ricardbejarano/haproxy/blob/master/Dockerfile.musl) (about `19.9MB`)


## Features

* Super tiny (see [Tags](#tags))
* Compiled from source (with binary exploit mitigations) during build time
* Built `FROM scratch`, with zero bloat (see [Filesystem](#filesystem))
* Reduced attack surface (no shell, no UNIX tools, no package manager...)
* Runs as unprivileged (non-`root`) user


## Configuration

### Volumes

- Mount your **configuration** at `/haproxy.cfg`.


## Building

- To build the `glibc`-based image: `$ docker build -t haproxy:glibc -f Dockerfile.glibc .`
- To build the `musl`-based image: `$ docker build -t haproxy:musl -f Dockerfile.musl .`


## Filesystem

### `glibc`

Based on the [glibc](https://www.gnu.org/software/libc/) implementation of `libc`. Dynamically linked.

```
/
├── etc/
│   ├── group
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

Based on the [musl](https://www.musl-libc.org/) implementation of `libc`. Dynamically linked.

```
/
├── etc/
│   ├── group
│   └── passwd
├── haproxy
└── lib/
    └── ld-musl-x86_64.so.1
```


## License

See [LICENSE](https://github.com/ricardbejarano/haproxy/blob/master/LICENSE).

<p align=center><img src=https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/155/racing-car_1f3ce.png width=120px></p>
<h1 align=center>haproxy (Docker image)</h1>
<p align=center>Built-from-source container image of the <a href=https://www.haproxy.org/>haproxy HTTP server</a></p>

Available at [`ricardbejarano/haproxy`](https://hub.docker.com/r/ricardbejarano/haproxy).


## Tags

[`1.9.6-glibc`, `1.9.6`, `glibc`, `latest` *(glibc/Dockerfile)*](https://github.com/ricardbejarano/haproxy/blob/master/glibc/Dockerfile)

[`1.9.6-musl`, `musl` *(musl/Dockerfile)*](https://github.com/ricardbejarano/haproxy/blob/master/musl/Dockerfile)


## Features

* Super tiny (`glibc`-based is `~11.6MB` and `musl`-based is `~19.2MB`)
* Built from source, including libraries
* Built `FROM scratch`, see the [Filesystem](#Filesystem) section below for an exhaustive list of the image's contents
* Reduced attack surface (no `bash`, no UNIX tools, no package manager...)
* Built with exploit mitigations enabled (see [Security](#Security))


## Building

To build the `glibc`-based image:

```bash
docker build -t haproxy:glibc -f glibc/Dockerfile .
```

To build the `musl`-based image:

```bash
docker build -t haproxy:musl -f musl/Dockerfile .
```


## Security

This image attempts to build a secure HAProxy Docker image.

It does so by the following ways:

- downloading and verifying the source code of HAProxy and every library it is built with,
- packaging the image with only those files required during runtime (see [Filesystem](#Filesystem)),
- by enforcing a series of exploit mitigations (PIE, full RELRO, full SSP, NX and Fortify)

### Verifying the presence of exploit mitigations

To check whether a binary in a Docker image has those mitigations enabled, use [tests/checksec.sh](https://github.com/ricardbejarano/haproxy/blob/master/tests/checksec.sh).

#### Usage

```
usage: checksec.sh docker_image executable_path

Docker-based wrapper for checksec.sh.
Requires a running Docker daemon.

Example:

  $ checksec.sh ricardbejarano/haproxy:glibc /haproxy

  Extracts the '/haproxy' binary from the 'ricardbejarano/haproxy:glibc' image,
  downloads checksec (github.com/slimm609/checksec.sh) and runs it on the
  binary.
  Everything runs inside Docker containers.
```

#### Example:

Testing the `/haproxy` binary in `ricardbejarano/haproxy:glibc`:

```
$ bash tests/checksec.sh ricardbejarano/haproxy:glibc /haproxy
Downloading ricardbejarano/haproxy:glibc...Done!
Extracting ricardbejarano/haproxy:glibc:/haproxy...Done!
Downloading checksec.sh...Done!
Running checksec.sh:
RELRO        STACK CANARY   NX           PIE           RPATH      RUNPATH      Symbols         FORTIFY   Fortified   Fortifiable   FILE
Full RELRO   Canary found   NX enabled   PIE enabled   No RPATH   No RUNPATH   8807 Symbols    Yes       0           38            /tmp/.checksec-PdU8rBVu
Cleaning up...Done!
```

This wrapper script works with any binary in a Docker image. Feel free to use it with any other image.

Other examples:

- `bash tests/checksec.sh debian /bin/bash`
- `bash tests/checksec.sh alpine /bin/sh`
- `bash tests/checksec.sh haproxy /usr/local/sbin/haproxy`


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

Based on the [musl](https://www.musl-libc.org/) implementation of `libc`. Dynamically linked.

```
/
├── etc/
│   ├── group
│   ├── haproxy/
│   │   └── haproxy.cfg
│   └── passwd
├── haproxy
└── lib/
    ├── ld-musl-x86_64.so.1
    ├── libcrypto.so.1.1
    ├── libpcre.so.1
    ├── libssl.so.1.1
    └── libz.so.1
```


## License

See [LICENSE](https://github.com/ricardbejarano/haproxy/blob/master/LICENSE).

<p align="center"><img src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/155/racing-car_1f3ce.png" width="120px"></p>
<h1 align="center">haproxy (container image)</h1>
<p align="center">Built-from-source container image of the <a href="https://www.haproxy.org/">HAProxy</a> load balancer</p>


## Tags

### Docker Hub

Available on Docker Hub as [`docker.io/ricardbejarano/haproxy`](https://hub.docker.com/r/ricardbejarano/haproxy):

- [`2.2.14`, `latest` *(Dockerfile)*](Dockerfile)

### RedHat Quay

Available on RedHat Quay as [`quay.io/ricardbejarano/haproxy`](https://quay.io/repository/ricardbejarano/haproxy):

- [`2.2.14`, `latest` *(Dockerfile)*](Dockerfile)


## Features

* Compiled from source during build time
* Built `FROM scratch`, with zero bloat
* Statically linked to the [`musl`](https://musl.libc.org/) implementation of the C standard library
* Reduced attack surface (no shell, no UNIX tools, no package manager...)
* Runs as unprivileged (non-`root`) user


## Building

```bash
docker build --tag ricardbejarano/haproxy --file Dockerfile .
```


## Configuration

### Volumes

- Mount your **configuration** at `/haproxy.cfg`.


## License

MIT licensed, see [LICENSE](LICENSE) for more details.

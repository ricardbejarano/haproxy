<div align="center">
	<p><img src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/160/apple/325/racing-car_1f3ce-fe0f.png" width="100px"></p>
	<h1>haproxy</h1>
	<p>Built-from-source container image of <a href="https://www.haproxy.org/">HAProxy</a></p>
	<code>docker pull quay.io/ricardbejarano/haproxy</code>
</div>


## Features

* Compiled from source during build time
* Built `FROM scratch`, with zero bloat
* Reduced attack surface (no shell, no UNIX tools, no package manager...)
* Runs as unprivileged (non-`root`) user


## Tags

### Docker Hub

Available on Docker Hub as [`docker.io/ricardbejarano/haproxy`](https://hub.docker.com/r/ricardbejarano/haproxy):

- [`2.6.10`, `latest` *(Dockerfile)*](Dockerfile)

### RedHat Quay

Available on RedHat Quay as [`quay.io/ricardbejarano/haproxy`](https://quay.io/repository/ricardbejarano/haproxy):

- [`2.6.10`, `latest` *(Dockerfile)*](Dockerfile)


## Configuration

### Volumes

- Mount your **configuration** at `/haproxy.cfg`.

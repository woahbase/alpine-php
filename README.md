[![Build Status](https://travis-ci.org/woahbase/alpine-php.svg?branch=master)](https://travis-ci.org/woahbase/alpine-php)

[![](https://images.microbadger.com/badges/image/woahbase/alpine-php.svg)](https://microbadger.com/images/woahbase/alpine-php)

[![](https://images.microbadger.com/badges/commit/woahbase/alpine-php.svg)](https://microbadger.com/images/woahsbase/alpine-php)

[![](https://images.microbadger.com/badges/version/woahbase/alpine-php.svg)](https://microbadger.com/images/woahbase/alpine-php)

## Alpine-PHP
#### Container for Alpine Linux + PHP

---

This [image][8] serves as a standalone web hosting/proxy server,
or as the base container for applications / services that require
[NGINX][12] and [PHP][13].

Built from my [alpine-nginx][9] image with the [s6][10] init
system [overlayed][11] in it.

Updated with latest php7 packages and proxied out through NGINX,
which is also used to serve the static files.

The image is tagged respectively for the following architectures,
* **armhf**
* **x86_64**

**armhf** builds have embedded binfmt_misc support and contain the
[qemu-user-static][5] binary that allows for running it also inside
an x64 environment that has it.

---
#### Get the Image
---

Pull the image for your architecture it's already available from
Docker Hub.

```
# make pull
docker pull woahbase/alpine-php:x86_64

```

---
#### Configurations
---

* These configurations are inherited from the nginx image:

    * Binds to both http(80) and https(443). Publish whichever you
    need, or both with automatic SSL bump.

    * Default configs setup a static site at `/` by copying
    `/defaults/index.html` at the webroot location `/config/www/`.
    Mount the `/config/` locally to persist modifications (or your
    webapps). NGINX configs are at `/config/nginx`, and vhosts at
    `/config/nginx/site-confs/`. For JSON indexable storage mount
    the data partition at `/storage/`.

    * 4096bit Self-signed SSL certificate is generated in first run at
    `/config/keys`. Pass the runtime variable `SSLSUBJECT` with
    a valid info string to make your own.

    * `.htpasswd` is generated with default credentials
    `admin/insecurebydefault` at `/config/keys/.htpasswd`

    * Sets up a https and auth protected web location at `/secure`.

    * If you're proxying multiple containers at the same host, or
    reverse proxying multiple hosts at the same container, you may
    need to add `--net=host` and/or add entries in your firewall to
    allow traffic.

* These packages below are installed by default into the image.

    * php7-fpm
    * php7-curl
    * php7-mcrypt
    * php7-mbstring
    * php7-openssl
    * php7-pcntl
    * php7-json

---
#### Run
---

If you want to run images for other architectures, you will need
to have binfmt support configured for your machine. [**multiarch**][4],
has made it easy for us containing that into a docker container.

```
# make regbinfmt
docker run --rm --privileged multiarch/qemu-user-static:register --reset

```
Without the above, you can still run the image that is made for your
architecture, e.g for an x86_64 machine..

```
# make
docker run --rm -it \
  --name docker_php --hostname php \
  -e PGID=100 -e PUID=1000 \
  -e WEBADMIN=admin
  -e PASSWORD=insecurebydefault \
  -c 64 -m 64m \
  -p 80:80 -p 443:443 \
  -v config:/config  \
  -v config/storage:/storage:ro \
  -v /etc/hosts:/etc/hosts:ro \
  -v /etc/localtime:/etc/localtime:ro \
  woahbase/alpine-php:x86_64

# make stop
docker stop -t 2 docker_php

# make rm
# stop first
docker rm -f docker_php

# make restart
docker restart docker_php

```

---
#### Shell access
---

```
# make rshell
docker exec -u root -it docker_php /bin/bash

# make shell
docker exec -it docker_php /bin/bash

# make logs
docker logs -f docker_php

```

---
## Development
---

If you have the repository access, you can clone and
build the image yourself for your own system, and can push after.

---
#### Setup
---

Before you clone the [repo][7], you must have [Git][1], [GNU make][2],
and [Docker][3] setup on the machine.

```
git clone https://github.com/woahbase/alpine-php
cd alpine-php

```
You can always skip installing **make** but you will have to
type the whole docker commands then instead of using the sweet
make targets.

---
#### Build
---

You need to have binfmt_misc configured in your system to be able
to build images for other architectures.

Otherwise to locally build the image for your system.

```
# make ARCH=x86_64 build
# sets up binfmt if not x86_64
docker build --rm --compress --force-rm \
  --no-cache=true --pull \
  -f ./Dockerfile_x86_64 \
  -t woahbase/alpine-php:x86_64 \
  --build-arg ARCH=x86_64 \
  --build-arg DOCKERSRC=alpine-nginx \
  --build-arg USERNAME=woahbase \
  --build-arg PUID=1000 \
  --build-arg PGID=1000

# make ARCH=x86_64 test
docker run --rm -it \
  --name docker_php --hostname php \
  woahbase/alpine-php:x86_64 \
  php --version

# make ARCH=x86_64 push
docker push woahbase/alpine-php:x86_64

```

---
## Maintenance
---

Built at Travis.CI (armhf / x64 builds). Docker hub builds maintained by [woahbase][6].

[1]: https://git-scm.com
[2]: https://www.gnu.org/software/make/
[3]: https://www.docker.com
[4]: https://hub.docker.com/r/multiarch/qemu-user-static/
[5]: https://github.com/multiarch/qemu-user-static/releases/
[6]: https://hub.docker.com/u/woahbase

[7]: https://github.com/woahbase/alpine-php
[8]: https://hub.docker.com/r/woahbase/alpine-php
[9]: https://hub.docker.com/r/woahbase/alpine-nginx

[10]: https://skarnet.org/software/s6/
[11]: https://github.com/just-containers/s6-overlay
[12]: https://nginx.org
[13]: http://php.net/

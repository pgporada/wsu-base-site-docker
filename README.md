# Overview

![base working in containers](./imgs/base1.png)
![starting containers](./imgs/docker1.png)
![frontend magic stuff](./imgs/docker2.png)

# How to use this stuff
Pull down the Wayne State University `base-site` repository inside of _this_ repository i.e.
```
git clone https://github.com/pgporada/wsu-base-site-docker
cd wsu-base-site-docker
git clone https://github.com/waynestate/base-site
cp base-site/.env.example base-site/.env
sed -i.bak -E 's/^REDIS_HOST=localhost$/REDIS_HOST=wsu-redis/' base-site/.env
```

Run the containers or shut them down
```
docker compose up
docker compose down
```

Now, do development work locally on your machine and watch as the changes are reflected in the docker container and via the `make watch` command.

To view running container information:
```
docker ps
```

To see what containers are downloaded on your machine:
```
docker images
```

To access a container, keep in mine that ports are mapped `LOCAL:REMOTE` meaning that `0.0.0.0:32678:3000` means you can access `localhost:32678` in a web browser and traffic destined for there will be sent to port 3000/tcp inside the container.

# Building a new container
The first time you run the build, PHP and PHP-FPM will be compiled based on the version of PHP stored in `./base-site/.phpbrewrc` which can take upwards of 20 minutes on a `11th Gen Intel(R) Core(TM) i7-1165G7 @ 2.80GHz`. Subsequent runs of build will take seconds because of how container layer caching works.
```
./build.sh

docker tag wsu-base-container pgporada/php:8.0.13
docker push pgporada/php:8.0.13
```

# Oddities and Considerations
[Base](https://github.com/waynestate/base-site) has many references to `.wayne.local`. The `.local` suffix is specifically intended for mDNS per [RFC 6762](https://datatracker.ietf.org/doc/html/rfc6762#section-3) which means that base is _doing the wrong thing_, but it's been in use for so long that changing habits is more difficult than pushing a boulder up a mountain so what do we do? Well, if we were to change, the `.localhost` domain will **always** resolve to the loopback address (typically 127.0.0.1 or ::1) depending on IPv4/IPv6 per [RFC 6761](https://www.rfc-editor.org/rfc/rfc6761.html#section-6.3). Alternatively, a developer runs a local DNS server that will resolve `*.local` addresses. Examples of this in the past would be using `vagrant-dns` and `NetworkManager` which both use `dnsmasq` under the hood.

# Additional reading
https://gist.github.com/soifou/404b4403b370b6203e6d145ba9846fcc

https://github.com/nickdenardis/docker-php

https://blog.joshwalsh.me/docker-nginx-php-fpm/

https://aschmelyun.com/blog/fixing-permissions-issues-with-docker-compose-and-php/

https://www.digitalocean.com/community/tutorials/how-to-set-up-laravel-nginx-and-mysql-with-docker-compose-on-ubuntu-20-04

[Setting up Traefik with dnsmasq or NetworkManager](https://www.adaltas.com/en/2022/11/17/traefik-docker-dnsmasq/)

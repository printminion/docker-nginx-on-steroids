FROM buildpack-deps:jessie-curl

MAINTAINER Alexey Zhokhov <alexey@zhokhov.com>

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

ENV NGINX_VERSION 1.10.0-1

RUN curl 'https://bintray.com/user/downloadSubjectPublicKey?username=bintray' | apt-key add -
RUN echo "deb http://dl.bintray.com/donbeave/deb jessie main" >> /etc/apt/sources.list

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install \
       luajit \
       libluajit-5.1-2 \
       ca-certificates \
       nginx-on-steroids=${NGINX_VERSION} \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/nginx

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

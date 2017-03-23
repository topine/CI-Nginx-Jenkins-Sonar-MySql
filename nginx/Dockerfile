FROM ubuntu:16.04
MAINTAINER Anderson Topine <support@topine.eu>

RUN groupadd -g 1000 nginx
RUN useradd -g nginx -s /bin/false -u 1000 -d /etc/nginx nginx

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y nginx vim curl apt-transport-https && \
    apt-get clean

RUN mkdir -p /var/docker /var/www /opt

VOLUME ["/var/docker", "/var/www","/opt"]

ADD nginx.conf /tmp/nginx.conf
ADD start.sh /usr/local/bin/nginx_start.sh 

EXPOSE 80 443
CMD ["/usr/local/bin/nginx_start.sh"]

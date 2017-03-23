#! /bin/bash -e

for D in /var/docker/conf/conf.d /var/docker/conf/sites-available /var/docker/conf/sites-enabled
 do
    if [ ! -e $D ]; then
       mkdir -p $D
    fi
 done

if [ ! -e /var/docker/conf/nginx.conf ]; then
   mv /tmp/nginx.conf /var/docker/conf/nginx.conf
fi

rm -rf /etc/nginx /var/log/nginx

ln -s /var/docker/conf /etc/nginx
ln -s /var/docker/logs /var/log/nginx

/etc/init.d/nginx start

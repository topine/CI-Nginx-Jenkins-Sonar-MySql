# How to use this image

docker run --name mysql  -v /opt/mysql:/var/lib/mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=welcome -d topineeu/mysql

Where :

-v /opt/mysql:/var/lib/mysql    : Place you are going to store the data in the host

MYSQL_ROOT_PASSWORD=welcome     : Root user password of the first time the image is executed if no data exists


#!/bin/sh

if [ "$1" = "httpd" ]; then

    HOSTNAME=$(hostname)
    sed -i "s|#ServerName\ www.example.com:80|ServerName\ ${HOSTNAME}:8080|" /etc/apache2/httpd.conf
    sed -i "s#/var/www/localhost/htdocs#${DOCUMENT_ROOT:-/app}#" /etc/apache2/httpd.conf
    sed -i "s#Timeout\ 60#Timeout\ 600#" /etc/apache2/httpd.conf

    XDEBUG_CLIENT_HOST=${XDEBUG_CLIENT_HOST:-`ip r | awk '/default/{print $3}'`}
    XDEBUG_CLIENT_PORT=${XDEBUG_CLIENT_PORT:-9003}
    printf "\
zend_extension=xdebug.so\n\
xdebug.mode=debug\n\
xdebug.start_with_request=yes\n\
xdebug.client_host=${XDEBUG_CLIENT_HOST}\n\
xdebug.client_port=${XDEBUG_CLIENT_PORT}\n\
xdebug.discover_client_host=false\n" > /etc/php7/conf.d/xdebug.ini

fi

exec "$@"
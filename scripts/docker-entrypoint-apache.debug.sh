#!/bin/sh

if [ "$1" = "httpd" ]; then

    HOSTNAME=$(hostname)
    sed -i "s|#ServerName\ www.example.com:80|ServerName\ ${HOSTNAME}:8080|" /etc/apache2/httpd.conf
    sed -i "s#/var/www/localhost/htdocs#${DOCUMENT_ROOT:-/app}#" /etc/apache2/httpd.conf
    sed -i "s#Timeout\ 60#Timeout\ 600#" /etc/apache2/httpd.conf

    XDEBUG_REMOTE_HOST=${XDEBUG_REMOTE_HOST:-`ip r | awk '/default/{print $3}'`}
    XDEBUG_REMOTE_PORT=${XDEBUG_REMOTE_PORT:-9000}
    printf "\
; Uncomment to enable this extension.\n\
zend_extension=xdebug.so\n\
xdebug.remote_enable=1\n\
xdebug.remote_host=${XDEBUG_REMOTE_HOST}\n\
xdebug.remote_port=${XDEBUG_REMOTE_PORT}\n\
xdebug.remote_connect_back=0\n\
xdebug.remote_autostart=1\n" > /etc/php7/conf.d/xdebug.ini

fi

exec "$@"
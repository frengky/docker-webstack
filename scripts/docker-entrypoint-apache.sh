#!/bin/sh

if [ "$1" = "httpd" ]; then

    HOSTNAME=$(hostname)
    sed -i "s|#ServerName\ www.example.com:80|ServerName\ ${HOSTNAME}:8080|" /etc/apache2/httpd.conf
    sed -i "s#/var/www/localhost/htdocs#${DOCUMENT_ROOT:-/app}#" /etc/apache2/httpd.conf

fi

exec "$@"
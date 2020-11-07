#!/bin/sh

if [ "$1" = "supervisord" ]; then

    sed -i "s|^\s*listen\s*.*|    listen ${NGINX_PORT} default_server;|" /etc/nginx/conf.d/default.conf
    sed -i "s|^\s*root\s*.*|    root ${NGINX_ROOT};|" /etc/nginx/conf.d/default.conf
    sed -i "s|^;php_admin_value\[sendmail_path\].*|php_admin_value\[sendmail_path\] = ${SENDMAIL_PATH}|" /etc/php7/php-fpm.d/www.conf
    sed -i "s|;*sendmail_path =.*|sendmail_path=\"${SENDMAIL_PATH}\"|i" /etc/php7/php.ini

    mv /etc/supervisor.d/nginx.tpl /etc/supervisor.d/nginx.ini
    mv /etc/supervisor.d/php-fpm.tpl /etc/supervisor.d/php-fpm.ini
fi

exec "$@"
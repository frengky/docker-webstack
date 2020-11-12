#!/bin/sh

if [ "$1" = "supervisord" ]; then

    MAIL_HOST=${MAIL_HOST:-mailserver}
    MAIL_PORT=${MAIL_PORT:-3025}
    SENDMAIL_PATH="/usr/sbin/sendmail -S ${MAIL_HOST}:${MAIL_PORT} -t -i"

    sed -i "s|;*sendmail_path =.*|sendmail_path=\"${SENDMAIL_PATH}\"|i" /etc/php7/php.ini

    XDEBUG_IDE_HOST=$(ip r | awk '/default/{print $3}')
    printf "\
; Uncomment to enable this extension.
zend_extension=xdebug.so
xdebug.remote_enable=1\n\
xdebug.remote_host=${XDEBUG_IDE_HOST}\n\
xdebug.remote_port=9000\n\
xdebug.remote_connect_back=0\n\
xdebug.remote_autostart=1\n" > /etc/php7/conf.d/xdebug.ini

    # Increase overall request processing time
    sed -i "/fastcgi_param SERVER_NAME*/a\ \ \ \ \ \ \ \ fastcgi_read_timeout 600s;\n\ \ \ \ \ \ \ \ fastcgi_send_timeout 600s;" /etc/nginx/conf.d/default.conf
    sed -i "/client_max_body_size*/a\ \ \ \ client_header_timeout 600s;\n\ \ \ \ client_body_timeout 600s;" /etc/nginx/conf.d/default.conf
    sed -i "s|php_admin_value\[max_execution_time\].*|php_admin_value\[max_execution_time\]\ =\ 600|i" /etc/php7/php-fpm.d/www.conf

fi

exec "$@"
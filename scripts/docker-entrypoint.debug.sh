#!/bin/sh

if [ "$1" = "supervisord" ]; then

    MAIL_HOST=${MAIL_HOST:-mailserver}
    MAIL_PORT=${MAIL_PORT:-3025}
    SENDMAIL_PATH="/usr/sbin/sendmail -S ${MAIL_HOST}:${MAIL_PORT} -t -i"

    sed -i "s|;*sendmail_path =.*|sendmail_path=\"${SENDMAIL_PATH}\"|i" /etc/php7/php.ini

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
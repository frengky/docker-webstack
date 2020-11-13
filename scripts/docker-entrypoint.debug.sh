#!/bin/sh

if [ "$1" = "supervisord" ]; then

    MAIL_HOST=${MAIL_HOST:-mailserver}
    MAIL_PORT=${MAIL_PORT:-3025}
    SENDMAIL_PATH="/usr/sbin/sendmail -S ${MAIL_HOST}:${MAIL_PORT} -t -i"

    sed -i "s|;*sendmail_path =.*|sendmail_path=\"${SENDMAIL_PATH}\"|i" /etc/php7/php.ini

    XDEBUG_IDE_HOST=$(ip r | awk '/default/{print $3}')
    printf "\
; Uncomment to enable this extension.\n\
zend_extension=xdebug.so\n\
xdebug.remote_enable=1\n\
xdebug.remote_host=${XDEBUG_IDE_HOST}\n\
xdebug.remote_port=9000\n\
xdebug.remote_connect_back=0\n\
xdebug.remote_autostart=1\n" > /etc/php7/conf.d/xdebug.ini

fi

exec "$@"
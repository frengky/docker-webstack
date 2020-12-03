#!/bin/sh

if [ "$1" = "supervisord" ]; then

    MAIL_HOST=${MAIL_HOST:-mailserver}
    MAIL_PORT=${MAIL_PORT:-3025}
    SENDMAIL_PATH="/usr/sbin/sendmail -S ${MAIL_HOST}:${MAIL_PORT} -t -i"

    if [ "${LARAVEL_SCHEDULER:-false}" != "false" ]; then
        echo "* * * * * /usr/bin/php /app/artisan schedule:run >> /dev/null 2>&1" | crontab -u app -
        mv /etc/supervisor.d/crond.tpl /etc/supervisor.d/crond.ini
    fi

    if [ "${LARAVEL_WORKER:-0}" -gt "0" ]; then
        mv /etc/supervisor.d/laravel-worker.tpl /etc/supervisor.d/laravel-worker.ini
    fi

    sed -i "s|;*sendmail_path =.*|sendmail_path=\"${SENDMAIL_PATH}\"|i" /etc/php7/php.ini

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
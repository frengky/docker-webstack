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

    printf "\
zend_extension=xdebug.so\n\
xdebug.mode=debug\n\
xdebug.start_with_request=yes\n\
xdebug.client_host=127.0.0.1\n\
xdebug.client_port=9010\n\
xdebug.discover_client_host=false\n" > /etc/php7/conf.d/xdebug.ini

fi

exec "$@"
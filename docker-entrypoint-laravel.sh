#!/bin/sh

if [ "$1" = "supervisord" ]; then

    export LARAVEL_ROOT=${LARAVEL:-/app}
    export NGINX_ROOT="${LARAVEL_ROOT}/public"

    if [ "${LARAVEL_SCHEDULER:-false}" != "false" ]; then
        # Creating laravel scheduler crontab entry
        echo "* * * * * cd ${LARAVEL_ROOT} && /usr/bin/php artisan schedule:run >> /dev/null 2>&1" | crontab -u app -
        mv /etc/supervisor.d/crond.tpl /etc/supervisor.d/crond.ini
    fi

    if [ "${LARAVEL_WORKER:-0}" -gt "0" ]; then
        # Enabling laravel worker
        mv /etc/supervisor.d/laravel-worker.tpl /etc/supervisor.d/laravel-worker.ini
    fi

    sed -i "s|^\s*listen\s*.*|    listen ${NGINX_PORT} default_server;|" /etc/nginx/conf.d/default.conf
    sed -i "s|^\s*root\s*.*|    root ${NGINX_ROOT};|" /etc/nginx/conf.d/default.conf
    sed -i "s|^;php_admin_value\[sendmail_path\].*|php_admin_value\[sendmail_path\] = ${SENDMAIL_PATH}|" /etc/php7/php-fpm.d/www.conf
    sed -i "s|;*sendmail_path =.*|sendmail_path=\"${SENDMAIL_PATH}\"|i" /etc/php7/php.ini

    mv /etc/supervisor.d/nginx.tpl /etc/supervisor.d/nginx.ini
    mv /etc/supervisor.d/php-fpm.tpl /etc/supervisor.d/php-fpm.ini
fi

exec "$@"
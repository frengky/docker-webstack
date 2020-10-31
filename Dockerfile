FROM frengky/php
LABEL maintainer="frengky.lim@gmail.com"

ENV NGINX_PORT=8080
ENV NGINX_ROOT=/app
ENV SENDMAIL_PATH="/usr/sbin/sendmail -S mailserver:3025 -t -i"

RUN apk -U upgrade && \
    apk --update --no-cache add \
    nginx \
    supervisor && \
    mkdir /run/nginx && \
    ln -s /dev/stdout /var/log/nginx/access.log && \
    ln -s /dev/stderr /var/log/nginx/error.log && \
    ln -s /dev/stdout /var/log/supervisord.log && \
    sed -i "s|;nodaemon=false.*|nodaemon=true|i" /etc/supervisord.conf && \
    sed -i "s|;logfile_maxbytes=50MB.*|logfile_maxbytes=0|i" /etc/supervisord.conf && \
    sed -i "s|;logfile_backups=10*|logfile_backups=0|i" /etc/supervisord.conf && \
    sed -i "s|;user=chrism.*|user=root|i" /etc/supervisord.conf && \
    sed -i "s|;silent=false.*|silent=true|i" /etc/supervisord.conf && \
    rm -f /var/cache/apk/*

COPY supervisor.d/ /etc/supervisor.d/
COPY www.conf /etc/php7/php-fpm.d/
COPY default.conf /etc/nginx/conf.d/

#HEALTHCHECK --interval=10s --timeout=3s CMD [ $(php -r "echo file_get_contents('http://localhost:'.\$_SERVER['NGINX_PORT'].'/ping');") == "pong" ] || exit 1

WORKDIR ${NGINX_ROOT}
EXPOSE ${NGINX_PORT}

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
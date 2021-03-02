FROM frengky/php:7
LABEL maintainer="frengky.lim@gmail.com"

RUN apk --update --no-cache add \
    php7-fpm \
    nginx \
    supervisor && \
    mkdir /run/nginx && \
    ln -s /dev/stdout /var/log/nginx/access.log && \
    ln -s /dev/stderr /var/log/nginx/error.log && \
    ln -s /dev/stdout /var/log/supervisord.log && \
    sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo=0|i" /etc/php7/php.ini && \
    sed -i "s|;nodaemon=false.*|nodaemon=true|i" /etc/supervisord.conf && \
    sed -i "s|;pidfile=/run/supervisord.pid.*|pidfile=/run/supervisord.pid|i" /etc/supervisord.conf && \
    sed -i "s|;logfile_maxbytes=50MB.*|logfile_maxbytes=0|i" /etc/supervisord.conf && \
    sed -i "s|;logfile_backups=10*|logfile_backups=0|i" /etc/supervisord.conf && \
    sed -i "s|;user=chrism.*|user=root|i" /etc/supervisord.conf && \
    sed -i "s|;silent=false.*|silent=true|i" /etc/supervisord.conf && \
    rm -f /var/cache/apk/*

COPY supervisor.d/nginx.ini /etc/supervisor.d/
COPY supervisor.d/php-fpm.ini /etc/supervisor.d/
COPY php/php-fpm.conf /etc/php7/
COPY php/www.conf /etc/php7/php-fpm.d/
COPY nginx/default.conf /etc/nginx/conf.d/

VOLUME /app
WORKDIR /app
EXPOSE 8080

COPY scripts/docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisord.conf"]

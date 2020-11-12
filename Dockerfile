FROM frengky/php
LABEL maintainer="frengky.lim@gmail.com"

ARG NGINX_PORT=8080
ARG NGINX_ROOT=/app

ENV NGINX_PORT ${NGINX_PORT}
ENV NGINX_ROOT ${NGINX_ROOT}

RUN apk -U upgrade && \
    apk --update --no-cache add \
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

RUN sed -i "s|^\s*listen\s*.*|    listen ${NGINX_PORT} default_server;|" /etc/nginx/conf.d/default.conf && \
    sed -i "s|^\s*root\s*.*|    root ${NGINX_ROOT};|" /etc/nginx/conf.d/default.conf

#HEALTHCHECK --interval=10s --timeout=3s CMD [ $(php -r "echo file_get_contents('http://localhost:'.\$_SERVER['NGINX_PORT'].'/ping');") == "pong" ] || exit 1

WORKDIR ${NGINX_ROOT}
EXPOSE ${NGINX_PORT}

COPY scripts/docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisord.conf"]

[program:php-fpm]
command=/usr/sbin/php-fpm7 -F
process_name=%(program_name)s_%(process_num)02d
priority=10
numprocs=1
autostart=true
autorestart=false
startsecs=0
redirect_stderr=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile_backups=0
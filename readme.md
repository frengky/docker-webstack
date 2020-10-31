# PHP NGINX Webstack docker container

PHP, NGINX webstack docker container based on Alpine Linux.

## Running a php website
Running a php website with current directory as the document root, on port 8080
```
docker run -it --rm --name laravel -v $(pwd):/app -p 8080:8080 frengky/webstack
```

## Running a Laravel application
Create a new Laravel project using composer in the current directory
```
docker run -it --rm --name composer -u 1000:1000 -v $(pwd):/app -v composer-cache:/tmp composer create-project --prefer-dist laravel/laravel .
```

Configure Laravel *.env* file to use *stderr* as logging destination
```
LOG_CHANNEL=stderr
```

Running the Laravel website with current directory as the Laravel source code, on port 8080
```
docker run -it --rm --name laravel -v $(pwd):/app -p 8080:8080 -e LARAVEL=/app frengky/webstack
```

Optional with Laravel scheduler and 2 queue workers
```
docker run -it --rm --name laravel -v $(pwd):/app -p 8080:8080 -e LARAVEL=/app -e LARAVEL_SCHEDULER=true -e LARAVEL_WORKER=2 frengky/webstack
```

Access Laravel's artisan command
```
docker run -it --rm --name laravel -v $(pwd):/app frengky/webstack php artisan route:list
```

Using docker compose
```
laravel-app:
    image: frengky/webstack
    environment:
        LARAVEL: /app
        LARAVEL_SCHEDULER: true
        LARAVEL_WORKER: 2
    ports:
        - "8080:8080"
    volumes:
        - ".:/app"
```

## Customisable environment variables
| Name | Default | Description |
|---|---|---|
| NGINX_PORT | 8080 | Nginx EXPOSE port |
| NGINX_ROOT | /app | Web document root |
| SENDMAIL_PATH | /usr/sbin/sendmail -S mailserver:3025 -t -i | PHP sendmail_path value |
| LARAVEL | /app | Enable Laravel app support with source code directory at /app |
| LARAVEL_SCHEDULER | false | Enable Laravel scheduler running on cron |
| LARAVEL_WORKER | 0 | Enable Laravel queue workers (integers) |
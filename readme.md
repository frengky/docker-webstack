# PHP NGINX Webstack docker container

PHP, NGINX webstack docker container based on Alpine Linux.

| Tag  | Description |
|---|---|
| latest | For running common PHP website |
| laravel | For running website using Laravel framework |

## Getting started
```
docker pull frengky/webstack:<tag>
```

## Running a php website
Running a php website with current directory as the document root, on port 8080
```
docker run -it --rm --name web -v $(pwd):/app -p 8080:8080 frengky/webstack
```

### Customisable environment variables
| Name | Default | Description |
|---|---|---|
| MAIL_HOST | mailserver | Mail server host |
| MAIL_PORT | 3025 | Mail server port |

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
docker run -it --rm --name laravel -v $(pwd):/app -p 8080:8080 frengky/webstack:laravel
```

Optional with Laravel scheduler and 2 queue workers
```
docker run -it --rm --name laravel -v $(pwd):/app -p 8080:8080 -e LARAVEL_SCHEDULER=true -e LARAVEL_WORKER=2 frengky/webstack:laravel
```

Access Laravel's artisan command
```
docker run -it --rm --name laravel -v $(pwd):/app frengky/webstack:laravel php artisan route:list
```

Using docker compose
```
laravel-app:
    image: frengky/webstack:laravel
    environment:
        LARAVEL_SCHEDULER: true
        LARAVEL_WORKER: 2
    ports:
        - "8080:8080"
    volumes:
        - ".:/app"
```

### Customisable environment variables
| Name | Default | Description |
|---|---|---|
| MAIL_HOST | mailserver | Mail server host |
| MAIL_PORT | 3025 | Mail server port |
| LARAVEL_SCHEDULER | false | Enable Laravel scheduler running on cron |
| LARAVEL_WORKER | 0 | Enable Laravel queue workers (int) |
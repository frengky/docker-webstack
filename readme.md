# PHP-FPM Nginx container

This PHP-FPM Nginx container is based on Alpine Linux, a multiple service (php-fpm, nginx) container managed by supervisor.

| Variant  | Description |
|---|---|
| frengky/webstack | For running common PHP website |
| frengky/webstack:debug | For running common PHP website (with XDebug) |
| frengky/webstack:laravel | For running website with Laravel framework |
| frengky/webstack:laravel-debug | For running website with Laravel framework (with XDebug) |
| frengky/webstack:apache | For running website using Apache2 |
| frengky/webstack:apache-debug | For running website using Apache2 (with XDebug) |

> By default `xdebug.remote_host` is set to container host ip (auto detect), `xdebug.remote_port=9000` and `xdebug.remote_autostart=1`
> If you wish to run a Laravel app using `apache` variant, set the environment `DOCUMENT_ROOT` to `/app/public`

To use XDebug variant, you need to install VSCode extension `PHP Debug`.
If you are using Remote SSH, make sure the `PHP Debug` extension are installed on your remote too.
And dont forget to adjust your `launch.json`:
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for XDebug",
            "type": "php",
            "request": "launch",
            "port": 9000,
            "pathMappings": {
                "/app": "${workspaceRoot}"
            }
        },
        {
            "name": "Launch currently open script",
            "type": "php",
            "request": "launch",
            "program": "${file}",
            "cwd": "${fileDirname}",
            "port": 9000
        }
    ]
}
```

## Running a php website
Running a php website with current directory as the document root, on port `8080`
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

Configure Laravel's `.env` file to use `stderr` as logging destination
```
LOG_CHANNEL=stderr
```

Running the Laravel website with current directory as the Laravel source code, on port `8080`
```
docker run -it --rm --name laravel -v $(pwd):/app -p 8080:8080 frengky/webstack:laravel
```

Optional with Laravel *scheduler* and 2 *queue workers*
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
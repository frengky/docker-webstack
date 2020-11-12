<?php
namespace Mougrim\XdebugProxy;

use Monolog\Logger;
use Monolog\Formatter\LineFormatter;
use Monolog\Handler\StreamHandler;

return (new Logger('xdebug-proxy'))
    ->pushHandler(
        (new StreamHandler('php://stdout', Logger::DEBUG))
            ->setFormatter(new LineFormatter("[%datetime%] %channel%.%level_name%: %message%\n"))
    );

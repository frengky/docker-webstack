<?php
namespace Mougrim\XdebugProxy;

return [
    'xdebugServer' => [
        // host:port for listening for Xdebug connections
        'listen' => '127.0.0.1:9010',
    ],
    'ideServer' => [
        // If the proxy cannot find the IDE, then it will
        // use the default IDE, if you need to switch off
        // the default IDE, you need to pass an empty line.
        // Default IDE is useful when only one person
        // is using the proxy.
        // 'defaultIde' => '0.0.0.0:9011',
        'defaultIde' => '',
        // The predefined IDEs are given using the format
        // 'idekey' => 'host:port', if predefined IDEs
        // are not required, you can specify an empty array.
        // Predefined IDEs are useful when proxy users
        // don’t change often, that way they don’t have
        // to re-register each time they rerun proxy.
        'predefinedIdeList' => [
            // 'vscode' => '127.0.0.1:9011',
        ],
    ],
    'ideRegistrationServer' => [
        // host:port for listening for connections to IDE
        // registrations, if IDE registrations need
        // to be switched off, you need to pass an empty line.
        'listen' => '0.0.0.0:9011',
    ],
];
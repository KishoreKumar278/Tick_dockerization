@ECHO OFF
TITLE sandbox.bat - TICK Sandbox

SET interactive=1
SET COMPOSE_CONVERT_WINDOWS_PATHS=1

SET TYPE=latest
SET TELEGRAF_TAG=latest
SET INFLUXDB_TAG=latest
SET CHRONOGRAF_TAG=latest
SET KAPACITOR_TAG=latest

ECHO %cmdcmdline% | FIND /i "/c"
IF %ERRORLEVEL% == 0 SET interactive=0

REM Enter attaches users to a shell in the desired container
IF "%1"=="enter" (
    IF "%2"=="influxdb" (
        ECHO Entering ^/bin^/bash session in the influxdb container
        docker-compose exec influxdb /bin/bash
        GOTO End
    )
    IF "%2"=="chronograf" (
        ECHO Entering ^/bin^/bash session in the chronograf container
        docker-compose exec chronograf /bin/bash
        GOTO End
    )
    IF "%2"=="kapacitor" (
        ECHO Entering ^/bin^/bash session in the kapacitor container
        docker-compose exec kapacitor /bin/bash
        GOTO End
    )
    IF "%2"=="telegraf" (
        ECHO Entering ^/bin^/bash session in the telegraf container
        docker-compose exec telegraf /bin/bash
        GOTO End
    )
)


IF "%1"=="up" (
        ECHO Spinning up latest, stable Docker Images...
        ECHO If this is your first time starting sandbox this might take a minute...
        docker-compose up -d --build
        ECHO Opening tabs in browser...
        timeout /t 3 /nobreak > NUL
        START "" http://localhost:3010
        START "" http://localhost:8888
        GOTO End
)

IF "%1"=="down" (
    ECHO Stopping and removing running sandbox containers...
    docker-compose down
    GOTO End
)

IF "%1"=="docker-clean" (
    ECHO Stopping all running sandbox containers...
    docker-compose down
    echo Removing TICK images...
    docker-compose down --rmi=all
    GOTO End
)

IF "%1"=="influxdb" (
    ECHO Entering the influx cli...
    docker-compose exec influxdb /usr/bin/influx
    GOTO End
)

IF "%1"=="flux" (
    ECHO Entering the flux cli...
    docker-compose exec influxdb /usr/bin/influx -type flux
    GOTO End
)

:End
IF "%interactive%"=="0" PAUSE
EXIT /B 0

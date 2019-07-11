#!/usr/bin/env bash

MC_DIR="$1"

if [[ -z "${MC_DIR}" ]]; then
    printf "No minecraft directory provided.\n"
    exit 1
fi

if [[ ! -f "run.sh" ]]; then
    printf "Could not find settings file.\n"
    exit 1
fi

cd ${MC_DIR}

source ./settings.sh

trap server_shutdown EXIT SIGTERM SIGINT

java -Xmx"${JVM_MEM_MAX}" -Xms"${JVM_MEM_MIN}" -jar server.jar nogui

function server_shutdown() {
    SERVER_PID=$(ps | grep java | grep if | cut -b 1-5)

    printf "Terminating java server\n"
    kill ${SERVER_PID}

    printf "Creating a backup\n"
    bash ../backups/backup.sh

    printf "Server terminating\n"
    exit
}
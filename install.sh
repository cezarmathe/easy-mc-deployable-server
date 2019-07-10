#!/usr/bin/env bash

function main() {
    local install_dir="$1"; shift
    local mc_jar_url="$1"; shift

    # create the server directory
    sudo mkdir ${install_dir}
    cd ${install_dir}

    # clone the server layout
    git clone https://github.com/cezarmathe/easy-mc-deployable-server.git server

    cd ${install_dir}/server

    # download the server jar
    curl "${mc_jar_url}" server.jar

    cd ${install_dir}

    # handle systemd units
    sudo cp systemd/* /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable mc_server@${install_dir}.service
    sudo systemctl enable mc_backup${install_dir}.service

    # give the user the option to edit the server.properties file
    vim ${install_dir}/server/server.properties
}

if [[ -z "$2" ]]; then
    prints "Not enough arguments.\n"
    exit 1
fi

main $@
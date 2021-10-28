#!/bin/bash

function echo_error() {
    echo -ne '\033[0;31m'
    echo $@
    echo -ne '\033[0m'
}

function run() {
    $@ >/tmp/octopus_pip_upgrade.log 2>&1
    exit_code=$?
    if [ "$exit_code" != "0" ]; then
        echo "======================= BEGIN LOG ======================="
        cat /tmp/octopus_pip_upgrade.log
        echo "=======================  END LOG  ======================="
        echo_error -e "\nThere was a problem installing dependencies. Please check-out the logs above."
        exit $exit_code
    fi
}

echo "Upgrading pip2 version"
# To upgrade pip, pretty much the only means is to get the version from the debian repository,
# use it to upgrade itself, and then remove the package
run apt update
run apt install -y python-pip
run python -m pip install --upgrade pip
run apt purge -y python-pip

echo "Upgrading pip3 version"
# To upgrade pip, pretty much the only means is to get the version from the debian repository,
# use it to upgrade itself, and then remove the package
run apt update
run apt install -y python3-pip
run python3 -m pip install --upgrade pip
run apt purge -y python3-pip

#!/bin/bash

# Setup MariaDB
setup_mariadb () {
    cd '/usr' || exit 1
    /usr/bin/mysqld_safe --datadir='/var/lib/mysql' &

    # Wait until the database is online
    # Use a cheap query to check if the database is online
    while ! mysql -u root -password='' -e 'DO 1;'
    do
        echo "Waiting for database..."
        sleep 1
    done
    echo "Database online!"


    # Setup mysql
    mysql -u root --password='' <<EOF
        CREATE USER 'smarthome'@'localhost' IDENTIFIED BY 'testing';
        CREATE DATABASE smarhome;
        GRANT ALL PRIVILEGES ON smarthome.* TO 'smarthome'@'localhost';
        FLUSH PRIVILEGES;
EOF
}

# Test if the directory is valid (contains a go.mod file)
check_go_directory() {
    cd /opt/smarthome/tests || exit 1
    if [ ! -f go.mod ]; then
        echo "You can only run integration tests inside a Go working directory"
        exit 1
    fi
}

# Runs the tests
run_integration_tests () {
    # Run the actual tests
    echo "Running integration tests..."
    # Use local Makefile
    make test || exit 99
}


# START
setup_mariadb
check_go_directory

# If `SMARTHOME_INTEGRATION_SETUP_ONLY` is set, do not run the integration tests
if [[ -n "$SMARTHOME_INTEGRATION_SETUP_ONLY" ]]; then
    if [ "$SMARTHOME_INTEGRATION_SETUP_ONLY" == "0" ]; then
        echo "SMARTHOME_INTEGRATION_SETUP_ONLY is set to '0': continuing integration tests"
    elif [ "$SMARTHOME_INTEGRATION_SETUP_ONLY" == '1' ]; then
        echo "SMARTHOME_INTEGRATION_SETUP_ONLY is set to '1': omitting integration tests"
        exit 0
    else
        echo "SMARTHOME_INTEGRATION_SETUP_ONLY is specified but holds invalid value: '$SMARTHOME_INTEGRATION_SETUP_ONLY': aborting integration tests"
        exit 1
    fi
fi

# Otherwise, run the integration tests
run_integration_tests

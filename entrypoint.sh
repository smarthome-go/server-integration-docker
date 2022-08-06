#!/bin/bash

# Setup MariaDB
setup_mariadb () {
    cd '/usr' || exit 1
    /usr/bin/mysqld_safe --datadir='/var/lib/mysql' &

    # Wait until the datbase is online
    # Use a cheap query to check if the datbase is online
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

# Runs the tests
run_integration_tests () {
    # Test if the directory is valid
    cd /opt/smarthome/tests || exit 1
    if [ ! -f go.mod ]; then
        echo "You can only run integration tests inside a Go working directory"
        exit 1
    fi

    # Run the actual tests
    echo "Running integration tests..."
    mkdir -p web/dist/html
    touch web/dist/html/testing.html
    # Prevents server panic

    go test -v -p 1 ./... --timeout=10000s
    # Tests should be run one after another due to deletion of the database at every test start
    rm -rf web/dist/html/testing.html
}


# START
setup_mariadb
run_integration_tests

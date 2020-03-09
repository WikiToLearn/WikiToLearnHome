#!/bin/bash
. ./load-libs.sh

if ! docker start ${WTL_INSTANCE_NAME}-parsoid ; then
    wtl-event MISSING_PARSOID
    exit 1
fi

if ! docker start ${WTL_INSTANCE_NAME}-mathoid ; then
    wtl-event MISSING_MATHOID
    exit 1
fi


if ! docker start ${WTL_INSTANCE_NAME}-memcached ; then
    wtl-event MISSING_MEMCACHED
    exit 1
fi


if ! docker start ${WTL_INSTANCE_NAME}-mysql; then
    wtl-event MISSING_MYSQL
    exit 1
else
    ROOT_PWD=$(cat $WTL_CONFIGS_DIR/mysql-users/root)
    WTLMYSQL_PWD=$(cat $WTL_CONFIGS_DIR/mysql-users/wtlmysql)

    docker cp $WTL_CONFIGS_DIR/mysql-root-password.cnf ${WTL_INSTANCE_NAME}-mysql:/root/mysql-root-password.cnf

    wtl-event WAITING_FOR_MYSQL
    while ! docker exec ${WTL_INSTANCE_NAME}-mysql mysql --defaults-file=/root/mysql-root-password.cnf -e "SELECT 1" &> /dev/null
    do
        wtl-event WAITING_FOR_MYSQL_INFO
        sleep 1
        docker start ${WTL_INSTANCE_NAME}-mysql
    done
    docker cp $WTL_CONFIGS_DIR/mysql-root-password.cnf ${WTL_INSTANCE_NAME}-mysql:/root/.my.cnf
    wtl-event MYSQL_IS_UP

    docker start ${WTL_INSTANCE_NAME}-mysql
    sleep 2

    wtl-event MYSQL_GRANT_PRIVS_TO_USER
    echo "GRANT ALL PRIVILEGES ON * . * TO 'wtlmysql'@'%' IDENTIFIED BY '$WTLMYSQL_PWD';" | docker exec -i ${WTL_INSTANCE_NAME}-mysql mysql
    if ! docker exec ${WTL_INSTANCE_NAME}-mysql mysql -uwtlmysql -p$WTLMYSQL_PWD -e "SELECT 1" &> /dev/null ; then
        wtl-event MYSQL_AUTH_TEST_FAIL
        exit 1
    fi

    docker start ${WTL_INSTANCE_NAME}-mysql
    sleep 2

    wtl-event MAKE_USERNAME_AND_PASSWORD_PHP_FILE $WTL_CONFIGS_DIR
    {
        echo "<?php"
        echo "\$wgDBuser = 'wtlmysql';"
        echo "\$wgDBpassword = '$WTLMYSQL_PWD';"
    } > $WTL_CONFIGS_DIR/LocalSettings.d/mysql-username-and-password.php

    for dbname in $(cat $WTL_WORKING_DIR/databases.conf)
    do
        wtl-event CREATE_DB $dbname
        if [[ $dbname =~ ^[a-z_]+$ ]]; then
            docker exec -i ${WTL_INSTANCE_NAME}-mysql mysql -e "CREATE DATABASE IF NOT EXISTS $dbname"
        else
            wtl-event DB_NAME_NOT_ALLOWD $dbname
        fi
    done
fi


if ! docker start ${WTL_INSTANCE_NAME}-restbase ; then
    wtl-event MISSING_RESTBASE
    exit 1
fi

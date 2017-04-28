#!/bin/bash
echo "[environment] Using 'base-easylink-developing' environment"

if [[ "$WTL_WORKING_DIR" == "" ]] ; then
    export WTL_WORKING_DIR=$WTL_REPO_DIR
fi

if [[ "$WTL_INSTANCE_NAME" == "" ]] ; then
    export WTL_INSTANCE_NAME="wtl-dev"
fi

if [[ -f $WTL_WORKING_DIR/docker-images.conf ]] ; then
    . $WTL_WORKING_DIR/docker-images.conf
fi

export WTL_HELPER_CREATE="single-node-wikirating-develop"
export WTL_HELPER_START="single-node"
export WTL_HELPER_RESTORE_BACKUP="single-node"
export WTL_HELPER_DO_BACKUP="single-node"
export WTL_HELPER_MAKE_READONLY="single-node"
export WTL_HELPER_MAKE_READWRITE="single-node"
export WTL_HELPER_DO_BACKUP_QUICK="single-node"

export WTL_DOCKER_IMAGES_LIST="WTL_DOCKER_MEMCACHED WTL_DOCKER_MATHOID WTL_DOCKER_MYSQL WTL_DOCKER_PARSOID WTL_DOCKER_HAPROXY WTL_DOCKER_WEBSRV WTL_DOCKER_RESTBASE"

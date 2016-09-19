#!/bin/bash
[[  "$WTL_SCRIPT_DEBUG" == "1" ]] && set -x
set -e
if [[ $(basename $0) != "backup-do.sh" ]] ; then
    echo "Wrong way to execute backup-do.sh"
    exit 1
fi
cd $(dirname $(realpath $0))"/.."
if [[ ! -f "const.sh" ]] ; then
    echo "Error changing directory"
    exit 1
fi

. ./load-libs.sh

. $WTL_SCRIPTS/environments/${WTL_ENV}.sh

if [[ "$WTL_INSTANCE_NAME" == "" ]] ; then
    wtl-event MIGGING_WTL_INSTANCE_NAME
    exit 1
fi

$WTL_SCRIPTS/helpers/backup-do/${WTL_HELPER_DO_BACKUP}.sh

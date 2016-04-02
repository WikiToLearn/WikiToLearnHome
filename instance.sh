#!/bin/bash
cd $(dirname $(realpath $0))

. ./load-libs.sh

if [[ ! -f $WTL_CACHE"/wtl-home-last-auto-update" ]] || [[ $(($(date +%s)-$(date +%s -r $WTL_CACHE"/wtl-home-last-auto-update"))) -gt 3300 ]] ; then
    echo "3600 sec from last WikiToLearn Home updates check..."
    $WTL_SCRIPTS/update-home.sh
    touch $WTL_CACHE"/wtl-home-last-auto-update"
    exit
fi

if [[ $# -eq 0 ]] ; then
    $0 help
    exit $?
fi

case $1 in
    first-run)
        $WTL_SCRIPTS/download-all.sh
        $WTL_SCRIPTS/create.sh
        $WTL_SCRIPTS/start.sh
        $WTL_SCRIPTS/backup-restore.sh $WTL_REPO_DIR/DeveloperDump/
        $WTL_SCRIPTS/unuse-instance.sh
        $WTL_SCRIPTS/use-instance.sh
        $WTL_SCRIPTS/update-db.sh
    ;;
    start)
        $WTL_SCRIPTS/start.sh
        $WTL_SCRIPTS/unuse-instance.sh
        $WTL_SCRIPTS/use-instance.sh
        $WTL_SCRIPTS/fix-hosts.sh
    ;;
    stop)
        $WTL_SCRIPTS/stop.sh
        $WTL_SCRIPTS/unuse-instance.sh
    ;;
    delete)
        $WTL_SCRIPTS/stop.sh
        $WTL_SCRIPTS/delete.sh
        $WTL_SCRIPTS/unuse-instance.sh
    ;;
    download)
        $WTL_SCRIPTS/download-code.sh
    ;;
    update-home)
        $WTL_SCRIPTS/update-home.sh
    ;;
    help)
        echo "No help yet, sorry"
    ;;
    *)
        echo "Command not found ($@)"
        exit
    ;;
esac

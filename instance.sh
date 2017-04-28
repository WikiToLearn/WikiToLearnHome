#!/bin/bash
[[  "$WTL_SCRIPT_DEBUG" == "1" ]] && set -x
set -e

if [[ $(basename $0) != "instance.sh" ]] ; then
    echo "[istance.sh] Wrong way to execute instance.sh"
    echo -e "\e[31mFATAL ERROR \e[0m"
    exit 1
fi

cd $(dirname $(realpath $0))
if [[ ! -f "const.sh" ]] ; then
    echo "[instance.sh] Error changing directory"
    echo -e "\e[31mFATAL ERROR \e[0m"
    exit 1
fi

# -------------------------------------------------------------

. ./load-libs.sh

#if [[ ! -f $WTL_CACHE"/wtl-home-last-auto-update" ]] || [[ $(($(date +%s)-$(date +%s -r $WTL_CACHE"/wtl-home-last-auto-update"))) -gt 3300 ]] ; then
#    echo "3600 sec from last WikiToLearn Home updates check..."
#    $WTL_SCRIPTS/update-home.sh
#    touch $WTL_CACHE"/wtl-home-last-auto-update"
#    exit
#fi

if [[ $# -eq 0 ]] ; then
    $0 help
    exit $?
fi

if test -f $WTL_LOCK_FILE ; then
    echo "WTLH lockfile ($WTL_LOCK_FILE) exists, this can be due to another process that is using $0 script"
    if kill -0 $(cat $WTL_LOCK_FILE) &> /dev/null ; then
        echo "The process is running, exit"
        exit 1
    else
        echo "The process is not running"
        rm -fv $WTL_LOCK_FILE
    fi
fi

echo $$ > $WTL_LOCK_FILE

case $1 in
    help)
        echo "Please look in the doc/ directory"
    ;;
    create)
        $WTL_SCRIPTS/create.sh
    ;;
    start)
        $WTL_SCRIPTS/start.sh
        $WTL_SCRIPTS/unuse-instance.sh
        $WTL_SCRIPTS/use-instance.sh
        $WTL_SCRIPTS/fix-hosts.sh
    ;;
    first-run)
        INITIAL_BACKUP=$WTL_REPO_DIR/DeveloperDump/
        if [[ "$2" != "" ]]
        then
            if test -d "$2"
            then
                INITIAL_BACKUP="$2"
            fi
        fi
        $WTL_SCRIPTS/unuse-instance.sh
        $WTL_SCRIPTS/download-all.sh
        $WTL_SCRIPTS/download-mediawiki-extensions.sh
        $WTL_SCRIPTS/create.sh
        $WTL_SCRIPTS/start.sh
        $WTL_SCRIPTS/fix-hosts.sh
        $WTL_SCRIPTS/backup-restore.sh $INITIAL_BACKUP
        $WTL_SCRIPTS/use-instance.sh
        $WTL_SCRIPTS/update-db.sh
        $WTL_SCRIPTS/mw-import-struct-wikipages.sh
    ;;
    stop)
        $WTL_SCRIPTS/unuse-instance.sh
        $WTL_SCRIPTS/stop.sh
    ;;
    delete)
        $WTL_SCRIPTS/unuse-instance.sh
        $WTL_SCRIPTS/stop.sh
        $WTL_SCRIPTS/delete.sh
    ;;
    delete-volumes)
        $WTL_SCRIPTS/delete-volumes.sh
    ;;
    delete-full)
        $WTL_SCRIPTS/unuse-instance.sh
        $WTL_SCRIPTS/stop.sh
        $WTL_SCRIPTS/delete.sh
        $WTL_SCRIPTS/delete-volumes.sh
    ;;
    fix-hosts)
        $WTL_SCRIPTS/fix-hosts.sh
    ;;
    update-home)
        $WTL_SCRIPTS/update-home.sh
    ;;
    download)
        $WTL_SCRIPTS/download-code.sh
        $WTL_SCRIPTS/download-mediawiki-extensions.sh
    ;;
    update-docker-container)
        $WTL_SCRIPTS/pull-images.sh
        $WTL_SCRIPTS/unuse-instance.sh
        $WTL_SCRIPTS/stop.sh
        $WTL_SCRIPTS/delete.sh
        $WTL_SCRIPTS/create.sh
        $WTL_SCRIPTS/start.sh
        $WTL_SCRIPTS/use-instance.sh
        $WTL_SCRIPTS/fix-hosts.sh
    ;;
    update-code-and-db)
        $WTL_SCRIPTS/download-code.sh
        $WTL_SCRIPTS/download-mediawiki-extensions.sh
        $WTL_SCRIPTS/pull-images.sh
        $WTL_SCRIPTS/unuse-instance.sh
        $WTL_SCRIPTS/stop.sh
        $WTL_SCRIPTS/delete.sh
        $WTL_SCRIPTS/create.sh
        $WTL_SCRIPTS/start.sh
        $WTL_SCRIPTS/use-instance.sh
        $WTL_SCRIPTS/fix-hosts.sh
        $WTL_SCRIPTS/update-db.sh
        $WTL_SCRIPTS/mw-import-struct-wikipages.sh
    ;;
    devdump-import)
        $WTL_SCRIPTS/backup-restore.sh $WTL_REPO_DIR/DeveloperDump/
        $WTL_SCRIPTS/update-db.sh
        $WTL_SCRIPTS/mw-import-struct-wikipages.sh
    ;;
    devdump-export)
        $WTL_SCRIPTS/backup-do.sh
        $WTL_SCRIPTS/copy-last-backup-to-devdump.sh
    ;;
    release-do)
        $WTL_SCRIPTS/release-procedure.sh
    ;;
    release-clean)
        $WTL_SCRIPTS/backup-auto-delete.sh
        $WTL_SCRIPTS/unused-instance-stop-delete.sh
        $WTL_SCRIPTS/docker-images-delete-old-images.sh
        $WTL_SCRIPTS/docker-images-clean.sh
    ;;
    staging)
        $WTL_SCRIPTS/release-procedure.sh
        $WTL_SCRIPTS/backup-auto-delete.sh
        $WTL_SCRIPTS/unused-instance-stop-delete.sh
        $WTL_SCRIPTS/docker-images-delete-old-images.sh
        $WTL_SCRIPTS/docker-images-clean.sh
    ;;
    dev)
        case $2 in
            confirm-email)
                $WTL_SCRIPTS/mw-confirm-all-email.sh
            ;;
            *)
                echo "Dev command not found ($@)"
            ;;
        esac
    ;;
    production)
        . $WTL_SCRIPTS/load-productoin-instance.sh
        case $2 in
            runJobs)
                $WTL_SCRIPTS/lang-foreach-php-maintenance.sh runJobs.php
            ;;
            backup-do)
                $WTL_SCRIPTS/backup-do.sh
            ;;
            backup-do-quick)
                $WTL_SCRIPTS/backup-do-quick.sh
            ;;
            backup-auto-delete)
                $WTL_SCRIPTS/backup-auto-delete.sh
            ;;
            mw-dumps-do)
                $WTL_SCRIPTS/mw-dumps-do.sh
            ;;
            *)
                echo "Production command not found ($@)"
            ;;
        esac
    ;;
    gpg-update)
        $WTL_SCRIPTS/git-gpg-check/update-trusted-keys.sh
    ;;
    *)
        echo "Command not found ($@)"
    ;;
esac

rm $WTL_LOCK_FILE

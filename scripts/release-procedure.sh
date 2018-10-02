#!/bin/bash
[[  "$WTL_SCRIPT_DEBUG" == "1" ]] && set -x
set -e
if [[ $(basename $0) != "release-procedure.sh" ]] ; then
    echo "Wrong way to execute release-procedure.sh"
    exit 1
fi
cd $(dirname $(realpath $0))"/.."
if [[ ! -f "const.sh" ]] ; then
    echo "Error changing directory"
    exit 1
fi

. ./load-libs.sh

cd $WTL_REPO_DIR
GIT_ID_CURRENT=$(git log -n 1 --format="%H")
cd $(dirname $(realpath $0))

$WTL_SCRIPTS/download-code.sh

cd $WTL_REPO_DIR
GIT_ID_NEW=$(git log -n 1 --format="%H")
cd $(dirname $(realpath $0))

if [[  "$1" != "" ]] ; then
    GIT_ID_NEW="$1"
fi

export NEW_WTL_INSTANCE_NAME="wtl-"${GIT_ID_NEW:0:8}
export NEW_WTL_WORKING_DIR=${WTL_RUNNING}"/"${GIT_ID_NEW}

docker inspect wikitolearn-haproxy &> /dev/null && {
    export OLD_WTL_INSTANCE_NAME=$(docker inspect -f '{{index .Config.Labels "WTL_INSTANCE_NAME"}}' wikitolearn-haproxy)
    export OLD_WTL_WORKING_DIR=$(docker inspect -f '{{index .Config.Labels "WTL_WORKING_DIR"}}' wikitolearn-haproxy)
}

if [[ "$NEW_WTL_INSTANCE_NAME" != "$OLD_WTL_INSTANCE_NAME" ]] ; then
    if [[ "$WTL_RELEASE_GPG_CHECK" == "1" ]]
    then
        wtl-event RELEASE_PROCEDURE_GPG_CHECK
        if ! $WTL_SCRIPTS/git-gpg-check/check-commit-signature.sh
        then
            wtl-event RELEASE_PROCEDURE_GPG_KO
            exit 1
        fi
    else
        wtl-event RELEASE_PROCEDURE_GPG_CHECK_SKIP
    fi
    wtl-event RELEASE_PROCEDURE_NEW_RUN ${GIT_ID_NEW:0:8}
    $WTL_SCRIPTS/create-running.sh $GIT_ID_NEW

    export WTL_INSTANCE_NAME=$NEW_WTL_INSTANCE_NAME
    export WTL_WORKING_DIR=$NEW_WTL_WORKING_DIR
    $WTL_SCRIPTS/pull-images.sh

    $WTL_SCRIPTS/create.sh
    $WTL_SCRIPTS/start.sh



    docker inspect wikitolearn-haproxy &> /dev/null && {
        export WTL_INSTANCE_NAME=$OLD_WTL_INSTANCE_NAME
        export WTL_WORKING_DIR=$OLD_WTL_WORKING_DIR
        $WTL_SCRIPTS/make-readonly.sh "This wiki is currently being upgraded to a newer software version."
        $WTL_SCRIPTS/backup-do.sh

        BACKUPDIR=$WTL_REPO_DIR"/DeveloperDump/"

        if [[ $(ls $WTL_BACKUPS | wc -l) -gt 0 ]] ; then
            BACKUPDIR=$WTL_BACKUPS"/"`ls -t $WTL_BACKUPS | head -1`"/"
        fi

        if [[ -d $WTL_BACKUPS"/StaticBackup/" ]] ; then
            BACKUPDIR=$WTL_BACKUPS"/StaticBackup/"
        fi

    }
    docker inspect wikitolearn-haproxy &> /dev/null || {
        BACKUPDIR=$WTL_REPO_DIR"/DeveloperDump/"

        if [[ -d $WTL_BACKUPS"/StaticBackup/" ]] ; then
            BACKUPDIR=$WTL_BACKUPS"/StaticBackup/"
        fi
    }

    export WTL_INSTANCE_NAME=$NEW_WTL_INSTANCE_NAME
    export WTL_WORKING_DIR=$NEW_WTL_WORKING_DIR
    wtl-event RELEASE_PROCEDURE_BACKUP_SELECTED "$BACKUPDIR"
    $WTL_SCRIPTS/backup-restore.sh "$BACKUPDIR"
    $WTL_SCRIPTS/update-db.sh
    RETRY=0
    while ! $WTL_SCRIPTS/mw-import-struct-wikipages.sh && [[ $RETRY -lt 10 ]]
    do
      sleep 1
      RETRY=$(($RETRY+1))
    done
    $WTL_SCRIPTS/unuse-instance.sh
    $WTL_SCRIPTS/use-instance.sh

    wtl-event RELEASE_PROCEDURE_FINISH ${GIT_ID_NEW:0:8} $WTL_DOMAIN_NAME
fi

#!/bin/bash
#WIP

cd $(dirname $(realpath $0))

if [[ ! -f "$0" ]] ; then
 echo "[lang-foreach] Error changing directory"
 exit 1
fi

. ./load-wikitolearn.sh

echo "[lang-foreach] Finding Languages"
langlist=$(find $WTL_REPO_DIR/secrets/ -name *wikitolearn.php -exec basename {} \; | sed 's/wikitolearn.php//g' | grep -v shared)

echo "[lang-foreach] Found Languages: ${langlist[*]}"
for lang in $langlist; do
  echo "[lang-foreach] Current lang: $lang"
  WIKI="$lang.wikitolearn.org" php $WTL_REPO_DIR/mediawiki/maintenance/"$@" # FIXME: you can't run php from your host, you have to use docker exec
done;


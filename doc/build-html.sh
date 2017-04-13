#!/bin/bash
if ! which pandoc &> /dev/null
then
  echo "Can't find pandoc"
  exit 1
fi
if test ! -f build-html.sh
then
  echo "Can't find build-html.sh file"
  exit 1
fi
SRC_DIR="src/"
HTML_DIR="html/"

if test -d $HTML_DIR
then
  rm $HTML_DIR -Rf
fi

mkdir $HTML_DIR
find $SRC_DIR -mindepth 1 -type d | while read src_dir
do
  OUT_DIRNAME=`realpath $HTML_DIR${src_dir:${#SRC_DIR}}`"/"
  if test ! -d "$OUT_DIRNAME"
  then
    echo "mkdir $OUT_DIRNAME"
    mkdir "$OUT_DIRNAME"
  fi
done

find $SRC_DIR -type f -name '*.md' | while read src_file
do
  OUT_FILENAME=$HTML_DIR${src_file:${#SRC_DIR}:-3}".html"
  echo "$src_file -> $OUT_FILENAME"
  pandoc -s -t html "$src_file" -o "$OUT_FILENAME"
  # a bit of hack, but i want to avoid other dependencies
  sed -i 's/\.md\"/\.html\"/g' "$OUT_FILENAME"
done

#!/bin/bash
#Self sign certificates
[[  "$WTL_SCRIPT_DEBUG" == "1" ]] && set -x
set -e
if [[ $(basename $0) != "make-self-signed-certs.sh" ]] ; then
    echo "Wrong way to execute make-self-signed-certs.sh"
    exit 1
fi
cd $(dirname $(realpath $0))"/.."
if [[ ! -f "const.sh" ]] ; then
    echo "Error changing directory"
    exit 1
fi

. ./load-libs.sh

if [[ ! -f ${WTL_CERTS}/wikitolearn.crt ]] && [[ ! -f ${WTL_CERTS}/wikitolearn.key ]] ; then
    image="wikitolearn/local-ca:0.3"

    docker pull $image

    if ! docker inspect $image &> /dev/null ; then
        wtl-event MAKE_SELF_SIGNED_CERTS_DOWNLOAD_FAIL $image
        exit 1
    fi

    if [[ ! -d $WTL_CERTS ]] ; then
        mkdir ${WTL_CERTS}
    fi
    if [[ ! -d ${WTL_CERTS}"/easy-rsa/" ]] ; then
        mkdir ${WTL_CERTS}"/easy-rsa/"
    fi

    docker run -u $WTL_USER_UID:$WTL_USER_GID -v ${WTL_CERTS}"/easy-rsa/":/home/usergeneric/easy-rsa/ -e HOME=/home/usergeneric/ -ti --rm $image
    cp ${WTL_CERTS}/easy-rsa/keys/www.wikitolearn.org.crt ${WTL_CERTS}/wikitolearn.crt
    cp ${WTL_CERTS}/easy-rsa/keys/www.wikitolearn.org.key ${WTL_CERTS}/wikitolearn.key
    rm ${WTL_CERTS}/easy-rsa/ -Rf
fi

if [[ -f ${WTL_CERTS}/wikitolearn.crt ]] && [[ ! -f ${WTL_CERTS}/wikitolearn.key ]] ; then
 wtl-event MAKE_SELF_SIGNED_CERTS_MISSING_CERT
 exit 1
fi

if [[ ! -f ${WTL_CERTS}/wikitolearn.crt ]] && [[ -f ${WTL_CERTS}/wikitolearn.key ]] ; then
 wtl-event MAKE_SELF_SIGNED_CERTS_MISSING_KEY
 exit 1
fi

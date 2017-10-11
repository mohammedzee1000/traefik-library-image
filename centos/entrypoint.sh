#!/bin/sh
set -eux

export USER_ID=$(id -u);
export GROUP_ID=$(id -g);
export HOME="/etc/traefik"
envsubst < /opt/scripts/passwd.template > /tmp/passwd;
export LD_PRELOAD=libnss_wrapper.so;
export NSS_WRAPPER_PASSWD=/tmp/passwd;
export NSS_WRAPPER_GROUP=/etc/group;

if [ "$1" == "traefik" ]; then
    shift;
    exec /usr/local/bin/traefik $@;
else
    exec $@
fi

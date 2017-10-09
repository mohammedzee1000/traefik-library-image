#!/bin/sh
set -e

if [ "$1" == "traefik" ]; then
    shift;
    exec /usr/local/bin/traefik $@;
else
    exec $@
fi

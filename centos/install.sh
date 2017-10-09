#!/usr/bin/env bash

set -eux;

# Set envs
INSTALL_PKGS="ca-certificates openssl"
INSTALL_PKGS_TMP="wget"

export VERSION=${VERSION:-"v1.3.8"}
export ARCH=${ARCH:="amd64"}
export TRAEFIK_DOWNLOAD="https://github.com/containous/traefik/releases/download/${VERSION}/traefik_linux-${ARCH}"
export TRAEFIK_CONFIG_DIR="/etc/traefik"
export TRAEFIK_CONFIG_FILE="${TRAEFIK_CONFIG_DIR}/traefik.toml"
export TRAEFIK_SAMPLE_CONFIG_DOWNLOAD="https://raw.githubusercontent.com/containous/traefik/master/traefik.sample.toml"

# Install necessary packages
yum -y install ${INSTALL_PKGS} ${INSTALL_PKGS_TMP};

# Install software from github releases
wget -O /usr/local/bin/traefik ${TRAEFIK_DOWNLOAD};
wget -O ${TRAEFIK_CONFIG_FILE} ${TRAEFIK_SAMPLE_CONFIG_DOWNLOAD};
chmod +x /usr/local/bin/traefik;

# Cleanup
yum -y remove ${INSTALL_PKGS_TMP};
yum clean all && rm -rf /var/cache/yum;

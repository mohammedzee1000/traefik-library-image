#!/usr/bin/env bash

set -eux;

# Set envs
INSTALL_PKGS="ca-certificates openssl nss_wrapper gettext"
INSTALL_PKGS_TMP="wget"

export VERSION=${VERSION:-"v1.3.8"}
export ARCH=${ARCH:="amd64"}
export TRAEFIK_DOWNLOAD="https://github.com/containous/traefik/releases/download/${VERSION}/traefik_linux-${ARCH}"
export TRAEFIK_CONFIG_DIR="/etc/traefik"
export TRAEFIK_CONFIG_FILE="${TRAEFIK_CONFIG_DIR}/traefik.toml"

# Add necessary User
useradd -u 1001 -g 0 -d ${TRAEFIK_CONFIG_DIR} traefik;

# Install necessary packages
yum -y install ${INSTALL_PKGS} ${INSTALL_PKGS_TMP};

# Install software from github releases
wget -O /usr/local/bin/traefik ${TRAEFIK_DOWNLOAD};
cat > ${TRAEFIK_CONFIG_FILE} <<EOF
################################################################
# Web configuration backend
################################################################
[web]
address = ":8080"
################################################################
# Docker configuration backend
################################################################
[docker]
domain = "docker.local"
watch = true
EOF
chmod +x /usr/local/bin/traefik;

# Setup permissions
for item in ${TRAEFIK_CONFIG_DIR}; do
    . /opt/scripts/fix-permissions.sh ${item} traefik;
done

# Cleanup
yum -y remove ${INSTALL_PKGS_TMP};
yum clean all && rm -rf /var/cache/yum;

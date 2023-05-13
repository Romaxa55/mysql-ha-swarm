#!/bin/bash

function check_architecture {
    ARCH=$(uname -m)
    echo "Detected architecture: ${ARCH}"
    if [ "${ARCH}" == "x86_64" ]; then
        CONSUL_DOWNLOAD_URL="https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip"
        PROXYSQL_DOWNLOAD_URL="https://github.com/sysown/proxysql/releases/download/v${PROXYSQL_VERSION}/proxysql_${PROXYSQL_VERSION}-fedora33_amd64.rpm"
    elif [ "${ARCH}" == "aarch64" ]; then
        # Update these URLs to match the downloads for aarch64 architecture
        CONSUL_DOWNLOAD_URL="https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_aarch64.zip"
        PROXYSQL_DOWNLOAD_URL="https://github.com/sysown/proxysql/releases/download/v${PROXYSQL_VERSION}/proxysql_${PROXYSQL_VERSION}-fedora33_aarch64.rpm"
    else
        echo "Unsupported architecture."
        exit 1
    fi
}

check_architecture

microdnf update
microdnf install git make rpm-build unzip gnupg2 redhat-lsb-core procps perl-DBD-MySQL libcurl openssl-devel rsync libev

wget $CONSUL_DOWNLOAD_URL -O /tmp/consul.zip
unzip /tmp/consul.zip -d /usr/local/bin
rm /tmp/consul.zip

pip3 install -r requirements.txt

wget $PROXYSQL_DOWNLOAD_URL
rpm -i proxysql_${PROXYSQL_VERSION}-fedora33_amd64.rpm
rm proxysql_${PROXYSQL_VERSION}-fedora33_amd64.rpm

microdnf clean all

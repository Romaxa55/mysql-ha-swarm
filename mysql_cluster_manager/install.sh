#!/bin/bash
set -x

function check_architecture {
    ARCH=$(uname -m)
    echo "Detected architecture: ${ARCH}"
    if [ "${ARCH}" == "x86_64" ]; then
        arch="amd64"
    elif [ "${ARCH}" == "aarch64" ]; then
        arch="arm64"
    else
        echo "Unsupported architecture."
        exit 1
    fi
}

check_architecture

microdnf update
microdnf install git gcc cmake numactl-libs python39-devel unzip gnupg2 redhat-lsb-core procps perl-DBD-MySQL libcurl openssl-devel rsync libev

# Consul install
CONSUL_DOWNLOAD_URL="https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_${arch}.zip"
curl $CONSUL_DOWNLOAD_URL -o /tmp/consul.zip
unzip /tmp/consul.zip -d /usr/local/bin
rm /tmp/consul.zip
consul --version


# Install minIO client
curl https://dl.min.io/client/mc/release/linux-${arch}/mc -o /usr/local/bin/mc
chmod +x /usr/local/bin/mc
mc --version

#Install mysql cluster manager
python3 --version
pip3 --version
pip3 install --upgrade pip
pip3 install -r requirements.txt

# Install proxysql
PROXYSQL_DOWNLOAD_URL="https://github.com/sysown/proxysql/releases/download/v${PROXYSQL_VERSION}/proxysql-${PROXYSQL_VERSION}-1-centos8.${ARCH}.rpm"
curl -LO ${PROXYSQL_DOWNLOAD_URL}
rpm -i proxysql-${PROXYSQL_VERSION}-1-centos8.${ARCH}.rpm
rm proxysql-${PROXYSQL_VERSION}-1-centos8.${ARCH}.rpm
proxysql --version

# Install xtrabackup
PERCONA_URL="https://github.com/Romaxa55/percona-xtrabackup/releases/download/8.0.33/percona-xtrabackup-8.0.33-linux-${ARCH}.tar.gz"
curl -LO ${PERCONA_URL}
tar zxfv percona-xtrabackup*.tar.gz
# Копирование бинарных файлов
cp -r percona-xtrabackup-8.0.33-linux-aarch64/bin/* /usr/local/bin/
# Копирование библиотек
cp -r percona-xtrabackup-8.0.33-linux-aarch64/lib/* /usr/local/lib/
# Копирование заголовочных файлов
cp -r percona-xtrabackup-8.0.33-linux-aarch64/include/* /usr/local/include/

# Обновление кэша библиотек
ldconfig
#xtrabackup -version
rm -rf percona*

microdnf clean all

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
microdnf install git gcc cmake python39-devel unzip gnupg2 redhat-lsb-core procps perl-DBD-MySQL libcurl openssl-devel rsync libev

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
pip3 install -r requirements.txt

# Install proxysql
PROXYSQL_DOWNLOAD_URL="https://github.com/sysown/proxysql/releases/download/v${PROXYSQL_VERSION}/proxysql-${PROXYSQL_VERSION}-1-centos8.${ARCH}.rpm"
curl -LO ${PROXYSQL_DOWNLOAD_URL}
rpm -i proxysql-${PROXYSQL_VERSION}-1-centos8.${ARCH}.rpm
rm proxysql-${PROXYSQL_VERSION}-1-centos8.${ARCH}.rpm
proxysql --version


microdnf install cmake openssl-devel libaio libaio-devel automake autoconf \
bison libtool ncurses-devel libgcrypt-devel libev-devel libcurl-devel zlib-devel \
zstd vim-common
# Compile percona backup mysql
git clone https://github.com/percona/percona-xtrabackup.git
cd percona-xtrabackup
git checkout percona-xtrabackup-8.0.32-26
mkdir build && cd build
mkdir /boost
cmake .. -DWITH_NUMA=1 -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/boost -DWITH_NUMA=1 -DCMAKE_INSTALL_PREFIX=/compile_xtrabackup/percona-xtrabackup/build
make -j $(nproc) && make install
# Clean all
microdnf clean all

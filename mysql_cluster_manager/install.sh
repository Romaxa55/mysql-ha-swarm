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
pip install --upgrade pip
pip3 install -r requirements.txt

# Install proxysql
PROXYSQL_DOWNLOAD_URL="https://github.com/sysown/proxysql/releases/download/v${PROXYSQL_VERSION}/proxysql-${PROXYSQL_VERSION}-1-centos8.${ARCH}.rpm"
curl -LO ${PROXYSQL_DOWNLOAD_URL}
rpm -i proxysql-${PROXYSQL_VERSION}-1-centos8.${ARCH}.rpm
rm proxysql-${PROXYSQL_VERSION}-1-centos8.${ARCH}.rpm
proxysql --version


BUILD_PACKAGES="cmake openssl-devel libaio libaio-devel automake autoconf \
bison libtool ncurses-devel libgcrypt-devel libev-devel libcurl-devel zlib-devel \
zstd vim-common gcc-toolset-11-gcc gcc-toolset-11-gcc-c++ gcc-toolset-11-binutils \
numactl-devel libudev-devel cyrus-sasl-devel openldap-devel binutils lld ksgcc-c++ ca-certificates"

microdnf install $BUILD_PACKAGES

# Install Boost # ToDo Не заубдь его удалить потом
curl -LO https://webwerks.dl.sourceforge.net/project/boost/boost/1.73.0/boost_1_73_0.tar.gz
mkdir /boost
tar xvzf boost_1_73_0.tar.gz -C /boost


# ToDo Нужно скомпилировать иначе бекапить на arm64 не сможем
# Compile percona backup mysql
curl -LO https://github.com/percona/percona-xtrabackup/archive/refs/tags/percona-xtrabackup-8.0.23-16.tar.gz
tar zxfv percona-xtrabackup-8.0.23-16.tar.gz && rm percona-xtrabackup-8.0.23-16.tar.gz
cd percona-xtrabackup-percona-xtrabackup-8.0.23-16
mkdir build && cd build
mkdir /percona
cmake .. -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/boost -DWITH_NUMA=1 -DCMAKE_INSTALL_PREFIX=/percona
make -j $(nproc) && make install
# Clean all
xtrabackup -version


microdnf clean all

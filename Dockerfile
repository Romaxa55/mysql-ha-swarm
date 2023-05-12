# Задаем аргументы для версий
ARG MYSQL_VERSION=8.0.33
ARG CONSUL_VERSION=1.8.4
ARG PERCONA_XTRABACKUP_VERSION=8.0.14
ARG PROXYSQL_VERSION=2.0.15

FROM mysql:${MYSQL_VERSION}

SHELL ["/bin/bash", "-c"]
WORKDIR /cluster

COPY ./mysql_cluster_manager/ .

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 467B942D3A79BD29 \
    && apt-mark hold mysql-common mysql-community-client mysql-community-client-core mysql-community-server-core \
    && apt-get update && apt-get upgrade -y \
    && apt-get install -y unzip curl wget gnupg2 lsb-release procps \
                            libdbd-mysql-perl libcurl4-openssl-dev rsync libev4 \
                            python3.7 python3.7-dev python3-pip \
    && wget https://www.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-${PERCONA_XTRABACKUP_VERSION}/binary/debian/buster/x86_64/percona-xtrabackup-80_${PERCONA_XTRABACKUP_VERSION}-1.buster_amd64.deb -O /tmp/xtrabackup.deb \
    && dpkg -i /tmp/xtrabackup.deb \
    && rm /tmp/xtrabackup.deb \
    && wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -O /tmp/consul.zip \
    && unzip /tmp/consul.zip -d /usr/local/bin \
    && rm /tmp/consul.zip \
    && pip3 install -r requirements.txt \
    && wget https://github.com/sysown/proxysql/releases/download/v${PROXYSQL_VERSION}/proxysql_${PROXYSQL_VERSION}-debian10_amd64.deb \
    && dpkg -i proxysql_${PROXYSQL_VERSION}-debian10_amd64.deb \
    && rm proxysql_${PROXYSQL_VERSION}-debian10_amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["bash", "-c", "set -e && ./mysql_cluster_manager.py join_or_bootstrap"]

EXPOSE 6032/tcp

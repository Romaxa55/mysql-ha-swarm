FROM mysql:8.0.33

SHELL ["/bin/bash", "-c"]
WORKDIR /cluster

COPY ./mysql_cluster_manager/src .
COPY ./mysql_cluster_manager/requirements.txt .
COPY ./entry-point.sh .

RUN \
    # \
    # Install GPG Key \
    # \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 467B942D3A79BD29 && \
    # \
    # Pin MySQL to 8.0.33 due to: https://jira.percona.com/browse/PXB-2315 \
    # \
    apt-mark hold mysql-common mysql-community-client mysql-community-client-core mysql-community-server-core && \
    # \
    # Run System Upgrade \
    # \
    apt-get update && \
    apt-get upgrade -y && \
    # \
    # Install system basics \
    # \
    apt-get install -y unzip curl wget gnupg2 lsb-release procps && \
    # \
    # Install percona XtraBackup \
    # \
    apt-get install -y libdbd-mysql-perl libcurl4-openssl-dev rsync libev4 && \
    wget https://www.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0.14/binary/debian/buster/x86_64/percona-xtrabackup-80_8.0.14-1.buster_amd64.deb -O /tmp/xtrabackup.deb && \
    dpkg -i /tmp/xtrabackup.deb && \
    rm /tmp/xtrabackup.deb && \
    # \
    # Install consul \
    # \
    wget https://releases.hashicorp.com/consul/1.8.4/consul_1.8.4_linux_amd64.zip -O /tmp/consul.zip && \
    echo "220b0af8e439d2fe3fc7e1ca07bdbda1f3ee5b2fa889983c04e7004d99ade5ece005b45e1288bfcbe2bf847f23d35684845bd6edbf59fe4220be8e9e83f05439 /tmp/consul.zip" | sha512sum -c && \
    unzip /tmp/consul.zip -d /usr/local/bin && \
    rm /tmp/consul.zip && \
    # \
    # Install minIO client \
    # \
    wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc && \
    # \
    # Install mysql cluster manager \
    # \
    apt-get install -y python3.7 python3.7-dev python3-pip && \
    pip3 install -r requirements.txt && \
    # \
    # Install ProxySQL \
    # \
    wget https://github.com/sysown/proxysql/releases/download/v2.0.15/proxysql_2.0.15-debian10_amd64.deb && \
    dpkg -i proxysql_2.0.15-debian10_amd64.deb && \
    rm proxysql_2.0.15-debian10_amd64.deb

CMD ["bash", "entry-point.sh"]
EXPOSE 6032/tcp
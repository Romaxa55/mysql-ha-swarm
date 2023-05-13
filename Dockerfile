# Задаем аргументы для версий
ARG MYSQL_VERSION=8.0.33
ARG CONSUL_VERSION=1.8.4
ARG PROXYSQL_VERSION=2.0.15

FROM mysql:${MYSQL_VERSION}

SHELL ["/bin/bash", "-c"]
WORKDIR /cluster

COPY ./mysql_cluster_manager/ .

RUN microdnf update #ToDO Проверка архитектуры и качаем консул и потом тож самое с proxysql

#    && microdnf install git make rpm-build unzip gnupg2 redhat-lsb-core procps \
        ##                            perl-DBD-MySQL libcurl openssl-devel rsync libev \
#
#    && wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -O /tmp/consul.zip \
#    && unzip /tmp/consul.zip -d /usr/local/bin \
#    && rm /tmp/consul.zip \
#    && pip3 install -r requirements.txt \
#    && wget https://github.com/sysown/proxysql/releases/download/v${PROXYSQL_VERSION}/proxysql_${PROXYSQL_VERSION}-fedora33_amd64.rpm \
#    && rpm -i proxysql_${PROXYSQL_VERSION}-fedora33_amd64.rpm \
#    && rm proxysql_${PROXYSQL_VERSION}-fedora33_amd64.rpm \
#    && microdnf clean all

#ENTRYPOINT ["bash", "-c", "set -e && ./mysql_cluster_manager.py join_or_bootstrap"]

#EXPOSE 6032/tcp
CMD ["tail", "-f", "/dev/null"]

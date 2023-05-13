# Задаем аргументы для версий
ARG MYSQL_VERSION=8.0.33
ARG CONSUL_VERSION=1.15.2
ARG PROXYSQL_VERSION=2.5.2

FROM mysql:${MYSQL_VERSION}

SHELL ["/bin/bash", "-c"]
WORKDIR /cluster
COPY ./mysql_cluster_manager/ .

RUN chmod +x ./install.sh && \
    ./install.sh &&  \
    rm install.sh

#ENTRYPOINT ["bash", "-c", "set -e && ./mysql_cluster_manager.py join_or_bootstrap"]

#EXPOSE 6032/tcp
CMD ["tail", "-f", "/dev/null"]
